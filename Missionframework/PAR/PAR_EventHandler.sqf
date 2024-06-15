params ["_unit"];

// Player
if (_unit == player) then {
	// Unblock units
	private _actions = missionNamespace getVariable ["BIS_fnc_addCommMenuItem_menu", []];
	private _id = (count _actions / 2) + 1;
	_actions = _actions + [
		["Do it !", true],
		["Unblock unit.", [_id + 1], "", -5, [["expression", "[groupSelectedUnits player] spawn PAR_unblock_AI"]], str _id, str _id]
	];
	missionNamespace setVariable ["BIS_fnc_addCommMenuItem_menu", _actions];	

	// Player killed EH
	player addEventHandler ["Killed", { _this spawn PAR_fn_death }];

	// Player respawn EH
	player addEventHandler ["Respawn", { [] spawn PAR_Player_Init }];

	// Player Handle Damage EH
	if (PAR_revive != 0) then {
		player addEventHandler ["HandleDamage", { _this call PAR_HandleDamage_EH }];
	};
} else {
	// AI killed EH
	_unit addEventHandler ["Killed", { _this spawn PAR_fn_death }];	

	// AI Handle Damage EH
	if (PAR_revive != 0) then {
		_unit addEventHandler ["HandleDamage", {
			params ["_unit","","_dam"];
			_veh = objectParent _unit;

			private _isNotWounded = !(_unit getVariable ["PAR_wounded", false]);
			if (_isNotWounded && _dam >= 0.86) then {
				_unit setVariable ["PAR_wounded", true, true];
				if (!isNull _veh) then {[_unit, _veh] spawn PAR_fn_eject};
				_unit setVariable ["PAR_BleedOutTimer", round(time + PAR_bleedout), true];
				[_unit] spawn PAR_fn_unconscious;
			};
			_dam min 0.86;
		}];
	};
};
