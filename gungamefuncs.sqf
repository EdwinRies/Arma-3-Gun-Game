ED_strings_replace = 
{
	_string = _this select 0;
	_replace = _this select 1;
	_replaceWith = _this select 2;
	_strar = toArray (_string);
	_replaceAr = toArray (_replace);
	_replaceWithAr = toArray (_replaceWith);
	_newStrAr = [];
	for[{_i = 0}, {_i < count(_strar)}, {_i = _i + 1}] do
	{
		if((_strar select _i) == (_replaceAr select 0)) then
		{
			_match = true;
			for[{_k = 0}, {((_k + _i) < count(_strar)) && (_k < count(_replaceAr))}, {_k = _k + 1}] do
			{
				if((_strar select (_k + _i)) != (_replaceAr select _k)) then 
				{
					_match = false;
				};
			};
			if(_match) then
			{
				for[{_j = 0}, {_j < count(_replaceWithAr)}, {_j = _j + 1}] do
				{
					_newStrAr = _newStrAr + [_replaceWithAr select _j];
				};
				_i = _i + count(_replaceAr) - 1;
			}
			else
			{
				_newStrAr = _newStrAr + [_strar select _i];
			};
		}
		else
		{
			_newStrAr = _newStrAr + [_strar select _i];
		};
	};
	toString (_newStrAr);
};

gunGameFunc = {
	(_this select 0) call spawnGuns;
	(_this select 1) spawn GG_Show_Kill;
	call killStreakIncrement;
};

spawnGuns = 
{
	if(!isNil "_this") then
	{
		GUNGAME_SCORE = _this;
	};
	if(isNil "GUNGAME_SCORE") then
	{
		GUNGAME_SCORE = 0;
	};	
	
	if (GUNGAME_SCORE >= GUNGAME_ROUNDS) exitWith	
	{
		hint "you won!";
		removeAllWeapons player;
		winner = name player;
		publicVariable "winner";		
		GAME_progress = 4;
		execVM "cleanupRound.sqf"; 
		GAME_progress = 0;
	};

	removeAllWeapons player;
	if(GUNGAME_SCORE < count(GUNGAME_WEAPONARRAY)) then {
		_gun = GUNGAME_WEAPONARRAY select GUNGAME_SCORE;
		player addMagazine (_gun select 2);
		player addMagazine (_gun select 2);
		player addMagazine (_gun select 2);
		player addMagazine (_gun select 2);
		player addWeapon (_gun select 0);
		
		
		
		_type = getNumber(configFile >> "cfgWeapons" >> _gun select 0 >> "type");
		_move = ([animationState player, "_"] call BIS_fnc_splitString) select 0;
		if(_type == 1) then
		{
			{
				player addPrimaryWeaponItem _x;
			}foreach (_gun select 1);
			_move = [_move, "pst", "rfl"] call ED_strings_replace;
		} 
		else
		{
			if(_type == 2) then
			{
				{
					player addHandGunItem _x;
				}foreach (_gun select 1);
				_move = [_move, "rfl", "pst"] call ED_strings_replace;
			};
		};
		player switchMove _move;
		
		if(GUNGAME_SCORE < (count(GUNGAME_WEAPONARRAY) - 1)) then {
			[] spawn GG_Show_Next_Weapon;
		};
	};
};

killFunc = {			
	_killer = _this;
	[_killer] spawn
	{
		_posPlayer = getPosATL player;		
		_posPlayer set [2, (_posPlayer select 2) + 1.6];
		KILLCAM = "camera" camCreate _posPlayer;
		showCinemaBorder false;
		KILLCAM cameraEffect ["Internal", "Back"];
		KILLCAM camSetTarget player;
		KILLCAM camSetPos _posPlayer;
		KILLCAM camSetFOV .90;
		KILLCAM camSetFocus [50, 0];
		KILLCAM camCommit 0;
		KILLCAM camSetTarget (_this select 0);
		KILLCAM camCommit 0;
		_playerPos = getPos player;
		_direction = ((_playerPos select 0) - ((getPos (_this select 0)) select 0)) atan2 ((_playerPos select 1) - ((getPos (_this select 0)) select 1));
		KILLCAM camSetRelPos [5 * sin(_direction),5 * cos(_direction),1.6];
		KILLCAM camCommit 3;
		waitUntil{INACTION};
		KILLCAM cameraEffect ["TERMINATE","BACK"];
		camDestroy KILLCAM;
	};
};

