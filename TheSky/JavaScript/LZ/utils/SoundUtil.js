var SoundUtil = {
		/**
		 * 播放音效
		 */
		playEffect:function(effect){
//			if (getUDBool(UDefKey.Setting_Effect) == "effect") {
			cc.audioEngine.playEffect(effect, false);
//			}
		},
		/**
		 * 播放音乐
		 */
		playMusic:function(music, loop){
			cc.audioEngine.stopMusic();
			if (!music) {
				return;
			}
			cc.audioEngine.playMusic(music, loop);
		},
		
		/**
		 * 停止音乐
		 */
		stopMusic:function(){
			cc.audioEngine.stopMusic();
		}
}