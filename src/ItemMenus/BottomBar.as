import gfx.io.GameDelegate;
import Components.Meter;

import skyui.components.ButtonPanel;
import skyui.defines.Inventory;


class BottomBar extends MovieClip
{
	#include "../version.as"

	/* PRIVATE VARIABLES */

	private var _lastItemType:Number;

	private var _healthMeter:Meter;
	private var _magickaMeter:Meter;
	private var _staminaMeter:Meter;
	private var _levelMeter:Meter;

	private var _playerInfoObj:Object;


	/* STAGE ELEMENTS */

	public var playerInfoCard:MovieClip;
	public var InfoClipArrayLeft:Array;
	public var InfoClipArrayMiddle:Array;
	public var InfoClipArrayRight:Array;
	
	public var armorValue = 0;


	/* PROPERTIES */

	public var buttonPanel:ButtonPanel;


	/* INITIALIZATION */

	public function BottomBar()
	{
		super();
		_lastItemType = Inventory.ICT_NONE;
		_healthMeter = new Meter(playerInfoCard.HealthRect.MeterInstance.Meter_mc);
		_magickaMeter = new Meter(playerInfoCard.MagickaRect.MeterInstance.Meter_mc);
		_staminaMeter = new Meter(playerInfoCard.StaminaRect.MeterInstance.Meter_mc);
		_levelMeter = new Meter(playerInfoCard.LevelMeterInstance.Meter_mc);
		
		//playerInfoCard.MenuName.autoSize = "center";
		
		 


		InfoClipArrayLeft = [playerInfoCard.PlayerGoldLabel, playerInfoCard.PlayerGoldValue, playerInfoCard.VendorGoldLabel, playerInfoCard.VendorGoldValue];

		InfoClipArrayRight = [playerInfoCard.StaminaRect, playerInfoCard.MagickaRect, playerInfoCard.HealthRect];

		InfoClipArrayMiddle = [playerInfoCard.DragonSoulsValue, playerInfoCard.dragonSoulsIcon, playerInfoCard.DamageValue, playerInfoCard.damageIcon, playerInfoCard.ArmorValue, playerInfoCard.armorIcon, playerInfoCard.CarryWeightValue, playerInfoCard.weightIcon];


	}


	/* PUBLIC FUNCTIONS */

	public function positionElements(a_leftOffset:Number, a_rightOffset:Number):Void
	{
		buttonPanel._x = a_leftOffset;
		buttonPanel._y = Stage.visibleRect.height - 50;
		buttonPanel.updateButtons(true);
		
		_x = 0;
		_y = 0;
		playerInfoCard._x = 0;
		playerInfoCard._y = 0;
		playerInfoCard.background._width = Stage.visibleRect.width;
		
		//playerInfoCard.MenuName._x = (playerInfoCard.background._width / 2) - (playerInfoCard.MenuName._width / 2);
		//playerInfoCard.MenuName._y = (playerInfoCard.background._height / 2) - (playerInfoCard.MenuName._height / 2);
	}
	
	public function getTopBarHeight(){
		return playerInfoCard.background._height + playerInfoCard.infoBar._height;
	}

