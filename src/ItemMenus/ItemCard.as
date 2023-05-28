import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.io.GameDelegate;
import Components.DeltaMeter;
import Shared.GlobalFunc;

import skyui.defines.Inventory;


class ItemCard extends MovieClip
{
	#include "../version.as"

	var ItemName: MovieClip;
	var ItemTextField: TextField;
	var ItemDesc: TextField;

	var HeaderBG: MovieClip;

	var BGCard: MovieClip;

	var ItemList: MovieClip;
	var CardList: MovieClip;

	var ItemData: MovieClip;
	var PointLabel: TextField;
	var PointValue: TextField;
	var WeightLabel: TextField;
	var WeightValue: TextField;
	var PriceLabel: TextField;
	var PriceValue: TextField;

	var MagicData: MovieClip;
	var CostLabel: TextField;
	var CostValue: TextField;
	var TimeLabel: TextField;

	var SkillText: TextField;

	var ShoutData: MovieClip;
	var EffectsList: MovieClip;
	var TinyMeter: MovieClip;
	var TMeter: DeltaMeter;
	var HSlider: MovieClip;
	var StolenIcon: MovieClip;

	var ButtonRect: MovieClip;
	var ButtonRect_mc: MovieClip;

	
	var InputHandler: Function;
	var dispatchEvent: Function;
	
	var LastUpdateObj: Object;

	var _bEditNameMode: Boolean;
	var bFadedIn: Boolean;
	var PrevFocus;
	

	function ItemCard()
	{
		super();
		
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.AddReverseFunctions();
		EventDispatcher.initialize(this);

		ItemTextField = ItemName.textField;

		ButtonRect_mc = ButtonRect;
		ItemList = CardList.List_mc;

		PointLabel = ItemData.PointLabel;
		PointValue = ItemData.PointValue;
		WeightLabel = ItemData.WeightLabel;
		WeightValue = ItemData.WeightValue;
		PriceLabel = ItemData.PriceLabel;
		PriceValue = ItemData.PriceValue;

		CostLabel = MagicData.CostLabel;
		CostValue = MagicData.CostValue;
		TimeLabel = MagicData.TimeLabel;

		TMeter = new DeltaMeter(TinyMeter.MeterInstance);
	
		SetupItemName();
		bFadedIn = false;
		InputHandler = undefined;
		_bEditNameMode = false;
	}

	function get bEditNameMode(): Boolean
	{
		return _bEditNameMode;
	}

	function GetItemName(): TextField
	{
		return ItemTextField;
	}

	function SetupItemName(aPrevName: String): Void
	{
		if (ItemName != undefined) {
			ItemName.textField.textAutoSize = "shrink";
			ItemName.textField.SetText(aPrevName, true);
			ItemName.textField.selectable = false;
		}
	}

