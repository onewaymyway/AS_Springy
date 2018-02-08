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
		public var pos:SpringVector;
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
			pos = currentBB.bottomleft;
		}
		
		public function PosTransform() {
		
		}
		
		public function toScreen(p:SpringVector):SpringVector {	
			var sx:Number =(p.x-pos.x)*width/size.x;
			var sy:Number = (p.y-pos.y)*height/size.y;
			return new SpringVector(sx, sy);
		}
		
		public function fromScreen(s:SpringVector):SpringVector {
			//var size:SpringVector = currentBB.topright.subtract(currentBB.bottomleft);
			var px:Number = (s.x / width) * size.x + pos.x;
			var py:Number = (s.y / height) * size.y + pos.y;
			return new Springy.Vector(px, py);
		}
	}

}