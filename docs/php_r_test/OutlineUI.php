<html>
  <head>
  <title>Select A Bounding Box</title>
</head>

<body>

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
?>

<p>This page will use a PHP-based form and an R script to produce a histogram based on user input. This example uses the POST method, so the data is not visible in the URL. The same php file gets the input and shows the results.</p>
<p>If you edit the form method to <code>method="get"</code> and change the statement in the php block to <code>$N = $_GET['N'];</code> and then reload the page and enter new data, you will see the variable in the URL when the form is processed.</p>
<p>Because the <code>exec()</code> command is using your command prompt or terminal, you must add R to your system PATH. This varies depending on your operating system. 
</body>
</html>
