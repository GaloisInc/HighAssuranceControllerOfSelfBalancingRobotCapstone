<?php
	include 'dhp.php';
?>

<!DOCTYPE HTML>
<html>
<head>

<style>
body {background-color: #696969;}
</style>

<script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
<script type="text/javascript">
window.onload = function () {

var PITCHdps = []; // dataPoints
var YAWdps = [];

var PITCHchart = new CanvasJS.Chart("chartContainer", {
	backgroundColor: "#FFEFD5",
	animationEnabled: true,
	zoomEnabled: true,
	title :{
		text: "PITCH"
	},
	axisY: {
		minimum: -1.65,
		maximum: 1.65,
		includeZero: true,
		stripLines: [{
			value: -0.05,
			label: "Set Point"
		}]

	},      
	data: [{
		type: "line",
		showInLegend: true,
		dataPoints: PITCHdps,
		legendText: "{name} " + PITCHdps,
	}]
});

var YAWchart = new CanvasJS.Chart("chartContainer2", {
	backgroundColor: "#E6E6FA",
	animationEnabled: true,
	zoomEnabled: true,
	title :{
		text: "YAW"
	},
	axisY: {
		minimum: -3.14,
		maximum: 3.14,
		includeZero: true
	},      
	data: [{
		type: "line",
		name: "YAW",
		color: "red",
		//yValueFormatString: "#,### watts",
		showInLegend: true,
		legendText: "{name} " + YAWdps,
		dataPoints: YAWdps,
	}]
});


var xVal = 0;
var updateInterval = 70;
var dataLength = 500; // number of dataPoints visible at any point

var updateChart = function (count) {

	count = count || 1;
	$.post("service.php",
	function(data)
	{
		//console.log(data);
			PITCHdps.push({x: xVal, y: data[0].PITCH});
			YAWdps.push({x: xVal, y: data[0].YAW});
			YAWchart.options.data[0].legendText = " YA YA YA " + data[0].YAW; 
			PITCHchart.options.data[0].legendText = " PITCH " + data[0].PITCH; 
	});

	xVal++;

	if (PITCHdps.length > dataLength) {
		PITCHdps.shift();
		YAWdps.shift();
	}

//	PITCHchart.options.data[1].legendText = "Building A " + data[0].PITCH + " watts";
//	  YAWchart.options.data[0].legendText = " Building B " + data[0].YAW + " watts"; 

	PITCHchart.render();
	YAWchart.render();

	$("#setPoint").click(function () {
		PITCHchart.options.axisY.stripLines[0].value = document.getElementById("inputField").value;
		});

	$("#saveTable").click(function () {
		var _tableName = document.getElementById("tableName").value;
		$.post('save-table.php', {named: _tableName}, function(response) {console.log(response)});
	});

    document.getElementById("selectTable").onclick = function () {

		// input table value into url
        var sel = document.getElementById("tables").value;
		// concat for complete turl
		window.location.href = '/data-display.php?table='.concat(sel);
    }
	

}

updateChart(dataLength);
setInterval(function(){updateChart()}, updateInterval);

}
</script>
</head>
<body>

<div id="chartContainer" style="height: 400px; width:100%;"></div>
<div id="chartContainer2" style="height: 400px; width:100%; margin-bottom: 75px"></div>

<input type="number" id="inputField" style="width: 5%;">
<button id="setPoint" style= "margin-bottom: 25px">Update Set Point</button>

<input type="text" id="tableName" placeholder="Data Name" style="float: right; width: 15.7%;" >
<button id="saveTable" style="float: right;" >Save Data to SQL</button>



<form action='' method='post'>
		<select name = "list" id = "tables" style="float: right;">
			<?php

					$result = $conn->query("SHOW TABLES LIKE '20%'");

					if($result->num_rows > 0) {
					// echo '<select name="dropdown"/>';
						while($row = $result->fetch_array(MYSQLI_NUM)) {
							echo '<option>' . $row[0] . '</option>';
						}
					// echo '</select>';
					}
			?>
		</select>
 </form>
 <button id="selectTable" style="float: right;" >View Saved Data</button>

<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

</body>
</html>




