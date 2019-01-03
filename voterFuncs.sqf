GG_CountDown = 
{
	ctrlSetText [60, _this];
};

GG_SrvrCD = 
{
	VoteCountDown = _this select 0;
	while {VoteCountDown > 0} do
	{
		sleep 1;
		[str VoteCountDown, "GG_CountDown"] spawn BIS_fnc_MP;
		VoteCountDown = VoteCountDown - 1;		
	};
	sleep 1;
};

GG_RoundsVoteProgressUpdateGUNGAMEVOTES_ROUNDS =
{
	if(isNil "GG_voteProgUpdate") then
	{
	if(GAME_progress != 0) exitWith {};
	_tmpList = [];
	{
		_i = 0;
		_found = false;
		while{_i < count(_tmpList) && !_found} do
		{
			if(_x select 1 == _tmpList select _i select 0) then
			{
				_tmpList set [_i, [_x select 1, (_tmpList select _i select 1) + 1]];
			};
			_i = _i + 1;
		};
		if(!_found) then
		{
			_tmpList pushBack [_x select 1, 1];
		};
	}foreach _this;
	
	_i = 0;
	lbClear 101;
	
	for[{_i = 0}, {_i < count(numRoundVoteOptions)}, {_i = _i + 1}] do
	{
		_votes = 0;
		{
			if(str(_x select 0) == str(numRoundVoteOptions select _i)) exitWith
			{
				_votes = _x select 1;
			};
		}foreach _tmpList;
		lbAdd [101, format["%1 %2", numRoundVoteOptions select _i, _votes]];
		lbSetData [101, _i, str(numRoundVoteOptions select _i)];
	};
	
	GG_voteProgUpdate = nil;
	};
};

GG_RoundsVoteProgressUpdateGUNGAMEVOTES_WEAPONS =
{
	if(isNil "GG_voteProgUpdate") then
	{
		if(GAME_progress != 2) exitWith {};
		_tmpList = [];
		{
			_i = 0;
			_found = false;
			while{_i < count(_tmpList) && !_found} do
			{
				if(str(_x select 1) == str((_tmpList select _i) select 0)) then
				{
					_tmpList set [_i, [_x select 1, ((_tmpList select _i) select 1) + 1]];
					_found = true;
				};
				_i = _i + 1;
			};
			if(!_found) then
			{
				_tmpList pushBack [_x select 1, 1];
			};
		}foreach _this;
		
		
		for[{_o = 0},{_o < count(_tmpList)},{_o = _o + 1}] do
		{
			for[{_i = 0},{_i < count(_tmpList)},{_i = _i + 1}] do
			{
				if((_tmpList select _o select 1) > (_tmpList select _i select 1)) then
				{
					_a = _tmpList select _o;
					_b = _tmpList select _i;
					_tmpList set [_o, _b];
					_tmpList set [_i, _a];
				};
			};
		};
		
		lbClear 131;
		{
			lbAdd [131, "(" + str(_x select 1) + ") " + getText(configFile >> "cfgWeapons" >> (_x select 0) select 0 >> "displayName") + " " + 
			getText(configFile >> "cfgWeapons" >> ((_x select 0) select 1) select 0 >> "displayName") + " " + 
			getText(configFile >> "cfgWeapons" >> ((_x select 0) select 1) select 1 >> "displayName") + " " + 
			getText(configFile >> "cfgWeapons" >> ((_x select 0) select 1) select 2 >> "displayName")];
			lbSetPicture [131, _foreachIndex, getText(configFile >> "cfgWeapons" >> _x select 0 select 0 >> "picture")];
			lbSetPictureColor [131, _foreachIndex, [1,1,1,1]];
		}foreach _tmpList;
		
		GG_voteProgUpdate = nil;
	};
};

GG_RoundsVoteProgressUpdateGUNGAMEVOTES_ZONE =
{
	if(isNil "GG_voteProgUpdate") then
	{
		if(GAME_progress != 1) exitWith {};
		_tmpList = [];
		{
			_i = 0;
			_found = false;
			while{_i < count(_tmpList) && !_found} do
			{
				if(str(_x select 1) == str((_tmpList select _i) select 0)) then
				{
					_tmpList set [_i, [_x select 1, ((_tmpList select _i) select 1) + 1]];
					_found = true;
				};
				_i = _i + 1;
			};
			if(!_found) then
			{
				_tmpList pushBack [_x select 1, 1];
			};
		}foreach _this;
		lbClear 101;
		{
			_votes = 0;
			_i = 0;
			while{_i < count(_tmpList)} do
			{
				if((_tmpList select _i select 0) == str(_x select 2)) exitWith
				{
					_votes = _tmpList select _i select 1;
					_i = _i + 1;
				};
				_i = _i + 1;
			};
			_sizeText = "";
			_rad = _x select 3;
					
			_calcedPlayers = (_rad) / (sqrt(65) * pi);
			_sizeText = format["%1-%2 Players",floor(_calcedPlayers * 0.75), floor(_calcedPlayers * 1.25)];
			lbAdd [101, "(" + str(_votes) + ") " + (_x select 1) + " (" + _sizeText + ")"];
			str(_x select 2) setMarkerTextLocal str(_votes);
			if(getMarkerColor str(_x select 2) != "ColorOrange") then
			{		
				if(_votes > 0) then
				{
					str(_x select 2) setMarkerColorLocal "ColorGreen";
				}
				else
				{
					str(_x select 2) setMarkerColorLocal "ColorBlack";
				};
			};
			lbSetData[101, _foreachIndex, str(_x select 2)];
			lbSetTooltip[101, _foreachIndex, "Size: " + str(_x select 3)];
		}foreach ED_locations;
	GG_voteProgUpdate = nil;
	};
};