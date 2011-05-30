package  
{
	import com.pecLevel.WaveEntry;
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_Reward extends MenuSystem
	{
		public var butt:SimpleButton;
		public var wave_text:TextField;
		public var count_text:TextField;
		public var spawn_text:TextField;
		public var escape_text:TextField;
		public var infest_text:TextField;
		public var na_text:TextField;
		public var aa_text:TextField;
		public var fa_text:TextField;
		
		public var virus_clip:MovieClip;
		
		public var na:Sprite;
		public var fa:Sprite;
		public var aa:Sprite;
		
		public var na_reward:int;
		public var aa_reward:int;
		public var fa_reward:int;
		
		public var grade:MovieClip;
		
		public var performance:String = "f";
		
		public var wave:String = "";
		
		public var c_infest:Sprite;
		
		
		public function MenuSystem_Reward() 
		{
			butt.addEventListener(MouseEvent.CLICK, onOkay, false, 0, true);
			//Director.startSFX(SoundLibrary.SFX_DISCOVERY);
		}
		
		public function setData(w:WaveEntry) {
			wave = w.id;
			setVirus(w);
			calcResources(w);
		}
		
		public function calcResources(w:WaveEntry) {
			var type:String = w.type;
			var count:int = w.original_count;
			var na_base:Number = 0;
			var aa_base:Number = 0;
			var fa_base:Number = 0;
			if (type == "virus_injector") {
				na_base = VirusInjector.RNA_COUNT * Costs.REWARD_INJECTOR[1];
				aa_base = VirusInjector.SPAWN_COUNT * Costs.REWARD_INJECTOR[2];
				fa_base = VirusInjector.SPAWN_COUNT * Costs.REWARD_INJECTOR[3] * w.vesicle;
			}else if (type == "virus_invader") {
				na_base = VirusInvader.RNA_COUNT * Costs.REWARD_INVADER[1];
				aa_base = VirusInvader.SPAWN_COUNT * Costs.REWARD_INVADER[2];
				fa_base = VirusInvader.SPAWN_COUNT * Costs.REWARD_INVADER[3] * w.vesicle;
			}else if (type == "virus_infester") {
				na_base = VirusInfester.RNA_COUNT * Costs.REWARD_INFESTER[1];
				aa_base = VirusInfester.SPAWN_COUNT * Costs.REWARD_INFESTER[2];
				fa_base = VirusInfester.SPAWN_COUNT * Costs.REWARD_INFESTER[3] * w.vesicle;
			}
			
			na_reward = Math.round(na_base * count);
			aa_reward = Math.round(aa_base * count);
			fa_reward = Math.round(fa_base * count);
			
			setResources(na_reward, aa_reward, fa_reward);
		}
		
		
		public function setResources(_na:int = 0, _aa:int = 0, _fa:int = 0) {
			na_text.htmlText = "<b>"+_na.toString()+"</b>";
			aa_text.htmlText = "<b>"+_aa.toString()+"</b>";
			fa_text.htmlText = "<b>"+_fa.toString()+"</b>";
			
			if (_fa == 0) {
				fa.visible = false;
				fa_text.visible = false;
			}
		}
		
		public function setVirus(w:WaveEntry) {
			var type:String = w.type;
						
			type = type.substr(6, type.length - 6);
			
			virus_clip.gotoAndStop(type);
			
			var intl:String = type.charAt(0);
						
			if (type == "infester") {
				infest_text.htmlText = "<b>" + w.infest_count.toString() + "</b>";
			}else {							//ONLY show infestation for infester virus
				c_infest.visible = false;
				infest_text.visible = false;
			}
			
			type = type.substr(1, type.length - 1);
			type = intl.toUpperCase() + type;
			wave_text.htmlText = "<b>"+type + " Virus</b>";
			count_text.htmlText = "<b>"+w.original_count.toString()+"</b>";
			spawn_text.htmlText = "<b>"+w.spawned_count.toString()+"</b>";
			escape_text.htmlText = "<b>" + w.escaped_count.toString() + "</b>";
			
			
			calcPerformance(w);
			//type. = type.charAt(0).toUpperCase();
			//wave_text.text = w.type
		}
		
		public function calcPerformance(w:WaveEntry) {
			var orig:Number = w.original_count;
			var spawn:Number = w.spawned_count;
			var escape:Number = w.escaped_count;
			var infest:Number = w.infest_count;
			
			//trace("
			
			var spawn_batch:Number = spawn / orig;
			var escape_batch:Number = escape / orig;
			var infest_batch:Number = infest / (orig * VirusInfester.RNA_COUNT);
			
			var batch:Number = (spawn_batch + escape_batch + infest_batch);
			
			var gpa:int = 0;
			
			if (batch == 0) {
				performance = "a+";
				gpa = 5;
			}else if (batch < 1) {
				performance = "a";
				gpa = 4;
			}else if (batch < 2) {
				performance = "b";
				gpa = 3;
			}else if (batch < 3) {
				performance = "c";
				gpa = 2;
			}else if (batch < 5) {
				performance = "d";
				gpa = 1;
			}else{
				performance = "d-";
				gpa = 0;
			}
			grade.gotoAndStop(performance);
			
			
			Engine.logGPA(gpa, orig);
		}
		
		public function onOkay(m:MouseEvent) {
			
			//p_engine.getReward(na_reward, aa_reward, fa_reward);
			exit();
		}
		
		public function getRewards():Array {
			return [0, na_reward, aa_reward, fa_reward, 0];
		}
		
	}
	
}