	public function positionInfoRow()
	{

		var bar = playerInfoCard.background;
		var yPos = bar._height / 2 + bar._y;
		
		var MeterWidth = playerInfoCard.LevelMeterInstance._width;
		
		playerInfoCard.LevelMeterInstance._y = bar._y + bar._height + 35;
		playerInfoCard.LevelMeterInstance._x = Stage.visibleRect.width - 35 - MeterWidth;
		
		var yPosMeter = playerInfoCard.LevelMeterInstance._y + playerInfoCard.LevelMeterInstance._height / 2;
		var xPosMeter = playerInfoCard.LevelMeterInstance._x + playerInfoCard.LevelMeterInstance._width / 2;
		
		playerInfoCard.SkillLevelCurrent._y = yPosMeter - playerInfoCard.SkillLevelCurrent._height / 2;
		playerInfoCard.SkillLevelCurrent._x = xPosMeter - playerInfoCard.SkillLevelCurrent._width / 2;
		
		playerInfoCard.SkillLevelLabel._y = yPosMeter - playerInfoCard.SkillLevelLabel._height / 2;
		playerInfoCard.SkillLevelLabel._x = playerInfoCard.LevelMeterInstance._x - playerInfoCard.SkillLevelLabel._width;

		playerInfoCard.PlayerGoldLabel._x = 5;

		for (var i = 0; i <= InfoClipArrayLeft.length; i++)
		{
			var e = InfoClipArrayLeft[i];
			
			if (e._visible == true){
				if (e instanceof TextField)
				{
					
					e.textAutoSize = "shrink";
				}
	
				e._y = yPos - (e._height / 2);
	
				if (i >= 1)
				{
					var prev = InfoClipArrayLeft[i - 1];
					e._x = prev._x + prev._width;
	
				}
			}
			

		}

		playerInfoCard.VendorGoldLabel._x += 5;
		playerInfoCard.VendorGoldValue._x += 5;

		playerInfoCard.StaminaRect._x = Stage.visibleRect.width - playerInfoCard.StaminaRect._width - 25;

		for (var i = 0; i <= InfoClipArrayRight.length; i++)
		{
			var e = InfoClipArrayRight[i];

			e._y = yPos - (e._height / 2);

			if (i >= 1)
			{
				var prev = InfoClipArrayRight[i - 1];
				e._x = prev._x - e._width - 10;

			}

		}

		playerInfoCard.DragonSoulsValue._x = bar._width;

		for (var i = 0; i <= InfoClipArrayMiddle.length; i++)
		{
			var e = InfoClipArrayMiddle[i];
			
			e._y = yPos - (e._height / 2);
			
			if (e instanceof TextField)
			{
				
				e.textAutoSize = "shrink";
			}

			if (i >= 1)
			{
				var prev = InfoClipArrayMiddle[i - 1];
				e._x = prev._x - e._width - 10;

			}

		}
		
		
		var lastInRow = InfoClipArrayMiddle[InfoClipArrayMiddle.length - 1];
		
		var midPoint = Math.abs( bar._width - lastInRow._x ) / 2;
		var offset = bar._width / 2;
		
		
		for (var i = 0; i <= InfoClipArrayMiddle.length; i++)
		{
			var e = InfoClipArrayMiddle[i];
			

			e._x -= offset;
			e._x += midPoint;
			

		}

	}
	
	public function setMenuName(t: String){
		
		//playerInfoCard.MenuName.SetText(t);
		
	}

	public function showPlayerInfo():Void
	{
		playerInfoCard._alpha = 100;
	}

	public function hidePlayerInfo():Void
	{
		playerInfoCard._alpha = 0;
	}

	// @API
	public function UpdatePlayerInfo(a_playerUpdateObj:Object, a_itemUpdateObj:Object):Void
	{
		_playerInfoObj = a_playerUpdateObj;
		
		playerInfoCard.VendorGoldValue._visible = false;
		playerInfoCard.VendorGoldLabel._visible = false;
		
		updatePerItemInfo(a_itemUpdateObj);
		
		positionInfoRow();
		
	}

	public function updatePerItemInfo(a_itemUpdateObj:Object):Void
	{
		
		var infoCard = playerInfoCard;
		var itemType:Number = a_itemUpdateObj.type;
		var bHasWeightandValue = true;
		
		var armorValueChange = Math.round(a_itemUpdateObj.armorChange);
		var newArmorValue = Math.floor(_playerInfoObj.armor);
		if (armorValue != newArmorValue){
			armorValue = newArmorValue;
			infoCard.armorIcon.gotoAndPlay("change");
		}
		
		var armorValueString = newArmorValue.toString();
		
		infoCard.ArmorValue.SetText(armorValueString);
		
		var damageValueChange = Math.round(a_itemUpdateObj.damageChange);
		var damageValueString = Math.floor(_playerInfoObj.damage).toString();
		infoCard.DamageValue.SetText(damageValueString);
		
		var weightValueString = Math.ceil(_playerInfoObj.encumbrance) + "/" + Math.floor(_playerInfoObj.maxEncumbrance);
		infoCard.CarryWeightValue.SetText(weightValueString);
		var goldValueString = _playerInfoObj.gold.toString();
		infoCard.PlayerGoldValue.SetText(goldValueString);
		
		var soulString = _playerInfoObj.dragonSoulText;
		var soulValueString = "";
		
		// parse dragon souls text. extract numbers
		for (var i = 0; i < soulString.length; i++) {
			var char = soulString.charAt(i);
			for (var n = 0; n < 9; n++) {
				if (char == n.toString()) {
					soulValueString += char;
				}
			}
		}
		
		infoCard.DragonSoulsValue.SetText(soulValueString);


		if (itemType == undefined)
		{
			itemType = _lastItemType;
			if (a_itemUpdateObj == undefined)
			{
				a_itemUpdateObj = {type:_lastItemType};
			}
		}
		else
		{
			_lastItemType = itemType;
		}
		
		showSkillData(false);
		

		if (itemType == Inventory.ICT_SPELL){
			showSkillData(true);
			updateSkillBar(a_itemUpdateObj.magicSchoolName,a_itemUpdateObj.magicSchoolLevel,a_itemUpdateObj.magicSchoolPct);

		}


		updateStatMeter(infoCard.HealthRect,_healthMeter,_playerInfoObj.health,_playerInfoObj.maxHealth,_playerInfoObj.healthColor);
		updateStatMeter(infoCard.MagickaRect,_magickaMeter,_playerInfoObj.magicka,_playerInfoObj.maxMagicka,_playerInfoObj.magickaColor);
		updateStatMeter(infoCard.StaminaRect,_staminaMeter,_playerInfoObj.stamina,_playerInfoObj.maxStamina,_playerInfoObj.staminaColor);
		
		
	}
	
