scriptName "civinfo_escort";

params ["_informant"];
private [ "_nearestfob", "_is_near_fob", "_grp" ];

if (KPLIB_civinfo_debug > 0) then {[format ["civinfo_escort called on: %1 - Parameters: [%2]", debug_source, _informant], "CIVINFO"] remoteExecCall ["KPLIB_fnc_log", 2];};

_is_near_fob = false;

waitUntil {
    sleep 5;
    _nearestfob = [ getpos _informant ] call KPLIB_fnc_getNearestFob;
    _is_near_fob = false;
    if (count _nearestfob == 3) then {
        _is_near_fob = ((_informant distance _nearestfob) < 30);
    };

    !alive _informant || (_is_near_fob && (vehicle _informant == _informant))
};

if (alive _informant) then {
    sleep 5;
    _grp = createGroup [KPLIB_side_civilian, true];
    [_informant] joinSilent _grp;
    if (KPLIB_ace_captives) then {
        private _isCuffed = _informant getVariable ["ace_captives_isHandcuffed", false];
        if (_isCuffed) then {
            ["ace_captives_setHandcuffed", [_informant, false], _informant] remoteExecCall ["CBA_fnc_targetEvent", 2];
        } else {
            ["ace_captives_setSurrendered", [_informant, false], _informant] remoteExecCall ["CBA_fnc_targetEvent", 2];
        };
        sleep 1;
    };
    _informant playmove "AmovPercMstpSnonWnonDnon_AmovPsitMstpSnonWnonDnon_ground";
    _informant disableAI "ANIM";
    _informant disableAI "MOVE";
    sleep 5;
    [_informant, "AidlPsitMstpSnonWnonDnon_ground00"] remoteExecCall ["switchMove"];
    [_informant] remoteExec ["civinfo_delivered",2];
    if (KPLIB_civinfo_debug > 0) then {["civinfo_escort -> Informant at FOB", "CIVINFO"] remoteExecCall ["KPLIB_fnc_log", 2];};
    sleep 600;
    if (isNull objectParent _informant) then {deleteVehicle _informant} else {(objectParent _informant) deleteVehicleCrew _informant};
    if (KPLIB_civinfo_debug > 0) then {[format ["civinfo_escort finished by: %1", debug_source], "CIVINFO"] remoteExecCall ["KPLIB_fnc_log", 2];};
} else {
    if (KPLIB_civinfo_debug > 0) then {[format ["civinfo_escort failed by: %1 - Informant isn't alive", debug_source], "CIVINFO"] remoteExecCall ["KPLIB_fnc_log", 2];};
    [3] remoteExec ["civinfo_notifications"];
};
