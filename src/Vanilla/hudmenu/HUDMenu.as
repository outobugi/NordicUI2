import gfx.io.GameDelegate;
import flash.display.BitmapData;

import Components.Meter;

class HUDMenu extends Shared.PlatformChangeUser
{

	var screen_padding = 20;
	
	var SavedRolloverText: String = "";
	var ItemInfoArray: Array = new Array();
	var CompassMarkerList: Array = new Array();
	var METER_PAUSE_FRAME: Number = 40;
	var ActivateButton_tf: TextField;
	var ArrowInfoInstance: MovieClip;

	var BottomLeftLockInstance: MovieClip;
	var BottomRightLockInstance: MovieClip;
	var BottomRightRefInstance: MovieClip;

	var BottomRightRefX: Number;
	var BottomRightRefY: Number;

	var CompassMarkerEnemy: Number;
	var CompassMarkerLocations: Number;
	var CompassMarkerPlayerSet: Number;
	var CompassMarkerQuest: Number;
	var CompassMarkerQuestDoor: Number;
	var CompassMarkerUndiscovered: Number;

	var Compass: MovieClip;
	var CompassRect: MovieClip;
	var CompassDirectionRect: MovieClip;
	
	var CompassTargetDataA: Array;
	var CompassThreeSixtyX: Number;
	var CompassZeroX: Number;

	var Crosshair: MovieClip;
	var CrosshairAlert: MovieClip;
	var CrosshairInstance: MovieClip;
	var EnemyHealthMeter: Meter;
	var EnemyHealth_mc: MovieClip;
	var FavorBackButtonBase: MovieClip;
	var FavorBackButton_mc: MovieClip;
	var FloatingQuestMarkerInstance: MovieClip;
	var FloatingQuestMarker_mc: MovieClip;
	var GrayBarInstance: MovieClip;
	var HUDModes: Array;
	var HudElements: Array;
	var LocationLockBase: MovieClip;

	var PlayerMeters: MovieClip;

	var Health: MovieClip;
	var HealthMeterAnim: MovieClip;
	var HealthMeter: Meter;

	var ItemData: MovieClip;

	var Magicka: MovieClip;
	var MagickaMeter: Meter;
	var MagickaMeterAnim: MovieClip;
	
	var Stamina: MovieClip;
	var StaminaMeter: Meter;
	var StaminaMeterAnim: MovieClip;

	var ChargeMeters: MovieClip;
	var LeftChargeMeter: Meter;
	var LeftChargeMeterAnim: MovieClip;
	var RightChargeMeter: Meter;
	var RightChargeMeterAnim: MovieClip;
	var ChargeMeterHideFrame: Number;

	var leftChargeWaitIndex: Number;
	var rightChargeWaitIndex: Number;

	var ChargeMeterWaitTime: Number = 3000;

	var ShoutMeterAnim: MovieClip;
	var ShoutMeterInstance: ShoutMeter;

	var MessagesBlock: MovieClip;
	var MessagesInstance: MovieClip;
	var QuestUpdateBaseInstance: MovieClip;

	var RolloverButton_tf: TextField;
	var RolloverGrayBar_mc: MovieClip;
	var RolloverInfoInstance: TextField;
	var RolloverInfoText: TextField;
	var RolloverNameInstance: TextField;
	var RolloverText: TextField;
	
	var StealthMeterAnim: MovieClip;
	var StealthMeterInstance: MovieClip;
	var SubtitleText: TextField;
	var SubtitleTextHolder: MovieClip;
	var TopLeftRefInstance: MovieClip;
	var TopLeftRefX: Number;
	var TopLeftRefY: Number;
	var TutorialHintsArtHolder: MovieClip;
	var TutorialHintsText: TextField;
	var TutorialLockInstance: MovieClip;
	var ValueTranslated: TextField;
	var WeightTranslated: TextField;
	var bCrosshairEnabled: Boolean;

	var ArrowNormalFrame: Number;
	var ArrowHideWait: Number;
	var ArrowWaitTime: Number = 7000;

	var healthVisible = false;
	var magicVisible = false;
	var staminaVisible = false;
	var shoutVisible = false;
	var isInDanger = false;

	var leftChargeVisible = false;
	var rightChargeVisible = false;

	var HealthPenaltyPercent = 0;
	var StaminaPenaltyPercent = 0;
	var MagickaPenaltyPercent = 0;
	var lastHealthMeterPercent = 0;
	var lastStaminaMeterPercent = 0;
	var lastMagickaMeterPercent = 0;
	var lastHealthPenaltyPercent = 0;
	var lastStaminaPenaltyPercent = 0;
	var lastMagickaPenaltyPercent = 0;
	var targetTempLevelFrame = 0;
	var temperatureMeterTempLevelFrames = new Array();

	var HUNGER_THRESHOLD_1 = 0;
	var HUNGER_THRESHOLD_2 = 20;
	var HUNGER_THRESHOLD_3 = 42;
	var COLD_THRESHOLD_1 = 0;
	var COLD_THRESHOLD_2 = 19;
	var COLD_THRESHOLD_3 = 42;
	var EXHAUSTION_THRESHOLD_1 = 0;
	var EXHAUSTION_THRESHOLD_2 = 20;
	var EXHAUSTION_THRESHOLD_3 = 46;

	var iPlatform = 1;
	static var CONTROLLER_ORBIS = 3;
	static var CONTROLLER_SCARLETT = 4;
	static var CONTROLLER_PROSPERO = 5;

