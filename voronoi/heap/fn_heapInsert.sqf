/*
	File: fn_heapInsert.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

    Function: VOR_fnc_heapInsert
	Description: Insert an item into the heap 
*/
#include "heapHeader.sqf";

params [
	["_heap", [], [[]]],
	["_key", -1],
	"_value"
];

private _last = _heap pushBack [_key, _value];

[_heap, _last] call VOR_fnc_heapPercUp;