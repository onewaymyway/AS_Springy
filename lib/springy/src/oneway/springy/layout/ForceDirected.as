package oneway.springy.layout {
	import oneway.springy.Edge;
	import oneway.springy.Graph;
	import oneway.springy.Node;
	import oneway.springy.Point;
	import oneway.springy.Spring;
	import oneway.springy.SpringVector;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ForceDirected {
		public var graph:Graph;
		public var stiffness:Number;
		/**
		 * 排斥力
		 */
		public var repulsion:Number;
		/**
		 * 衰减
		 */
		public var damping:Number;
		public var minEnergyThreshold:Number;
		public var maxSpeed:Number;
		public var nodePoints:Object = {};
		public var edgeSprings:Object = {};
		
		public function ForceDirected(graph:Graph, stiffness:Number, repulsion:Number, damping:Number, minEnergyThreshold:Number = 0.01, maxSpeed:Number = 0) {
			this.graph = graph;
			this.stiffness = stiffness; // spring stiffness constant
			this.repulsion = repulsion; // repulsion constant
			this.damping = damping; // velocity damping factor
			this.minEnergyThreshold = minEnergyThreshold || 0.01; //threshold used to determine render stop
			this.maxSpeed = maxSpeed || Infinity; // nodes aren't allowed to exceed this speed
			
			this.nodePoints = {}; // keep track of points associated with nodes
			this.edgeSprings = {}; // keep track of springs associated with edges
		}
		
		public function point(node:Node):Point {
			if (!(node.id in this.nodePoints)) {
				var mass:Number = (node.data.mass !== undefined) ? node.data.mass : 1.0;
				this.nodePoints[node.id] = new Point(SpringVector.random(), mass);
			}
			
			return this.nodePoints[node.id];
		}
		
		public function spring(edge:Edge):Spring {
			if (!(edge.id in this.edgeSprings)) {
				var length:Number = (edge.data.length !== undefined) ? edge.data.length : 1.0;
				
				var existingSpring:* = false;
				
				var from:Array = this.graph.getEdges(edge.source, edge.target);
				from.forEach(function(e:*):void {
						if (existingSpring === false && e.id in this.edgeSprings) {
							existingSpring = this.edgeSprings[e.id];
						}
					}, this);
				
				if (existingSpring !== false) {
					return new Spring(existingSpring.point1, existingSpring.point2, 0.0, 0.0);
				}
				
				var to:Array = this.graph.getEdges(edge.target, edge.source);
				from.forEach(function(e:*):void {
						if (existingSpring === false && e.id in this.edgeSprings) {
							existingSpring = this.edgeSprings[e.id];
						}
					}, this);
				
				if (existingSpring !== false) {
					return new Spring(existingSpring.point2, existingSpring.point1, 0.0, 0.0);
				}
				
				this.edgeSprings[edge.id] = new Spring(this.point(edge.source), this.point(edge.target), length, this.stiffness);
			}
			
			return this.edgeSprings[edge.id];
		}
		
		public function eachNode(callback:Function):void {
			var t:* = this;
			this.graph.nodes.forEach(function(n:*):void {
					callback.call(t, n, t.point(n));
				});
		}
		
		public function eachEdge(callback:Function):void {
			var t:* = this;
			this.graph.edges.forEach(function(e:*):void {
					callback.call(t, e, t.spring(e));
				});
		}
		
		public function eachSpring(callback:Function):void {
			var t:* = this;
			this.graph.edges.forEach(function(e:*):void {
					callback.call(t, t.spring(e));
				});
		}
		
		public function applyCoulombsLaw():void {
			this.eachNode(function(n1:*, point1:*):void {
					this.eachNode(function(n2:*, point2:*):void {
							if (point1 !== point2) {
								var d:* = point1.p.subtract(point2.p);
								var distance:* = d.magnitude() + 0.1; // avoid massive forces at small distances (and divide by zero)
								var direction:* = d.normalise();
								
								// apply force to each end point
								point1.applyForce(direction.multiply(this.repulsion).divide(distance * distance * 0.5));
								point2.applyForce(direction.multiply(this.repulsion).divide(distance * distance * -0.5));
							}
						});
				});
		}
		
		public function applyHookesLaw():void {
			this.eachSpring(function(spring:*):void {
					var d:* = spring.point2.p.subtract(spring.point1.p); // the direction of the spring
					var displacement:* = spring.length - d.magnitude();
					var direction:* = d.normalise();
					
					// apply force to each end point
					spring.point1.applyForce(direction.multiply(spring.k * displacement * -0.5));
					spring.point2.applyForce(direction.multiply(spring.k * displacement * 0.5));
				});
		}
		
		public function attractToCentre():void {
			this.eachNode(function(node:*, point:*):void {
					var direction:* = point.p.multiply(-1.0);
					point.applyForce(direction.multiply(this.repulsion / 50.0));
				});
		}
		
		public function updateVelocity(timestep:Number):void {
			this.eachNode(function(node:*, point:*):void {
				// Is this, along with updatePosition below, the only places that your
				// integration code exist?
					point.v = point.v.add(point.a.multiply(timestep)).multiply(this.damping);
					if (point.v.magnitude() > this.maxSpeed) {
						point.v = point.v.normalise().multiply(this.maxSpeed);
					}
					point.a = new SpringVector(0, 0);
				});
		}
		
		public function updatePosition(timestep:Number):void {
			this.eachNode(function(node:*, point:*):void {
				// Same question as above; along with updateVelocity, is this all of
				// your integration code?
					point.p = point.p.add(point.v.multiply(timestep));
				});
		}
		
		public function totalEnergy(timestep:Number=0.03):Number {
			var energy:* = 0.0;
			this.eachNode(function(node:Node, point:Point):void {
					var speed:* = point.v.magnitude();
					energy += 0.5 * point.m * speed * speed;
				});
			
			return energy;
		}
		
		public var render:Function;
		public var onRenderStop:Function;
		public var onRenderStart:Function;
		private var _started:Boolean;
		private var _stop:Boolean;
		public function start(render:*, onRenderStop:Function, onRenderStart:Function):void {
			this.render = render;
			this.onRenderStart = onRenderStart;
			this.onRenderStop = onRenderStop;
			if (this._started)
				return;
			this._started = true;
			this._stop = false;
			
			if (onRenderStart !=null) {
				onRenderStart();
			}
			
			Laya.timer.frameLoop(1, this, step);
		}
		
		private function step():* {
				this.tick(0.03);
				
				if (render !=null) {
					render();
				}
				
				// stop simulation when energy of the system goes below a threshold
				if (this._stop || this.totalEnergy() < this.minEnergyThreshold) {
					this._started = false;
					if (onRenderStop !=null) {
						onRenderStop();
					}
					Laya.timer.clear(this, step);
				}
				else {
				}
		}
		
		public function stop():void {
			this._stop = true;
		}
		
		public function tick(timestep:Number):void {
			this.applyCoulombsLaw();
			this.applyHookesLaw();
			this.attractToCentre();
			this.updateVelocity(timestep);
			this.updatePosition(timestep);
		}
		
		public function nearest(pos:*):Object {
			var min:Object = {node: null, point: null, distance: null};
			var t:ForceDirected = this;
			this.graph.nodes.forEach(function(n:*):* {
					var point:* = t.point(n);
					var distance:* = point.p.subtract(pos).magnitude();
					
					if (min.distance === null || distance < min.distance) {
						min = {node: n, point: point, distance: distance};
					}
				});
			
			return min;
		}
		
		public function getBoundingBox():Object {
			var bottomleft:* = new SpringVector(-2, -2);
			var topright:* = new SpringVector(2, 2);
			
			this.eachNode(function(n:*, point:*):* {
					if (point.p.x < bottomleft.x) {
						bottomleft.x = point.p.x;
					}
					if (point.p.y < bottomleft.y) {
						bottomleft.y = point.p.y;
					}
					if (point.p.x > topright.x) {
						topright.x = point.p.x;
					}
					if (point.p.y > topright.y) {
						topright.y = point.p.y;
					}
				});
			
			var padding:* = topright.subtract(bottomleft).multiply(0.07); // ~5% padding
			
			return {bottomleft: bottomleft.subtract(padding), topright: topright.add(padding)};
		}
	
	}

}