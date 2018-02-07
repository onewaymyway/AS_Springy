package {
	import laya.display.Sprite;
	import oneway.springy.Graph;
	import oneway.springy.layout.ForceDirected;
	import oneway.springy.Renderer;
	import oneway.springy.Springy;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TestSpringy {
		
		public function TestSpringy() {
			Springy.init();
			Laya.init(1000, 900);
			testSpringy();
		}
		private var sp:Sprite;
		public var width:Number=10;
		public var height:Number = 10;
		private function testSpringy():void {
			sp = new Sprite();
			Laya.stage.addChild(sp);
			sp.pos(100, 100);
			var graph:Graph = new Graph();
			graph.addNodes('Dennis', 'Michael', 'Jessica', 'Timothy', 'Barbara')
			graph.addNodes('Amphitryon', 'Alcmene', 'Iphicles', 'Heracles');
			graph.addEdges(['Dennis', 'Michael', { color: '#00A0B0', label: 'Foo bar' } ], ['Michael', 'Dennis', { color: '#6A4A3C' } ], ['Michael', 'Jessica', { color: '#CC333F' } ], ['Jessica', 'Barbara', { color: '#EB6841' } ], ['Michael', 'Timothy', { color: '#EDC951' } ], ['Amphitryon', 'Alcmene', { color: '#7DBE3C' } ], ['Alcmene', 'Amphitryon', { color: '#BE7D3C' } ], ['Amphitryon', 'Iphicles'], ['Amphitryon', 'Heracles'], ['Barbara', 'Timothy', { color: '#6A4A3C' } ]);
			
			var layout:ForceDirected;
			layout = new ForceDirected(graph, 100, 100, 0.5);
			
			var render:Renderer;
			render = new Renderer(layout, clear.bind(this), drawEdge.bind(this), drawNode.bind(this));
			render.start();
		}
		

		private function clear():void
		{
			trace("clear");
			sp.graphics.clear();
		}
		
		private function drawEdge(edge, p1, p2):void
		{
			trace("drawEdge:", edge, p1, p2);
			sp.graphics.drawLine(p1.x*width, p1.y*height, p2.x*width, p2.y*height, "#ff0000");
		}
		
		private function drawNode(node, p):void
		{
			trace("drawNode", node, p);
			sp.graphics.drawCircle(p.x*width, p.y*height, 5, "#ffff00");
		}
	}

}