	function HUDMenu()
	{
		super();
		Shared.GlobalFunc.MaintainTextFormat();
		Shared.GlobalFunc.AddReverseFunctions();
		Key.addListener(this);

		Health = PlayerMeters.Health;
		Magicka = PlayerMeters.Magicka;
		Stamina = PlayerMeters.Stamina;

		ArrowInfoInstance = PlayerMeters.ArrowInfoInstance;

		MagickaMeter = new Meter(Magicka.MagickaMeter_mc);
		HealthMeter = new Meter(Health.HealthMeter_mc);
		StaminaMeter = new Meter(Stamina.StaminaMeter_mc);
		
		ShoutMeterAnim = PlayerMeters.ShoutMeterAnim;
		ShoutMeterInstance = new ShoutMeter(ShoutMeterAnim.ShoutMeter);
		


		LeftChargeMeter = new Meter(ChargeMeters.LeftHandChargeMeterInstance.ChargeMeterL);
		RightChargeMeter = new Meter(ChargeMeters.RightHandChargeMeterInstance.ChargeMeterR);

		LeftChargeMeterAnim = ChargeMeters.LeftHandChargeMeterInstance;
		RightChargeMeterAnim = ChargeMeters.RightHandChargeMeterInstance;
		LeftChargeMeterAnim.gotoAndStop("Hide");
		RightChargeMeterAnim.gotoAndStop("Hide");
		ChargeMeterHideFrame = RightChargeMeterAnim._currentframe;


		
		MagickaMeterAnim = Magicka;
		HealthMeterAnim = Health;
		StaminaMeterAnim = Stamina;

		StealthMeterAnim = Compass.StealthMeterAnim;
		StealthMeterInstance = StealthMeterAnim.StealthMeterInstance;

		

		MagickaMeterAnim.gotoAndStop("Hide");
		HealthMeterAnim.gotoAndStop("Hide");
		StaminaMeterAnim.gotoAndStop("Hide");
		ShoutMeterAnim.gotoAndStop("Hide");
		StealthMeterAnim.gotoAndStop("Normal")

		ArrowInfoInstance.gotoAndStop("Normal");
		ArrowNormalFrame = ArrowInfoInstance._currentframe;

		ArrowInfoInstance.gotoAndStop("FadeIn");

		EnemyHealthMeter = new Meter(EnemyHealth_mc);
		EnemyHealth_mc.BracketsInstance.RolloverNameInstance.textAutoSize = "shrink";
		EnemyHealthMeter.SetPercent(0);
		gotoAndStop("Alert");
		CrosshairAlert = Crosshair;
		CrosshairAlert.gotoAndStop("NoTarget");
		gotoAndStop("Normal");
		CrosshairInstance = Crosshair;
		CrosshairInstance.gotoAndStop("NoTarget");

		RolloverText = ItemData.RolloverNameInstance;
		RolloverButton_tf = ItemData.ActivateButton_tf;
		RolloverInfoText = ItemData.RolloverInfoInstance;
		
		RolloverInfoText.html = true;
		FavorBackButton_mc = FavorBackButtonBase;
		CompassRect = Compass.CompassRect;
		CompassDirectionRect = CompassRect.DirectionRect;
		InitCompass();
		FloatingQuestMarker_mc = FloatingQuestMarkerInstance;
		MessagesInstance = MessagesBlock;
		SetCrosshairTarget(false, "");
		bCrosshairEnabled = true;
		SubtitleText = SubtitleTextHolder.textField;
		TutorialHintsText = TutorialLockInstance.TutorialHintsInstance.FadeHolder.TutorialHintsTextInstance;
		TutorialHintsArtHolder = TutorialLockInstance.TutorialHintsInstance.FadeHolder.TutorialHintsArtInstance;
		TutorialLockInstance.TutorialHintsInstance.gotoAndStop("FadeIn");
		CompassTargetDataA = new Array();
		SetModes();
		
		StealthMeterInstance.gotoAndStop("FadedOut");
	}

	function RegisterComponents(): Void
	{
		GameDelegate.call("RegisterHUDComponents", [this, HudElements, QuestUpdateBaseInstance, EnemyHealthMeter, StealthMeterInstance, StealthMeterInstance.SneakAnimInstance, EnemyHealth_mc.BracketsInstance, EnemyHealth_mc.BracketsInstance.RolloverNameInstance, StealthMeterInstance.SneakTextHolder, StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance]);
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		iPlatform = aiPlatform;
		FavorBackButton_mc.FavorBackButtonInstance.SetPlatform(aiPlatform, abPS3Switch);
		TutorialHintsArtHolder.SetPlatform(aiPlatform,abPS3Switch);
	}

