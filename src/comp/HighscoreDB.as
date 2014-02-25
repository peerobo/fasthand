package comp 
{
	import base.Factory;
	import base.GlobalInput;
	CONFIG::isIOS{
		import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
		import com.adobe.ane.gameCenter.GameCenterController;
		import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;
	}
	CONFIG::isAndroid{
		import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
		import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	}
	import fasthand.FasthandUtil;
	/**
	 * ...
	 * @author ndp
	 */
	public class HighscoreDB 
	{
		private var highscoreMap:Object;
		
		// game center only
		CONFIG::isIOS{
			private var gcController:GameCenterController;		
			private var gameCenterLogged:Boolean;
			private var validCats:Array;
		}
		
		CONFIG::isAndroid{
			private var googlePlay:AirGooglePlayGames;
			private var googlePlayLogged:Boolean;
		}
		
		
		public function initGameCenter():void
		{
			CONFIG::isIOS{
				if (GameCenterController.isSupported)
				{
					gcController = new GameCenterController();
					//Authenticate 
					gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, gameCenterAuthenticatedFailed);				
					gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATION_CHANGED, gameCenterAuthenticatedChanged);				
					//Leadership
					gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED, leaderBoardViewClose);
					gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_LOADED, leaderboardeCategoriesLoaded);				
					gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_FAILED, leaderboardeCategoriesFailed);	
					if (!gcController.authenticated) {
						gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, gameCenterAuthenticated);
						gcController.authenticate();
					}
				}
			}
		}
			
		CONFIG::isIOS{	
			private function leaderBoardViewClose(e:GameCenterLeaderboardEvent):void 
			{
				var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
				globalInput.disable = false;
			}
			
			private function gameCenterAuthenticatedChanged(e:GameCenterAuthenticationEvent):void 
			{
				gameCenterLogged = gcController.authenticated;
			}
			
			private function gameCenterAuthenticatedFailed(e:GameCenterAuthenticationEvent):void 
			{
				gameCenterLogged = false;
			}
			
			private function leaderboardeCategoriesFailed(e:GameCenterLeaderboardEvent):void 
			{
				validCats = null;
			}
			
			private function leaderboardeCategoriesLoaded(e:GameCenterLeaderboardEvent):void 
			{
				validCats = e.leaderboardCategories;
			}
			
			protected function gameCenterAuthenticated(event:GameCenterAuthenticationEvent):void
			{
				gameCenterLogged = gcController.authenticated;
				if (gcController.authenticated)
				{
					gcController.requestLeaderboardCategories();
				}
			}
		}
		
		public function HighscoreDB() 
		{
			highscoreMap = { };
		}
		
		public function registerType(type:String):void
		{
			if (!highscoreMap.hasOwnProperty(type))
			{
				highscoreMap[type] = 0;
			}
		}
		
		public function getHighscore(type:String):int
		{
			return highscoreMap[type];
		}
		
		public function setHighscore(type:String, value:int):void
		{
			highscoreMap[type ] = value;
			CONFIG::isIOS{
				if (Util.isIOS && gameCenterLogged && validCats)
				{
					var catName:String = Constants.HIGHSCORE_ITUNE_PRE + type.substr(0, 1).toUpperCase() + type.substr(1);
					if(validCats.indexOf(catName) > -1)
						gcController.submitScore(value, catName);				
				}
			}
		}
		
		public function saveHighscore():void
		{
			for (var s:String in highscoreMap) 
			{
				Util.setPrivateValue(s, highscoreMap[s]);
			}			
		}
		
		public function loadHighscore():void
		{
			for (var s:String in highscoreMap) 
			{
				var tmpVal:String = Util.getPrivateKey(s);
				var val:int = parseInt(tmpVal);
				highscoreMap[s] = isNaN(val) ? 0 : val;
			}
			
		}
		
		public function showGameCenterHighScore(cat:String):void 
		{
			CONFIG::isIOS{
				if (gcController && gameCenterLogged && validCats)
				{
					var catName:String = Constants.HIGHSCORE_ITUNE_PRE + cat.substr(0, 1).toUpperCase() + cat.substr(1);
					if(validCats.indexOf(catName) > -1)
					{
						gcController.showLeaderboardView(catName);
						var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
						globalInput.disable = true;
					}
				}
			}
		}
		
		public function initGooglePlayGameService():void 
		{
			CONFIG::isAndroid{
				// Initialize
				googlePlay = AirGooglePlayGames.getInstance();
				googlePlay.addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onGooglePlayResponse);
				googlePlay.addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onGooglePlayResponse);
				googlePlay.addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onGooglePlayResponse);
				googlePlay.startAtLaunch();
			}
		}
				
		public function showGooglePlayLeaderboard(cat:String):void 
		{
			CONFIG::isAndroid{
				if(googlePlay && googlePlayLogged)
				{
					googlePlay.showLeaderboard(FasthandUtil.getCatForGooglePlay(cat));
				}
			}
		}
		
		CONFIG::isAndroid{
			private function onGooglePlayResponse(e:AirGooglePlayGamesEvent):void 
			{
				switch(e.type)
				{
					case AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS:
						googlePlayLogged = true;
						FPSCounter.log("play login ok");
					break;
					case AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL:
						googlePlayLogged = false;
						FPSCounter.log("play login fail");
					break;
					case AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS:
						googlePlayLogged = false;
						FPSCounter.log("play login fail");
					break;
				}
			}
		}
	}

}