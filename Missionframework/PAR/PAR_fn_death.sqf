params ["_unit"];

[(_unit getVariable ['PAR_myMedic', objNull]), _unit] call PAR_fn_medicRelease;
_unit setVariable ['PAR_wounded', false];

if (_unit == player) then {
	titleText ["" ,"BLACK FADED", 100];
	_unit connectTerminalToUAV objNull;
	private _pos = getPosATL _unit;
	"player_grave_box" setMarkerPosLocal _pos;
	titleText ["" ,"BLACK FADED", 100];
} else {
	player globalChat (format [localize "STR_PAR_DE_01", name _unit]);
	removeAllActions _unit;
	removeAllWeapons _unit;
	hideBody _unit;
	sleep 5;
	deleteVehicle _unit;
};