	function onLoad(): Void
	{

		HSlider.addEventListener("change", this, "onSliderChange");

		ButtonRect_mc.AcceptMouseButton.addEventListener("click", this, "onAcceptMouseClick");
		ButtonRect_mc.CancelMouseButton.addEventListener("click", this, "onCancelMouseClick");
		ButtonRect_mc.AcceptMouseButton.SetPlatform(0, false);
		ButtonRect_mc.CancelMouseButton.SetPlatform(0, false);
		
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		ButtonRect_mc.AcceptGamepadButton._visible = aiPlatform != 0;
		ButtonRect_mc.CancelGamepadButton._visible = aiPlatform != 0;
		ButtonRect_mc.AcceptMouseButton._visible = aiPlatform == 0;
		ButtonRect_mc.CancelMouseButton._visible = aiPlatform == 0;

		if (aiPlatform != 0) {
			ButtonRect_mc.AcceptGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
			ButtonRect_mc.CancelGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
		}
		ItemList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function onAcceptMouseClick(): Void
	{
		if (ButtonRect_mc._alpha == 100 && ButtonRect_mc.AcceptMouseButton._visible == true && InputHandler != undefined) {
			var inputEnterObj: Object = {value: "keyDown", navEquivalent: NavigationCode.ENTER};
			InputHandler(inputEnterObj);
		}
	}

	function onCancelMouseClick(): Void
	{
		if (ButtonRect_mc._alpha == 100 && ButtonRect_mc.CancelMouseButton._visible == true && InputHandler != undefined) {
			var inputTabObj: Object = {value: "keyDown", navEquivalent: NavigationCode.TAB};
			InputHandler(inputTabObj);
		}
	}

	function FadeInCard(): Void
	{
		if (bFadedIn)
			return;
		_visible = true;
		_parent.gotoAndPlay("fadeIn");
		bFadedIn = true;
	}

	function FadeOutCard(): Void
	{
		if (bFadedIn) {
			_parent.gotoAndPlay("fadeOut");
			bFadedIn = false;
		}
	}

	function hideAll(){
		
		ItemDesc._visible = false;
		ItemList._visible = false;
		ItemData._visible = false;
		ShoutData._visible = false;
		EffectsList._visible = false;
		TinyMeter._visible = false;
		HSlider._visible = false;
		ButtonRect._visible = false;
		CardList._visible = false;
		SkillText._visible = false;

		MagicData._visible = false;
		TimeLabel._visible = false;
	}

	function showSlider(){
		hideAll();
		HSlider._visible = true;
	
	}

	function positionElements(){

		var maxWidth = BGCard._width;
		var centerPos = maxWidth / 2.0;

		

		StolenIcon._x = centerPos;
		StolenIcon._y = 0;

		var header_space = ItemName._height * 2.2;
		

		ItemName._y = (header_space / 2) - (ItemName._height / 2);
		ItemName._x = centerPos - (ItemName._width / 2);

		SkillText._y = ItemName._y + ItemName._height - (SkillText._height / 2);
		SkillText._x = centerPos - (SkillText._width / 2);

		TinyMeter._y = (StolenIcon._height / 2) + (TinyMeter._height / 2);
		TinyMeter._x = centerPos - (TinyMeter._width / 2);

		ItemTextField.verticalAlign = "center";
		ItemDesc.verticalAlign = "center";
		PointLabel.autoSize = "center";
		WeightLabel.autoSize = "center";
		PriceLabel.autoSize = "center";

		PointValue._width = PointLabel._width;
		WeightValue._width = WeightLabel._width;
		PriceValue._width = PriceLabel._width;

		ItemDesc.textAutoSize = "shrink";
		PointValue.textAutoSize = "shrink";
		PriceValue.textAutoSize = "shrink";
		WeightValue.textAutoSize = "shrink";

		CostLabel.autoSize = "center";
		CostValue.autoSize = "center";
		TimeLabel.autoSize = "center";

		var body_pos = header_space - 10;
		HeaderBG._height = header_space - 20;
		var x_spacing = 32;

		if (MagicData._visible){

			CostLabel._x = 0;
			CostLabel._y = 0;
			CostValue._x = CostLabel._x + CostLabel._width;
			CostValue._y = (CostLabel._height / 2) - (CostValue._height / 2);

			var time_pos = 0;

			if (TimeLabel._visible){
				time_pos = CostValue._x + CostValue._width;
			}

			TimeLabel._x = time_pos;
			TimeLabel._y = 0;

			MagicData._y = body_pos;
			MagicData._x = centerPos - (MagicData._width / 2);

			ShoutData._x = centerPos - (ShoutData._width / 2);
			ShoutData._y = MagicData._y + MagicData._height;

			var descPos = ShoutData._visible ? ShoutData._y + ShoutData._height : ShoutData._y;

			ItemDesc._y = descPos;

		} else if (ItemData._visible){

			PointLabel._x = 0;
			PointLabel._y = 0;
			
			PointValue._x = PointLabel._x + (PointLabel._width / 2) - (PointValue._width / 2);
			PointValue._y = PointLabel._y + PointLabel._height;
			
			var weightPos = 0;

			if (PointLabel._visible){
				weightPos = PointLabel._x + PointLabel._width + x_spacing;
			}

			WeightLabel._x = weightPos;
			WeightLabel._y = 0;
			
			WeightValue._x = WeightLabel._x + (WeightLabel._width / 2) - (WeightValue._width / 2);
			WeightValue._y = PointValue._y;

			var pricePos = 0;

			if (WeightLabel._visible){
				pricePos = WeightLabel._x + WeightLabel._width + x_spacing;
			}

			PriceLabel._x = pricePos;
			PriceLabel._y = 0;
			
			PriceValue._x = PriceLabel._x + (PriceLabel._width / 2) - (PriceValue._width / 2);
			PriceValue._y = PointValue._y;

			ItemData._x = centerPos - (ItemData._width / 2);
			ItemData._y = body_pos;

			ItemDesc._y = ItemData._y + ItemData._height;

		} else {

			ItemDesc._y = body_pos;
		}

		ItemDesc._x = centerPos - (ItemDesc._width / 2);

		EffectsList._x = centerPos;
		EffectsList._y = ItemDesc._y + (EffectsList._height / 2) + 6;

		var cardHeight = 0;

		if (ItemData._visible){
			cardHeight = ItemData._y + ItemData._height + 8;
		} else {
			cardHeight = header_space;
		}

		if (ItemDesc._visible){
			cardHeight = ItemDesc._y + ItemDesc._height;
		}

		if (EffectsList._visible){
			cardHeight = EffectsList._y + (EffectsList._height / 2);
		}
		

		BGCard._height = cardHeight + 28;

	}


	function showItemDataSection(iSection: Number): Void 
	{

		ItemData._visible = true;

		PointLabel._visible = false;
		PointValue._visible = false;
		WeightLabel._visible = false;
		WeightValue._visible = false;
		PriceLabel._visible = false;
		PriceValue._visible = false;

		switch (iSection){
			case 0:
				ItemData._visible = false;
				break;
			case 1:
				PointLabel._visible = true;
				PointValue._visible = true;
				break;
			case 2:
				WeightLabel._visible = true;
				WeightValue._visible = true;
				break;
			case 3:
				PriceLabel._visible = true;
				PriceValue._visible = true;
				break;
			case 4:
				WeightLabel._visible = true;
				WeightValue._visible = true;
				PriceLabel._visible = true;
				PriceValue._visible = true;
				break;
			default:
				PointLabel._visible = true;
				PointValue._visible = true;
				WeightLabel._visible = true;
				WeightValue._visible = true;
				PriceLabel._visible = true;
				PriceValue._visible = true;
				break;
		}
	}

	function get quantitySlider(): MovieClip
	{
		return HSlider;
	}

	function get weaponChargeMeter(): DeltaMeter
	{
		return TMeter;
	}

	function get itemInfo(): Object
	{
		return LastUpdateObj;
	}

	function set itemInfo(aUpdateObj: Object): Void
	{

		SetupItemName("");

		var _iItemType: Number = aUpdateObj.type;

		hideAll();

		var bIsMagic = false;

		showItemDataSection();
		
		switch (_iItemType) {

			case Inventory.ICT_ARMOR:

				if (aUpdateObj.effects.length != 0)
					ItemDesc._visible = true;

				PointLabel.SetText("$ARMOR")
				
				PointValue.SetText(aUpdateObj.armor);
				
				ItemDesc.htmlText = aUpdateObj.effects;
				SkillText.text = aUpdateObj.skillText;
				SkillText._visible = true;

				break;
				
			case Inventory.ICT_WEAPON:

				PointLabel.SetText("$DAMAGE")

				if (aUpdateObj.effects.length != 0) {
				
					TMeter.SetPercent(aUpdateObj.usedCharge);
					TMeter.SetDeltaPercent(aUpdateObj.charge);
					TinyMeter._visible = true;
					ItemDesc._visible = true;
				}
				// TODO
				//var strIsPoisoned: String = aUpdateObj.poisoned == true ? "On" : "Off";
				
				PointValue.SetText(aUpdateObj.damage);
				
				ItemDesc.htmlText = aUpdateObj.effects;
				break;
				
			case Inventory.ICT_BOOK: 

				showItemDataSection(4);

				if (aUpdateObj.description != undefined && aUpdateObj.description != "") {
					ItemDesc._visible = true;
					ItemDesc.SetText(aUpdateObj.description);
				}
				break;
				
			case Inventory.ICT_POTION: 
				ItemDesc._visible = true;
				
				ItemDesc.htmlText = aUpdateObj.effects;
				showItemDataSection(4);
				SkillText._visible = true;
				SkillText.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
				break;
				
			case Inventory.ICT_FOOD:

				showItemDataSection(4);
				ItemDesc._visible = true;
				
				ItemDesc.htmlText = aUpdateObj.effects;
				SkillText._visible = true;
				SkillText.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
				break;
				
			case Inventory.ICT_SPELL_DEFAULT:

				ItemDesc._visible = true;
				ItemDesc.SetText(aUpdateObj.effects, true);
				
				showItemDataSection(0);
				
				CostLabel.SetText("$COST");
				MagicData._visible = true;

				CostValue.SetText(aUpdateObj.spellCost.toString());

				break;
				
			case Inventory.ICT_SPELL:

				showItemDataSection(0);

				bIsMagic = true;
			
				ItemDesc._visible = true;

				SkillText._visible = true;
				SkillText.text = aUpdateObj.castLevel.toString();
				
				ItemDesc.SetText(aUpdateObj.effects, true);

				CostLabel.SetText("$COST");
				MagicData._visible = true;
				CostValue.SetText(aUpdateObj.spellCost.toString());
				
				
				break;
				
			case Inventory.ICT_INGREDIENT:

				showItemDataSection(4);

				EffectsList._visible = true;

				for (var i: Number = 0; i < 4; i++) {
					EffectsList["EffectLabel" + i].textAutoSize = "shrink";
					if (aUpdateObj["itemEffect" + i] != undefined && aUpdateObj["itemEffect" + i] != "") {
						EffectsList["EffectLabel" + i].textColor = 0xFFFFFF;
						EffectsList["EffectLabel" + i].SetText(aUpdateObj["itemEffect" + i]);
					} else if (i < aUpdateObj.numItemEffects) {
						EffectsList["EffectLabel" + i].textColor = 0x999999;
						EffectsList["EffectLabel" + i].SetText("$UNKNOWN");
					} else {
						EffectsList["EffectLabel" + i].SetText("");
					}
				}
				break;
				
			case Inventory.ICT_MISC:
				showItemDataSection(4);
				break;
				
			case Inventory.ICT_SHOUT:

				bIsMagic = true;

				showItemDataSection(0);

				ShoutData._visible = true;

				var iLastWord: Number = 0;
				for (var i: Number = 0; i < 3; i++) {
					if (aUpdateObj["unlocked" + i] == true){
						ShoutData["ShoutTextInstance" + i]._visible = true;
					} else {
						ShoutData["ShoutTextInstance" + i]._visible = false;
					}
					if (aUpdateObj["word" + i] != undefined && aUpdateObj["word" + i] != "" && aUpdateObj["unlocked" + i] == true)
						iLastWord = i;
				}
				for (var i: Number = 0; i < 3; i++) {

					var strDragonWord: String = aUpdateObj["dragonWord" + i] == undefined ? "" : aUpdateObj["dragonWord" + i];
					var strWord: String = aUpdateObj["word" + i] == undefined ? "" : aUpdateObj["word" + i];
					var bWordKnown: Boolean = aUpdateObj["unlocked" + i] == true;
					var mc = ShoutData["ShoutTextInstance" + i];
					mc._x = 0;
					mc._y = mc._height;

					if (i > 0){
						var prev_mc = ShoutData["ShoutTextInstance" + (i - 1)];
						if (mc._visible){
							mc._x = prev_mc._x + prev_mc._width;
						}
						
					}

					mc.DragonShoutLabelInstance.ShoutWordsLabel.textAutoSize = "shrink";
					mc.ShoutLabelInstance.ShoutWordsLabelTranslation.textAutoSize = "shrink";
					mc.DragonShoutLabelInstance.ShoutWordsLabel.SetText(strDragonWord.toUpperCase());
					mc.ShoutLabelInstance.ShoutWordsLabelTranslation.SetText(strWord);

					if (bWordKnown && i == iLastWord && LastUpdateObj.soulSpent == true) {
						mc.gotoAndPlay("Learn");
						
					} else if (bWordKnown) {
						mc.gotoAndStop("Known");
						mc.gotoAndStop("Known");
						
					} else {
						mc.gotoAndStop("Unlocked");
						mc.gotoAndStop("Unlocked");
						
					}

				}

				ItemDesc._visible = true;
				ItemDesc.htmlText = aUpdateObj.effects;

				CostLabel.SetText("$RECHARGE");

				if (aUpdateObj.spellCost != undefined){
					MagicData._visible = true;
					CostValue.SetText(aUpdateObj.spellCost.toString());
				}
				
				break;
				
			case Inventory.ICT_ACTIVE_EFFECT:

				bIsMagic = true;

				ItemDesc._visible = true;
				ItemDesc.SetText(aUpdateObj.effects, true);
				
				if (aUpdateObj.timeRemaining > 0) {

					MagicData._visible = true;
					TimeLabel._visible = true;

					showItemDataSection(0);

					var iEffectTimeRemaining: Number = Math.floor(aUpdateObj.timeRemaining);
	
					if (iEffectTimeRemaining >= 3600) {
						iEffectTimeRemaining = Math.floor(iEffectTimeRemaining / 3600);
						
						if (iEffectTimeRemaining == 1)
							TimeLabel.SetText("$hour");
						else
							TimeLabel.SetText("$hours");

					} else if (iEffectTimeRemaining >= 60) {

						iEffectTimeRemaining = Math.floor(iEffectTimeRemaining / 60);
						if (iEffectTimeRemaining == 1)
							TimeLabel.SetText("$min");
						else
							TimeLabel.SetText("$mins");
					} else {
						
						if (iEffectTimeRemaining == 1)
							TimeLabel.SetText("$sec");
						else
							TimeLabel.SetText("$secs");
					}

					CostValue.SetText(iEffectTimeRemaining.toString());

				}

				break;
				
			case Inventory.ICT_SOUL_GEMS:

				showItemDataSection(4);
				SkillText.text = aUpdateObj.soulLVL;

				break;
				
			case Inventory.ICT_LIST:

				ItemData._visible = false;
				
				if (aUpdateObj.listItems != undefined) {
					CardList._visible = true;
					ItemList.entryList = aUpdateObj.listItems;
					ItemList.InvalidateData();
					TinyMeter._visible = true;
					TMeter.SetPercent(aUpdateObj.currentCharge);
					TMeter.SetDeltaPercent(aUpdateObj.currentCharge + ItemList.selectedEntry.chargeAdded);
					OpenListMenu();
				}
				break;
				
			case Inventory.ICT_CRAFT_ENCHANTING:
				ItemData._visible = false;

			case Inventory.ICT_HOUSE_PART:

				TinyMeter._visible = true;
				ItemDesc._visible = true;
				SkillText._visible = true;
				SkillText.SetText("");

				if (aUpdateObj.type == Inventory.ICT_HOUSE_PART) {

					
					if (aUpdateObj.effects == undefined)
						ItemDesc.SetText("", true);
					else
						ItemDesc.SetText(aUpdateObj.effects, true);

				} else if (aUpdateObj.sliderShown == true) {

					if (aUpdateObj.totalCharges != undefined && aUpdateObj.totalCharges != 0)
						SkillText.text = aUpdateObj.totalCharges;

				} else if (aUpdateObj.damage == undefined) {

					if (aUpdateObj.armor == undefined) {

						if (aUpdateObj.soulLVL != undefined) {

							SkillText.SetText(aUpdateObj.soulLVL);
							showItemDataSection(4);
						}

					} else {
						
						ItemData._visible = true;
						PointValue.SetText(aUpdateObj.armor);
						SkillText.text = aUpdateObj.skillText;

					}
				} else {
					ItemData._visible = true;
					PointValue.SetText(aUpdateObj.damage);
				}
				
				if (aUpdateObj.usedCharge == 0 && aUpdateObj.totalCharges == 0){
					TinyMeter._visible = false;
				}
					
				else if (aUpdateObj.usedCharge != undefined) {

					TMeter.SetPercent(aUpdateObj.usedCharge);
				}

				if (aUpdateObj.effects != undefined && aUpdateObj.effects.length > 0) {
					
					ItemDesc.SetText(aUpdateObj.effects, true);
					
					
				} else {
					
					ItemDesc.SetText("", true);

				}
				break;
			
			case Inventory.ICT_KEY:
				showItemDataSection(4);
				break;
			case Inventory.ICT_NONE:
			default:
		}
		
		
		if (aUpdateObj.name != undefined) {
			var strItemName: String = aUpdateObj.count != undefined && aUpdateObj.count > 1 ? aUpdateObj.name + " (" + aUpdateObj.count + ")" : aUpdateObj.name;
			ItemTextField.SetText(_bEditNameMode || aUpdateObj.upperCaseName == false ? strItemName : strItemName.toUpperCase(), false);
			ItemTextField.textColor = aUpdateObj.negativeEffect == true ? 0xFF0000 : 0xFFFFFF;
		}

		if (bIsMagic == false){
			if (aUpdateObj.value != undefined && PriceValue != undefined)
				PriceLabel.text = "$VALUE";
				PriceValue.SetText(aUpdateObj.value.toString());
			if (aUpdateObj.weight != undefined && WeightValue != undefined)
				WeightValue.SetText(RoundDecimal(aUpdateObj.weight, 2).toString());
		}

		StolenIcon._visible = aUpdateObj.stolen;
		LastUpdateObj = aUpdateObj;

		positionElements();
	}

	function RoundDecimal(aNumber: Number, aPrecision: Number): Number
	{
		var significantFigures = Math.pow(10, aPrecision);
		return Math.round(significantFigures * aNumber) / significantFigures;
	}


	function ShowEnchantingSlider(aiMaxValue: Number, aiMinValue: Number, aiCurrentValue: Number): Void
	{

		showSlider();
		
		HSlider.maximum = aiMaxValue;
		HSlider.minimum = aiMinValue;
		HSlider.value = aiCurrentValue;
		PrevFocus = FocusHandler.instance.getFocus(0);
		FocusHandler.instance.setFocus(HSlider, 0);
		InputHandler = HandleQuantityMenuInput;
		dispatchEvent({type: "subMenuAction", opening: true, menu: "quantity"});
	}

	function ShowQuantityMenu(aiMaxAmount: Number): Void
	{
		showSlider();

		SkillText._visible = true;
		SkillText.SetText("$How many?", true);
		
		HSlider.maximum = aiMaxAmount;
		HSlider.value = aiMaxAmount;
		HSlider.Count._visible = true;
		HSlider.Count.textAutoSize = "shrink";
		HSlider.Count.SetText(Math.floor(HSlider.value).toString());

		PrevFocus = FocusHandler.instance.getFocus(0);
		FocusHandler.instance.setFocus(HSlider, 0);
		InputHandler = HandleQuantityMenuInput;
		dispatchEvent({type: "subMenuAction", opening: true, menu: "quantity"});
	}

	function HideQuantityMenu(abCanceled: Boolean): Void
	{
		FocusHandler.instance.setFocus(PrevFocus, 0);
		
		HSlider._visible = false;
		ButtonRect_mc._visible = false;
		InputHandler = undefined;
		dispatchEvent({type: "subMenuAction", opening: false, canceled: abCanceled, menu: "quantity"});
	}

	function OpenListMenu(): Void
	{
		hideAll()
		
		PrevFocus = FocusHandler.instance.getFocus(0);
		FocusHandler.instance.setFocus(ItemList, 0);
		ItemList._visible = true;
		TinyMeter._visible = true;

		ItemList.addEventListener("itemPress", this, "onListItemPress");
		ItemList.addEventListener("listMovedUp", this, "onListSelectionChange");
		ItemList.addEventListener("listMovedDown", this, "onListSelectionChange");
		ItemList.addEventListener("selectionChange", this, "onListMouseSelectionChange");
		
		InputHandler = HandleListMenuInput;
		dispatchEvent({type: "subMenuAction", opening: true, menu: "list"});
	}

	function HideListMenu(): Void
	{
		FocusHandler.instance.setFocus(PrevFocus, 0);

		CardList._visible = false;
		TinyMeter._visible = false;
		ItemList._visible = false;

		InputHandler = undefined;
		
		dispatchEvent({type: "subMenuAction", opening: false, menu: "list"});
	}

	function ShowConfirmMessage(astrMessage: String): Void
	{
		hideAll();
		ButtonRect_mc._visible = true;

		var messageArray: Array = astrMessage.split("\r\n");
		var strMessageText = messageArray.join("\n");
		SetupItemName(strMessageText);

		PrevFocus = FocusHandler.instance.getFocus(0);
		FocusHandler.instance.setFocus(this, 0);
		InputHandler = HandleConfirmMessageInput;
		dispatchEvent({type: "subMenuAction", opening: true, menu: "message"});
	}

	function HideConfirmMessage(): Void
	{
		FocusHandler.instance.setFocus(PrevFocus, 0);
		ButtonRect_mc._visible = false;
		InputHandler = undefined;
		dispatchEvent({type: "subMenuAction", opening: false, menu: "message"});
	}

	function StartEditName(aInitialText: String, aiMaxChars: Number): Void
	{
		if (Selection.getFocus() != ItemTextField) {
			PrevFocus = FocusHandler.instance.getFocus(0);
			if (aInitialText != undefined)
				ItemTextField.text = aInitialText;
			ItemTextField.type = "input";
			ItemTextField.noTranslate = true;
			ItemTextField.selectable = true;
			ItemTextField.maxChars = aiMaxChars == undefined ? null : aiMaxChars;
			Selection.setFocus(ItemTextField, 0);
			Selection.setSelection(0, 0);
			InputHandler = HandleEditNameInput;
			dispatchEvent({type: "subMenuAction", opening: true, menu: "editName"});
			_bEditNameMode = true;
		}
	}

	function EndEditName(): Void
	{
		ItemTextField.type = "dynamic";
		ItemTextField.noTranslate = false;
		ItemTextField.selectable = false;
		ItemTextField.maxChars = null;

		var bPreviousFocusEnabled: Boolean = PrevFocus.focusEnabled;

		PrevFocus.focusEnabled = true;
		Selection.setFocus(PrevFocus, 0);
		PrevFocus.focusEnabled = bPreviousFocusEnabled;
		InputHandler = undefined;

		dispatchEvent({type: "subMenuAction", opening: false, menu: "editName"});
		_bEditNameMode = false;

		

	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (pathToFocus.length > 0 && pathToFocus[0].handleInput != undefined) 
			pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		if (InputHandler != undefined)
			bHandledInput = InputHandler(details);
		return bHandledInput;
	}

	function HandleQuantityMenuInput(details: Object): Boolean
	{
	
		var bValidKeyPressed: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details))
			if (details.navEquivalent == NavigationCode.ENTER) {
				HideQuantityMenu(false);
				if (HSlider.value > 0)
					dispatchEvent({type: "quantitySelect", amount: Math.floor(HSlider.value)});
				else
					itemInfo = LastUpdateObj;
				bValidKeyPressed = true;
			} else if (details.navEquivalent == NavigationCode.TAB) {
				HideQuantityMenu(true);
				itemInfo = LastUpdateObj;
				bValidKeyPressed = true;
			}
		return bValidKeyPressed;

	}

	function HandleListMenuInput(details: Object): Boolean
	{
		var bValidKeyPressed: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details) && details.navEquivalent == NavigationCode.TAB) {
			HideListMenu();
			bValidKeyPressed = true;
		}
		return bValidKeyPressed;
	}

	function HandleConfirmMessageInput(details: Object): Boolean
	{
		var bValidKeyPressed: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.ENTER) {
				HideConfirmMessage();
				dispatchEvent({type: "messageConfirm"});
				bValidKeyPressed = true;
			} else if (details.navEquivalent == NavigationCode.TAB) {
				HideConfirmMessage();
				dispatchEvent({type: "messageCancel"});
				itemInfo = LastUpdateObj;
				bValidKeyPressed = true;
			}
		}
		return bValidKeyPressed;
	}

	function HandleEditNameInput(details: Object): Boolean
	{
		Selection.setFocus(ItemTextField, 0);
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.ENTER && details.code != 32)
				dispatchEvent({type: "endEditItemName", useNewName: true, newName: ItemTextField.text});
			else if (details.navEquivalent == NavigationCode.TAB)
				dispatchEvent({type: "endEditItemName", useNewName: false, newName: ""});
		}
		return true;
	}

	function onSliderChange(): Void
	{
		var currentValue_tf: TextField = HSlider.Count;
		var iCurrentValue: Number = Number(currentValue_tf.text);
		var iNewValue: Number = Math.floor(HSlider.value);

		HSlider.Count.SetText(iNewValue.toString());

		if (iCurrentValue != iNewValue) {
			
			GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
			dispatchEvent({type: "sliderChange", value: iNewValue});
		}
	}

	function onListItemPress(event: Object): Void
	{
		dispatchEvent(event);
		HideListMenu();
	}

	function onListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
			onListSelectionChange(event);
	}

	function onListSelectionChange(event: Object): Void
	{
		TMeter.SetDeltaPercent(ItemList.selectedEntry.chargeAdded + LastUpdateObj.currentCharge);
	}

}
