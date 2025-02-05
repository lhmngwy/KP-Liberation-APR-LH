
/*
	Author: Genesis, tweaked by Freddo

	Description:
		Finds closest known enemy to unit

	Parameter(s):
		0: OBJECT - Unit to search from

	Returns:
		OBJECT
		if none found, ARRAY
*/

if (_this isEqualType []) exitWith {_rtrn = [];_rtrn};

private _unitSide = (side _this);
private _a1 = [];
{
	private _targetSide = side _x;
	if ([_unitSide, _targetSide] call BIS_fnc_sideIsEnemy && {!(vehicle _X isKindOf "Air")}) then {_a1 pushback _x;};
} forEach allUnits;

private _rtrn = [_a1,_this,true] call VCM_fnc_ClstObj;
if (isNil "_rtrn") then {_rtrn = []};

_rtrn