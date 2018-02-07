package oneway.springy 
{
	/**
	 * ...
	 * @author ww
	 */
	public class Node 
	{
		public var id:String;
		public var data:Object;
		public function Node(id:*,data:Object=null) 
		{
			this.id = id;
			this.data = data || { };
		}
		
	}

}