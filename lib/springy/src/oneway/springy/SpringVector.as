package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class SpringVector{
		public var x:Number;
		public var y:Number;
		
		public function SpringVector(x:Number, y:Number) {
			this.x = x;
			this.y = y;
		}
		
		public static function random():SpringVector {
			return new SpringVector(10.0 * (Math.random() - 0.5), 10.0 * (Math.random() - 0.5));
		}
		
		public function add(v2:SpringVector):SpringVector {
			return new SpringVector(this.x + v2.x, this.y + v2.y);
		}
		
		public function subtract(v2:SpringVector):SpringVector {
			return new SpringVector(this.x - v2.x, this.y - v2.y);
		}
		
		public function multiply(n:Number):SpringVector {
			return new SpringVector(this.x * n, this.y * n);
		}
		
		public function divide(n:Number):SpringVector {
			return new SpringVector((this.x / n) || 0, (this.y / n) || 0); // Avoid divide by zero errors..
		}
		
		public function magnitude():Number {
			return Math.sqrt(this.x * this.x + this.y * this.y);
		}
		
		public function normal():SpringVector {
			return new SpringVector(-this.y, this.x);
		}
		
		public function normalise():SpringVector {
			return this.divide(this.magnitude());
		}
	}

}