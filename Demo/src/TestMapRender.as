package 
{
	import map.MapRender;
	import oneway.springy.Graph;
	import oneway.springy.PosTransform;
	import oneway.springy.layout.ForceDirected;
	/**
	 * ...
	 * @author ...
	 */
	public class TestMapRender 
	{
		
		public function TestMapRender() 
		{
			Laya.init(1000, 900);
			test();
		}
		private var map:MapRender;
		private function test():void
		{
			var layout:ForceDirected;
			var graph:Graph = new Graph();
			graph.addNodes('Dennis', 'Michael', 'Jessica', 'Timothy', 'Barbara')
			graph.addNodes('Amphitryon', 'Alcmene', 'Iphicles', 'Heracles');
			graph.addEdges(['Dennis', 'Michael', { color: '#00A0B0', label: 'Foo bar' } ], ['Michael', 'Dennis', { color: '#6A4A3C' } ], ['Michael', 'Jessica', { color: '#CC333F' } ], ['Jessica', 'Barbara', { color: '#EB6841' } ], ['Michael', 'Timothy', { color: '#EDC951' } ], ['Amphitryon', 'Alcmene', { color: '#7DBE3C' } ], ['Alcmene', 'Amphitryon', { color: '#BE7D3C' } ], ['Amphitryon', 'Iphicles'], ['Amphitryon', 'Heracles'], ['Barbara', 'Timothy', { color: '#6A4A3C' } ]);
			
			
			layout = new ForceDirected(graph, 100, 100, 0.6);
			
			
			map = new MapRender(layout);
			Laya.stage.addChild(map.sp);
			var posTransform:PosTransform;
			posTransform = new PosTransform();
			posTransform.width = 600;
			posTransform.height = 400;
			//posTransform.fixScale = 0.2;
			map.posTransform = posTransform;
			map.start();
		}
		
	}

}