//Build leaderboard


if(!isDedicated) then {

LeaderboardInitiated = false;
GG_LeaderBoardHeader = [];
GG_LeaderBoardControls = [];

	"GG_TOP_SCORE" addPublicVariableEventHandler
	{
		(_this select 1) call GG_Leaderboard_Update;
	};
	
	GG_Leaderboard_Update = {
		if(!LeaderboardInitiated) exitWith {};
		disableSerialization;
		_i = 0;
		while {_i < 10} do
		{
			_ctrlRow = GG_LeaderBoardControls select _i;
			if(count(_this) > _i) then
			{
				_data = _this select _i;				
				(_ctrlRow select 0) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>"+ (str (_i + 1)) +"</t>");
				(_ctrlRow select 1) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>"+ (str(_data select 1)) +"</t>");
				(_ctrlRow select 2) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>"+ (str(_data select 0)) +"</t>");
			}
			else
			{
				(_ctrlRow select 0) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>"+ (str (_i + 1)) +"</t>");
				(_ctrlRow select 1) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'></t>");
				(_ctrlRow select 2) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'></t>");
			};
			(_ctrlRow select 0) ctrlCommit 0;
			(_ctrlRow select 1) ctrlCommit 0;
			(_ctrlRow select 2) ctrlCommit 0;
			_i = _i + 1;
		};
	};	

	GG_LeaderBoardShowing = false;
	GG_LeaderBoardToggling = false;
	
	GG_Leaderboard_Toggle = {
		if(!LeaderboardInitiated) exitWith {};
		disableSerialization;
		true;
		if(GG_LeaderBoardToggling) exitWith{};
		GG_LeaderBoardToggling = true;
		_controls = GG_LeaderBoardControls;
		_controls pushback GG_LeaderBoardHeader;
		for[{_i = 0}, {_i < count(_controls)}, {_i = _i + 1}] do 
		{
			_controlRow = _controls select _i;
			if(GG_LeaderBoardShowing) then 
			{
				{
					_x ctrlShow false;
					_x ctrlCommit 0;
				}foreach _controlRow;
			}
			else
			{
				{
					_x ctrlShow true;
					_x ctrlCommit 0;
				}foreach _controlRow;
			};
		};	
		if(GG_LeaderBoardShowing) then {GG_LeaderBoardShowing = false;} else {GG_LeaderBoardShowing = true;};
		GG_LeaderBoardToggling = false;
	};
	
	disableSerialization;
	_display = nil;
	waituntil {
	_display = findDisplay 46;
	if (isNil "_display") exitWith {false};
	if (isNull _display) exitWith {false};
	true;
	};
	keyPress = 
	{	
		_handled = false;
		switch (_this select 1) do
		{
			//P key
			case 25: 
			{
				call GG_Leaderboard_Toggle;
				_handled = true;
			};
		};
		_handled;
	};
	_display displayAddEventHandler ["KeyDown", "_this call keyPress"];
	
	
	
	
};

if(isServer) then
{	
	GG_Sort_Score = { 
		_GG_Leaderboard_data = [];
		
		playerScoreArray;
		playerScoreArrayIndex;
		playerScoreNamesArray;
		
		_sorting = true;
		
		while{_sorting} do 
		{
			_sorting = false;
			for[{_i = 0}, {_i < count(playerScoreArray) - 1}, {_i = _i + 1}] do{
				if(playerScoreArray select _i < playerScoreArray select (_i + 1)) then 
				{
					_sotring = true;
					_score1 = playerScoreArray select _i;
					_score2 = playerScoreArray select (_i + 1);
					
					_index1 = playerScoreArrayIndex select _i;
					_index2 = playerScoreArrayIndex select (_i + 1);
					
					_name1 = playerScoreNamesArray select _i;
					_name2 = playerScoreNamesArray select (_i + 1);
					
					playerScoreArray set [_i, _score2];
					playerScoreArray set [_i + 1, _score1];
					
					playerScoreArrayIndex set [_i, _index2];
					playerScoreArrayIndex set [_i + 1, _index1];
					
					playerScoreNamesArray set [_i, _name2];
					playerScoreNamesArray set [_i + 1, _name1];
				};
			};		
		};
		
		_sizeLeaderAr = 0;
		if(count(playerScoreArray) < 10) then 
		{
			_sizeLeaderAr = count(playerScoreArray);
		}
		else
		{
			_sizeLeaderAr = 10;
		};
		
		for[{_i = 0}, {_i < _sizeLeaderAr}, {_i = _i + 1}] do 
		{
			_GG_Leaderboard_data pushback [playerScoreArray select _i, playerScoreNamesArray select _i];
		};
		
		if(!isDedicated) then 
		{
			_GG_Leaderboard_data spawn GG_Leaderboard_Update;
		};
		GG_TOP_SCORE = _GG_Leaderboard_data;
		publicVariable "GG_TOP_SCORE";
		_this;
	};
};

if(!isDedicated) then {
waitUntil {!isNil "INACTION"};
waitUntil {INACTION};
if (hasInterface) then {
		disableSerialization; 
		_i = 0;
		while {_i <= 10} do
		{			      
			
			_display = call BIS_fnc_displayMission;
			_ctrlPos = _display ctrlCreate ["RscStructuredText", -1];
			_ctrlPos ctrlShow false;
			_ctrlPos ctrlSetBackgroundColor [0,0,0,0.6];
			_ctrlPos ctrlSetPosition [
				safeZoneX + ((safeZoneW / 2) - 0.35), 
				safeZoneY + (safeZoneH * 0.2) + (_i * 0.05), 
				0.1, 
				0.05
			];			
			_ctrlPos ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>###</t>");

			_ctrlPos ctrlCommit 0;
			
			
			_ctrlName = _display ctrlCreate ["RscStructuredText", -1];
			_ctrlName ctrlSetBackgroundColor [0,0,0,0.6];
			_ctrlName ctrlShow false;
			_ctrlName ctrlSetPosition [
				safeZoneX + ((safeZoneW / 2) - 0.25), 
				safeZoneY + (safeZoneH * 0.2) + (_i * 0.05), 
				0.5, 
				0.05
			];
			_ctrlName ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>###</t>");

			_ctrlName ctrlCommit 0;

			
			_ctrlScore = _display ctrlCreate ["RscStructuredText", -1];
			_ctrlScore ctrlSetBackgroundColor [0,0,0,0.6];
			_ctrlScore ctrlShow false;
			_ctrlScore ctrlSetPosition [
				safeZoneX + ((safeZoneW / 2) + 0.25), 
				safeZoneY + (safeZoneH * 0.2) + (_i * 0.05), 
				0.1, 
				0.05
			];
			
			_ctrlScore ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>###</t>");

			_ctrlScore ctrlCommit 0;

			
			if(_i == 0) then 
			{
				GG_LeaderBoardHeader = [_ctrlPos, _ctrlName, _ctrlScore];
			}
			else
			{
				GG_LeaderBoardControls pushback [_ctrlPos, _ctrlName, _ctrlScore];
			};
			_i = _i + 1;
		};	
		
		(GG_LeaderBoardHeader select 0) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>#</t>");
		(GG_LeaderBoardHeader select 1) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>Player</t>");
		(GG_LeaderBoardHeader select 2) ctrlSetStructuredText parseText ("<t align='center' color='#ffffffff' shadow='2'>Score</t>");

};
LeaderboardInitiated = true;
[] spawn GG_Leaderboard_Update;
};