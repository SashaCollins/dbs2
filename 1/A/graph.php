<?php
if (!function_exists('replaceUmlauts'))  {
	function replaceUmlauts($arr)  {
		$replacements = array(
			'ä' => 'ae',
			'ö' => 'oe',
			'ü' => 'ue',
			'ß' => 'ss'
		);
		foreach ($arr as $key => $value) {
			foreach ($replacements as $umlaut => $replacement){
				if (stristr($value, $umlaut))  {
					$arr[$key] = str_replace($umlaut, $replacement, $value);
				}
			}
		}
		
		return $arr;
	}
}

if (!function_exists('draw_graph'))  {
	function draw_graph($data, $legends, $filename)  {
		date_default_timezone_set("Europe/Berlin");
		
		require_once('jpgraph/jpgraph.php');
		require_once('jpgraph/jpgraph_pie.php');
		require_once('jpgraph/jpgraph_pie3d.php');
		
		$legendCols = 3;  // 3 Legend Entries in a Row
		$lines = ceil(sizeof($data) / $legendCols);
		$lineHeight = 20;  // 20px per Line of Legends
		
		// Create the Pie Graph. 
		$graph = new PieGraph(525, 340 + $lines * $lineHeight);
		
		// Theme
		$theme_class = new VividTheme;
		$graph->SetTheme($theme_class);

		// Set A title for the plot
		$graph->title->Set("Verteilung Fussballfans");
		$graph->title->SetFont(FF_ARIAL, FS_NORMAL, 18);
		$graph->subtitle->Set("State: ".date("d.m.Y; H:i:s"));

		// Create
		$p1 = new PiePlot3D($data);
		$p1->value->SetFormat('%01.2f%%');
		$p1->SetLabelPos(1.1);
		//$p1->value->SetMargin(20);
		$p1->SetCenter(275, 175);
		$p1->SetSize(0.4);
		//$legends = replaceUmlauts($legends);  // In case there are problems
		
		$p1->SetLegends($legends);
		$p1->ShowBorder();
		$p1->SetColor('black');
		$p1->ExplodeAll(); 

		$graph->Add($p1);
		$graph->legend->SetFont(FF_ARIAL);
		$graph->legend->SetFrameWeight(1);
		$graph->legend->SetPos(0.5, 0.99, 'center', 'bottom');
		$graph->legend->SetColumns($legendCols);
		$gdImgHandler = $graph->Stroke(_IMG_HANDLER);
		$graph->img->Stream($filename);
	}
}
?>