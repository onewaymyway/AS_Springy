package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class Spring {
		public var point1:Point;
		public var point2:Point;
		public var length:Number;
		public var k:Number;
		
		public function Spring(point1:Point, point2:Point, length:Number, k:Number) {
			this.point1 = point1;
			this.point2 = point2;
			this.length = length; // spring length at rest
			this.k = k; // spring constant (See Hooke's law) .. how stiff the spring is
		}
		
		public static function isEmpty(obj:Object):Boolean {
			for (var k:String in obj) {
				if (obj.hasOwnProperty(k)) {
					return false;
				}
			}
			return true;
		}
		
		public static var requestAnimationFrame:Function;
	}

}