package fasthand.screen 
{
	import base.BaseButton;
	import base.BFConstructor;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.PopupMgr;
	import base.SoundManager;
	import com.adobe.utils.StringUtil;
	import comp.LoadingIcon;
	import comp.TileImage;
	import fasthand.comp.TileIcon;
	import fasthand.Fasthand;
	import fasthand.FasthandUtil;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.ButtonAsset;
	import res.asset.SoundAsset;
	import res.ResMgr;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Color;
	/**
	 * ...
	 * @author ndp
	 */
	public class GameScreen extends Sprite implements IAnimatable
	{
		private var stringSeq:Array;
		private var cat:String;
		
		// containers
		private var tilesBg:Sprite
		private var tiles:Sprite;
		private var topBar:Sprite;
		private var bottomBar:Sprite;
		private var bgContainer:Sprite;
		
		private const ITEM_W:int = 330;
		private const GAP:int = 6;
		private var timeOutText:BaseBitmapTextField;
		private var findText:BaseBitmapTextField;
		private var quadTimeout:Quad;
		
		public var isShowing:Boolean = false;
		
		public function GameScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			bgContainer = new Sprite();
			addChild(bgContainer);
		}
		
		private function onRemove(e:Event):void 
		{
			if(e.target == this)
			{
				isShowing = false;
				Starling.juggler.remove(this);
				hide();
			}
		}
		
		public function hide():void 
		{
			
		}
		
		private function onAdded(e:Event):void 
		{			
			if(e.target == this)
			{
				isShowing = true;		
				Starling.juggler.add(this);
				show();
			}
			
		}
		
		public function show():void
		{
			stringSeq = FasthandUtil.adjectives.split(";");
			for (var i:int = 0; i < stringSeq.length; i++) 
			{
				if (stringSeq[i] == "")
				{
					stringSeq.splice(i, 1);
					i--;
				}
			}
			
			cat = "adjectives";			
			getTexture(cat);
			
			var loadingIcon:LoadingIcon = Factory.getInstance(LoadingIcon);
			PopupMgr.addPopUp(loadingIcon);
			
			if (bgContainer.numChildren < 1)
			{				
				var tileImg:TileImage = new TileImage();
				tileImg.draw(Asset.getBaseTexture(BackgroundAsset.BG_TILE), Util.appWidth, Util.appHeight);
				addChild(tileImg);
			}
		}				
		
		private function getTexture(texName:String):void 
		{
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			resMgr.loadTextureAtlas(texName, getTextureOK);
		}
		
		private function getTextureOK(progress:Number):void 
		{
			if (progress == 1)
			{				
				SoundAsset.download(cat, stringSeq);				
			}
		}
		
		private function init():void 
		{			
			var loadingIcon:LoadingIcon = Factory.getInstance(LoadingIcon);
			PopupMgr.removePopup(loadingIcon);
			var logic:Fasthand = Factory.getInstance(Fasthand);
			logic.startNewGame(cat);
			logic.gameOverCallback = init;
			initBoard();
			initTopBar();
		}
		
		private function initTopBar():void 
		{
			if (!topBar)
			{
				topBar = new Sprite();
				topBar.y = 12;
				addChild(topBar);								
				
				var startButton:BaseButton = ButtonAsset.getBaseBt(BackgroundAsset.BG_STRING_HOLDER);
				startButton.x = 300;
				startButton.icons[0].width = 280;
				startButton.icons[0].height = 90;
				startButton.setLabel(BFConstructor.getShortTextField(280, 90, "Nghe lai", BFConstructor.BANHMI));
				topBar.addChild(startButton);
				startButton.setCallbackFunc(onListenAgain);
				
				quadTimeout = new Quad(1, 1, Color.SILVER);
				quadTimeout.alpha = 0.5;
				quadTimeout.x = 0;				
				quadTimeout.height = 90;
				topBar.addChild(quadTimeout);
				
				timeOutText = BFConstructor.getShortTextField(1, 1, "", BFConstructor.BANHMI, Color.YELLOW);
				timeOutText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				topBar.addChild(timeOutText);
				timeOutText.text = "Thoi gian: 120";
				
				findText = BFConstructor.getShortTextField(1, 1, "", BFConstructor.BANHMI, Color.LIME);
				findText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				findText.x = startButton.x + startButton.width + 24;
				topBar.addChild(findText);
				findText.text = "...";
				
				topBar.x = Util.appWidth - topBar.width >> 1;			
			}
		}
		
		private function onListenAgain():void 
		{
			var logic:Fasthand = Factory.getInstance(Fasthand);
			SoundManager.playSound(SoundAsset.getName(cat, logic.word2Find));
		}
		
		private function initBoard():void 
		{
			var clone:Array = stringSeq.concat();			
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			clone = logic.seqs;
						
			if (!tilesBg)
			{
				tilesBg = new Sprite();
				addChild(tilesBg);
			}
			if (!tiles)
			{
				tiles = new Sprite();
				addChild(tiles);
			}
			//tilesBg.removeChildren(0, -1, true);
			//tiles.removeChildren(0, -1, true);			
			var posX:int = 0;
			var posY:int = 0;			
			var count:int = 0;
		
			for each(var tileName:String in clone)
			{
				var itemBG:DisplayObject
				var bt:BaseButton
				if (tilesBg.numChildren < clone.length)
				{
					if (count == 4)
					{
						posX = 0;
						posY += itemBG.height + GAP;
					}
					itemBG = Asset.getBaseImage(BackgroundAsset.BG_ITEM);
					bt = ButtonAsset.getBaseBtWithImage(itemBG);
					bt.x = posX;
					bt.y = posY;
					itemBG.width = itemBG.height = ITEM_W;
					posX += itemBG.width + GAP;										
					tilesBg.addChild(bt);
				}
				else
				{
					bt = tilesBg.getChildAt(count) as BaseButton;
				}												
				bt.name = tileName;
				bt.setCallbackFunc(onClickTile,[bt,tileName]);
			
				
				var tileIcon:TileIcon;
				
				if (tiles.numChildren < clone.length)
				{
					tileIcon = new TileIcon();
					tileIcon.setBound(ITEM_W, ITEM_W);
					tiles.addChild(tileIcon);
					tileIcon.x = bt.x;
					tileIcon.y = bt.y;
				}
				else
				{
					tileIcon = tiles.getChildAt(count) as TileIcon;
				}
				tileIcon.setIcon(cat, tileName);

				count++;
			}
			
			tilesBg.x = Util.appWidth - tilesBg.width >> 1;
			tilesBg.y = Util.appHeight - tilesBg.height >> 1;
			tilesBg.y += 60;
			tiles.x = tilesBg.x;
			tiles.y = tilesBg.y;
			
			SoundManager.playSound(SoundAsset.getName(cat, logic.word2Find));
		}
		
		private function onClickTile(bt:BaseButton, nameS:String):void 
		{
			
			
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if (logic.checkAdvanceRound(nameS))
			{
				initBoard();
			}
			else
			{
				SoundManager.playSound(SoundAsset.getName(cat, nameS));
				bt.shake();
				Starling.juggler.delayCall(stopTileShake, 0.6, bt);
			}
			
		}
		
		private function stopTileShake(bt:BaseButton):void 
		{
			bt.stopShaking();
		}
		
		private function checkloadingSound():void 
		{
			if(SoundAsset.currProgress == 1)
			{
				SoundAsset.currProgress = 0;
				init();
			}
		}			
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void 
		{				
			// loading sound when loading game
			checkloadingSound();	
			
			// in game progress
			var logic:Fasthand = Factory.getInstance(Fasthand);
			if (timeOutText)
			{	
				timeOutText.setContent ("Thoi gian: " ,logic.gameRoundTime.toString());
				timeOutText.setContentColor (Color.WHITE, Color.YELLOW);
			}
			if (findText)
			{
				findText.text = logic.word2Find;
			}
			if (quadTimeout)
			{
				quadTimeout.width = (300 - 36) * logic.gameRoundTime / Constants.SEC_PER_ROUND;
			}
		}				
	}

}