	function SetModes(): Void
	{
		HudElements = new Array();
		HUDModes = new Array();
		HudElements.push(PlayerMeters);
		HudElements.push(CompassRect);
		HudElements.push(LeftChargeMeterAnim);
		HudElements.push(RightChargeMeterAnim);
		HudElements.push(CrosshairInstance);
		HudElements.push(CrosshairAlert);

		HudElements.push(ItemData);
		
		HudElements.push(MessagesBlock);
		HudElements.push(SubtitleTextHolder);
		HudElements.push(QuestUpdateBaseInstance);
		HudElements.push(EnemyHealth_mc);
		HudElements.push(StealthMeterInstance);
		HudElements.push(StealthMeterInstance.SneakTextHolder.SneakTextClip);
		HudElements.push(StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance);
		
		HudElements.push(FavorBackButton_mc);
		HudElements.push(FloatingQuestMarker_mc);
		HudElements.push(LocationLockBase);
		HudElements.push(TutorialLockInstance);
		
		PlayerMeters.All = true;
		
		LeftChargeMeterAnim.All = true;
		RightChargeMeterAnim.All = true;
		CrosshairInstance.All = true;
		CrosshairAlert.All = true;
		// RolloverText.All = true;
		// RolloverInfoText.All = true;
		// RolloverGrayBar_mc.All = true;
		ItemData.All = true;
		CompassRect.All = true;
		
		
		MessagesBlock.All = true;
		SubtitleTextHolder.All = true;
		QuestUpdateBaseInstance.All = true;
		EnemyHealth_mc.All = true;
		StealthMeterInstance.All = true;
		
		FloatingQuestMarker_mc.All = true;
		StealthMeterInstance.SneakTextHolder.SneakTextClip.All = true;
		StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance.All = true;
		LocationLockBase.All = true;
		TutorialLockInstance.All = true;
		
		
		CrosshairInstance.Favor = true;
		// RolloverText.Favor = true;
		// RolloverInfoText.Favor = true;
		// RolloverGrayBar_mc.Favor = true;
		ItemData.Favor = true;
		CompassRect.Favor = true;
		
		MessagesBlock.Favor = true;
		SubtitleTextHolder.Favor = true;
		QuestUpdateBaseInstance.Favor = true;
		EnemyHealth_mc.Favor = true;
		StealthMeterInstance.Favor = true;
		FavorBackButton_mc.Favor = true;
		FavorBackButton_mc._visible = false;
		FloatingQuestMarker_mc.Favor = true;
		LocationLockBase.Favor = true;
		TutorialLockInstance.Favor = true;
		
		MessagesBlock.InventoryMode = true;
		QuestUpdateBaseInstance.InventoryMode = true;
		
		MessagesBlock.TweenMode = true;
		QuestUpdateBaseInstance.TweenMode = true;
		
		MessagesBlock.BookMode = true;
		QuestUpdateBaseInstance.BookMode = true;
		
		QuestUpdateBaseInstance.DialogueMode = true;
		CompassRect.DialogueMode = true;
		
		MessagesBlock.DialogueMode = true;
		
		QuestUpdateBaseInstance.BarterMode = true;
		MessagesBlock.BarterMode = true;
		
		MessagesBlock.WorldMapMode = true;
		
		MessagesBlock.MovementDisabled = true;
		QuestUpdateBaseInstance.MovementDisabled = true;
		SubtitleTextHolder.MovementDisabled = true;
		TutorialLockInstance.MovementDisabled = true;
		
		PlayerMeters.StealthMode = true;
		CrosshairInstance.StealthMode = true;
		LeftChargeMeterAnim.StealthMode = true;
		RightChargeMeterAnim.StealthMode = true;
		// RolloverText.StealthMode = true;
		ItemData.StealthMode = true;
		// RolloverInfoText.StealthMode = true;
		// RolloverGrayBar_mc.StealthMode = true;
		CompassRect.StealthMode = true;
		MessagesBlock.StealthMode = true;
		SubtitleTextHolder.StealthMode = true;
		QuestUpdateBaseInstance.StealthMode = true;
		EnemyHealth_mc.StealthMode = true;
		StealthMeterInstance.StealthMode = true;
		StealthMeterInstance.SneakTextHolder.SneakTextClip.StealthMode = true;
		StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance.StealthMode = true;
		FloatingQuestMarker_mc.StealthMode = true;
		LocationLockBase.StealthMode = true;
		TutorialLockInstance.StealthMode = true;
		
		PlayerMeters.Swimming = true;
		
		LeftChargeMeterAnim.Swimming = true;
		RightChargeMeterAnim.Swimming = true;
		CrosshairInstance.Swimming = true;
		// RolloverText.Swimming = true;
		// RolloverInfoText.Swimming = true;
		// RolloverGrayBar_mc.Swimming = true;
		ItemData.Swimming = true;
		
		MessagesBlock.Swimming = true;
		SubtitleTextHolder.Swimming = true;
		QuestUpdateBaseInstance.Swimming = true;
		EnemyHealth_mc.Swimming = true;
		FloatingQuestMarker_mc.Swimming = true;
		LocationLockBase.Swimming = true;
		TutorialLockInstance.Swimming = true;
		CompassRect.Swimming = true;


		PlayerMeters.HorseMode = true;
		CompassRect.HorseMode = true;
		MessagesBlock.HorseMode = true;
		SubtitleTextHolder.HorseMode = true;
		QuestUpdateBaseInstance.HorseMode = true;
		EnemyHealth_mc.HorseMode = true;
		FloatingQuestMarker_mc.HorseMode = true;
		LocationLockBase.HorseMode = true;
		TutorialLockInstance.HorseMode = true;
		
		PlayerMeters.WarHorseMode = true;
		CompassRect.WarHorseMode = true;
		MessagesBlock.WarHorseMode = true;
		SubtitleTextHolder.WarHorseMode = true;
		QuestUpdateBaseInstance.WarHorseMode = true;
		EnemyHealth_mc.WarHorseMode = true;
		FloatingQuestMarker_mc.WarHorseMode = true;
		LocationLockBase.WarHorseMode = true;
		TutorialLockInstance.WarHorseMode = true;
		CrosshairInstance.WarHorseMode = true;
		
		RightChargeMeterAnim.WarHorseMode = true;
		
		MessagesBlock.CartMode = true;
		SubtitleTextHolder.CartMode = true;
		TutorialLockInstance.CartMode = true;
		
		/*
		All // Normal hud mode
		Favor
		MovementDisabled
		Swimming
		WarhorseMode
		HorseMode
		InventoryMode
		BookMode
		DialogueMode
		StealthMode
		SleepWaitMode
		BarterMode
		TweenMode
		WorldMapMode
		JournalMode // Everything is hidden
		CartMode
		VATSPlayback // Deathcam/killcam
		*/
	}

