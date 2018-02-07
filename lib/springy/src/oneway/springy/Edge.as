package oneway.springy 
{
	/**
	 * ...
	 * @author ww
	 */
	public class Edge 
	{
		public var id:int;
		public var source:Node;
		public var target:Node;
		public var data:Object;
		public function Edge(id:*,source:Node,target:Node,data:Object=null) 
		{
			this.id = id;
			this.source = source;
			this.target = target;
			this.data = data || {};
		}
		
	}

}