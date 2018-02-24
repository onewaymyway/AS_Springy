package map
{
	import laya.display.Sprite;
	import laya.utils.Utils;
	import oneway.springy.Edge;
	import oneway.springy.Node;
	import oneway.springy.Point;
	import oneway.springy.PosTransform;
	import oneway.springy.Spring;
	import oneway.springy.SpringVector;
	import oneway.springy.layout.ForceDirected;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MapRender
	{
		public var layout:ForceDirected;
		public var posTransform:PosTransform;
		public var sp:Sprite;
		private var _render:Function;
		private var _renderEdge:Function;
		private var _renderNode:Function;
		private var _onRenderStop:Function;
		private var _onRenderStart:Function;
		public var width:Number=1;
		public var height:Number = 1;
		public function MapRender(layout:*)
		{
			_render = Utils.bind(render, this);
			_renderEdge = Utils.bind(renderEdge, this);
			_renderNode = Utils.bind(renderNode, this);
			_onRenderStop = Utils.bind(onRenderStop, this);
			_onRenderStart = Utils.bind(onRenderStart, this);
			sp = new Sprite();
			this.layout = layout;
			this.layout.graph.addGraphListener(this);
		}
		
		public function graphChanged(e:*):void
		{
			this.start();
		}
		
		public function start(done:* = null):void
		{
			this.layout.start(_render, this._onRenderStop, this._onRenderStart);
		}
		
		public function render():void
		{
			this.clear();
			if (posTransform)
			{
				posTransform.updateBB(layout.getBoundingBox());
			}
			this.layout.eachEdge(_renderEdge);
			
			this.layout.eachNode(_renderNode);
		}
		
		private function renderNode(node:Node, point:Point):void
		{
			if (posTransform)
			{
				this.drawNode(node, posTransform.toScreen(point.p));
			}
			else
			{
				this.drawNode(node, point.p);
			}
		
		}
		
		private function renderEdge(edge:Edge, spring:Spring):void
		{
			if (posTransform)
			{
				this.drawEdge(edge, posTransform.toScreen(spring.point1.p), posTransform.toScreen(spring.point2.p));
			}
			else
				this.drawEdge(edge, spring.point1.p, spring.point2.p);
		}
		
		public function stop():void
		{
			this.layout.stop();
		}
		
		private function clear():void
		{
			trace("clear");
			sp.graphics.clear();
		}
		
		private function drawEdge(edge:Edge, p1:SpringVector, p2:SpringVector):void
		{
			trace("drawEdge:", edge, p1, p2);
			sp.graphics.drawLine(p1.x * width, p1.y * height, p2.x * width, p2.y * height, "#ff0000");
		}
		private var node:Object;
		
		private function drawNode(node:Node, p:SpringVector):void
		{
			trace("drawNode", node, p);
			sp.graphics.drawCircle(p.x * width, p.y * height, 15, "#ffff00");
			this.node = node;
		}
		
		public function onRenderStart():void
		{
		}
		
		public function onRenderStop():void
		{
		}
	}

}