package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class Graph {
		public var nodeSet:Object = {};
		public var nodes:Array = [];
		public var edges:Array = [];
		public var adjacency:Object = {};
		public var nextNodeId:int = 0;
		public var nextEdgeId:int = 0;
		public var eventListeners:Array = [];
		
		public function Graph() {
		
		}
		
		public function addNode(node:Node):Node {
			if (!(node.id in this.nodeSet)) {
				this.nodes.push(node);
			}
			
			this.nodeSet[node.id] = node;
			
			this.notify();
			return node;
		}
		
		public function addNodes(... args):void {
			for (var i:int = 0; i < args.length; i++) {
				var name:String = args[i];
				var node:Node = new Node(name, {label: name});
				this.addNode(node);
			}
		}
		
		public function addEdge(edge:Edge):Edge {
			var exists:Boolean = false;
			this.edges.forEach(function(e:Edge):void {
					if (edge.id === e.id) {
						exists = true;
					}
				});
			
			if (!exists) {
				this.edges.push(edge);
			}
			
			if (!(edge.source.id in this.adjacency)) {
				this.adjacency[edge.source.id] = {};
			}
			if (!(edge.target.id in this.adjacency[edge.source.id])) {
				this.adjacency[edge.source.id][edge.target.id] = [];
			}
			
			exists = false;
			this.adjacency[edge.source.id][edge.target.id].forEach(function(e:Edge):void {
					if (edge.id === e.id) {
						exists = true;
					}
				});
			
			if (!exists) {
				this.adjacency[edge.source.id][edge.target.id].push(edge);
			}
			
			this.notify();
			return edge;
		}
		
		public function addEdges(... args):void {
			// accepts variable number of arguments, where each argument
			// is a triple [nodeid1, nodeid2, attributes]
			for (var i:int = 0; i < args.length; i++) {
				var e:Object = args[i];
				var node1:Node = this.nodeSet[e[0]];
				if (!node1) {
					throw new Error("invalid node name: " + e[0]);
				}
				var node2:Node = this.nodeSet[e[1]];
				if (!node2) {
					throw new Error("invalid node name: " + e[1]);
				}
				var attr:Object = e[2];
				
				this.newEdge(node1, node2, attr);
			}
		}
		
		public function newNode(data:Object = null):Node {
			var node:Node = new Node(this.nextNodeId++, data);
			this.addNode(node);
			return node;
		}
		
		public function newEdge(source:Node, target:Node, data:Object = null):Edge {
			var edge:Edge = new Edge(this.nextEdgeId++, source, target, data);
			this.addEdge(edge);
			return edge;
		}
		
		public function loadJSON(json:*):void {
			if (json is String) {
				json = JSON.parse(json);
			}
			
			if ('nodes' in json || 'edges' in json) {
				this.addNodes.apply(this, json['nodes']);
				this.addEdges.apply(this, json['edges']);
			}
		}
		
		public function getEdges(node1:Node, node2:Node):Array {
			if (node1.id in this.adjacency && node2.id in this.adjacency[node1.id]) {
				return this.adjacency[node1.id][node2.id];
			}
			
			return [];
		}
		
		public function removeNode(node:Node):void {
			if (node.id in this.nodeSet) {
				delete this.nodeSet[node.id];
			}
			
			for (var i:int = this.nodes.length - 1; i >= 0; i--) {
				if (this.nodes[i].id === node.id) {
					this.nodes.splice(i, 1);
				}
			}
			
			this.detachNode(node);
		}
		
		public function detachNode(node:Node):void {
			var tmpEdges:Array = this.edges.slice();
			tmpEdges.forEach(function(e:Edge):void {
					if (e.source.id === node.id || e.target.id === node.id) {
						this.removeEdge(e);
					}
				}, this);
			
			this.notify();
		}
		
		public function removeEdge(edge:Edge):void {
			for (var i:int = this.edges.length - 1; i >= 0; i--) {
				if (this.edges[i].id === edge.id) {
					this.edges.splice(i, 1);
				}
			}
			
			for (var x:String in this.adjacency) {
				for (var y:String in this.adjacency[x]) {
					var edges:Array = this.adjacency[x][y];
					
					for (var j:int = edges.length - 1; j >= 0; j--) {
						if (this.adjacency[x][y][j].id === edge.id) {
							this.adjacency[x][y].splice(j, 1);
						}
					}
					
					// Clean up empty edge arrays
					if (this.adjacency[x][y].length == 0) {
						delete this.adjacency[x][y];
					}
				}
				
				// Clean up empty objects
				if (Spring.isEmpty(this.adjacency[x])) {
					delete this.adjacency[x];
				}
			}
			
			this.notify();
		}
		
		public function merge(data:Object):void {
			var nodes:Array = [];
			data.nodes.forEach(function(n:Node):void {
					nodes.push(this.addNode(new Node(n.id, n.data)));
				}, this);
			
			data.edges.forEach(function(e:*):void {
					var from:* = nodes[e.from];
					var to:* = nodes[e.to];
					
					var id:String = (e.directed) ? (id = e.type + "-" + from.id + "-" + to.id) : (from.id < to.id) // normalise id for non-directed edges
						? e.type + "-" + from.id + "-" + to.id : e.type + "-" + to.id + "-" + from.id;
					
					var edge:Edge = this.addEdge(new Edge(id, from, to, e.data));
					edge.data.type = e.type;
				}, this);
		}
		
		public function filterNodes(fn:Function):void {
			var tmpNodes:Array = this.nodes.slice();
			tmpNodes.forEach(function(n:Node):void {
					if (!fn(n)) {
						this.removeNode(n);
					}
				}, this);
		}
		
		public function filterEdges(fn:Function):void {
			var tmpEdges:Array = this.edges.slice();
			tmpEdges.forEach(function(e:*):void {
					if (!fn(e)) {
						this.removeEdge(e);
					}
				}, this);
		}
		
		public function addGraphListener(obj:Object):void {
			this.eventListeners.push(obj);
		}
		
		public function notify():void {
			this.eventListeners.forEach(function(obj:*):void {
					obj.graphChanged();
				});
		}
	}

}