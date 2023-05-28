import Components.UniformTimeMeter;
import mx.transitions.Tween;
import mx.transitions.easing.*;

// this is the QuestUpdateBaseInstance movieclip

class QuestNotification extends MovieClip
{
	static var QuestNotificationIntervalIndex: Number = 0;
	static var AnimationCount: Number = 0;
	static var QUEST_UPDATE: Number = 0;
	static var SKILL_LEVEL_UPDATE: Number = 1;
	static var PLAYER_LEVEL_UPDATE: Number = 2;
	static var SHOUT_UPDATE: Number = 3;
	static var bPlayerLeveled: Boolean = false;
	static var PlayerLevel: Number = 0;
	
	var ShowNotifications: Boolean = true;
	
	var AnimStrip: MovieClip;
	var AnimStripText: TextField;

	static var AnimStripWaitIndex: Number;
	static var AnimStripWaitKillIndex: Number;

	static var ShoutTextWaitIndex: Number;

	var AnimStripWidth;

	var LevelMeter: MovieClip;
	var LevelMeterBaseInstance: MovieClip;
	var LevelUpMeter: UniformTimeMeter;
	
	var ObjText: ObjectiveText;

	var ObjectiveLineInstance: ObjectiveText;
	var ObjectivesA: Array;
	var ObjectivesCount: Number;

	var ShoutTextInstance: MovieClip;

	static var Instance: Object;

	static var LevelUpMeterIntervalIndex: Number;
	static var LevelUpMeterKillIntervalIndex: Number;

	function QuestNotification()
	{
		super();
		QuestNotification.Instance = this;
		ObjectivesA = new Array();

		AnimStripText = AnimStrip.textField;
		AnimStrip._visible = false;

		AnimStrip._width *= 0.8;
		AnimStrip._height *= 0.8;

		ShoutTextInstance._width *= 1.5;
		ShoutTextInstance._height *= 1.5;

		LevelMeterBaseInstance.LevelMeter.levelValue.textAutoSize = "shrink";
		LevelMeterBaseInstance.LevelMeter.levelValue.verticalAlign = "center";
		
		ObjText = ObjectiveLineInstance;

		LevelUpMeter = new UniformTimeMeter(LevelMeterBaseInstance.LevelMeter.LevelUpMeterInstance, "UILevelUp", LevelMeterBaseInstance.LevelMeter.LevelUpMeterInstance.FlashInstance, "StartFlash");
		LevelUpMeter.FillSpeed = 0.2;
		LevelMeterBaseInstance.gotoAndStop("FadeIn");

		QuestNotification.LevelUpMeterIntervalIndex = 0;
		QuestNotification.LevelUpMeterKillIntervalIndex = 0;
		QuestNotification.AnimStripWaitIndex = 0;
		ShoutTextWaitIndex = 0;

		PositionElements();
	}

	function PositionElements(){

		AnimStrip._x = 0;

		LevelMeterBaseInstance._y = (LevelMeterBaseInstance._height / 2) + 20;
		LevelMeterBaseInstance._x = 0;

		var lvlLabel = LevelMeterBaseInstance.LevelMeter.levelValue;
		
		lvlLabel._x = -(lvlLabel._width / 2);
		lvlLabel._y = -(lvlLabel._height / 2);
		
		AnimStrip._y = LevelMeterBaseInstance._y + (LevelMeterBaseInstance._height / 2) + 50;

		AnimStripText._y = -(AnimStripText._height / 2);
		ShoutTextInstance._y = AnimStrip._y + AnimStrip._height;

		
		
		ObjectiveLineInstance._x = 0;
		ObjectiveLineInstance._y = AnimStrip._y + AnimStrip._height;

		ShoutTextInstance._x = -(ShoutTextInstance._width / 2);



		ResetShoutTextMask();
	}

	static function Update(): Void
	{
		QuestNotification.Instance.ObjText.UpdateObjectives(QuestNotification.Instance.ObjectivesA);
	}

	function EvaluateNotifications(): Void
	{
		if (QuestNotification.AnimationCount == 0) {
			// QuestNotification.RestartAnimations();
			clearInterval(QuestNotification.QuestNotificationIntervalIndex);
			QuestNotification.QuestNotificationIntervalIndex = 0;
		}
	}

	static function DecAnimCount(): Void
	{
		--QuestNotification.AnimationCount;
		if (QuestNotification.AnimationCount == 0) 
			QuestNotification.Instance.ShowObjectives(QuestNotification.Instance.ObjectivesCount);
	}

	static function CheckContinue(): Boolean
	{
		QuestNotification.Instance.EvaluateNotifications();
		return true;
	}

	function CanShowNotification(): Boolean
	{
		return ShowNotifications && QuestNotification.AnimationCount == 0;
	}

	function ResetShoutTextMask(){
		var tField = ShoutTextInstance.ShoutText.textField;
		var mask = ShoutTextInstance.ShoutText.Mask;
		mask._width = tField._width;
		mask._height = tField._height;
		mask._x = -mask._width;
		mask._y = 0;
	}

	function ShowShoutText(aText: String)
	{

		var tField = ShoutTextInstance.ShoutText.textField;

		tField.SetText(aText);

		ShoutTextInstance.ShoutText.textFieldGlow.SetText(aText);

		var fadeTimeSec = 1;

		ResetShoutTextMask();
		
		var tween = new Tween(ShoutTextInstance.ShoutText.Mask, "_x", Regular.easeOut, -tField._width, 0, fadeTimeSec, true);

		clearInterval(ShoutTextWaitIndex)

		ShoutTextWaitIndex = setInterval(this, "HideShoutText", (fadeTimeSec * 1000) + 2000)

	}