	function ShowElements(aMode: String, abShow: Boolean): Void
	{
		var newHUDMode: String = "All";
		var HUDModeIdx: Number = HUDModes.length - 1;

		if (abShow) {
			while (HUDModeIdx >= 0) {
				if (HUDModes[HUDModeIdx] == aMode)
					HUDModes.splice(HUDModeIdx, 1);
				HUDModeIdx--;
			}
			HUDModes.push(aMode);
			newHUDMode = aMode;
		} else {
			if (aMode.length > 0) {
				var found: Boolean = false;
				while (HUDModeIdx >= 0 && !found) {
					if (HUDModes[HUDModeIdx] == aMode) {
						HUDModes.splice(HUDModeIdx, 1);
						found = true;
					}
					HUDModeIdx--;
				}
			} else {
				HUDModes.pop();
			}
			if (HUDModes.length > 0) {
				newHUDMode = String(HUDModes[HUDModes.length - 1]);
			}
		}
		
		for(var i: Number = 0; i < HudElements.length; i++) {
			if (HudElements[i] != undefined) {
				HudElements[i]._visible = HudElements[i].hasOwnProperty(newHUDMode);
				if (HudElements[i].onModeChange != undefined)
					HudElements[i].onModeChange(newHUDMode);
			}
		}
	}

	function SetLocationName(aLocation: String): Void
	{
		LocationLockBase.LocationNameBase.LocationTextBase.LocationTextInstance.SetText(aLocation);
		LocationLockBase.LocationNameBase.gotoAndPlay(1);
	}

	function CheckAgainstHudMode(aObj: Object): Boolean
	{
		var HUDMode: String = "All";
		if (HUDModes.length > 0) {
			HUDMode = String(HUDModes[HUDModes.length - 1]);
		}
		return HUDMode == "All" || (aObj != undefined && aObj.hasOwnProperty(HUDMode));
	}

	function InitExtensions(): Void
	{
		
		Shared.GlobalFunc.SetLockFunction();

		PlayerMeters.Lock("BL");

		ShoutMeterAnim._x = ShoutMeterAnim._width / 2;
		ShoutMeterAnim._y = ShoutMeterAnim._height / 2;

		HealthMeterAnim._y = ShoutMeterAnim._y;
		HealthMeterAnim._x = ShoutMeterAnim._x + (ShoutMeterAnim._width / 2);

		StaminaMeterAnim._x = HealthMeterAnim._x + 2;
		MagickaMeterAnim._x = HealthMeterAnim._x + 2;

		var meterPadding = 5;

		StaminaMeterAnim._y = HealthMeterAnim._y + HealthMeterAnim._height + meterPadding;
		MagickaMeterAnim._y = HealthMeterAnim._y - HealthMeterAnim._height - meterPadding;

		ArrowInfoInstance._x = MagickaMeterAnim._x;
		ArrowInfoInstance._y = MagickaMeterAnim._y - MagickaMeterAnim._height;

		PlayerMeters._y -= screen_padding + (PlayerMeters._height / 2) + 10;
		PlayerMeters._x += screen_padding;

		var meterScale = 0.65;
		
		PlayerMeters._width *= meterScale;
		PlayerMeters._height *= meterScale;

		var compScale = 0.8;

		Compass._width *= compScale;
		Compass._height *= compScale;
		Compass.Lock("T");

		EnemyHealth_mc._x = Compass._x;
		EnemyHealth_mc._y = Compass._y + (Compass._height / 2);
		EnemyHealth_mc._height *= compScale;
		EnemyHealth_mc._width *= compScale;

		QuestUpdateBaseInstance._y = EnemyHealth_mc._y + EnemyHealth_mc._height;
		QuestUpdateBaseInstance._x = Compass._x;

		// Vignette._x = 0;
		// Vignette._y = 0;
		// Vignette._width = Stage.visibleRect.width;
		// Vignette._height = Stage.visibleRect.height;

		ChargeMeters.Lock("BR");
		ChargeMeters._x -= 40;
		ChargeMeters._y -= 20;


		TopLeftRefInstance.Lock("TL");
		BottomRightRefInstance.Lock("BR");
		BottomLeftLockInstance.Lock("BL");
		BottomRightLockInstance.Lock("BR");
		
		FavorBackButton_mc.Lock("BR");
		LocationLockBase.Lock("TR");
		LocationLockBase.LocationNameBase.gotoAndStop(1);
		var TopLeftRefCoords: Object = {x: TopLeftRefInstance.LocationRefInstance._x, y: TopLeftRefInstance.LocationRefInstance._y};
		TopLeftRefInstance.localToGlobal(TopLeftRefCoords);
		TopLeftRefX = TopLeftRefCoords.x;
		TopLeftRefY = TopLeftRefCoords.y;
		var LocationRefCoords: Object = {x: BottomRightRefInstance.LocationRefInstance._x, y: BottomRightRefInstance.LocationRefInstance._y};
		BottomRightRefInstance.localToGlobal(LocationRefCoords);
		BottomRightRefX = LocationRefCoords.x;
		BottomRightRefY = LocationRefCoords.y;
		
		MessagesBlock.Lock("TL");
		
		SubtitleTextHolder.Lock("B");
		SubtitleText._visible = false;

		SubtitleText.enabled = true;
		SubtitleText.verticalAutoSize = "bottom";
		SubtitleText.SetText(" ", true);
		RolloverText.verticalAutoSize = "top";
		RolloverText.html = true;



		GameDelegate.addCallBack("SetCrosshairTarget", this, "SetCrosshairTarget");
		GameDelegate.addCallBack("SetLoadDoorInfo", this, "SetLoadDoorInfo");
		GameDelegate.addCallBack("ShowMessage", this, "ShowMessage");
		GameDelegate.addCallBack("ShowSubtitle", this, "ShowSubtitle");
		GameDelegate.addCallBack("HideSubtitle", this, "HideSubtitle");
		GameDelegate.addCallBack("SetCrosshairEnabled", this, "SetCrosshairEnabled");
		GameDelegate.addCallBack("SetSubtitlesEnabled", this, "SetSubtitlesEnabled");
		GameDelegate.addCallBack("SetHealthMeterPercent", this, "SetHealthMeterPercent");
		GameDelegate.addCallBack("SetMagickaMeterPercent", this, "SetMagickaMeterPercent");
		GameDelegate.addCallBack("SetStaminaMeterPercent", this, "SetStaminaMeterPercent");
		GameDelegate.addCallBack("SetShoutMeterPercent", this, "SetShoutMeterPercent");
		GameDelegate.addCallBack("FlashShoutMeter", this, "FlashShoutMeter");
		GameDelegate.addCallBack("SetChargeMeterPercent", this, "SetChargeMeterPercent");

		GameDelegate.addCallBack("StartMagickaMeterBlinking", this, "StartMagickaBlinking");
		GameDelegate.addCallBack("StartStaminaMeterBlinking", this, "StartStaminaBlinking");
		GameDelegate.addCallBack("FadeOutStamina", this, "FadeOutStamina");

		GameDelegate.addCallBack("FadeOutChargeMeters", this, "FadeOutChargeMeters");

		GameDelegate.addCallBack("SetCompassAngle", this, "SetCompassAngle");
		GameDelegate.addCallBack("SetCompassMarkers", this, "SetCompassMarkers");
		GameDelegate.addCallBack("SetEnemyHealthPercent", EnemyHealthMeter, "SetPercent");
		GameDelegate.addCallBack("SetEnemyHealthTargetPercent", EnemyHealthMeter, "SetTargetPercent");
		GameDelegate.addCallBack("ShowNotification", QuestUpdateBaseInstance, "ShowNotification");
		GameDelegate.addCallBack("ShowElements", this, "ShowElements");
		GameDelegate.addCallBack("SetLocationName", this, "SetLocationName");
		GameDelegate.addCallBack("ShowTutorialHintText", this, "ShowTutorialHintText");
		GameDelegate.addCallBack("ValidateCrosshair", this, "ValidateCrosshair");


	}

