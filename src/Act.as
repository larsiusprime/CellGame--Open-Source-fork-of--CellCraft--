package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Act //Act for Action
	{
		public static const NOTHING:int = -1;
		public static const MOVE:int = 0;
		public static const RECYCLE:int = 1;
		public static const CANCEL_RECYCLE:int = 2;
		public static const POP:int = 3;
		public static const REPAIR:int = 4;
		public static const DIVIDE:int = 5;

		public static const ACTIVE_TRANSPORT:int = 16;
		public static const PASSIVE_TRANSPORT:int = 17;
		public static const MITOSIS:int = 18;
		public static const MAKE_DEFENSIN:int = 19;
		public static const TAKE_DEFENSIN:int = 20;
		
		
		public static const EAT:int = 22;
		public static const TARGET:int = 23;
		
		
		public static const MAKE_TOXIN:int = 24;
		public static const TAKE_TOXIN:int = 25;
		
		public static const MAKE_BASALBODY:int = 32;
		public static const MAKE_MEMBRANE:int = 33;
		public static const TAKE_MEMBRANE:int = 34;
		public static const MAKE_VESICLE:int = 35;
		public static const UPGRADE_ER:int = 36;
		public static const ATTACH_ER:int = 37;
		public static const DETACH_ER:int = 38;
		public static const MAKE_GOLGI:int = 39;
		
		public static const BLEB:int = 40;
		public static const PSEUDOPOD:int = 41;
		public static const PSEUDOPOD_PREPARE:int = 42;
		
		public static const DISABLE:int = 50;
		public static const ENABLE:int = 51;
		public static const TOGGLE:int = 52;
		public static const MIX_DISABLE:int = 53;
		public static const TOGGLE_FA:int = 53;
		public static const BURN_G:int = 54;
		public static const BURN_FA:int = 55;
		public static const TOGGLE_BROWN_FAT:int = 56;
		public static const ENABLE_BROWN_FAT:int = 57;
		public static const DISABLE_BROWN_FAT:int = 58;
		public static const MIX_BROWN_FAT:int = 59;
		
		public static const APOPTOSIS:int = 60;
		public static const NECROSIS:int = 61;
		
		public static const BUY_LYSOSOME:int = 70;
		public static const BUY_PEROXISOME:int = 71;
		public static const ENABLE_AUTO_PEROXISOME:int = 72;
		public static const DISABLE_AUTO_PEROXISOME:int = 73;
		public static const TOGGLE_AUTO_PEROXISOME:int = 74;
		public static const BUY_SLICER:int = 75;
		public static const BUY_RIBOSOME:int = 76;
		public static const BUY_DNAREPAIR:int = 77;
		
		public static const LYSOSOME_X:int = 2;   
		public static const DEFENSIN_X:int = 1;   
		public static const PEROXISOME_X:int = 1;
		public static const SLICER_X:int = 5;
		public static const RIBOSOME_X:int = 5;
		public static const DNAREPAIR_X:int = 1;
		
		public function Act() 
		{
			
		}
		
		public static function getI(s:String):int {
			s.toLowerCase();
			if (s == "move") return MOVE;
			else if (s == "recycle") return RECYCLE;
			else if (s == "cancel_recycle") return CANCEL_RECYCLE;
			else if (s == "pop") return POP;
			else if (s == "repair") return REPAIR;
			else if (s == "divide") return DIVIDE;
			else if (s == "apoptosis") return APOPTOSIS;
			else if (s == "necrosis") return NECROSIS;
			else if (s == "active_transport") return ACTIVE_TRANSPORT;
			else if (s == "passive_transport") return PASSIVE_TRANSPORT;
			else if (s == "mitosis") return MITOSIS;
			else if (s == "make_defensin") return MAKE_DEFENSIN;
			else if (s == "take_defensin") return TAKE_DEFENSIN;
			else if (s == "make_golgi") return MAKE_GOLGI;
			else if (s == "eat") return EAT;
			else if (s == "target") return TARGET;
			else if (s == "make_basalbody") return MAKE_BASALBODY;
			else if (s == "make_membrane") return MAKE_MEMBRANE;
			else if (s == "take_membrane") return TAKE_MEMBRANE;
			else if (s == "make_vesicle") return MAKE_VESICLE;
			else if (s == "upgrade_er") return UPGRADE_ER;
			else if (s == "attach_er") return ATTACH_ER;
			else if (s == "detach_er") return DETACH_ER;
			else if (s == "bleb") return BLEB;
			else if (s == "pseudopod") return PSEUDOPOD;
			else if (s == "pseudopod_prepare") return PSEUDOPOD_PREPARE;
			else if (s == "enable") return ENABLE;
			else if (s == "disable") return DISABLE;
			else if (s == "toggle") return TOGGLE;
			else if (s == "toggle_fa") return TOGGLE_FA;
			else if (s == "burn_fa") return BURN_FA;
			else if (s == "burn_g") return BURN_G;
			else if (s == "enable_brown_fat") return ENABLE_BROWN_FAT;
			else if (s == "disable_brown_fat") return DISABLE_BROWN_FAT;
			else if (s == "toggle_brown_fat") return TOGGLE_BROWN_FAT;
			else if (s == "enable_auto_peroxisome") return ENABLE_AUTO_PEROXISOME;
			else if (s == "disable_auto_peroxisome") return DISABLE_AUTO_PEROXISOME;
			else if (s == "toggle_auto_peroxisome") return TOGGLE_AUTO_PEROXISOME;
			else if (s == "mix_disable") return MIX_DISABLE;
			else if (s == "mix_brown_fat") return MIX_BROWN_FAT;
			else if (s == "buy_lysosome") return BUY_LYSOSOME;
			else if (s == "buy_peroxisome") return BUY_PEROXISOME;
			else if (s == "buy_ribosome") return BUY_RIBOSOME;
			else if (s == "buy_slicer") return BUY_SLICER;
			else if (s == "buy_dnarepair") return BUY_DNAREPAIR;
			else if (s == "make_toxin") return MAKE_TOXIN;
			else if (s == "take_toxin") return TAKE_TOXIN;
			return NOTHING;
		}
		
		public static function getS(i:int):String {
			switch(i) {
				case NOTHING: return ""; break;
				case MOVE: return "move"; break;
				case RECYCLE: return "recycle"; break;
				case CANCEL_RECYCLE: return "cancel_recycle"; break;
				case POP: return "pop"; break;
				case REPAIR: return "repair"; break;
				case DIVIDE: return "divide"; break;
				case APOPTOSIS: return "apoptosis"; break;
				case NECROSIS: return "necrosis"; break;
				case ACTIVE_TRANSPORT: return "active_transport"; break;
				case PASSIVE_TRANSPORT: return "passive_transport"; break;
				case MITOSIS: return "mitosis"; break;
				case MAKE_GOLGI: return "make_golgi"; break;
				case MAKE_DEFENSIN: return "make_defensin"; break;
				case TAKE_DEFENSIN: return "take_defensin"; break;
				case EAT: return "eat"; break;
				case TARGET: return "target"; break;
				case MAKE_BASALBODY: return "make_basalbody"; break;
				case MAKE_MEMBRANE: return "make_membrane"; break;
				case TAKE_MEMBRANE: return "take_membrane"; break;
				case MAKE_VESICLE: return "make_vesicle"; break;
				case UPGRADE_ER: return "upgrade_er"; break;
				case ATTACH_ER: return "attach_er"; break;
				case DETACH_ER: return "detach_er"; break;
				case BLEB: return "bleb"; break;
				case PSEUDOPOD: return "pseudopod"; break;
				case PSEUDOPOD_PREPARE: return "pseudopod_prepare"; break;
				case ENABLE: return "enable"; break;
				case DISABLE: return "disable"; break;
				case TOGGLE: return "toggle"; break;
				case TOGGLE_FA: return "toggle_fa"; break;
				case BURN_FA: return "burn_fa"; break;
				case BURN_G: return "burn_g"; break;
				case TOGGLE_BROWN_FAT: return "toggle_brown_fat"; break;
				case ENABLE_BROWN_FAT: return "enable_brown_fat"; break;
				case DISABLE_BROWN_FAT: return "disable_brown_fat"; break;
				case MIX_DISABLE: return "mix_disable"; break;
				case MIX_BROWN_FAT: return "mix_brown_fat"; break;
				case BUY_LYSOSOME: return "buy_lysosome"; break;
				case BUY_PEROXISOME: return "buy_peroxisome"; break;
				case ENABLE_AUTO_PEROXISOME: return "enable_auto_peroxisome"; break;
				case TOGGLE_AUTO_PEROXISOME: return "toggle_auto_peroxisome"; break;
				case DISABLE_AUTO_PEROXISOME: return "disable_auto_peroxisome"; break;
				case BUY_SLICER: return "buy_slicer"; break;
				case BUY_RIBOSOME: return "buy_ribosome"; break;
				case BUY_DNAREPAIR: return "buy_dnarepair"; break;
				case MAKE_TOXIN: return "make_toxin"; break;
				case TAKE_TOXIN: return "take_toxin"; break;
			}
			return "";
		}
		
		public static function getTxt(i:int):String {
			var s:String;
			switch(i) {
				case NOTHING: return ""; break;
				case MOVE: return ("Move"); break;
				case POP: return ("Pop");  break;
				case RECYCLE: return ("Recycle"); break;
				case CANCEL_RECYCLE: return ("Cancel Recycle"); break;	
				case REPAIR: return ("Repair");break;
				case DIVIDE: return ("Divide"); break;
				case APOPTOSIS: return ("Apoptosis"); break;
				case NECROSIS: return ("Necrosis"); break;
				case MITOSIS: return ("Mitosis"); break;
				case MAKE_GOLGI: return ("Make Golgi"); break;
				case MAKE_BASALBODY: return ("Make Basal Body"); break;
				case MAKE_MEMBRANE: return ("Buy Membrane"); break;
				case TAKE_MEMBRANE: return ("Recycle Membrane"); break;
				case MAKE_VESICLE: return ("Make Vesicle"); break;
				case UPGRADE_ER: return ("Upgrade ER");  break;
				case ATTACH_ER: return ("Attach ER");  break;
				case DETACH_ER: return ("Detach ER");  break;
				case BLEB: return ("Bleb"); break;
				case PSEUDOPOD: return ("Pseudopod"); break;
				case PSEUDOPOD_PREPARE: return ("Click & Drag"); break;
				case ENABLE: return ("Enable"); break;
				case DISABLE: return ("Disable"); break;
				case TOGGLE: return ("Toggle"); break;
				case TOGGLE_FA: return ("Toggle FA"); break;
				case BURN_G: return ("Use Glucose"); break;
				case BURN_FA: return ("Use Fatty Acids"); break;
				//case BURN_
				case TOGGLE_BROWN_FAT: return ("Toggle Brown Fat"); break;
				case ENABLE_BROWN_FAT: return ("Enable Brown Fat"); break;
				case DISABLE_BROWN_FAT: return ("Disable Brown Fat"); break;
				case TOGGLE_AUTO_PEROXISOME: return ("Toggle Auto-build peroxisomes"); break;
				case ENABLE_AUTO_PEROXISOME: return ("Auto-build peroxisomes"); break;
				case DISABLE_AUTO_PEROXISOME: return ("Don't auto-build peroxisomes"); break;
				
				case MIX_DISABLE: return ("Disable"); break;
				case MIX_BROWN_FAT: return ("Disable Brown Fat"); break;
				case MAKE_TOXIN: return ("Buy Toxin"); break;
				case TAKE_TOXIN: return ("Recycle Toxin"); break;
				case TAKE_DEFENSIN: return ("Recycle Defensin");
				case MAKE_DEFENSIN: return ("Buy Defensin"); break;
								/*if (DEFENSIN_X > 1) s = "Buy " + DEFENSIN_X + s + "s";
								else s = "Buy a " + s;
								return s;
								break;*/
				case BUY_LYSOSOME: s = " Lysosome";
								if (LYSOSOME_X > 1) s = "Buy " + LYSOSOME_X + s + "s";
								else s = "Buy a " + s;
								return s;   
								break;
				case BUY_PEROXISOME: s = " Peroxisome";
								if (PEROXISOME_X > 1) s = "Buy " + PEROXISOME_X + s + "s";
								else s = "Buy a " + s;
								return s;   
								break;
				case BUY_SLICER: s = " Slicer Enzyme";
								if (SLICER_X > 1) s = "Buy " + SLICER_X + s + "s";
								else s = "Buy a " + s;
								return s;   
								break;
				case BUY_RIBOSOME: s = " Ribosome";
								if (RIBOSOME_X > 1) s = "Buy " + RIBOSOME_X + s + "s";
								else s = "Buy a " + s;
								return s;
								break;
				case BUY_DNAREPAIR: s = " DNA Repair Enzyme";
								if (DNAREPAIR_X > 1) s = "Buy " + DNAREPAIR_X + s + "s";
								else s = "Buy a " + s;
								return s;
								break;
				
			}
			return "";
		}
		
	}
	
}