	public function showSkillData(enable: Boolean){
		playerInfoCard.SkillLevelCurrent._visible = enable;
		playerInfoCard.SkillLevelLabel._visible = enable;
		playerInfoCard.LevelMeterInstance._visible = enable;
	}

	// @API
	public function UpdateCraftingInfo(a_skillName:String, a_levelStart:Number, a_levelPercent:Number):Void
	{
		showSkillData(true);
		updateSkillBar(a_skillName,a_levelStart,a_levelPercent);
	}

	public function updateBarterInfo(a_playerUpdateObj:Object, a_itemUpdateObj:Object, a_playerGold:Number, a_vendorGold:Number, a_vendorName:String):Void
	{
		
		_playerInfoObj = a_playerUpdateObj;
		updatePerItemInfo(a_itemUpdateObj);
		
		var infoCard = playerInfoCard;

		
		if (a_vendorName != undefined)
		{
			infoCard.VendorGoldLabel._visible = true;
			infoCard.VendorGoldLabel.SetText("$Gold");
			infoCard.VendorGoldLabel.SetText(a_vendorName + " " + infoCard.VendorGoldLabel.text);
		}
		infoCard.VendorGoldValue.SetText(a_vendorGold.toString());
		infoCard.VendorGoldValue._visible = true;
		
		positionInfoRow();
		
	}


	public function setGiftInfo(a_favorPoints:Number):Void
	{
		
	}

	public function setPlatform(a_platform:Number, a_bPS3Switch:Boolean):Void
	{
		buttonPanel.setPlatform(a_platform,a_bPS3Switch);
	}


	/* PRIVATE FUNCTIONS */

	private function updateStatMeter(a_meterRect:MovieClip, a_meterObj:Meter, a_currValue:Number, a_maxValue:Number, a_colorStr:String):Void
	{
		if (a_colorStr == undefined)
		{
			a_colorStr = "#FFFFFF";
		}
		if (a_meterRect._alpha > 0)
		{
			if (a_meterRect.MeterText != undefined)
			{
				a_meterRect.MeterText.textAutoSize = "shrink";
				a_meterRect.MeterText.html = true;
				a_meterRect.MeterText.SetText("<font color=\'" + a_colorStr + "\'>" + Math.floor(a_currValue) + "/" + Math.floor(a_maxValue) + "</font>",true);
			}
			a_meterRect.MeterInstance.gotoAndStop("Pause");
			a_meterObj.SetPercent(a_currValue / a_maxValue * 100);
		}
	}

	private function updateSkillBar(a_skillName:String, a_levelStart:Number, a_levelPercent:Number):Void
	{
		var infoCard = playerInfoCard;

		infoCard.SkillLevelLabel.SetText(a_skillName);
		infoCard.SkillLevelCurrent.SetText(a_levelStart);
		infoCard.SkillLevelNext.SetText(a_levelStart + 1);
		infoCard.LevelMeterInstance.gotoAndStop("Pause");
		_levelMeter.SetPercent(a_levelPercent);
	}

}