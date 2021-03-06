package oneway.springy {
	import oneway.springy.layout.ForceDirected;
	
	/**
	 * ...
	 * @author ww
	 */
	public class Renderer {
		public var layout:ForceDirected;
		public var clear:Function;
		public var drawEdge:Function;
		public var drawNode:Function;
		public var onRenderStop:Function;
		public var onRenderStart:Function;
		public var posTransform:PosTransform;
		
		public function Renderer(layout:*, clear:Function, drawEdge:Function, drawNode:Function, onRenderStop:Function, onRenderStart:Function) {
			this.layout = layout;
			this.clear = clear;
			this.drawEdge = drawEdge;
			this.drawNode = drawNode;
			this.onRenderStop = onRenderStop;
			this.onRenderStart = onRenderStart;
			
			this.layout.graph.addGraphListener(this);
		}
		
		public function graphChanged(e:*):void {
			this.start();
		}
		
		public function start(done:* = null):void {
			var t:Renderer = this;
			this.layout.start(function render():void {
					t.clear();
					if (posTransform) {
						posTransform.updateBB(layout.getBoundingBox());
					}
					t.layout.eachEdge(function(edge:Edge, spring:Spring):void {
							if (posTransform) {
								t.drawEdge(edge, posTransform.toScreen(spring.point1.p), posTransform.toScreen(spring.point2.p));
							}
							else
								t.drawEdge(edge, spring.point1.p, spring.point2.p);
						});
					
					t.layout.eachNode(function(node:Node, point:Point):void {
							if (posTransform) {
								t.drawNode(node, posTransform.toScreen(point.p));
							}
							else {
								t.drawNode(node, point.p);
							}
						
						});
				}, this.onRenderStop, this.onRenderStart);
		}
		
		public function stop():void {
			this.layout.stop();
		}
	}

}