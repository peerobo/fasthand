package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import comp.SpriteNumber;
	import fasthand.comp.TileRenderer;
	import fasthand.Fasthand;
	import flash.geom.Rectangle;
	import res.Asset;
	import res.asset.IconAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class GameBoard extends BaseJsonGUI 
	{
		private var scoreBoard:SpriteNumber;
		public var wordTxt:BaseBitmapTextField;
		public var rectTile:Array;
		public var timeProgressbar:DisplayObject;
		public var timeProgressbarBg:DisplayObject;
		public var rectPBMin:Rectangle;
		
		public var maxTime:Number;
		public var time:Number;
		public var isAnimatedTime:Boolean;
		public var rectScore:Rectangle;
		public var onAnimateComplete:Function;
		public var onSelectWord:Function;
		
		public function GameBoard() 
		{
			super("GameBoard");
			
		}
		
		override public function onAdded(e:Event):void 
		{
			super.onAdded(e);
			
			var item:TileRenderer;
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				item = new TileRenderer();
				addChild(item);
				item.name = "tile" + i;
				item.x = rectTile[i].x;
				item.y = rectTile[i].y;
				item.width = rectTile[i].width;
				item.height = rectTile[i].height;				
				item.touchCallback = onItemClick;
				
				item.pivotX = item.width >> 1;
				item.pivotY = item.height >> 1;
				item.x += item.width >> 1;
				item.y += item.height >> 1;
			}
			
			wordTxt.color = Color.LIME;
			
			scoreBoard = Factory.getObjectFromPool(SpriteNumber);
			scoreBoard.init(Asset.getBaseTextures(IconAsset.ICO_NUMBER));
			scoreBoard.text = "0";
			scoreBoard.x = rectScore.x;
			scoreBoard.y = rectScore.y;
			addChildAt(scoreBoard, 0);			
		}
		
		private function onItemClick(item:TileRenderer):void 
		{
			//animate();
			onSelectWord(item.word);
		}
		
		public function resetTimeCount():void
		{
			timeProgressbar.width = timeProgressbarBg.width;
			time = maxTime;
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			if (isAnimatedTime)
			{
				this.time -= time;
				var p:Number = this.time / maxTime;
				p = p > 1 ? 1 : (p < 0 ? 0 : p);
				var w:int = timeProgressbarBg.width * p;
				if (w < rectPBMin.width)
				{
					timeProgressbar.alpha = w / rectPBMin.width;
				}
				else
				{
					timeProgressbar.alpha = 1;
				}
				timeProgressbar.width = w;
			}
			var logic:Fasthand = Factory.getInstance(Fasthand);
			scoreBoard.text = Util.numberWithCommas(logic.currentPlayerScore);
		}
		
		public function animate():void 
		{
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = true;
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.reset();
				item.scaleX = item.scaleY = 0.3;
				if (i == 0)
					Starling.juggler.tween(item, 0.5, { scaleX:1, scaleY:1, onComplete: animatedDone } );
				else
					Starling.juggler.tween(item, 0.5, { scaleX:1, scaleY:1 } );
			}
		}
		
		public function setIcons(seqs:Array):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.setWord(logic.cat,seqs[i]);
			}
		}
		
		public function setWord(word2Find:String):void 
		{
			var str:String = word2Find.substr(0,1).toUpperCase() + word2Find.substr(1);
			wordTxt.text = str;
		}
		
		private function animatedDone():void 
		{
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = false;
			onAnimateComplete();
		}
			
		public function reset():void
		{
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.reset();
			}
		}
		
	}

}