
<?php


#save data for all inputs
header('Access-Control-Allow-Origin *');
$coords = $_POST['coords'];
print_r($_POST['coords']);
echo "<br>";
$startmonth = $_POST['smonth'];
print_r($_POST['smonth']);
echo "<br>";
$endmonth = $_POST['emonth'];
print_r($_POST['emonth']);
echo "<br>";
$year = $_POST['year'];
print_r($_POST['year']);
	
    $xmin = $coords[0];
    $xmax = $coords[1];
    $ymin = $coords[3];
    $ymax = $coords[2];

    echo "xmin: ". $xmin." xmax: ".$xmax."<br /> ymin: ".$ymin." ymax: ".$ymax;
    echo "<br>";
	
    $centroid = exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" C:\\xampp\\htdocs\\centroid_calc.R $xmin $xmax $ymin $ymax");
    echo "Centroid located at: ".$centroid;
	echo "<br>";
	echo "Start Month: $startmonth  and End Month: $endmonth";
	$centpoints = preg_split ("/\,/", $centroid);
	print_r($centpoints);

	#exec("Weather") "5inputs"
	exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\WeatherScript.R\" $year $startmonth $endmonth $centpoints[0] $centpoints[1]");
	
	exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\GDD.R\"");
	#exec("GDD") "no inputs"
	
	exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\TempDataSummary.R\"");
	#exec("SUMWeather") "no inputs"
	
	exec("\"C:\\Program Files\\R\\R-4.2.0\\bin\\Rscript.exe\" \"C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP\\Cory_CropInfoV3.R\" $xmin $xmax $ymin $ymax $centpoints[0] $centpoints[1]");
	#exec("Soil") "4inputs" "Return State Name, FIPS CODE"


?>
