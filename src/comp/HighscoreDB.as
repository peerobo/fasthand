package comp 
{
	import base.Factory;
	import base.GlobalInput;
	import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
	import com.adobe.ane.gameCenter.GameCenterController;
	import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;
	/**
	 * ...
	 * @author ndp
	 */
	public class HighscoreDB 
	{
		private var highscoreMap:Object;
		
		// game center only
		private var gcController:GameCenterController;		
		private var gameCenterLogged:Boolean;
		private var validCats:Array;
		
		public function initGameCenter():void
		{
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
				//Achievements
				/*gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED,achViewFinished);
				gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_LOADED,achLoaded);
				gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_FAILED,achFailed);
				gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED,achSubmittedSuccess);
				gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED,achSubmitFailed);
				gcController.addEventListener(GameCenterAchievementEvent.RESET_ACHIEVEMENTS_SUCCEEDED,resetSuccess);
				gcController.addEventListener(GameCenterAchievementEvent.RESET_ACHIEVEMENTS_FAILED,resetUnsuccess);
				//FriendReuest
				gcController.addEventListener(GameCenterFriendEvent.FRIEND_REQUEST_VIEW_FINISHED,friendRequestViewFinished);
				gcController.addEventListener(GameCenterFriendEvent.FRIEND_LIST_LOADED,friendListLoaded);
				gcController.addEventListener(GameCenterFriendEvent.FRIEND_LIST_FAILED,friendListFailed);
				//scores
				gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED,submitScoreSucceed);
				gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED,submitScoreFailed);
				gcController.addEventListener(GameCenterLeaderboardEvent.SCORES_LOADED,requestedScoresLoaded);
				gcController.addEventListener(GameCenterLeaderboardEvent.SCORES_FAILED,requestedScoresFailed);
				*/				
				if (!gcController.authenticated) {
					gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, gameCenterAuthenticated);
					gcController.authenticate();
				}
			}
		}
		
		private function leaderBoardViewClose(e:GameCenterLeaderboardEvent):void 
		{
			var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
			globalInput.disable = false;
			Util.showBannerAd();
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
			if (Util.isIOS && gameCenterLogged && validCats)
			{
				var catName:String = Constants.HIGHSCORE_ITUNE_PRE + type.substr(0, 1).toUpperCase() + type.substr(1);
				if(validCats.indexOf(catName) > -1)
					gcController.submitScore(value, catName);				
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
			if (gcController && gameCenterLogged && validCats)
			{
				var catName:String = Constants.HIGHSCORE_ITUNE_PRE + cat.substr(0, 1).toUpperCase() + cat.substr(1);
				if(validCats.indexOf(catName) > -1)
				{
					gcController.showLeaderboardView(catName);
					var globalInput:GlobalInput = Factory.getInstance(GlobalInput);
					globalInput.disable = true;
					Util.hideBannerAd();
				}
			}
		}
		
	}

}