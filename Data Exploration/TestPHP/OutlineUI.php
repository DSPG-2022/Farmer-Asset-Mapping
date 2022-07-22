<html>
  <head>
    <title>"Assignment 2b"</title>
<meta name="description" content="Harun Celik - leaflet testing" />

<style>
    html, body, 

#map { height: 700px; margin: 10px; padding: 10px; }

</style>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
crossorigin=""/>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.4/leaflet.draw-src.css" integrity="sha512-vJfMKRRm4c4UupyPwGUZI8U651mSzbmmPgR3sdE3LcwBPsdGeARvUM5EcSTg34DK8YIRiIo+oJwNfZPMKEQyug==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	  
<script src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"
integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ=="
crossorigin=""></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.4/leaflet.draw.js" integrity="sha512-ozq8xQKq6urvuU6jNgkfqAmT7jKN2XumbrX1JiB3TnF7tI48DPI4Gy1GXKD/V3EExgAs1V+pRO7vwtS1LHg0Gw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

	  
  </head>
<head>
<meta name="description" content="Search Bounds Box - returncoords for DSPG">
  <meta charset="utf-8" />
  <title>Querying features</title>
  <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />

  <!-- Load libraries from CDN-->

	<script src="https://code.jquery.com/jquery.min.js"></script>

<link rel="stylesheet" href="https://www.w3schools.com/lib/w3.css">	


    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css" />

    <script src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"></script>

<!--http://tablesorter.com/docs/-->
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js"></script>

<script>
console.clear();




//define globals
var queryBox, map, bbox;

//Base layers and overlays
var OSM = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
	attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
	maxZoom: 18
});

//create the maps
map = L.map('map', {
	center: new L.LatLng(42.0, -93),
	zoom: 8,
	layers: [OSM]
});


  // getBounds() returns an object containing coords of map boundary 
bbox = map.getBounds();
currentBounds();
</script> <br />

</head>
<body>
 <center><h2>Bounding Box Selection</h2></center><br>
<div id="map"></div>

<script>
    console.clear();

var map = L.map('map', {drawControl: true}).setView([42.2, -93], 7);

// add a tile layer
var Esri_NatGeoWorldMap = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}', {
	attribution: 'Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC',
	maxZoom: 16
}).addTo(map);
	bbox = map.getBounds();
currentBounds();


//when map is changed recalculate bounds
map.on('moveend', function(e) {
	bbox = map.getBounds();
	currentBounds();
		
});


function currentBounds() {
	
 queryBox  = [
	bbox._southWest.lat,
    bbox._northEast.lat,
	bbox._northEast.lng,
    bbox._southWest.lng
  ];


	//Add AJAX call here or just add a submit button to send the coords to the php file.
	$.ajax({
            type: "GET",
            url: "C:\\xampp\\htdocs\\OutlineUI.php",
            data: {test: queryBox}
        });

}

$.ajax({
            type: "POST",
            url: "C:\\xampp\\htdocs\\OutlineUI.php",
            data: {test: queryBox}
        });

</script>

Limit: <input type="number" id="limit" maxlength="4" size="4" min="1" max="7" step="1" value='5' >
	field: <select id="field1">
  <option value="d2010" selected >2010 Decennial</option>
	<option value="d2000">2000 Decennial</option>
	<option value="d1990">1990 Decennial</option> 
	</select><br />
<<form method="get" action="OutlineUI.php">
    <label>XMIN: </label><input id="xmin" name="xmin" type="text"> <br />
    <label>XMAX: </label><input id="xmax" name="xmax" type="text"> <br />
    <label>YMIN: </label><input id="ymin" name="ymin" type="text"> <br />
    <label>YMAX: </label><input id="ymax" name="ymax" type="text"> <br />   
	<label>Select A Year For Weather: </label><input id="year" name="year" type="number" min="2015" max ="2021" value = "2015"> <br /> 
    <b> Select A Start Month For Weather </b>
	<select id = "startmnth" name ="startmonth">
	<option> January </option>  
	<option> Feburary </option>  
	<option> March </option>  
	<option> April </option> 
	<option> May</option>  
	<option> June </option>  
	<option> July </option>  
	<option> August </option>  
	<option> September </option>
	<option> October </option>  
	<option> November </option>  
	<option> December </option> 
	</select>  <br />
   <b> Select A End Month For Weather </b>
	<select id = "endmonth" name ="endmonth">
	<option> January </option>  
	<option> Feburary </option>  
	<option> March </option>  
	<option> April </option> 
	<option> May</option>  
	<option> June </option>  
	<option> July </option>  
	<option> August </option>  
	<option> September </option>
	<option> October </option>  
	<option> November </option>  
	<option> December </option> </select>  <br />

	<input type="submit" value="Calculate centroid">
</form>
<hr>
<?php
$test = $_POST['queryBox'];
$test2 =$_GET['queryBox'];
print_r($_POST);

if(isset($_GET['xmin']))
{
echo("<b>Results</b>");
    echo("<hr>");
    $xmin = $_GET['xmin'];
    $xmax = $_GET['xmax'];
    $ymin = $_GET['ymin'];
    $ymax = $_GET['ymax'];
	$year = $_GET['year'];
	$startmonth = $_GET['startmonth'];
	$endmonth = $_GET['endmonth'];
    echo "xmin: ". $xmin." xmax: ".$xmax."<br /> ymin: ".$ymin." ymax: ".$ymax;
    echo "<br>";
	
    $centroid = exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" C:\\xampp\\htdocs\\centroid_calc.R $xmin $xmax $ymin $ymax");
    echo "Centroid located at: ".$centroid;
	echo "<br>";
	echo "Start Month: $startmonth  and End Month: $endmonth";
	$centpoints = preg_split ("/\,/", $centroid);
	print_r($centpoints);
	echo $centpoints[0];
	echo $queryBox[0];
	echo $queryBox[1];
	echo $queryBox[2];	
	echo $queryBox[3];
	#exec("Weather") "5inputs"
	#exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\WeatherScript.R\" $year $startmonth $endmonth $centpoints[0] $centpoints[1]");
	
	#exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\GDD.R\"");
	#exec("GDD") "no inputs"
	
	#exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\TempDataSummary.R\"");
	#exec("SUMWeather") "no inputs"
	
	#exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\Cory_CropInfoV3.R\" 
	  # $xmin $xmax $ymin $ymax $centpoints[0] $centpoints[1]");
	#exec("Soil") "4inputs" "Return State Name, FIPS CODE"

}
?>

<p>This page will use a PHP-based form and an R script to produce a histogram based on user input. This example uses the POST method, so the data is not visible in the URL. The same php file gets the input and shows the results.</p>
<p>If you edit the form method to <code>method="get"</code> and change the statement in the php block to <code>$N = $_GET['N'];</code> and then reload the page and enter new data, you will see the variable in the URL when the form is processed.</p>
<p>Because the <code>exec()</code> command is using your command prompt or terminal, you must add R to your system PATH. This varies depending on your operating system. 
</body>
</html>
