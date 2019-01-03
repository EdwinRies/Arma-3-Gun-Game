if(isNil "votedGunsAmount") then
{
	votedGunsAmount = 0;
};
votedGunsAmount = votedGunsAmount + 1;
if(votedGunsAmount > GUNGAME_ROUNDS) then
{
	votedGunsAmount = 1;
};
_gunText = lbText [4, lbCurSel 4];
_gunClass = lbData [101, lbCurSel 101];
if(!isClass (configFile >> "cfgWeapons" >> _gunClass)) exitWith {systemChat "No gun selected"};
_attachments = [lbData [111, lbCurSel 111], lbData [112, lbCurSel 112], lbData [113, lbCurSel 113]];

castVoteWeapons = [(getPlayerUID player) + str(votedGunsAmount), [_gunClass, _attachments]];
if(!isServer) then
{
	publicVariableServer "castVoteWeapons";
}
else
{
	["GUNGAMEVOTES_WEAPONS", castVoteWeapons] spawn processIncomingVote;
};