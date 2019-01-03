/*
	File: fn_heapSize.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

    Function: VOR_fnc_heapSize
	Description: Returns the size of the heap (one could also just use count)
*/
#include "heapHeader.sqf";

private _return = 0;
if(_this isEqualType []) then {
	_return = count _this;
};
_return