class ObjectiveText extends MovieClip
{
	static var ClipCount: Number = 0;
	static var ArraySize: Number = 0;
	static var ObjectiveLine_mc;
	

	function ObjectiveText()
	{
		super();
		HideObjectives();
		
	}

	function UpdateObjectives(aObjectiveArrayA: Array): Boolean
	{
		if (ObjectiveText.ArraySize > 0) {
			ShowObjectives(0, aObjectiveArrayA);
			return true;
		}
		return false;
	}

	function DuplicateObjective(aObjectiveArrayA: Array): Void
	{
		// var aPrimaryObjective: String = String(aObjectiveArrayA.shift());
		// var aSecondaryObjective: String = String(aObjectiveArrayA.shift());

		// var aObjectiveText: String = undefined;

		// if (aPrimaryObjective != "undefined") {

		// 	if (aSecondaryObjective.length > 0) {
		// 		aObjectiveText = aSecondaryObjective + ": " + aPrimaryObjective;
		// 	} else {
		// 		aObjectiveText = aPrimaryObjective;
		// 	}

		// 	ObjectiveText.ObjectiveLine_mc = _parent.ObjectiveLineInstance;

		// 	var aObjectiveLine_mc: MovieClip = ObjectiveText.ObjectiveLine_mc.duplicateMovieClip("objective" + ObjectiveText.ClipCount++, _parent.GetDepth());

		// 	++QuestNotification.AnimationCount;
		// 	aObjectiveLine_mc.ObjectiveTextFieldInstance.TextFieldInstance.SetText(aObjectiveText);
		// 	ObjectiveClips.push(aObjectiveLine_mc);
		// }
		// --ObjectiveText.ArraySize;
		// if (ObjectiveText.ArraySize == 0)
		// 	QuestNotification.RestartAnimations();
	}

	function ShowObjectives(aCount: Number, aObjectiveArrayA: Array): Void
	{

		if (aObjectiveArrayA.length > 0) {
			gfx.io.GameDelegate.call("PlaySound", ["UIObjectiveNew"]);
		}
			
		// while (ObjectiveClips.length) {
		// 	delete(eval(ObjectiveClips.shift()));
		// }
		// var aMaxObjectives: Number = Math.min(aObjectiveArrayA.length, Math.min(aCount, 3)); // Shows a max of 3 objectives

		// ObjectiveText.ArraySize = aCount;
		var aObjectivesShown: Number = 0;

		var p = _parent.ObjectiveLineInstance;

		var objArray = [p.ObjectiveText1, p.ObjectiveText2, p.ObjectiveText3];


		while (aObjectivesShown < objArray.length) {

			var obj = objArray[aObjectivesShown];

			obj._x = 0;
			obj._y = 0;

			if (aObjectivesShown > 0){
				var prev = objArray[aObjectivesShown - 1];
				obj._y = prev._y + prev._height;
			}

			obj.TextFieldInstance.textField.SetText(aObjectiveArrayA[aObjectivesShown])
			obj.gotoAndPlay("FadeIn");
			++aObjectivesShown;
		}
		
		
	}

	function HideObjectives(){

		var index: Number = 0;

		var p = _parent.ObjectiveLineInstance;

		var objArray = [p.ObjectiveText1, p.ObjectiveText2, p.ObjectiveText3];

		while (index < objArray.length) {
			var obj = objArray[index];
			obj.gotoAndStop("Hide");
			++index;
		}
	}

}
