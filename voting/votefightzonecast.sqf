if(GAME_progress == 1) then
{
	castVoteZone = [getPlayerUID player, lbData [101, lbCurSel 101]];
	if(!isServer) then
	{
		publicVariableServer "castVoteZone";
	}
	else
	{
		["GUNGAMEVOTES_ZONE", castVoteZone] spawn processIncomingVote;
	};
};