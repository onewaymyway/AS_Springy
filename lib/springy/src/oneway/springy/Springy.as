package oneway.springy {
	
	/**
	 * ...
	 * @author ww
	 */
	public class Springy {
		
		public function Springy() {
		
		}
		
		public static function init():void {
			var requestFun:Function;
			var b:*= __JS__("window");
			requestFun = b.requestAnimationFrame || b.webkitRequestAnimationFrame || b.mozRequestAnimationFrame || b.oRequestAnimationFrame || b.msRequestAnimationFrame;
			Spring.requestAnimationFrame = requestFun;
		}
	}

}