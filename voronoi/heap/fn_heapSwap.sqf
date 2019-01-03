/*
	File: fn_heapSwap.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

    Function: VOR_fnc_heapSwap
	Description: Swap to nodes in the heap
*/
#include "heapHeader.sqf";

params ["_heap", "_index1", "_index2"];
private _temp = _heap#_index1;
_heap set [_index1, _heap#_index2];
_heap set [_index2, _temp];