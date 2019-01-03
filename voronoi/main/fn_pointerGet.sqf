/*
	File: fn_pointerGet.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-12
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

	Function: VOR_fnc_pointerGet
	Description: Returns the value in the given _container at the given _adress
*/

#include "voronoiHeader.sqf"

params [
	"_container",
	"_adress"
];

_container getVariable _adress;

