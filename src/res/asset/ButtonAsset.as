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
		public static const BT_BACK:String = "bt_back";		
		public static const BT_BLUE:String = "bt_blue";		
		public static const BT_DARK_GRAY:String = "bt_dark_gray";		
		
		public function ButtonAsset() 
		{
			
		}
		
		public static function getBaseBt(...names):BaseButton
		{
			var bt:BaseButton = new BaseButton();
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			
			for (var i:int = 0; i < names.length; i++) 
			{				
				var img:DisplayObject = Asset.getBaseImage(names[i]);				
				bt.addIcon(img);
			}
			
			return bt;
		}		
		
		public static function getBaseBtWithTexture(...texs):BaseButton
		{
			var bt:BaseButton = Factory.getObjectFromPool(BaseButton);
			var resMgr:ResMgr = Factory.getInstance(ResMgr);
			for (var i:int = 0; i < texs.length; i++) 
			{
				var img:Image = Factory.getObjectFromPool(Image);
				img.texture = texs[i] as Texture;
				img.readjustSize();
				bt.addIcon(img);
			}			
			return bt;
		}				
		
		public static function getBaseBtWithImage(...imgs):BaseButton
		{
			var bt:BaseButton = Factory.getObjectFromPool(BaseButton);
			for (var i:int = 0; i < imgs.length; i++) 
			{				
				bt.addIcon(imgs[i]);
			}			
			return bt;
		}
	}

}