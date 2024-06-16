// The PAR Manager
// by pSiKO

waituntil {sleep 1; alive player};

private _comm_id1 = 0;
private ["_unit", "_is_medic", "_has_medikit", "_wnded_list", "_wnded"];

while {true} do {
    waitUntil { sleep 1; alive player && count (units player) > 0 };
    PAR_AI_bros = ((units player) + (units civilian)) select {!isPlayer _x && alive _x && (_x getVariable ["PAR_Grp_ID","0"]) == format["Bros_%1", PAR_Grp_ID]};
    if ( count PAR_AI_bros > 0) then {
        {
            _unit = _x;
            if (PAR_revive != 0) then {
                // Medic can heal auto
                _wnded_list = (units player) select {
                    (_x distance2D _unit) < 30 &&
                    !(surfaceIsWater (getPos _x)) &&
                    isNull objectParent _x &&
                    damage _x >= 0.1 &&
                    behaviour _x != "COMBAT" &&
                    isNil {_x getVariable 'PAR_busy'} &&
                    isNil {_x getVariable 'PAR_healed'}
                };

                if (count _wnded_list > 0) then {
                    _is_medic = [_unit] call PAR_is_medic;
                    _has_medikit = [_unit] call PAR_has_medikit;
                    _wnded = _wnded_list select 0;
                    if (_is_medic && _has_medikit &&
                        isNull objectParent _unit &&
                        (behaviour _unit) != "COMBAT" &&
                        (currentCommand _unit != "STOP") &&
                        lifeState _unit != 'INCAPACITATED' &&
                        isNil {_unit getVariable 'PAR_busy'} &&
                        isNil {_unit getVariable 'PAR_heal'}
                    ) then {
                        [_unit, _wnded] spawn PAR_fn_heal;
                    };
                };
            };

            // Blood trail
            if (damage _unit > 0.6 && isNull objectParent _unit && !(surfaceIsWater (getPos _unit))) then {
                private _spray = createVehicle ["BloodSpray_01_New_F", getPos _unit, [], 0, "CAN_COLLIDE"];
                _spray spawn {sleep (10 + floor(random 5)); deleteVehicle _this};
            };

            // AI revive
            if (PAR_ai_revive > 0) then {
                private _timer = _unit getVariable ["PAR_revive_msg_timer", 0];
                if (time > _timer) then {
                    private _msg = "";
                    private _cur_revive = _unit getVariable ["PAR_revive_max", PAR_ai_revive];
                    private _near_medical = (count (nearestObjects [_unit, [PAR_medical_source], 12]) > 0);
                    if (_cur_revive == 0) then {
                        _msg = format ["CRITICAL: Can't revive %1 anymore!", name _unit];
                    };
                    if (_msg != "") then {
                        [_unit, _msg] call PAR_fn_globalchat;
                        _unit setVariable ["PAR_revive_msg_timer", round (time + (3 * 60))];
                    };
                };
            };
            sleep 0.3;
        } forEach PAR_AI_bros;
    };
    
    {
        if (count PAR_AI_bros < PAR_ai_limit) then {
            _unit = _x;
            if  ((_unit getVariable ["PAR_Grp_ID","0"]) != format["Bros_%1", PAR_Grp_ID]) then {          
                if (_unit == player) then {
                    [] call PAR_Player_Init;
                    [player] call PAR_EventHandler;
                } else {
                    [_unit] call PAR_fn_AI_Damage_EH;
                };
            };
            sleep 0.3;
        };
    } forEach (units player);

    sleep 5;
};