	function HideShoutText()
	{

		var fadeTimeSec = 0.5;

		var tField = ShoutTextInstance.ShoutText.textField;
	
		var tween = new Tween(ShoutTextInstance.ShoutText.Mask, "_x", Regular.easeOut, 0, tField._width, fadeTimeSec, true);

		clearInterval(ShoutTextWaitIndex)

	}

	function ShowQuestText(aName: String, aStatus: String){

		
		if (aName.length > 0 && aStatus.length > 0) {
			AnimStripText.SetText(aStatus + ": " + aName);
	
		} else {
			AnimStripText.SetText(aName);
		}


		AnimStripText.textAutoSize = "shrink";
		AnimStripText.verticalAlign = "center";
		AnimStripText._x = -(AnimStripText._width / 2);
		
		AnimStripWidth = AnimStripText.getLineMetrics(0).width + 64;

		AnimStrip._visible = true;

		var fadeTimeSec = 0.5;

		var maskTween = new Tween(AnimStrip.Mask, "_width", Regular.easeOut, 0, AnimStripWidth, fadeTimeSec, true);
		var bgTween = new Tween(AnimStrip.Background, "_width", Regular.easeOut, 0, AnimStripWidth, fadeTimeSec, true);
		++AnimationCount;

		clearInterval(AnimStripWaitIndex);
		AnimStripWaitIndex = setInterval(this, "HideQuestText", (fadeTimeSec * 1000) + 3000);

	}

	function HideQuestText(): Void
	{

		var fadeTimeSec = 0.5;

		var maskTween = new Tween(AnimStrip.Mask, "_width", Regular.easeOut, AnimStripWidth, 0, fadeTimeSec, true);
		var bgTween = new Tween(AnimStrip.Background, "_width", Regular.easeOut, AnimStripWidth, 0, fadeTimeSec, true);

		clearInterval(AnimStripWaitIndex);

		AnimStripWaitKillIndex = setInterval(this, "KillQuestText", fadeTimeSec * 1000);

	}

	function KillQuestText(): Void
	{
		DecAnimCount();
		AnimStrip._visible = false;
		clearInterval(AnimStripWaitKillIndex);
	}


	function ShowNotification(aNotificationText: String, aStatus: String, aSoundID: String, aObjectiveCount: Number, aNotificationType: Number, aLevel: Number, aStartPercent: Number, aEndPercent: Number, aDragonText: String): Void
	{

		ShowNotifications = false;

		if (aSoundID.length > 0)
			gfx.io.GameDelegate.call("PlaySound", [aSoundID]);
		EvaluateNotifications();
		QuestNotification.QuestNotificationIntervalIndex = setInterval(mx.utils.Delegate.create(this, EvaluateNotifications), 30);

		if (aNotificationType == QuestNotification.QUEST_UPDATE || aNotificationType == undefined) {
			LevelMeterBaseInstance.gotoAndStop("FadeIn");
			if (aNotificationText.length == 0) {
				ShowObjectives(aObjectiveCount);
			} else {
				ShowQuestText(aNotificationText.toUpperCase(), aStatus.toUpperCase());
				ObjectivesCount = aObjectiveCount;
			}
			return;
		}
		
		ShowQuestText(aNotificationText.toUpperCase());

		if (aDragonText && aNotificationType == QuestNotification.SHOUT_UPDATE) {
			ShowShoutText(aDragonText.toUpperCase());
			
			return;
		}

		QuestNotification.bPlayerLeveled = aStartPercent < 1 && aEndPercent >= 1;
		LevelMeterBaseInstance.gotoAndPlay("FadeIn");
		LevelUpMeter.SetPercent(aStartPercent * 100);
		LevelUpMeter.SetTargetPercent(aEndPercent * 100);
		LevelMeterBaseInstance.LevelMeter.levelValue.SetText(aLevel || 101);
		QuestNotification.PlayerLevel = aLevel;
		clearInterval(QuestNotification.LevelUpMeterIntervalIndex);
		clearInterval(QuestNotification.LevelUpMeterKillIntervalIndex);
		QuestNotification.LevelUpMeterKillIntervalIndex = setInterval(QuestNotification.KillLevelUpMeter, 1000);
	}

	static function UpdateLevelUpMeter(): Void
	{
		QuestNotification.Instance.LevelUpMeter.Update();
	}

	static function KillLevelUpMeter(): Void
	{
		if (QuestNotification.AnimationCount == 0) {
			if (QuestNotification.bPlayerLeveled) {
				QuestNotification.bPlayerLeveled = false;
				QuestNotification.Instance.ShowQuestText(QuestNotification.Instance.LevelUpTextInstance.text);
				QuestNotification.Instance.LevelMeterBaseInstance.LevelMeter.levelValue.SetText(QuestNotification.PlayerLevel + 1);
				return;
			}
			clearInterval(QuestNotification.LevelUpMeterIntervalIndex);
			clearInterval(QuestNotification.LevelUpMeterKillIntervalIndex);
			QuestNotification.Instance.LevelMeterBaseInstance.gotoAndPlay("FadeOut");
		}
	}

	function ShowObjectives(aObjectiveCount: Number): Void
	{
		ObjText.ShowObjectives(aObjectiveCount, ObjectivesA);
		ShowNotifications = true;
	}

	function GetDepth(): Number
	{
		return getNextHighestDepth();
	}

	static function RestartAnimations(): Void
	{
		// var aQuestUpdateBase: MovieClip = QuestNotification.Instance;
		// for (var s: String in aQuestUpdateBase) {
		// 	if (aQuestUpdateBase[s] instanceof AnimatedLetter) {
		// 		aQuestUpdateBase[s].gotoAndPlay(aQuestUpdateBase[s]._currentFrame);
		// 	}
		// }
	}

}
