package com.pecSound{
	
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.events.Event;
	//import flash.display.MovieClip;
	
	// We have to extend EventDispatcher because we need to be able to add event listeners.  
	public class SoundManager extends EventDispatcher{
		
		// Sound library
		private const mySoundLib:SoundLibrary = new SoundLibrary();
		
		// Sound info arrays
		private var mus_infos:Array = new Array(); // We're going to limit this to 1 element
		private var amb_infos:Array = new Array(); // Also limited to 1 element
		private var sfx_infos:Array = new Array(); // We will make a new SoundInfo object for each SFX.
		
		// Sound transforms
		private var mus_trans:SoundTransform = new SoundTransform();
		private var amb_trans:SoundTransform = new SoundTransform();
		private var sfx_trans:SoundTransform = new SoundTransform(); // All SFX will have the same transform.
		
		// Volume preferences - since muting changes volume too, we need to record the most recent volume preference.
		private var mus_vol:Number = 1;
		private var amb_vol:Number = 1;
		private var sfx_vol:Number = 1;
		
		// Mute prefs - since we need to keep track of mutes universally, not just per item
		// While these would logically be bools, they're easier to track as 0 and 1 since we
		// use them as multipliers on the volume.  Note this means that 1 is not muted and 0 is muted.
		private var mus_mute_level:Number = 1;
		private var amb_mute_level:Number = 1;
		private var sfx_mute_level:Number = 1;
		
		
		// Track sound items that need to be dealt with for fading
		private var toFadeIn:Array = new Array();
		private var toFadeOut:Array = new Array();
		
		// Keeps track of the max external ID. Does not track when id's are removed, which means that
		// given enough time we'll max out the integer.  However, at 100 sound effects per sectond, that
		// would take 4 months, so I think it'll be okay, even if it's not ideal programming.
		private var nextExternalID:int = 0;
		
		// Constructor
		public function SoundManager():void{
			mus_trans.volume = mus_vol;
			amb_trans.volume = amb_vol;
			sfx_trans.volume = sfx_vol;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		// NEED TO ADD A FADEOUT LEVEL TO SOUNDINFO TO MAINTAIN FADES DURING VOLUME CHANGES.
		private function enterFrameHandler(e:Event):void{
			checkFadeStatus();
			//SoundInfo(toFadeIn[count]).setSoundVolume((SoundInfo(toFadeIn[count]).channel.position / SoundInfo(toFadeIn[count]).fadeInLengh) * 
				
			
			/*for (count = 0; count < toFadeIn.length; count++){
				if (toFadeIn[count] == "a"){
					toFadeIn.splice(count,1);
					count--; // If we kill one, we back up one.
				}
				else
					toFadeIn[count] = "a";
			}*/
		}
		
		private function checkFadeStatus():void{
			if (mus_infos.length > 0){
				if (mus_infos[0].toFadeIn){
					// This ugly looking line constrains the value to within 0 and 1 and sets it according to progression through the fade.
					mus_infos[0].fadeLevel = Math.max(0, Math.min(1, (mus_infos[0].channel.position + mus_infos[0].startingPos) / (mus_infos[0].fadeInLength + mus_infos[0].startingPos)));
					setSoundVolume(mus_infos[0], mus_vol, mus_trans);
					if (mus_infos[0].channel.position >= mus_infos[0].fadeInLength) // If we've hit our fade point.
						mus_infos[0].toFadeIn = false; // We're done fading.
				}
				if (mus_infos[0].toFadeOut && mus_infos[0].channel.position >= mus_infos[0].fadeOutStart){
					mus_infos[0].fadeLevel = Math.max(0, Math.min(1, (mus_infos[0].fadeOutLength + mus_infos[0].fadeOutStart - mus_infos[0].channel.position) / mus_infos[0].fadeOutLength));
					setSoundVolume(mus_infos[0], mus_vol, mus_trans);
					if (mus_infos[0].channel.position >= (mus_infos[0].fadeOutLength + mus_infos[0].fadeOutStart)) // If we've hit our fade point.
						mus_infos[0].toFadeOut = false; // We're done fading.
				}
			}
			if (amb_infos.length > 0){
				if (amb_infos[0].toFadeIn){
					amb_infos[0].fadeLevel = Math.max(0, Math.min(1, (amb_infos[0].channel.position + amb_infos[0].startingPos) / (amb_infos[0].fadeInLength + amb_infos[0].startingPos)));
					setSoundVolume(amb_infos[0], amb_vol, amb_trans);
					if (amb_infos[0].channel.position >= amb_infos[0].fadeInLength) // If we've hit our fade point.
						amb_infos[0].toFadeIn = false; // We're done fading.
				}
				
				if (amb_infos[0].toFadeOut){
					amb_infos[0].fadeLevel = Math.max(0, Math.min(1, (amb_infos[0].fadeOutLength + amb_infos[0].fadeOutStart - amb_infos[0].channel.position) / amb_infos[0].fadeOutLength));
					setSoundVolume(amb_infos[0], amb_vol, amb_trans);
					if (amb_infos[0].channel.position >= (amb_infos[0].fadeOutLength + amb_infos[0].fadeOutStart)) // If we've hit our fade point.
						amb_infos[0].toFadeOut = false; // We're done fading.
				}
			}
		}
		
		private function startSound(info:SoundInfo, vol:Number, trans:SoundTransform):void{
			// Start playing the sound
			info.setChannel(Sound(mySoundLib.getSound(info.soundID)), 0, trans);
			info.length = Sound(mySoundLib.getSound(info.soundID)).length;
			setSoundVolume(info, vol, trans); // Go ahead and make sure we're using the right volume.
			
			//Add listener to check if we need to loop when the sound is done
			info.addEventListener(Event.SOUND_COMPLETE, soundFinishedHandler);
		}
		
		private function pauseSound(info:SoundInfo, vol:Number, transform:SoundTransform, p:Boolean):void{
			//trace("PauseFunc");
			if (p){
				if (!info.isPaused){ // If already paused, we don't need to do anything
					info.pos = info.channel.position;
					info.channel.stop();
				}
			}
			else{
				if (info.isPaused){ // If not paused, we don't need to start playing it again
					info.channel.stop();
					info.setChannel(Sound(mySoundLib.getSound(info.soundID)), info.pos);
					setSoundVolume(info, vol, transform)
				}
			}
			info.isPaused = p;
		}
		
		// Will check to see if the sound should loop, and will loop it if so.
		// Thanks to doogog.com for this suggested method of handling looping.
		private function soundFinishedHandler(e:Event):void{
			//trace("Finished!");
			var tempInfo:SoundInfo = SoundInfo(e.target); // Set up a variable to simplify notation
			if (tempInfo.isLooping){
				tempInfo.setChannel(Sound(mySoundLib.getSound(tempInfo.soundID)), 0, SoundInfo(e.target).channel.soundTransform);
				//tempInfo.channel = Sound(mySoundLib.getSound(tempInfo.soundID)).play();
				tempInfo.addEventListener(Event.SOUND_COMPLETE, soundFinishedHandler);
				//trace("Loop!");
			}
			else{
				stopSound(tempInfo);
				//trace("No loop.");
				//mus_chan.removeEventListener(Event.SOUND_COMPLETE, soundFinishedHandler)
			}
		}
		
		private function stopSound(info:SoundInfo):void {
			if(info.channel){
				info.channel.stop();
				var id:int = info.soundID;
				info.soundID = -1;
				info.removeEventListener(Event.SOUND_COMPLETE, soundFinishedHandler);
				//trace("Index (should be 0): " + mus_infos.indexOf(mus_infos[0]));
				info.destroy();
				Director.onSoundFinish(id);			//HACKITY HACKITY HACK!!!!
			}
		}
		
		/*// If doMute is true, we set volume to 0.  If false, we set volume back to saved volume level.
		private function setSoundMute(doMute:Boolean, info:SoundInfo, savedVol:Number, transform:SoundTransform):void{
			if (doMute)
				info.muteLevel = 0;
			else
				info.muteLevel = 1;
				
			setSoundVolume(info, savedVol, transform);
		}*/
		
		private function setSoundVolume(info:SoundInfo, vol:Number, transform:SoundTransform):void{
			if (vol > 1) vol = 1;
			if (vol < 0) vol = 0;
			transform.volume = vol * info.fadeLevel * info.muteLevel; // Make sure we track if we're fading or muted.
			if(info.channel){ //protect from bugs
				info.channel.soundTransform = transform;
			}
		}
		
		private function seekSound(info:SoundInfo, position:int):void{
			if (info.isPaused){
				info.pos = position; // If we're paused, just set the new position.
			}
			else{
				info.channel.stop(); // Need to stop the current one or we'll get layers
				info.setChannel(Sound(mySoundLib.getSound(info.soundID)), position);
				//info.channel = Sound(mySoundLib.getSound(info.soundID)).play(position);
			}
		}
	
		/*
		private function setSoundFadeOut(info:SoundInfo, len:int, trans:SoundTransform):void{
		}
		
		private function setSoundFadeIn(info:SoundInfo, len:int, trans:SoundTransform):void{
		}*/
		
		// Starts playing the specified music from the beginning.
		public function startMusic(soundID:int, loop:Boolean):int{
			// If we currently have a sound loaded, stop its channel and remove it.
			if (mus_infos.length > 0){
				stopMusic();
			}
			
			var extID:int = nextExternalID;
			mus_infos.push(new SoundInfo(mus_infos, nextExternalID)); // Add a new entry
			nextExternalID++; // Increment our next ID, since we just used this one.
			
			// Set up state and preference variables
			mus_infos[0].isLooping = loop;			
			mus_infos[0].soundID = soundID;
			mus_infos[0].isPaused = false;
			mus_infos[0].pos = 0;
			mus_infos[0].muteLevel = mus_mute_level;
			
			startSound(mus_infos[0], mus_vol, mus_trans);
			return extID;
		}
		
		// If p is true, pauses the music.  If false, unpauses.
		public function pauseMusic(p:Boolean):void{
			if (mus_infos.length > 0){ // If we have an active clip - otherwise there's nothing to pause/unpause
				pauseSound(mus_infos[0], mus_vol, mus_trans, p);
			}
		}
		
		public function stopMusic():void{
			if (mus_infos.length > 0)
			{
				stopSound(mus_infos[0]);
			}
		}
		
		// Volume should be between 0 and 1, and will be constrained to those values within the function.
		public function setMusicVolume(vol:Number):void {
			//trace("SoundManager.setMusicVolume(" + vol + ")");
			if (vol > 1) vol = 1; // Cap to <= 1
			if (vol < 0) vol = 0; // Cap to >= 0

			mus_vol = vol; // Store the new volume preference
			
			if (mus_infos.length > 0)
				setSoundVolume(mus_infos[0], mus_vol, mus_trans);
		}
		
		// If doMute is true, we set volume to 0.  If false, we set volume back to saved volume level.
		public function setMusicMute(doMute:Boolean):void{
			mus_mute_level=doMute?0:1; // We set our universal mute based on doMute
			if (mus_infos.length > 0){
				mus_infos[0].muteLevel = mus_mute_level; // Now we update our music instance mute setting
				setSoundVolume(mus_infos[0], mus_vol, mus_trans); // And update the sound volume
			}
		}
		
		public function seekMusic(position:int):void{
			if (mus_infos.length > 0){
				seekSound(mus_infos[0], position);
			}
		}
		
		// Puts the playhead at position.  If a soundID is given then we create a new sound too and return
		// the external ID for the specific instance.  If no ID is given, returns -1.
		public function startMusicAt(position:int, soundID:int = -1, loop:Boolean = false):int{
			var extID:int = -1;
			if (soundID > -1){
				extID = startMusic(soundID, loop);
				mus_infos[0].startingPos = position;
			}
			
			pauseMusic(false); // Make sure music is playing
			seekMusic(position); // Move the playhead
			return extID;
		}
		
		// Sets a fade out for the sound.  If startFade is given then the fade will start at that point,
		// otherwise it will start at len milliseconds prior to the end of the sound file.
		public function setMusicFadeOut(len:int, startFade:int = -1):void{
			if (mus_infos.length > 0){
				mus_infos[0].toFadeOut = true;
				mus_infos[0].fadeOutLength = len;
				if (startFade > -1)
					mus_infos[0].fadeOutStart = startFade;
				else
					mus_infos[0].fadeOutStart = mus_infos[0].length - len;
			}
			else
				throw new Error("No music object exists.  Start music before setting a fade.");
		}
		
		public function setMusicFadeIn(len:int):void{
			if (mus_infos.length > 0){
				mus_infos[0].toFadeIn = true;
				mus_infos[0].fadeInLength = len;
			}
			else
				throw new Error("No music object exists.  Start music before setting a fade.");
		}
		
		// Starts playing the specified ambient from the beginning.
		public function startAmbient(soundID:int, loop:Boolean):int{
			// If we currently have a sound loaded, stop its channel and remove it.
			if (amb_infos.length > 0){
				stopAmbient();
			}
			
			var extID:int = nextExternalID;
			amb_infos.push(new SoundInfo(amb_infos, nextExternalID)); // Add a new entry
			nextExternalID++; // Increment our next ID, since we just used this one.
			
			// Set up state and preference variables
			amb_infos[0].isLooping = loop;			
			amb_infos[0].soundID = soundID;
			amb_infos[0].isPaused = false;
			amb_infos[0].pos = 0;
			amb_infos[0].muteLevel = amb_mute_level;
			
			startSound(amb_infos[0], amb_vol, amb_trans);
			return extID;
		}
		
		// If p is true, pauses the ambient.  If false, unpauses.
		public function pauseAmbient(p:Boolean):void{
			if (amb_infos.length > 0){ // If we have an active clip - otherwise there's nothing to pause/unpause
				pauseSound(amb_infos[0], amb_vol, amb_trans, p);
			}
		}
		
		public function stopAmbient():void{
			if (amb_infos.length > 0)
			{
				stopSound(amb_infos[0]);
			}
		}
		
		// Volume should be between 0 and 1, and will be constrained to those values within the function.
		public function setAmbientVolume(vol:Number):void{
			if (vol > 1) vol = 1; // Cap to <= 1
			if (vol < 0) vol = 0; // Cap to >= 0

			amb_vol = vol; // Store the new volume preference
			
			if (amb_infos.length > 0)
				setSoundVolume(amb_infos[0], amb_vol, amb_trans);
		}
		
		// If doMute is true, we set volume to 0.  If false, we set volume back to saved volume level.
		// If doMute is true, we set volume to 0.  If false, we set volume back to saved volume level.
		public function setAmbientMute(doMute:Boolean):void{
			amb_mute_level=doMute?0:1; // We set our universal mute based on doMute
			if (amb_infos.length > 0){
				amb_infos[0].muteLevel = amb_mute_level; // Now we update our music instance mute setting
				setSoundVolume(amb_infos[0], amb_vol, amb_trans); // And update the sound volume
			}
		}
		
		public function seekAmbient(position:int):void{
			if (amb_infos.length > 0){
				seekSound(amb_infos[0], position);
			}
		}
		
		// Puts the playhead at position.  If a soundID is given then we create a new sound too and return
		// the external ID for the specific instance.  If no ID is given, returns -1.
		public function startAmbientAt(position:int, soundID:int = -1, loop:Boolean = false):int{
			var extID:int = -1;
			if (soundID > -1){
				extID = startAmbient(soundID, loop);
				amb_infos[0].startingPos = position;
			}
			
			pauseAmbient(false); // Make sure music is playing
			seekAmbient(position); // Move the playhead
			return extID;
		}
		
		// Sets a fade out for the sound.  If startFade is given then the fade will start at that point,
		// otherwise it will start at len milliseconds prior to the end of the sound file.
		public function setAmbientFadeOut(len:int, startFade:int = -1):void{
			if (amb_infos.length > 0){
				amb_infos[0].toFadeOut = true;
				amb_infos[0].fadeOutLength = len;
				if (startFade > -1)
					amb_infos[0].fadeOutStart = startFade;
				else
					amb_infos[0].fadeOutStart = amb_infos[0].length - len;
			}
			else
				throw new Error("No ambient object exists.  Start ambient before setting a fade.");
		}
		
		public function setAmbientFadeIn(len:int):void{
			if (amb_infos.length > 0){
				amb_infos[0].toFadeIn = true;
				amb_infos[0].fadeInLength = len;
			}
			else
				throw new Error("No ambient object exists.  Start ambient before setting a fade.");
		}
		
		// Starts playing the specified SFX from the beginning.
		public function startSFX(soundID:int, loop:Boolean=false):int{
			var extID:int = nextExternalID;
			sfx_infos.push(new SoundInfo(sfx_infos, nextExternalID)); // Add a new entry
			nextExternalID++; // Increment our next ID, since we just used this one.
			
			// Set up state and preference variables.  We are setting up the last element at the moment.
			sfx_infos[sfx_infos.length - 1].isLooping = loop;			
			sfx_infos[sfx_infos.length - 1].soundID = soundID;
			sfx_infos[sfx_infos.length - 1].isPaused = false;
			sfx_infos[sfx_infos.length - 1].pos = 0;
			sfx_infos[sfx_infos.length - 1].muteLevel = sfx_mute_level;
			
			startSound(sfx_infos[sfx_infos.length - 1], sfx_vol, sfx_trans);
			return extID;
		}
		
		// If p is true, pauses the specified SFX.  If false, unpauses.  Returns true if it finds a matching index.
		public function pauseSFX(p:Boolean, extID:int):Boolean{
			var sfxIndex:int = -1; // Assume we don't find one, set to -1
			var counter:int = 0;
			
			while (counter <  sfx_infos.length && sfxIndex < 0){ // Stop if we find it or hit the end.
				if (sfx_infos[counter].getExternalID() == extID){
					sfxIndex = counter;
				}
				counter++;
			}
	
			if (sfxIndex > -1){ // If we find a matching index we pause it.
				pauseSound(sfx_infos[sfxIndex], sfx_vol, sfx_trans, p);
				return true;
			}
			else
				return false;
		}
		
		// If p is true, pauses all SFX.  If false, unpauses.
		public function pauseAllSFX(p:Boolean):void{
			var counter:int = 0;
			
			while (counter < sfx_infos.length)
			{
				pauseSound(sfx_infos[counter], sfx_vol, sfx_trans, p);
				counter++;
			}
		}
		
		public function stopSFX(extID:int):Boolean{
			var sfxIndex:int = -1; // Assume we don't find one, set to -1
			var counter:int = 0;
			
			while (counter <  sfx_infos.length && sfxIndex < 0){ // Stop if we find it or hit the end.
				if (sfx_infos[counter].getExternalID() == extID){
					sfxIndex = counter;
				}
				counter++;
			}
	
			if (sfxIndex > -1){ // If we find a matching index we pause it.
				stopSound(sfx_infos[sfxIndex]);
				return true;
			}
			else
				return false;
		}
		
		public function stopAllSFX():void{
			var counter:int = 0;
			while (counter < sfx_infos.length)
			{
				stopSound(sfx_infos[counter]);
				counter++;
			}
		}
		
		// Volume should be between 0 and 1, and will be constrained to those values within the function.
		public function setSFXVolume(vol:Number):void{
			if (vol > 1) vol = 1; // Cap to <= 1
			if (vol < 0) vol = 0; // Cap to >= 0

			sfx_vol = vol; // Store the new volume preference
			
			var counter:int = 0;
			while (counter < sfx_infos.length)
			{
				setSoundVolume(sfx_infos[counter], sfx_vol, sfx_trans);
				counter++;
			}
				
		}
		
		// If doMute is true, we set volume to 0.  If false, we set volume back to saved volume level.
		public function setSFXMute(doMute:Boolean):void{
			sfx_mute_level=doMute?0:1; // We set our universal mute based on doMute
			var counter:int = 0;
			while (counter < sfx_infos.length)
			{
				sfx_infos[counter].muteLevel = sfx_mute_level; // Now we update our music instance mute setting
				setSoundVolume(sfx_infos[counter], sfx_vol, sfx_trans); // And update the sound volume
				counter++;
			}
		}
	}
}