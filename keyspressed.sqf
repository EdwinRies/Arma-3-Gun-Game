//copied from Arma 3 wiki :P https://community.bistudio.com/wiki/displaySetEventHandler

private['_handled'];
_handled = false;
systemchat str (_this select 1);
switch (_this select 1) do
{
	//P key
	case 25: 
	{
		[] spawn GG_Leaderboard_Toggle;
		_handled = true;
	};
};
_handled;