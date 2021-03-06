/*
	File: fn_heapPercUp.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

    Function: VOR_fnc_heapPercUp
	Description: Percolate a node up the tree (towards the root) to its correct height
*/
#include "heapHeader.sqf";

params ["_heap", "_i"];
private _parent = PARENT(_i);
while {_parent >= 0} do {
	private _keyChild = KEY(_heap#_i);
	private _keyParent = KEY(_heap#_parent);
	if( COMPARE(_keyChild,_keyParent) ) then {
		[_heap, _i, _parent] call VOR_fnc_heapSwap;
	};
	_i = _parent;
	_parent = PARENT(_i);
};

/* TODO Test this version later
params ["_heap", "_i"];
private _parent = PARENT(_i);
while {_parent >= 0} do {
	private _keyChild = KEY(_heap#_i);
	private _keyParent = KEY(_heap#_parent);
	if( COMPARE(_keyChild,_keyParent) ) then {
		[_heap, _i, _parent] call VOR_fnc_heapSwap;
		_i = _parent;
		_parent = PARENT(_i);
	} else {
		_parent = -1;
	};
};
*/