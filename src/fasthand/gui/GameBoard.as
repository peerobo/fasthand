package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.EffectMgr;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.SoundManager;
	import comp.ShakeObject;
	import comp.SpriteNumber;
	import fasthand.comp.TileRenderer;
	import fasthand.Fasthand;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ndp
	 */
	public class GameBoard extends BaseJsonGUI 
	{
		//private var scoreBoard:SpriteNumber;
		public var wordTxt:BaseBitmapTextField;
		public var rectTile:Array;
		public var timeProgressbar:DisplayObject;
		public var timeProgressbarBg:DisplayObject;
		public var rectPBMin:Rectangle;
		
		public var maxTime:Number;
		public var time:Number;
		public var isAnimatedTime:Boolean;		
		public var onAnimateComplete:Function;
		public var onSelectWord:Function;
		private var timeoutSound:SoundChannel;
		private var countAnimatedDone:int;
		private var _isPaused:Boolean;		
		private var shakeObj:ShakeObject;
		
		public function GameBoard() 
		{
			super("GameBoard");		
			shakeObj = new ShakeObject();
			shakeObj.AMP = 10;
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
			
			/*scoreBoard = Factory.getObjectFromPool(SpriteNumber);
			scoreBoard.init(Asset.getBaseTextures(IconAsset.ICO_NUMBER));
			scoreBoard.text = "0";
			scoreBoard.x = rectScore.x;
			scoreBoard.y = rectScore.y;
			addChildAt(scoreBoard, 0);	*/		
		}
		
		private function onItemClick(item:TileRenderer):void 
		{
			//animate();
			onSelectWord(item.word,item);
		}
		
		public function resetTimeCount():void
		{
			_isPaused = false;
			timeProgressbar.width = timeProgressbarBg.width;
			time = maxTime;
			if (timeoutSound)
				timeoutSound.stop();
			timeoutSound = null
		}
		
		override public function update(time:Number):void 
		{
			super.update(time);
			if (!_isPaused)
			{
				var logic:Fasthand = Factory.getInstance(Fasthand);
				if (isAnimatedTime && logic.isStartGame)
				{
					this.time -= time;
					if (this.time <= 3 && !timeoutSound)
					{
						timeoutSound = SoundManager.playSound(SoundAsset.SOUND_TIMEOUT);					
					}								
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
			}
			//scoreBoard.text = Util.numberWithCommas(logic.currentPlayerScore);
		}
		
		public function animate():void 
		{
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = true;
			countAnimatedDone = Constants.TILE_PER_ROUND;
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.reset();
				item.flatten();
				item.scaleX = item.scaleY = 0.3;				
				//if (i == 0)
					Starling.juggler.tween(item, 0.5, { scaleX:1, scaleY:1, onComplete: animatedDone } );
				//else
					//Starling.juggler.tween(item, 0.5, { scaleX:1, scaleY:1 } );
			}
			if (timeoutSound)
				timeoutSound.stop();
		}
		
		public function setIcons(seqs:Array):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.setWord(logic.cat, seqs[i]);
				item.flatten();
			}
		}
		
		public function setWord(word2Find:String):void 
		{
			var str:String = word2Find.substr(0,1).toUpperCase() + word2Find.substr(1);
			wordTxt.text = str;
		}
		
		private function animatedDone():void 
		{
			countAnimatedDone--;
			if(countAnimatedDone<=0)
			{
				var input:GlobalInput = Factory.getInstance(GlobalInput);
				input.disable = false;
				onAnimateComplete();
			}
		}
			
		public function reset():void
		{
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;
				item.touchable = true;
				item.reset();
				item.flatten();
			}
			if (timeoutSound)
				timeoutSound.stop();
		}
		
		public function animateWrongWord(disp:DisplayObject):void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);			
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = true;
			var item:TileRenderer = disp as TileRenderer;
			item.reset();
			item.flatten();
			item.touchable = false;
			Starling.juggler.tween(item, 0.5, { alpha:0, onComplete: onAnimatedWrongWordDone } );
			
			this.time -= Constants.PENALTY_TIME;
			var disp:DisplayObject = Asset.getBaseImage(BackgroundAsset.BG_PROGRESSBAR);
			disp.width = Constants.PENALTY_TIME / logic.GAME_ROUND_TIME * timeProgressbarBg.width;
			var rec:Rectangle = timeProgressbar.getBounds(Util.root);
			disp.x = rec.right - disp.width;
			disp.y = rec.y;			
			var c:ColorMatrixFilter = new ColorMatrixFilter();
			c.adjustBrightness(0.05);
			c.adjustHue( 0.8);
			c.adjustSaturation(0.5);
			disp.filter = c;
			var pos:Point = new Point(0, disp.y + 120);
			EffectMgr.floatObject(disp, pos);
			shakeObj.shake(timeProgressbar, 500);
		}
		
		private function onAnimatedWrongWordDone():void 
		{
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = false;
			shakeObj.stopShake();			
		}
		
		public function pause():void 
		{
			_isPaused = true;
		}
		
		public function resume():void 
		{
			_isPaused = false;
		}
		
	}

}