package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class Point {
		/**
		 * position
		 */
		public var p:Object;
		/**
		 * mass
		 */
		public var m:Number;
		/**
		 * velocity
		 */
		public var v:SpringVector;
		/**
		 * acceleration
		 */
		public var a:SpringVector;
		
		public function Point(position:Object, mass:Number) {
			this.p = position; // position
			this.m = mass; // mass
			this.v = new SpringVector(0, 0); // velocity
			this.a = new SpringVector(0, 0); // acceleration
		}
		
		public function applyForce(force:SpringVector):void {
			this.a = this.a.add(force.divide(this.m));
		}
		
		
	}

}