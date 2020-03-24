use super::schema::OtisData;

#[derive(Insertable)]
#[table_name="OtisData"]
pub struct NewData<'a> {
    pub PITCH: &'a f32,
    pub YAW: &'a f32,
    pub OUTPUT1: &'a f32,
    pub OUTPUT2: &'a f32,
}