	function InitCompass(): Void
	{
		CompassRect.gotoAndStop("ThreeSixty");
		CompassThreeSixtyX = CompassDirectionRect._x;
		CompassRect.gotoAndStop("Zero");
		CompassZeroX = CompassDirectionRect._x;
		var CompassMarkerTemp: MovieClip = CompassDirectionRect.attachMovie("Compass Marker", "temp", CompassDirectionRect.getNextHighestDepth());
		CompassMarkerTemp.gotoAndStop("Quest");
		CompassMarkerQuest = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("QuestDoor");
		CompassMarkerQuestDoor = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("PlayerSet");
		CompassMarkerPlayerSet = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("Enemy");
		CompassMarkerEnemy = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("LocationMarkers");
		CompassMarkerLocations = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("UndiscoveredMarkers");
		CompassMarkerUndiscovered = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.removeMovieClip();
	}



	function SetDangerMode(abDanger: Boolean)
	{
		if(abDanger && !isInDanger)
		{
			isInDanger = true;
			
			if (!shoutVisible){
				ShoutMeterAnim.gotoAndPlay("FadeIn");
			}
			
			
			ShoutMeterInstance.SetCombatMode(true);

			if (!healthVisible){
				HealthMeterAnim.gotoAndPlay("FadeIn");
				
			}
			
			StealthMeterAnim.gotoAndPlay("FadeIn");
		}
		if(!abDanger && isInDanger)
		{
			isInDanger = false;

			if(!healthVisible)
			{
				HealthMeterAnim.gotoAndPlay("FadeOut");
			}
			
			ShoutMeterInstance.SetCombatMode(false);
			
			if (!shoutVisible){
				ShoutMeterAnim.gotoAndPlay("FadeOut");
			}
			
			StealthMeterAnim.gotoAndPlay("FadeOut");
		}
	}

	function RunMeterAnim(aMeter: MovieClip): Void
	{
	}

	function FadeOutMeter(aMeter: MovieClip): Void
	{
		if (aMeter._currentframe > METER_PAUSE_FRAME){
			aMeter.gotoAndStop("Pause");
		}
			
		aMeter.PlayReverse();
	}

	function FadeOutStamina(aPercent: Number): Void
	{
	}

	function FadeOutChargeMeters(): Void
	{
		if (leftChargeVisible){
			LeftChargeMeterAnim.gotoAndPlay("FadeOut");
			leftChargeVisible = false;
		}

		if (rightChargeVisible){
			RightChargeMeterAnim.gotoAndPlay("FadeOut");
			rightChargeVisible = false;
		}
		
	}

	function SetChargeMeterPercent(aPercent: Number, abForce: Boolean, abLeftHand: Boolean, abShow: Boolean): Void
	{
		var ChargeMeter: Meter = abLeftHand ? LeftChargeMeter : RightChargeMeter;
		var ChargeMeterAnim: MovieClip = abLeftHand ? LeftChargeMeterAnim : RightChargeMeterAnim;

		// This is a mess
		
		if (abLeftHand){
			clearInterval(leftChargeWaitIndex);
		} else {
			clearInterval(rightChargeWaitIndex);
		}

		if (!abShow) {

			if (abLeftHand){
				if (leftChargeVisible){
					leftChargeVisible = false;
					LeftChargeMeterAnim.gotoAndPlay("FadeOut");
				}
				
			} else {
				if (rightChargeVisible){
					rightChargeVisible = false;
					RightChargeMeterAnim.gotoAndPlay("FadeOut");
				}
			}
			return;

		} else {
			if (abLeftHand){
				if (!leftChargeVisible){
					leftChargeVisible = true;
					
					LeftChargeMeterAnim.gotoAndPlay("FadeIn");
				}
				
			} else {
				if (!rightChargeVisible){
					rightChargeVisible = true;
					
					RightChargeMeterAnim.gotoAndPlay("FadeIn");
				}
			}
		}

		if (abLeftHand){
			leftChargeWaitIndex = setInterval(this, "FadeOutChargeMeter", ChargeMeterWaitTime, LeftChargeMeterAnim);
		} else {
			rightChargeWaitIndex = setInterval(this, "FadeOutChargeMeter", ChargeMeterWaitTime, RightChargeMeterAnim);
		}
		

		if (abForce) {

			ChargeMeter.SetPercent(aPercent);
			ChargeMeter.SetPercent(aPercent);
			
			return;
		}

		ChargeMeter.SetTargetPercent(aPercent);
		ChargeMeter.SetTargetPercent(aPercent);
	}

