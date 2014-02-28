package comp 
{
	import base.Factory;
	import base.GlobalInput;
	import starling.core.Starling;
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
	public class GameService 
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
					FPSCounter.log("init game center");
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
						FPSCounter.log("authen game center");
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
				FPSCounter.log("cannot log in game center");
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
				FPSCounter.log("authen game center done");
				if (gcController.authenticated)
				{
					FPSCounter.log("authen game center ok");
					gcController.requestLeaderboardCategories();
				}
			}
		}
		
		public function GameService() 
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
			var catName:String;
			highscoreMap[type ] = value;			
			CONFIG::isIOS{
				if (Util.isIOS && gameCenterLogged && validCats)
				{
					catName = Constants.HIGHSCORE_ITUNE_PRE + type.substr(0, 1).toUpperCase() + type.substr(1);
					if(validCats.indexOf(catName) > -1)
						gcController.submitScore(value, catName);				
				}				
			}
			CONFIG::isAndroid {
				if (Util.isAndroid && googlePlayLogged)
				{
					catName = FasthandUtil.getCatForGooglePlay(type);
					googlePlay.reportScore(catName, value);
				}
			}
			
			var tmpVal:int = 0;
			for (var cat:String in highscoreMap) 
			{
				if (cat == Constants.OVERALL_HIGHSCORE)
					continue;
				tmpVal += highscoreMap[cat];
			}
			if (highscoreMap[Constants.OVERALL_HIGHSCORE] < tmpVal)
			{
				highscoreMap[Constants.OVERALL_HIGHSCORE] = tmpVal;
				CONFIG::isIOS{
					if (Util.isIOS && gameCenterLogged && validCats)
					{
						catName = Constants.HIGHSCORE_ITUNE_PRE + Constants.OVERALL_HIGHSCORE.substr(0, 1).toUpperCase() + Constants.OVERALL_HIGHSCORE.substr(1);
						if(validCats.indexOf(catName) > -1)
							gcController.submitScore(value, catName);				
					}				
				}
				CONFIG::isAndroid {
					if (Util.isAndroid && googlePlayLogged)
					{
						catName = FasthandUtil.getCatForGooglePlay(Constants.OVERALL_HIGHSCORE);
						googlePlay.reportScore(catName, value);
					}
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
				else if (gcController && !gameCenterLogged && validCats)
				{
					gcController.authenticate();
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
				
				Starling.juggler.delayCall(googlePlay.signOut, 5);
			}
		}
				
		public function showGooglePlayLeaderboard(cat:String):void 
		{
			CONFIG::isAndroid{
				if(googlePlay && googlePlayLogged)
				{
					googlePlay.showLeaderboard(FasthandUtil.getCatForGooglePlay(cat));
				}
				else if(googlePlay)
				{
					googlePlay.signIn();
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
						googlePlay.signIn();						
					break;
				}
			}
		}
		
		public function unlockAchievement(type:String):void
		{
			var ach:String;
			var key:String = "achievement" + type;
			var checkDone:String = Util.getPrivateKey(key);
			if (checkDone)
				return;
			Util.setPrivateValue(key, "available");
			CONFIG::isIOS {
				ach = FasthandUtil.getAchievementIOS(type);
				gcController.submitAchievement(ach, 100);
			}
			CONFIG::isAndroid {
				ach = FasthandUtil.getAchievementAndroid(type);
				googlePlay.reportAchievement(ach);
			}
		}
	}

}