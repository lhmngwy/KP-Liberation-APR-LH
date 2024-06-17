params ["_unit"];

[(_unit getVariable ['PAR_myMedic', objNull]), _unit] call PAR_fn_medicRelease;
_unit setVariable ['PAR_wounded', false];

if (_unit == player) then {
	titleText ["" ,"BLACK FADED", 100];
	_unit connectTerminalToUAV objNull;
	private _pos = getPosATL _unit;
	"player_grave_box" setMarkerPosLocal _pos;
	titleText ["" ,"BLACK FADED", 100];
};
