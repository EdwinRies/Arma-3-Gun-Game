lbClear 101;

{
	lbAdd [101, (_x select 1)];	     
	lbSetToolTip [101, _foreachIndex, (_x select 1)];		
	lbSetData[101, _foreachIndex, _x select 0];
	lbSetPicture [101, _foreachIndex, _x select 4];
	lbSetPictureColor [101, _foreachIndex, [1,1,1,1]];
	_foreachIndex = _foreachIndex + 1;
} foreach voteGun_handGun + voteGun_primary;

populateAttachments = 
{
	_weaponClass = lbData [101, lbCurSel 101];
	lbClear 111;
	lbClear 112;
	lbClear 113;
	lbAdd [111, "None"];
	lbAdd [112, "None"];
	lbAdd [113, "None"];
	{
		lbAdd [111, ""];
		lbSetData [111, _foreachIndex +1, _x];
		lbSetPicture [111, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "picture")];
		lbSetPictureColor [111, _foreachIndex +1, [1,1,1,1]];
		lbSetToolTip [111, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "displayName")]; 
	}foreach getArray(configFile >> "CfgWeapons" >> _weaponClass >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");
	lbSetCurSel [111,0];
	
	{
		lbAdd [112, ""];
		lbSetData [112, _foreachIndex +1, _x];
		lbSetPicture [112, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "picture")];
		lbSetPictureColor [112, _foreachIndex +1, [1,1,1,1]];
		lbSetToolTip [112, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "displayName")]; 
	}foreach getArray(configFile >> "CfgWeapons" >> _weaponClass >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
	lbSetCurSel [112,0];
	
	{
		lbAdd [113, ""];
		lbSetData [113, _foreachIndex +1, _x];
		lbSetPicture [113, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "picture")];
		lbSetPictureColor [113, _foreachIndex +1, [1,1,1,1]];
		lbSetToolTip [113, _foreachIndex +1, getText(configFile >> "CfgWeapons" >> _x >> "displayName")]; 
	}foreach getArray(configFile >> "CfgWeapons" >> _weaponClass >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
	lbSetCurSel [113,0];
	
};

((findDisplay 100) displayCtrl 101) ctrlSetEventHandler ["LBSelChanged","call populateAttachments;"];

lbSetCurSel [101,0];