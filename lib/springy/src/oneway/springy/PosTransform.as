package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class PosTransform {
		public var width:int = 100;
		public var height:int = 100;
		public var currentBB:Object;
		public var size:SpringVector;
		public function updateBB(bb:Object):void
		{
			this.currentBB = bb;
			size = currentBB.topright.subtract(currentBB.bottomleft);
			var xS:Number;
			var yS:Number;
			xS = size.x / width;
			yS = size.y / height;
			if (xS < yS)
			{
				size.x = width * yS;
			}else
			{
				size.y = height * xS;
			}
		}
		
		public function PosTransform() {
		
		}
		
		public function toScreen(p:SpringVector):SpringVector {
			//var size:SpringVector = currentBB.topright.subtract(currentBB.bottomleft);
			var sx:Number = p.subtract(currentBB.bottomleft).divide(size.x).x * width;
			var sy:Number = p.subtract(currentBB.bottomleft).divide(size.y).y * height;
			return new SpringVector(sx, sy);
		}
		
		public function fromScreen(s:SpringVector):SpringVector {
			//var size:SpringVector = currentBB.topright.subtract(currentBB.bottomleft);
			var px:Number = (s.x / width) * size.x + currentBB.bottomleft.x;
			var py:Number = (s.y / height) * size.y + currentBB.bottomleft.y;
			return new Springy.Vector(px, py);
		}
	}

}