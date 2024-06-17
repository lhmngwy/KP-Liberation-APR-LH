params ["_unit", ["_slow", true]];
if (isNull objectParent _unit || isNull _unit || !alive _unit) exitWith {};
if ((vehicle _unit) isKindOf "ParachuteBase") exitWith {};

unAssignVehicle _unit;
[_unit] orderGetIn false;
[_unit] allowGetIn false;

if (_slow) then { sleep 2 };
moveOut _unit;
sleep 1;
if (!alive _unit) exitWith {};

if (getPos _unit select 2 >= 50) then {
	private _pos = _unit getPos [50, 360];
	if (backpack _unit != "B_Parachute") then {
		private _para = createVehicle ["Steerable_Parachute_F",_pos,[],0,"FLY"];
		_unit moveInDriver _para;
		sleep 3;
		if (isNull (driver _para)) then { deleteVehicle _para };
	};
};
