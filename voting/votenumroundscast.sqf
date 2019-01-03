if(GAME_progress == 0) then
{
	castVoteRounds = [getPlayerUID player, parseNumber(lbData [101, (lbCurSel 101)])];
	if(!isServer) then
	{
		publicVariableServer "castVoteRounds";
	}
	else
	{
		["GUNGAMEVOTES_ROUNDS", castVoteRounds] spawn processIncomingVote;
	};
};
