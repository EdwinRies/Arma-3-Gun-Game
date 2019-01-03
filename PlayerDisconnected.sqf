_id = _this select 0;
_name = _this select 1;
_uid = _this select 2;

{
	if(getPlayerUID _x == _uid) then
	{
		_x addScore -(score _x)
	};
} foreach PlayableUnits;

{
	if(owner _x == _id) then 
	{
		deleteVehicle _x;
	};
}foreach allUnitsUAV;