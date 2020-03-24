#[macro_use]
extern crate diesel;

use std::io::{Read, Write};
use std::net::TcpStream;
use std::str::from_utf8;
use byteorder::{ByteOrder, LittleEndian};
use diesel::prelude::*;
use diesel::mysql::MysqlConnection;
use dotenv::dotenv;
use std::env;
use std::time::Duration;

use self::models::*;

pub mod schema;
pub mod models;

#[derive(Queryable)]
pub struct Otis_AK{
    pub id: i32,
    pub PITCH: f32,
    pub YAW: f32,
    pub OUTPUT1: f32,
    pub OUTPUT2: f32,
}

pub fn save_data<'a>(conn: &MysqlConnection, 
    PITCH: &'a f32,
    YAW: &'a f32,
    OUTPUT1: &'a f32,
    OUTPUT2: &'a f32,) {

     use schema::OtisData;

     let new_data = NewData{
         PITCH:PITCH,
         YAW:YAW,
         OUTPUT1:OUTPUT1,
         OUTPUT2:OUTPUT2,
     };

     diesel::insert_into(OtisData::table)
     .values(&new_data)
     .execute(conn); //alt use get_result()
     //expect("Error saving new post");

    }



pub fn establish_connection() -> MysqlConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");
    MysqlConnection::establish(&database_url)
        .expect(&format!("Error connecting to {}", database_url))
}

fn main () -> std::io::Result<()>{

    // Initial connection with database
    let connection = establish_connection();

    // Clear main database table on start
    connection.execute("TRUNCATE TABLE OtisData").unwrap();

    // Initial TCP connection with Arduino
    let mut stream = attempt_arduino_connection();

    let mut data = [0 as u8; 8];
    stream.read(&mut data);


    // Read 1st msg
    let text = from_utf8(&data).unwrap();
    println!("{}", text);

   



    loop{


        stream.read(&mut data);
        if data == [0 as u8; 8]{
            println!("Connection lost");
            stream = attempt_arduino_connection();
            connection.execute("TRUNCATE TABLE OtisData").unwrap();
        }
        // decode data stream
       let mut p = [data[0] as u8, data[1] as u8];
       let p_float: f32 = (LittleEndian::read_u16(&p) as f32) / 10436.0 - 3.14 ;
       let mut y = [data[2] as u8, data[3] as u8];
       let y_float: f32 = (LittleEndian::read_u16(&y) as f32) / 10436.0 - 3.14 ;
       let mut o = [data[4] as u8, data[5] as u8];
       let o_float: f32 = (LittleEndian::read_u16(&o) as f32) / 33.0 - 1000.0 ;
       let mut g = [data[6] as u8, data[7] as u8];
       let g_float: f32 = (LittleEndian::read_u16(&g) as f32) / 33.0 - 1000.0 ;

       println!("P: {}, Y: {}, O: {}, G: {}", p_float, y_float, o_float, g_float);

        // save data to mysql server
        save_data(&connection, &p_float, &y_float, &o_float, &g_float);
        // reset data buffer
        data = [0 as u8; 8];
    }


}

pub fn attempt_arduino_connection () -> std::net::TcpStream {

    // attempt to connect to arduino on loop
    let mut stream = loop {

        if let Ok(stream) = TcpStream::connect("192.168.50.45:80") {
            println!("Connected to the server!");
            break stream;
        } else {
           // println!("Couldn't connect to server...");

        }
    };

    // Set timeout condition to 5 seconds
    stream.set_read_timeout(Some(Duration::new(5, 0))).expect("set_read_timeout failed");
    stream.write(&[1]).expect("Failed to send data to Arduino");
    stream

}