	function FadeOutChargeMeter(aMeter: MovieClip){

		aMeter.gotoAndPlay("FadeOut");

		if (aMeter == LeftChargeMeterAnim){
			clearInterval(leftChargeWaitIndex);
			leftChargeVisible = false;
		}

		if (aMeter == RightChargeMeterAnim){
			clearInterval(rightChargeWaitIndex);
			rightChargeVisible = false;
		}

	}

	function SetHealthMeterPercent(aPercent: Number, abForce: Boolean): Void
	{
		var isTheSame = aPercent === lastHealthMeterPercent;
		lastHealthMeterPercent = aPercent;
		aPercent = aPercent * (100 - HealthPenaltyPercent) / 100;
		HealthMeter.SetTargetPercent(aPercent);
		HealthMeter.SetPercent(aPercent);
		
		if(!isInDanger)
		{
			if(aPercent >= 100)
			{
				if(healthVisible){
					healthVisible = false;
					HealthMeterAnim.gotoAndPlay("FadeOut");
				}
			}
			else if(aPercent >= 0)
			{
				if(!healthVisible){
					healthVisible = true;
					HealthMeterAnim.gotoAndPlay("FadeIn");
				}
			}
     	}
	}

	function SetMagickaMeterPercent(aPercent: Number, abForce: Boolean): Void
	{
		var isTheSame = aPercent === lastMagickaMeterPercent;
		lastMagickaMeterPercent = aPercent;
		aPercent = aPercent * (100 - MagickaPenaltyPercent) / 100;
		MagickaMeter.SetTargetPercent(aPercent);
		MagickaMeter.SetPercent(aPercent);
		if(aPercent >= 100)
		{
			if(magicVisible)
			{
				magicVisible = false;
				MagickaMeterAnim.gotoAndPlay("FadeOut");
			}
		}
		else if(aPercent >= 0)
		{
			if(!magicVisible)
			{
				magicVisible = true;
				MagickaMeterAnim.gotoAndPlay("FadeIn");
			}
		}
	}

	function SetStaminaMeterPercent(aPercent: Number, abForce: Boolean): Void
	{
		var isTheSame = aPercent === lastStaminaMeterPercent;
		
		lastStaminaMeterPercent = aPercent;

		aPercent = aPercent * (100 - StaminaPenaltyPercent) / 100;
		StaminaMeter.SetTargetPercent(aPercent);
		StaminaMeter.SetPercent(aPercent);

		if(aPercent >= 100)
		{
			if(staminaVisible)
			{
				staminaVisible = false;
				StaminaMeterAnim.gotoAndPlay("FadeOut");
			}
		}
		else if(aPercent >= 0)
		{
			if(!staminaVisible)
			{
				staminaVisible = true;
				StaminaMeterAnim.gotoAndPlay("FadeIn");
			}
		}
	}

	function SetShoutMeterPercent(aPercent: Number, abForce: Boolean): Void
	{
		
		ShoutMeterInstance.SetPercent(aPercent);

		if(!isInDanger)
		{
			if(aPercent >= 100)
			{
				if(shoutVisible)
				{
					shoutVisible = false;
					ShoutMeterAnim.gotoAndPlay("FadeOut");
				}
			}
			else if(aPercent >= 0)
			{
				if(!shoutVisible)
				{
					shoutVisible = true;
					ShoutMeterAnim.gotoAndPlay("FadeIn");
				}
			}
		}
		
	}

	function FlashShoutMeter(): Void
	{
	}

	function StartMagickaBlinking(): Void
	{
	}

	function StartStaminaBlinking(): Void
	{
	}

	function SetCompassAngle(aPlayerAngle: Number, aCompassAngle: Number, abShowCompass: Boolean)
	{
		CompassRect._parent._visible = abShowCompass;
		if (abShowCompass) {
			var Compass_x: Number = Shared.GlobalFunc.Lerp(CompassZeroX, CompassThreeSixtyX, 0, 360, aCompassAngle);
			CompassDirectionRect._x = Compass_x;
			UpdateCompassMarkers(aPlayerAngle);
		}
	}

	function ShowSurvivalElements(abShow, aUpdateData, abForce){

	}

	function SetCompassTemperature(aTemperatureLevel, abForce){

	}

	function TemperatureMeterAnim(){

	}

	function SetColdPenaltyMeter(aPercent, abForce){

	}

	function SetHungerPenaltyMeter(aPercent, abForce){

	}

	function SetExhaustionPenaltyMeter(aPercent, abForce){

	}