GG_Show_Kill = {
if(GUNGAME_SCORE >= count(GUNGAME_WEAPONARRAY)) exitWith {};
if (hasInterface) then {
        disableSerialization;       
		_display = call BIS_fnc_displayMission;
        _ctrl = _display ctrlCreate ["RscStructuredText", -1];
        _ctrl ctrlShow true;
        _ctrl ctrlSetPosition [
            safeZoneX, 
            safeZoneY + (safeZoneH * 0.75), 
            safeZoneW, 
            safeZoneH
        ];
		
		_index = 1;		
		_target = count(toArray _this);
		
		_gun = GUNGAME_WEAPONARRAY select (GUNGAME_SCORE - 1);
		_gunpicture = getText(configFile >> "cfgWeapons" >> _gun select 0 >> "picture");
		
		while {_index <= _target} do
		{
			_ctrl ctrlSetStructuredText parseText ("<t align='center' shadow='2' size='1.3'><img size='2' image='"+ _gunpicture +"'/> <t color='#ff771100'>" + (_this select [0, _index]) +"</t></t>");
			_ctrl ctrlCommit 0;
			waituntil {ctrlCommitted _ctrl};
			playSound ["ReadoutHideClick1", true];
			sleep 0.05;
			_index = _index + 1;
		};
		_ctrl ctrlSetStructuredText parseText ("<t align='center' shadow='2' size='1.3'><img size='2' image='"+ _gunpicture +"'/> <t color='#ff771100'>" + _this + "</t></t>");
		_ctrl ctrlCommit 0;
		sleep 1;
		
		_i = time;
		while{time - _i <= 2} do
		{	
			 _ctrl ctrlSetPosition [
				safeZoneX, 
				safeZoneY + (safeZoneH * (0.75 + (0.2 * ((time -_i) / 3)))), 
				safeZoneW, 
				safeZoneH
			];
			_ctrl ctrlSetFade ((time -_i) / 2);
			_ctrl ctrlCommit 0;
			waituntil {ctrlCommitted _ctrl};
			sleep 0.02;
		};		
		
   		ctrlDelete _ctrl;
};
};

GG_Show_Next_Weapon = {
if(GUNGAME_SCORE >= count(GUNGAME_WEAPONARRAY)) exitWith {};
if (hasInterface) then {
        disableSerialization;       
		_display = call BIS_fnc_displayMission;
        _ctrl = _display ctrlCreate ["RscStructuredText", -1];
        _ctrl ctrlShow true;
        _ctrl ctrlSetPosition [
            safeZoneX + (safeZoneW * 0.2), 
            safeZoneY + (safeZoneH * 0.85), 
            safeZoneW, 
            safeZoneH * 0.2
        ];
		
		_index = 1;		
		_gun = GUNGAME_WEAPONARRAY select (GUNGAME_SCORE + 1);
		_gunpicture = getText(configFile >> "cfgWeapons" >> _gun select 0 >> "picture");
		_ctrl ctrlSetStructuredText parseText ("<t align='right' shadow='2'>Next Gun<img size='5' image='"+ _gunpicture +"'/></t>");
		_ctrl ctrlSetFade 1;
		_ctrl ctrlCommit 0;
		
		_i = time;
		while{time - _i <= 1} do
		{	
			 _ctrl ctrlSetPosition [
				safeZoneX + (safeZoneW * (0.1 - (0.2 * ((time -_i) / 1)))), 
				safeZoneY + (safeZoneH * 0.85),
				safeZoneW, 
				safeZoneH * 0.2
			];
			_ctrl ctrlSetFade (1 - ((time -_i) / 2));
			_ctrl ctrlCommit 0;
			waituntil {ctrlCommitted _ctrl};
			sleep 0.02;
		};
		
		_ctrl ctrlSetFade 0;
		_ctrl ctrlCommit 0;
		
		sleep 3;
		
		_i = time;
		while{time - _i <= 1} do
		{	
			 _ctrl ctrlSetPosition [
				safeZoneX + (safeZoneW * ((0.2 * ((time -_i) / 1)) - 0.1)), 
				safeZoneY + (safeZoneH * 0.85), 
				safeZoneW, 
				safeZoneH * 0.2
			];
			_ctrl ctrlSetFade ((time -_i) / 1);
			_ctrl ctrlCommit 0;
			waituntil {ctrlCommitted _ctrl};
			sleep 0.02;
		};
		
		
		ctrlDelete _ctrl;
};
};