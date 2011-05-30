package SWFStats
{
	public final class PlayerLevel
	{
		public function PlayerLevel() { }
		
		public var LevelId:int;
		public var PlayerId:int;
		public var PlayerName:String;
		public var Name:String;
		public var Data:String;
		public var Votes:int;
		public var Plays:int;
		public var Rating:Number;
		public var Score:int;

		public function Thumbnail():String
		{
			return "http://utils.swfstats.com/playerlevels/thumb.aspx?levelid=" + this.LevelId;
		}
	}
}