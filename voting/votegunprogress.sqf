sleep 0.1;
waitUntil{!dialog};

if(!isNil "voteGunProgress") exitWith {};
voteGunProgress = true;

while {GAME_progress == 2} do
{
	voteGun_handGun = ED_dynamicWeapons_HandGun;
	voteGun_primary = ED_dynamicWeapons_Primary;
	_dialog = createDialog "voteWeaponsDialog";	
	
	execVM 'populateWeapons.sqf';
	
	waitUntil{GAME_progress != 2};
	if(dialog) then {closeDialog 0};
};

