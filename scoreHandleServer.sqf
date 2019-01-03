respawnQueue = [];

"requestSpawn" addPublicVariableEventHandler
{
	_playerObject = _this select 1;
	respawnResponse = true;
	respawnQueue pushBack _playerObject;
};

if(isNil "playerScoreArray" || isNil "playerScoreArrayIndex" || isNil "playerScoreNamesArray") then 
{
	playerScoreArray = [];
	playerScoreArrayIndex = [];
	playerScoreNamesArray = [];
};

//adds and returns score
addScorePlayer = 
{
	_uid = _this select 0;
	_name = _this select 2;
	_score = 0;	
	_index = playerScoreArrayIndex find _uid;
	if(_index > -1) then
	{
		playerScoreArray set[_index, (playerScoreArray select _index) + 1];
		_score = playerScoreArray select _index; 
	}
	else
	{
		playerScoreArray pushBack 1;
		playerScoreArrayIndex pushBack _uid;
		playerScoreNamesArray pushBack _name;
		_score = 1;
	};
	_score call GG_Sort_Score;	
};


giveScoreServerFunc = 
{
	if(GAME_progress != 4) then
	{			
			_id = _this select 0;
			_uid = _this select 1;
			_killedName = _this select 2;
			_killerName = _this select 3;
			_uidVictim = _this select 4;
			if(_uid == _uidVictim) exitWith{};
			
			giveScoreClient = [[_uid, _killedName, _killerName] call addScorePlayer, _killedName];
			
			{
				if(getPlayerUID _x == _uid) exitWith{
					_x addScore ((giveScoreClient select 0) - (score _x));
				}
			} foreach playableUnits;
			
			if(!isDedicated) then
			{
				if(getPlayerUID player == _uid) then 
				{
					giveScoreClient call gunGameFunc;	
				}
				else
				{
					_id publicVariableClient "giveScoreClient";	
				};
			}
			else
			{
				_id publicVariableClient "giveScoreClient";					
			}

		};
};

while{true} do
{
	waitUntil{count(respawnQueue) > 0};
	_player = respawnQueue select 0;
	if(!isNull _player) then
	{
		if(_player != player) then
		{
			(owner _player) publicVariableClient "respawnResponse";
		}
		else
		{
			maySpawn = true;
		};
		_player removeAllMPEventHandlers "MPKilled";
		_player addMPEventHandler ["MPKilled",{if(isServer) then {[owner(_this select 1), getPlayerUID(_this select 1), name(_this select 0), name(_this select 1), getPlayerUID(_this select 0)] spawn giveScoreServerFunc;};}];
		respawnQueue set [0, "delete"];
		respawnQueue = respawnQueue - ["delete"];
	};
	sleep 0.1;
};