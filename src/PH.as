package   
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import fl.motion.Color;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PH extends InterfaceElement
	{
		private var ph:Number;
		public var c_text:TextField;
		public var c_icon:MovieClip;
		
		public function PH() 
		{

		}
		
		public function setPH(n:Number) {
			ph = n;
			c_text.text = ph.toFixed(1);
		}
	
		/**
		 * Give me your current ph & volume, and your target ph, and I'll tell you how many lysosomes you need
		 * @param	curr_ph Current ph
		 * @param	vol     Current volume
		 * @param	targ_ph Target ph
		 * @return          Lysosomes needed
		 */
		public static function getLysosNeeded(curr_ph:Number, vol:Number, targ_ph:Number):Number {
			targ_ph = (curr_ph * 0.1) + (targ_ph * 0.9); //90% of the way
			var lyso_ph:Number = Lysosome.PH_BALANCE;
			var lyso_vol:Number = Lysosome.LYSO_VOL * Lysosome.VOL_V;
			var lysoneeded:Number = (vol * (targ_ph - curr_ph)) / (lyso_vol * (lyso_ph-targ_ph));
			return lysoneeded;

			//targph = (currph_vol + lysoph_vol * x) / (vol + lyso_volume*x);
		}
		
		/**
		 * Take one ph-bearing sphere and merge it with another ph bearing sphere
		 * @param	_ph ph of the first sphere
		 * @param	_vol volume of the first sphere
		 * @param	ph_ ph of the second sphere
		 * @param	vol_ volume of the second sphere
		 * @return ph of the resultant sphere
		 */
		
		public static function mergePH(_ph:Number, _vol:Number, ph_:Number, vol_:Number):Number {
			var _ph_vol:Number = _ph * _vol;
			var ph_vol_:Number = ph_ * vol_;
			var result:Number = (_ph_vol + ph_vol_) / (_vol + vol_);
			//trace("PH.mergePH! (" + _ph + "x" + _vol + ") + (" + ph_ +"x" + vol_ +"), result="+result);
			return result;
		}
		
		/**
		 * Take a ph-bearing sphere and remove it from a second ph-bearing sphere
		 * @param	ph_1 ph of the first sphere
		 * @param	vol_1 vol of the first sphere
		 * @param	ph_2 ph of the second sphere
		 * @param	vol_2 vol of the second sphere
		 * @return ph of the bigger sphere
		 */
		
		public static function removeFromPH(ph_1:Number, vol_1:Number, ph_2:Number, vol_2:Number):Number {
			var ph_vol_1:Number = ph_1 * vol_1;
			var ph_vol_2:Number = ph_2 * vol_2;
			var result:Number;
			if(vol_2 > vol_1)
				result = (ph_vol_2 - ph_vol_1) / (vol_2 - vol_1);
			else	
				result = (ph_vol_1 - ph_vol_2) / (vol_1 - vol_2);
			//trace("PH.removeFromPH! (" + ph_1 + "x" + vol_1 + ") , (" + ph_2 + "x" + vol_2 +"), result=" + result);
			return result;
		}
		
		public static function getCytoColor(ph_:Number) {
			if (ph_ < 4.5) {
				return Color.interpolateColor(0xFFAA44, 0xFFEE11, (ph_) / 4.5);
			}else if (ph_ > 4.5 && ph_ < 7.5) {
				return Color.interpolateColor(0xFFEE11, 0x44AAFF, (ph_-4.5) / 3);
			}else if (ph_ >= 7.5) {
				return Color.interpolateColor(0x44AAFF, 0x8833CC, (ph_-7.5) / 7.5);
			}
			return 0x000000; //error
		}
		
		public static function getGapColor(ph_:Number) {
			if (ph_ < 4.5) {
				return Color.interpolateColor(0xFF9999, 0xFFFF99, (ph_) / 4.5);
			}else if (ph_ > 4.5 && ph_ < 7.5) {
				return Color.interpolateColor(0xFFFF99, 0x99CCFF, (ph_-4.5) / 3);
			}else if (ph_ >= 7.5) {
				return Color.interpolateColor(0x99CCFF, 0xBB99FF, (ph_-7.5) / 7.5);
			}
			return 0x000000; //error
		}
		
		public static function getLineColor(ph_:Number) {
			if (ph_ < 4.5) {
				return Color.interpolateColor(0xFF0000, 0x996600, (ph_) / 4.5);
			}else if (ph_ > 4.5 && ph_ < 7.5) {
				return Color.interpolateColor(0x996600, 0x0066FF, (ph_-4.5) / 3);
			}else if (ph_ >= 7.5) {
				return Color.interpolateColor(0x0066FF, 0x663399, (ph_-7.5) / 7.5);
			}
			return 0x000000; //error
		}
		
		public override function blackOut() {
			super.blackOut();
			c_icon.visible = false;
			c_text.visible = false;
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			c_icon.visible = true;
			c_text.visible = true;
		}
	}
	
}