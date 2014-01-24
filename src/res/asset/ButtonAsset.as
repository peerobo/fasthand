package res.asset 
{
	import base.BaseButton;
	import base.Factory;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import res.Asset;
	import res.ResMgr;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ndp
	 */
	public class ButtonAsset 
	{
		public static const BT_CYAN:String = "bt_cyan";
		public static const BT_LIGHT_BROWN:String = "bt_light_brown";
		public function ButtonAsset() 
		{
			
		}
		
		public static function getBaseBt(...names):BaseButton
		{
			var bt:BaseButton = new BaseButton();
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			
			for (var i:int = 0; i < names.length; i++) 
			{
				var tex:Texture = resMgr.getTexture(Asset.BASE_GUI + Asset.contentSuffix, names[i] as String);
				var img:*
				if (Asset.getRec(names[i]))
					img = new Scale9Image(new Scale9Textures(tex, Asset.getRec(names[i])));
				else
					img = new Image(tex);
				bt.addIcon(img as DisplayObject);
			}
			
			return bt;
		}		
		
		public static function getBaseBtWithTexture(...texs):BaseButton
		{
			var bt:BaseButton = new BaseButton();
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			for (var i:int = 0; i < texs.length; i++) 
			{
				var img:Image = new Image(texs[i] as Texture);
				bt.addIcon(img);
			}			
			return bt;
		}				
		
		public static function getBaseBtWithImage(...imgs):BaseButton
		{
			var bt:BaseButton = new BaseButton();
			for (var i:int = 0; i < imgs.length; i++) 
			{				
				bt.addIcon(imgs[i]);
			}			
			return bt;
		}
	}

}