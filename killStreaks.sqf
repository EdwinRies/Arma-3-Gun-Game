killStreakNumber = 5;

killStreakUAVNumber = 3;

hasUAV = false;

killStreakObjects = [];

"killStreakBroadCast" addPublicVariableEventHandler
{
	hint format["%1 is on a Kill Streak!", name (_this select 1)];
	killStreakObjects pushBack (_this select 1);
};

killStreakEndFunc = {
	hint format["%1's Kill Streak was ended!", name _this];
	{
		if(getPlayerUID _x == getPlayerUID _this) then
		{
			killStreakObjects set [_foreachIndex, "DEL"];			
		};
	}foreach killStreakObjects;
	killStreakObjects = killStreakObjects - ["DEL"];
};

"killStreakEnd" addPublicVariableEventHandler
{
	(_this select 1) call killStreakEndFunc;
};

streakIconPath = getText(configfile >> "CfgWeaponIcons" >> "srifle");

streakIconsFunc = 
{
	{
		if(!isNull _x && isPlayer _x) then
		{
			_pos = ASLtoATL (eyePos _x);
			_pos set [2, (_pos select 2) + 0.5];
			drawIcon3D [streakIconPath, [1,0,0,0.35], _pos, 1, 1, 45, "Kill Streak", 1, 0.025, "TahomaB"];
		}
		else
		{
			killStreakObjects set[_foreachIndex, "DEL"];
		};
	}foreach killStreakObjects;
	killStreakObjects = killStreakObjects - ["DEL"];
};


eachFrameHandles pushBack streakIconsFunc;

killStreakIncrement =
{
	killStreakCounter = killStreakCounter + 1;
	if(killStreakCounter == killStreakNumber) then
	{
		killStreakBroadCast = player;
		publicVariable "killStreakBroadCast";
		[] spawn 
		{
			sleep 1;
			hint "You are on a kill streak, you are now visible to all!";
		};
	};
	
	if(killStreakUAVNumber == killStreakCounter) then 
	{
		[] spawn killStreakUAV;
	};
};

killStreakStopFunc =
{
	if(killStreakCounter >= killStreakNumber) then
	{
		killStreakEnd = player;
		publicVariable "killStreakEnd";
	};
};

killStreakUAV = {
	if(!hasUAV) then{
		UAV_Vehicle = createVehicle ["B_UAV_01_F", getPos player vectorAdd [0,0,200],[],0, "FLY"];
		createVehicleCrew UAV_Vehicle;
		UAV_Vehicle lockCameraTo [player, [0]];
		UAV_Vehicle flyInHeight 40;		
		
		hasUAV = true;
		_pos = getPos player vectorAdd [0,0,300];
		ksUAV = "camera" camCreate getPos player;
		ksUAV camSetTarget player; 
		ksUAV attachTo [UAV_Vehicle, [0,0,-1]];
		ksUAV camSetFov 0.5;
		ksUAV cameraEffect ["INTERNAL", "BACK", "uavcam"];
		"uavcam" setPiPEffect [2];
		ksUAV camCommit 0;	
		disableserialization;
		_display = call BIS_fnc_displayMission;
		_uavCtrl = _display ctrlCreate ["RscPicture", -1];
		_uavCtrl ctrlSetFade 0.05;
		_uavCtrl ctrlShow true;
        _uavCtrl ctrlSetPosition [
            safeZoneX, 
            safeZoneY + (safeZoneH * 0.75), 
            safeZoneW * 0.25, 
            safeZoneH * 0.25
        ];
		_uavCtrl ctrlSetText "#(argb,512,512,1)r2t(uavcam,1.0)";
		_uavCtrl ctrlCommit 0;

		[] spawn {
			while{hasUAV} do
			{
				{deleteWaypoint _x} foreach waypoints UAV_Vehicle;
				_wp = group UAV_Vehicle addWaypoint [(position player), 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 1;
				sleep 1;
			};
		};
		
		waitUntil {!(alive player) || Game_progress != 3 || !(alive UAV_Vehicle)};
		camDestroy ksUAV;
		hasUAV = false;
		ctrlDelete _uavCtrl;
		deleteVehicle UAV_Vehicle;
	};	
};