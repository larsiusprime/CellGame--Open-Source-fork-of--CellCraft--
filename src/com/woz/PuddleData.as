package com.woz 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PuddleData extends EntityData
	{
		private var _goodieType:String;
		private var _radius:Number;
		private var _area:Number;
		private var _concentration:Number;
		private var _amount:Number;

		
		public function PuddleData() 
		{
			super();
		}
		
		public function set goodieType(s:String) {
			s.toLowerCase();
			_goodieType = s;
			if (s == "aa") {
				_concentration = Cell.AA_CONCENTRATION;
			}else if (s == "na") {
				_concentration = Cell.NA_CONCENTRATION;
			}else if (s == "fa") {
				_concentration = Cell.FA_CONCENTRATION;
			}else if (s == "g") {
				_concentration = Cell.G_CONCENTRATION;
			}else {
				throw new Error("Unrecognized goodie type : " + s);
			}
		}
		
		public function set radius(r:Number) {
			_radius = r;
			_area = _radius * _radius * Math.PI;
			_amount = _concentration * _area;
		}
		
		public function get amount():Number {
			return _amount;
		}
		
	}
	
}