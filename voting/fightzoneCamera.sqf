_town = lbData [101, lbCurSel 101];
{
	if(str(_x select 2) == _town) exitWith
	{
		VOTECAM cameraEffect ["Internal", "Back"];
		VOTECAM camSetTarget [(_x select 2) select 0, (_x select 2) select 1,0];	
		VOTECAM camSetRelPos [-80,80,50];
		VOTECAM camSetFOV .90;
		VOTECAM camSetFocus [50, 0];
		VOTECAM camCommit 0;
		VOTECAM camSetRelPos [80,40,100];
		VOTECAM camCommit 5;
	};
}foreach ED_locations;