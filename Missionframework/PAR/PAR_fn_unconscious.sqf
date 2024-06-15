params ["_unit"];

if (rating _unit < -2000) exitWith {_unit setDamage 1};

if (isPlayer _unit) then {
	[] call PAR_show_marker;
} else {
	[_unit] call PAR_fn_deathSound;
};

_unit setUnconscious true;
_unit setCaptive true;
_unit allowDamage false;

waituntil {sleep 0.5; lifeState _unit == "INCAPACITATED" && (isTouchingGround (vehicle _unit) || (round (getPos _unit select 2) <= 1))};

if (!isNil {_unit getVariable "PAR_busy"} || !isNil {_unit getVariable "PAR_heal"}) then {
	_unit setVariable ["PAR_busy", nil];
	_unit setVariable ["PAR_heal", nil];
};

_unit setVariable ["PAR_healed", nil];
[(_unit getVariable ["PAR_myMedic", objNull]), _unit] call PAR_fn_medicRelease;

_unit switchMove "AinjPpneMstpSnonWrflDnon";	// lay down
_unit playMoveNow "AinjPpneMstpSnonWrflDnon";
sleep 7;

if (PAR_ai_revive > 0 && !isPlayer _unit && local _unit) then {
	private _cur_revive = _unit getVariable ["PAR_revive_max", PAR_ai_revive];
	if (_cur_revive == 0) then { _unit setDamage 1; sleep 3 };
};
if (!alive _unit) exitWith {};

_unit setVariable ["PAR_isUnconscious", true, true];
if !(isPlayer _unit) then { sleep 3 };

private _bld = [_unit] call PAR_spawn_blood;
private _cnt = 0;
private ["_medic", "_msg"];
while { alive _unit && (_unit getVariable ["PAR_isUnconscious", false]) && time <= (_unit getVariable ["PAR_BleedOutTimer", 0])} do {
	if (_cnt == 0) then {
		_unit setOxygenRemaining 1;
		if ( {alive _x} count PAR_AI_bros > 0 ) then {
			_medic = _unit getVariable ["PAR_myMedic", nil];
			if (isNil "_medic") then {
				_unit groupchat localize "STR_PAR_UC_01";
				_medic = [_unit] call PAR_fn_medic;
				if (!isNil "_medic") then { [_unit, _medic] call PAR_fn_911 };
			};
		} else {
			_msg = format [localize "STR_PAR_UC_03", name player];
			if (lifeState player == "INCAPACITATED") then {
				_msg = format [localize "STR_PAR_UC_02", name player];
			};
			_last_msg = player getVariable ["PAR_last_message", 0];
			if (time > _last_msg) then {
				[_unit, _msg] call PAR_fn_globalchat;
				player setVariable ["PAR_last_message", round(time + 20)];
			};
		};
		//systemchat str ((_unit getVariable ["PAR_BleedOutTimer", 0]) - time);
		_cnt = 10;
	};
	_cnt = _cnt - 1;
	sleep 1;
};

if (!isNull _bld) then { _bld spawn {sleep (30 + floor(random 30)); deleteVehicle _this} };
[(_unit getVariable ["PAR_myMedic", objNull]), _unit] call PAR_fn_medicRelease;
if (isPlayer _unit) then {
	[] call PAR_del_marker;
};

// Bad end
if (!alive _unit) exitWith {};
if (lifeState _unit == "INCAPACITATED" && time > _unit getVariable ["PAR_BleedOutTimer", 0]) exitWith {
	_unit setDamage 1;
};

// Good end
if (isPlayer _unit) then {
	if (primaryWeapon _unit != "") then { _unit selectWeapon primaryWeapon _unit };
};
