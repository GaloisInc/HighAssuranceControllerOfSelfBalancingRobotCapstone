<!DOCTYPE HTML>
     <html>
     <head>
    <style type="text/css">
        table {
            border-collapse: collapse;
            width: 85%;
            color: #778899;
            font-family: monospace;
            font-size: 11px;
            text-align: Center;
            margin: 0 auto;

        }
        th {
            background-color: #778899;
            color: white;
        }

        body {background-color: #000000;}
        </style>

<div id="chartContainer" style="height: 600px; width: 90%; margin: 0 auto; margin-bottom: 75px"></div>
<div id="chartContainer2" style="height: 600px; width: 96%; margin: 0 auto; margin-bottom: 75px"></div>
<?php
     include 'dhp.php';

    $dataPoints1 = array();
    $dataPoints2 = array();
    $dataPoints3 = array();
    $dataPoints4 = array();
    $x = 0;

    $name = mysqli_real_escape_string($conn, $_POST['named']);

    // print table if necessary

    /*echo '<table cellspacing="5" cellpadding="5">
      <tr> 
        <th>ID</th> 
        <th>PITCH</th> 
        <th>YAW</th> 
        <th>OUTPUT1</th>
	      <th>OUTPUTY</th> 
        <th>Timestamp</th> 
      </tr>';*/

    $qdate = date('Y-m-d');
    $table_name = $qdate." ".$name;
    $_table_name = mysqli_real_escape_string($conn, $table_name);




     if (isset($_GET['table'])) {
        $table = $_GET['table'];
        $sql = "SELECT id, PITCH, YAW, OUTPUT1, OUTPUT2, reading_time FROM `$table` ORDER BY id ASC";
      } else {
        $sql = "SELECT id, PITCH, YAW, OUTPUT1, OUTPUT2, reading_time FROM OtisData ORDER BY id ASC";
      }


      if ($result = $conn->query($sql)) {
        while ($row = $result->fetch_assoc()) {
            array_push($dataPoints1, array("x" => $x, "y" => $row["PITCH"]));
            array_push($dataPoints2, array("x" => $x, "y" => $row["YAW"]));
            array_push($dataPoints3, array("x" => $x, "y" => $row["OUTPUT1"]));
            array_push($dataPoints4, array("x" => $x, "y" => $row["OUTPUT2"]));

            $x += 1;

          // print data, will slow down website significantly
            /*echo '<tr> 
                <td>' . $row["id"] . '</td> 
                <td>' . $row["PITCH"] . '</td> 
                <td>' . $row["YAW"] . '</td> 
                <td>' . $row["OUTPUT1"] . '</td> 
                <td>' . $row["OUTPUT2"] . '</td> 
                <td>' . $row["reading_time"] . '</td> 
              </tr>';*/
        }
        $result->free();

      }

  if(array_key_exists('button1', $_POST)) { 
        button1($conn); 
    } 
    
    function button1($conn) { 
      $table = $_GET['table'];
      $sql = "DROP TABLE`$table`";
      $conn->query($sql);
    } 
    
     ?>

     <script>
     window.onload = function() {
      
     var dataPoints1 = <?php echo json_encode($dataPoints1, JSON_NUMERIC_CHECK); ?>;
     var dataPoints2 = <?php echo json_encode($dataPoints2, JSON_NUMERIC_CHECK); ?>;
     var dataPoints3 = <?php echo json_encode($dataPoints3, JSON_NUMERIC_CHECK); ?>;
     var dataPoints4 = <?php echo json_encode($dataPoints4, JSON_NUMERIC_CHECK); ?>;

     const queryString = window.location.search;
     const urlParams = new URLSearchParams(queryString);
     const product = urlParams.get('table');

     var chart = new CanvasJS.Chart("chartContainer", {
      backgroundColor: "#0",
         zoomEnabled: true,
         
         title: {
              text: "Table (" + product + ") PITCH & YAW Graph",
              fontSize: 22,
              fontColor: "white",
         },
         toolTip: {
              shared: true
         },
         legend: {
              fontColor: "white",
              cursor:"pointer",
              verticalAlign: "top",
              fontSize: 18,
              fontColor: "dimGrey",
         },
         axisX: {
          labelFontColor: "white",
         },
         axisY: {
              minimum: -3.14,
              maximum: 3.14,
              includeZero: true,
              labelFontColor: "white",
            	  },  
         data: [{ 
              type: "line",
              name: "PITCH",
              showInLegend: true,
              dataPoints: dataPoints1
                },
                 {				
              type: "line",
              name: "YAW" ,
              showInLegend: true,
              dataPoints: dataPoints2
           }]
     });
      
     chart.render();

     var chart2 = new CanvasJS.Chart("chartContainer2", {
       backgroundColor: "#0",
         zoomEnabled: true,
         title: {
             text: "Table (" + product + ") OUTPUT Graph",
             fontSize: 22,
             fontColor: "white",
         },
         toolTip: {
             shared: true
         },
         legend: {
             cursor:"pointer",
             verticalAlign: "top",
             fontSize: 18,
             fontColor: "dimGrey",
         }, 
         axisX: {
          labelFontColor: "white",
         },
         axisY: {
		    minimum: -1000,
		    maximum: 1000,
        labelFontColor: "white",
		    includeZero: true
            	},  



         data: [{ 
                 type: "line",
                 name: "OUTPUT1",
                 showInLegend: true,
                 dataPoints: dataPoints3
             },
             {				
                 type: "line",
                 name: "OUTPUTY" ,
                 showInLegend: true,
                 dataPoints: dataPoints4
         }]
     });
      
     chart2.render();

     }
     </script>
     </head>
     <body>
     <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

     <a href="/live.php" style="float: right;" >Return To Live Page</a> 
     <form method="post"> 
        <input type="submit" name="button1"
                class="button" value="DELETE TABLE" style= "background-color: red;"/> 
    </form> 

     </body>
     </html>                              