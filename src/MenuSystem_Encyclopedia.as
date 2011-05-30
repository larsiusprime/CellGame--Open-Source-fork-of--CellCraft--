package  
{
	import fl.containers.ScrollPane;
	import fl.controls.List;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStatsTest.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_Encyclopedia extends MenuSystem
	{
		
		public var c_list_index:List;
		public var c_scroll_game:ScrollPane;
		public var c_scroll_science:ScrollPane;
		public var c_game_text:TextSwitcher;
		public var c_science_text:TextSwitcher;
		public var c_pic_game:TextSwitcher;
		public var c_pic_science:TextSwitcher;
		public var c_butt_prev:SimpleButton;
		public var c_butt_next:SimpleButton;
		public var c_butt_exit:SimpleButton;
		public var c_text_title:TextField;
		
		private var curr_entry:String = "";
		
		public function MenuSystem_Encyclopedia(s:String="root",t:String="") 
		{
			curr_entry = s;
			trace("MenuSystem_Encyclopedia(" + curr_entry + ")");
		}
		
		public override function init() {
						
			Director.setHalfVolume(true);
			//Director.pauseAudio(true);
			c_butt_exit.addEventListener(MouseEvent.CLICK, doExit);
			c_butt_prev.addEventListener(MouseEvent.CLICK, doPrev);
			c_butt_next.addEventListener(MouseEvent.CLICK, doNext);
			c_science_text = new ScienceText();
			c_game_text = new GameText();
			c_scroll_game.source = c_game_text;
			c_scroll_science.source = c_science_text;
			
			setEntry(curr_entry);
		}
		
		public function doExit(m:MouseEvent) {
			Director.setHalfVolume(false);
			//Director.pauseAudio(false);
			exit();
		}
		
		private function sanitizeEntry(s:String):String {
			if (s == "protein_glob") return "protein";
			if (s == "all_resources") return "na";
			return s;
		}
		
		public function setEntry(s:String) {
			
			if(Director.STATS_ON){Log.CustomMetric("encyclopedia_show_" + s, "encyclopedia");}
			s = sanitizeEntry(s);
			curr_entry = s;
			getTitle(s);
			c_pic_game.gotoAndStop(curr_entry);
			c_pic_science.gotoAndStop(curr_entry);
			c_game_text.gotoAndStop(curr_entry);
			c_science_text.gotoAndStop(curr_entry);
			c_scroll_game.source = c_game_text;
			c_scroll_science.source = c_science_text;
			c_scroll_game.verticalScrollPosition = 0;
			c_scroll_science.verticalScrollPosition = 0;
		}
		
		public function doPrev(m:MouseEvent) {
			setEntry(c_pic_game.getPrevEntry());
		}
		
		public function doNext(m:MouseEvent) {
			setEntry(c_pic_game.getNextEntry());
		}
		
		public function getTitle(s:String) {
			var t:String;
			s = s.toLowerCase();
			if (s == "mitochondrion") t = "Mitochondrion";
			else if (s == "root") t = "The Cell";
			else if (s == "golgi") t = "Golgi Body";
			else if (s == "er") t = "Endoplasmic Reticulum";
			else if (s == "nucleus") t = "Nucleus";
			else if (s == "atp") t = "ATP";
			else if (s == "aa") t = "Amino Acids";
			else if (s == "fa") t = "Fatty Acids";
			else if (s == "na") t = "Nucleic Acids";
			else if (s == "g") t = "Glucose";
			else if (s == "mrna") t = "mRNA";
			else if (s == "chloroplast") t = "Chloroplast";
			else if (s == "dna") t = "DNA";
			else if (s == "membrane") t = "Plasma Membrane";
			else if (s == "centrosome") t = "Centrosome";
			else if (s == "cytoplasm") t = "Cytoplasm";
			else if (s == "ribosome") t = "Ribosome";
			else if (s == "lysosome") t = "Lysosome";
			else if (s == "peroxisome") t = "Peroxisome";
			else if (s == "organelle") t = "Organelle";
			else if (s == "protein") t = "Protein";
			else if (s == "pseudopod") t = "Pseudopod";
			else if (s == "plant") t = "Plant Cell";
			else if (s == "animal") t = "Animal Cell";
			else if (s == "metabolism") t = "Cellular Metabolism";
			else if (s == "injector") t = "Injector virus";
			else if (s == "invader") t = "Invader virus";
			else if (s == "infester") t = "Infester virus";
			else if (s == "necrosis") t = "Necrosis";
			else if (s == "recycling") t = "Lysosomic Recycling";
			else if (s == "radical") t = "Free Radical";
			else if (s == "defensin") t = "Defensin";
			else if (s == "brown_fat") t = "Brown Fat Cells";
			else if (s == "sydney") t = "Dr. Sydney Paradoxus";
			else if (s == "spike") t = "Dr. Spike Anatinus";
			else if (s == "bill") t = "Supreme Overlord Bill";
			else if (s == "jeeves") t = "JEEVES";
			else if (s == "platypus") t = "Duck-Billed Platypus";
			else if (s == "monotremus") t = "Planet Monotremus";
			else if (s == "e4r1h") t = "Planet E4-R1H";
			else if (s == "slicer") t = "Slicer Enzyme";
		
			c_text_title.htmlText = "<b>" + t + "</b>";
		}
	}
	
}