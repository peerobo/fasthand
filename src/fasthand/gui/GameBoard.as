package fasthand.gui 
{
	import base.BaseJsonGUI;
	import base.EffectMgr;
	import base.Factory;
	import base.font.BaseBitmapTextField;
	import base.GlobalInput;
	import base.SoundManager;
	import comp.SpriteNumber;
	import fasthand.comp.TileRenderer;
	import fasthand.Fasthand;
	import feathers.controls.ImageLoader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import res.Asset;
	import res.asset.BackgroundAsset;
	import res.asset.IconAsset;
	import res.asset.SoundAsset;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
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
		public var onSelectWord:Function;	// callback(word:String,item:DisplayObject);
		private var timeoutSound:SoundChannel;
		
		private var isPaused:Boolean;
		private var countAnimated:int;
		
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
		}
		
		private function onItemClick(item:TileRenderer):void 
		{
			//animate();			
			onSelectWord(item.word,item);
		}
		
		public function resetTimeCount():void
		{
			timeProgressbar.width = timeProgressbarBg.width;
			time = maxTime;
			if (timeoutSound)
				timeoutSound.stop();
			timeoutSound = null
		}
		
		override public function update(time:Number):void 
		{
			if (isPaused)
				return;
			super.update(time);
			
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
		
		public function animate():void 
		{
			var input:GlobalInput = Factory.getInstance(GlobalInput);
			input.disable = true;
			countAnimated = 0;
			for (var i:int = 0; i < rectTile.length; i++) 
			{
				var item:TileRenderer = getChildByName("tile" + i) as TileRenderer;				
				item.reset();
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
				item.setWord(logic.cat,seqs[i]);
			}
		}
		
		public function setWord(word2Find:String):void 
		{
			var str:String = word2Find.substr(0,1).toUpperCase() + wo~�4����r�#sF[�+��\�lU��޾E�	&�O�z��S��f�6����4d�u�(̝�5a8���G�w?��t�̧�g�#Wj�p�h����w>�%(m�۠�����6ǝ����ZŧW��c0��w�"/�c{X��͸�"���!����Q+۬Ҷ2�>�S��n�U0����(a�1�v�Fq;����T����M�N����v�N�Ϣ�+�-���	9��lY-��.�s#�?jh�q5[y��D17�^�<�z�ݻ�RLG�fg���+��Yyg��n�8�о��.tTR��R�o��
�BP�겆#[�|���/�{v�Y}���<���~�Ŵ���
�HL29��D��(��l���zPn�����{���Z�1�K�_���	�,?΂�a6�Y��Y��4�Ԏ�����L����M�V�?�mb�y�pi� [����Վ���>)�s�:�yy�t֧�ǋ�Aq��zI�Qe?�m���5���s�ѫJW�����g>t��r]�Lrb��@�Y��ҷc<:bVm/�f�ҍl=�1�ύ�������rfN�q���B5R���Bu�4�����@���\�"Z2+A��ް�̞��уiN�o����б����oFx��M7����f���~�~��)��重9_�ܫ�j8
5�&�_���l�Tv�F�Iu�[��Hd}R�>O�Tʑ�y���-��Zq䋊j^p��#��r�W�����z=��hm��Qf���d;��}������R���	u(�ڰPR^t���ۥ���E��{Jd���ӱ��+���fZ�Q��j)�a �(uM`R���ɰK{�L�bQ�uŊ����ҦD�����+C���q���^=�o�{�ͣ���̡��c��c��r�A׷GF���:�:�5$�h�w<��jF�#� d#~���\�pwQVNqik�gyd�ܤ�Fb������U�N�cEy