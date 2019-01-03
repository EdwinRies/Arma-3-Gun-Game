/*
	File: fn_heapNew.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

    Function: VOR_fnc_heapNew
	Description: Creates a new heap from a given array of arrays with the first element of each sub-array being a key (number).
	Example: 
		[[1, "world!"], [2, "there"], [3, "Hello"]] call VOR_fnc_heapNew
*/
#include "heapHeader.sqf";
private _return = [];
if(_this isEqualType []) then {
	private _heap = +_this;
	private _i = LAST(_heap);
	while { _i >= 0 } do {
		[_heap, _i] call VOR_fnc_heapPercDown;
		_i = _i - 1;
	};

	_return = _heap;
};
_return