	function SetCrosshairTarget(abActivate: Boolean, aName: String, abShowButton: Boolean, abTextOnly: Boolean, abFavorMode: Boolean, abShowCrosshair: Boolean, aWeight: Number, aCost: Number, aFieldValue: Number, aFieldText): Void // Unknown type aFieldText, possibly Number
	{
		var FavorModeNoTarget: String = abFavorMode ? "Favor" : "NoTarget";
		var FavorModeTarget: String = abFavorMode ? "Favor" : "Target";
		var Crosshair_mc: MovieClip = _currentframe == 1 ? CrosshairInstance : CrosshairAlert;
		Crosshair_mc._visible = CheckAgainstHudMode(Crosshair_mc) && abShowCrosshair != false;
		Crosshair_mc._alpha = bCrosshairEnabled ? 100 : 0;
		if (!abActivate && SavedRolloverText.length > 0) {
			Crosshair_mc.gotoAndStop(FavorModeNoTarget);
			RolloverText.SetText(SavedRolloverText, true);
			RolloverText._alpha = 100;
			RolloverButton_tf._alpha = 0;
		} else if (abTextOnly || abActivate) {
			if (!abTextOnly) {
				Crosshair_mc.gotoAndStop(FavorModeTarget);
			}
			RolloverText.SetText(aName, true);
			RolloverText._alpha = 100;
			RolloverButton_tf._alpha = abShowButton ? 100 : 0;
			// RolloverButton_tf._x = RolloverText._x + RolloverText.getLineMetrics(0).x - 103;
		} else {
			Crosshair_mc.gotoAndStop(FavorModeNoTarget);
			RolloverText.SetText(" ", true);
			RolloverText._alpha = 0;
			RolloverButton_tf._alpha = 0;
		}
		
		var TranslateText: String = "";
		if (aCost != undefined) {
			TranslateText = ValueTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aCost) + "</font>" + TranslateText;
		}
		if (aWeight != undefined) {
			TranslateText = WeightTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Shared.GlobalFunc.RoundDecimal(aWeight, 1) + "</font>	  " + TranslateText;
		}
		if (aFieldValue != undefined) {
			var aTextField: TextField = new TextField();
			aTextField.text = aFieldText.toString();
			TranslateText = aTextField.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aFieldValue) + "</font>	  " + TranslateText;
		}
		// if (TranslateText.length > 0) {
		// 	RolloverGrayBar_mc._alpha = 100;
		// } else {
		// 	RolloverGrayBar_mc._alpha = 0;
		// }
		
		RolloverInfoText.htmlText = TranslateText;

	}

	function RefreshActivateButtonArt(astrButtonName: String): Void
	{
		if (astrButtonName == undefined) {
			RolloverButton_tf.SetText(" ", true);
			return;
		}
		
		var ButtonImage: BitmapData = BitmapData.loadBitmap(astrButtonName + ".png");
		if (ButtonImage != undefined && ButtonImage.height > 0) {
			var MaxHeight: Number = 26;
			var ScaledWidth: Number = Math.floor(MaxHeight / ButtonImage.height * ButtonImage.width);
			RolloverButton_tf.SetText("<img src=\'" + astrButtonName + ".png\' height=\'" + MaxHeight + "\' width=\'" + ScaledWidth + "\'>", true);
			return;
		}
		RolloverButton_tf.SetText(" ", true);
	}

	function SetLoadDoorInfo(abShow: Boolean, aDoorName: String): Void
	{
		if (abShow) {
			SavedRolloverText = aDoorName;
			SetCrosshairTarget(true, SavedRolloverText, false, true, false);
			return;
		}
		SavedRolloverText = "";
		SetCrosshairTarget(false, SavedRolloverText, false, false, false);
	}

	function SetSubtitlesEnabled(abEnable: Boolean): Void
	{
		SubtitleText.enabled = abEnable;
		if (!abEnable) 	{
			SubtitleText._visible = false;
			return;
		}
		
		if (SubtitleText.htmlText != " ")
			SubtitleText._visible = true;
	}

	function ShowMessage(asMessage: String): Void
	{
		MessagesInstance.MessageArray.push(asMessage);
	}

	function ShowSubtitle(astrText: String): Void
	{
		SubtitleText.SetText(astrText, true);
		if (SubtitleText.enabled) 
			SubtitleText._visible = true;
	}

	function HideSubtitle(): Void
	{
		SubtitleText.SetText(" ", true);
		SubtitleText._visible = false;
	}

	function ShowArrowCount(aCount: Number, abHide: Boolean, aArrows): Void
	{

		if (abHide){

			if (ArrowInfoInstance._currentframe == ArrowNormalFrame){
				ArrowInfoInstance.gotoAndPlay("FadeOut");
				clearInterval(ArrowHideWait);
				
			}

		} else {

			if (ArrowInfoInstance._currentframe != ArrowNormalFrame){
				ArrowInfoInstance.gotoAndPlay("FadeIn");
			}

			clearInterval(ArrowHideWait);
			ArrowHideWait = setInterval(this, "ShowArrowCount", ArrowWaitTime, 0, true, "")
			
			ArrowInfoInstance.ArrowCountInstance.ArrowNumInstance.SetText(aArrows + " (" + aCount.toString() + ")");
			
		} 


	}

	function onEnterFrame(): Void
	{
		MagickaMeter.Update();
		HealthMeter.Update();
		StaminaMeter.Update();
		// update penalty here
		EnemyHealthMeter.Update();
		LeftChargeMeter.Update();
		RightChargeMeter.Update();
		MessagesInstance.Update();
		TemperatureMeterAnim();
		if(this.lastMagickaPenaltyPercent > this.EXHAUSTION_THRESHOLD_1)
		{
		}
		if(this.lastHealthPenaltyPercent > this.COLD_THRESHOLD_1)
		{
		}
		if(this.lastStaminaPenaltyPercent > this.HUNGER_THRESHOLD_1)
		{
		}
	}

	function SetCompassMarkers(): Void
	{
		var COMPASS_HEADING: Number = 0;
		var COMPASS_ALPHA: Number = 1;
		var COMPASS_GOTOANDSTOP: Number = 2;
		var COMPASS_SCALE: Number = 3;
		var COMPASS_STRIDE: Number = 4;
		
		while (CompassMarkerList.length > CompassTargetDataA.length / COMPASS_STRIDE) {
			CompassMarkerList.pop().movie.removeMovieClip();
		}
		
		for (var i: Number = 0; i < CompassTargetDataA.length / COMPASS_STRIDE; i++) {
			var j: Number = i * COMPASS_STRIDE;
			if (CompassMarkerList[i].movie == undefined) {
				markerData = {movie: undefined, heading: 0};
				if (CompassTargetDataA[j + COMPASS_GOTOANDSTOP] == CompassMarkerQuest || CompassTargetDataA[j + COMPASS_GOTOANDSTOP] == CompassMarkerQuestDoor) {
					markerData.movie = CompassDirectionRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + CompassMarkerList.length, CompassDirectionRect.QuestHolder.getNextHighestDepth());
				} else {
					markerData.movie = CompassDirectionRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + CompassMarkerList.length, CompassDirectionRect.MarkerHolder.getNextHighestDepth());
				}
				CompassMarkerList.push(markerData);
			} else {
				var compassMarkerFrame: Number = CompassMarkerList[i].movie._currentframe;
				if (compassMarkerFrame == CompassMarkerQuest || compassMarkerFrame == CompassMarkerQuestDoor) {
					if (CompassMarkerList[i].movie._parent == CompassDirectionRect.MarkerHolder) {
						markerData = {movie: undefined, heading: 0};
						markerData.movie = CompassDirectionRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + CompassMarkerList.length, CompassDirectionRect.QuestHolder.getNextHighestDepth());
						aCompassMarkerList = CompassMarkerList.splice(i, 1, markerData);
						aCompassMarkerList[0].movie.removeMovieClip();
					}
				} else if (CompassMarkerList[i].movie._parent == CompassDirectionRect.QuestHolder) {
					var markerData: Object = {movie: undefined, heading: 0};
					markerData.movie = CompassDirectionRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + CompassMarkerList.length, CompassDirectionRect.MarkerHolder.getNextHighestDepth());
					var aCompassMarkerList: Array = CompassMarkerList.splice(i, 1, markerData);
					aCompassMarkerList[0].movie.removeMovieClip();
				}
			}
			CompassMarkerList[i].heading = CompassTargetDataA[j + COMPASS_HEADING];
			CompassMarkerList[i].movie._alpha = CompassTargetDataA[j + COMPASS_ALPHA];
			CompassMarkerList[i].movie.gotoAndStop(CompassTargetDataA[j + COMPASS_GOTOANDSTOP]);
			CompassMarkerList[i].movie._xscale = CompassTargetDataA[j + COMPASS_SCALE];
			CompassMarkerList[i].movie._yscale = CompassTargetDataA[j + COMPASS_SCALE];
		}
	}

	function UpdateCompassMarkers(aiCenterAngle: Number): Void
	{
		var compassMarkerWidth: Number = CompassRect.CompassMask_mc._width;
		var angleDelta: Number = compassMarkerWidth * 180 / Math.abs(CompassThreeSixtyX - CompassZeroX);
		var angleDeltaLeft: Number = aiCenterAngle - angleDelta;
		var angleDeltaRight: Number = aiCenterAngle + angleDelta;
		var widthDeltaLeft: Number = 0 - CompassDirectionRect._x - compassMarkerWidth / 2;
		var widthDeltaRight: Number = 0 - CompassDirectionRect._x + compassMarkerWidth / 2;

		var hasEnemies: Boolean = false;
		
		for (var i: Number = 0; i < CompassMarkerList.length; i++) {
			var heading: Number = CompassMarkerList[i].heading;

			if (angleDeltaLeft < 0 && heading > 360 - aiCenterAngle - angleDelta) {
				heading = heading - 360;
			}
			if (angleDeltaRight > 360 && heading < angleDelta - (360 - aiCenterAngle)) {
				heading = heading + 360;
			}
			if(CompassMarkerList[i].movie._currentframe == CompassMarkerEnemy)
			{
				hasEnemies = true;
			}

			if (heading > angleDeltaLeft && heading < angleDeltaRight) {
				CompassMarkerList[i].movie._x = Shared.GlobalFunc.Lerp(widthDeltaLeft, widthDeltaRight, angleDeltaLeft, angleDeltaRight, heading);
			} else {
				var markerFrame: Number = CompassMarkerList[i].movie._currentframe;
				if (markerFrame == CompassMarkerQuest || markerFrame == CompassMarkerQuestDoor) {
					var angleRadians = Math.sin((heading - aiCenterAngle) * Math.PI / 180);
					CompassMarkerList[i].movie._x = angleRadians <= 0 ? widthDeltaLeft + 2 : widthDeltaRight;
				} else {
					CompassMarkerList[i].movie._x = 0;
				}
			}
		}

		SetDangerMode(hasEnemies);
	}

	function ShowTutorialHintText(astrHint: String, abShow: Boolean): Void
	{
		if (abShow) {
			TutorialHintsText.text = astrHint;
			var buttonHtmlText: String = TutorialHintsArtHolder.CreateButtonArt(TutorialHintsText);
			if (buttonHtmlText != undefined) {
				TutorialHintsText.html = true;
				TutorialHintsText.htmlText = buttonHtmlText;
			}
		}
		if (abShow) {
			TutorialLockInstance.TutorialHintsInstance.gotoAndPlay("FadeIn");
			return;
		}
		TutorialLockInstance.TutorialHintsInstance.gotoAndPlay("FadeOut");
	}

	function SetCrosshairEnabled(abFlag: Boolean): Void
	{
		bCrosshairEnabled = abFlag;
		var crosshairMode: MovieClip = _currentframe == 1 ? CrosshairInstance : CrosshairAlert;
		crosshairMode._alpha = bCrosshairEnabled ? 100 : 0;
	}

	function ValidateCrosshair(): Void
	{
		var crosshairMode: MovieClip = _currentframe == 1 ? CrosshairInstance : CrosshairAlert;
		crosshairMode._visible = CheckAgainstHudMode(crosshairMode);
		StealthMeterInstance._visible = CheckAgainstHudMode(StealthMeterInstance);
	}

}
