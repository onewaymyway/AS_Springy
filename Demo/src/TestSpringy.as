package {
	import laya.display.Sprite;
	import laya.events.Event;
	import oneway.springy.Graph;
	import oneway.springy.layout.ForceDirected;
	import oneway.springy.Point;
	import oneway.springy.PosTransform;
	import oneway.springy.Renderer;
	import oneway.springy.SpringVector;
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
		private var layout:ForceDirected;
		private var render:Renderer; 
		public var width:Number=1;
		public var height:Number = 1;
		private function testSpringy():void {
			sp = new Sprite();
			Laya.stage.addChild(sp);
			sp.pos(100, 100);
			var graph:Graph = new Graph();
			graph.addNodes('Dennis', 'Michael', 'Jessica', 'Timothy', 'Barbara')
			graph.addNodes('Amphitryon', 'Alcmene', 'Iphicles', 'Heracles');
			graph.addEdges(['Dennis', 'Michael', { color: '#00A0B0', label: 'Foo bar' } ], ['Michael', 'Dennis', { color: '#6A4A3C' } ], ['Michael', 'Jessica', { color: '#CC333F' } ], ['Jessica', 'Barbara', { color: '#EB6841' } ], ['Michael', 'Timothy', { color: '#EDC951' } ], ['Amphitryon', 'Alcmene', { color: '#7DBE3C' } ], ['Alcmene', 'Amphitryon', { color: '#BE7D3C' } ], ['Amphitryon', 'Iphicles'], ['Amphitryon', 'Heracles'], ['Barbara', 'Timothy', { color: '#6A4A3C' } ]);
			
			
			layout = new ForceDirected(graph, 100, 100, 0.6);
			
			
			render = new Renderer(layout, clear.bind(this), drawEdge.bind(this), drawNode.bind(this));
			var posTransform:PosTransform;
			posTransform = new PosTransform();
			posTransform.width = 600;
			posTransform.height = 400;
			//posTransform.fixScale = 0.2;
			render.posTransform = posTransform;
			render.start();
			
			Laya.stage.on(Event.MOUSE_DOWN, this, onClick);
		}
		
		private function onClick():void
		{
			trace("node:", node);
			var point:Point;
			point = layout.point(node);
			debugger;
			point.p = render.posTransform.fromScreen(new SpringVector(sp.mouseX, sp.mouseY));
			point.m = 100;
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
		private var node:Object;
		private function drawNode(node, p):void
		{
			trace("drawNode", node, p);
			sp.graphics.drawCircle(p.x * width, p.y * height, 5, "#ffff00");
			this.node = node;
		}
	}

}