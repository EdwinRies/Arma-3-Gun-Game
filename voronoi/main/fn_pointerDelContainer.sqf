/*
	File: fn_pointerDelContainer.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-12
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

	Function: VOR_fnc_pointerDelContainer
	Description: Deletes a given container
*/

#include "voronoiHeader.sqf"
params [
	["_container", objNull, [objNull]]
];

if(!isNull _container) then {
	private _grp = group _container;
	deleteVehicle _container;
	deleteGroup _grp;
};