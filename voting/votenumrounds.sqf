sleep 0.1;
waitUntil{!dialog};
systemchat "Vote for a number of rounds.";
if(!isNil "voteNumRounds") exitWith {};
voteNumRounds = true;

if(isNil "GAME_progress") then
{
GAME_progress == 0;
};
numRoundVoteOptions = [10,20,30,40,50];
while {GAME_progress == 0} do
{
	_dialog = createDialog "voteNumRounds";	
	((findDisplay 102) displayCtrl 130) htmlLoad "credits.html";
	((findDisplay 102) displayCtrl 130) ctrlCommit 0;
	((findDisplay 102) displayCtrl 101) ctrlSetEventHandler ["LBSelChanged","execVM 'voting\votenumroundscast.sqf';"];
	{
		lbAdd [101, str(_x)];
		lbSetData[101, _foreachIndex, str(_x)];
	}foreach numRoundVoteOptions;
	//lbSetCurSel [101, 1];
	waitUntil{GAME_progress != 0};
	if(dialog) then {closeDialog 0};
};

execVM "voting\votefightzone.sqf";