[] call compile preprocessFileLineNumbers "scripts\client\misc\init_markers.sqf";
[] call KPLIB_fnc_initArsenal;

spawn_camera = compile preprocessFileLineNumbers "scripts\client\spawn\spawn_camera.sqf";
cinematic_camera = compile preprocessFileLineNumbers "scripts\client\ui\cinematic_camera.sqf";
write_credit_line = compile preprocessFileLineNumbers "scripts\client\ui\write_credit_line.sqf";
do_load_box = compile preprocessFileLineNumbers "scripts\client\ammoboxes\do_load_box.sqf";
kp_fuel_consumption = compile preprocessFileLineNumbers "scripts\client\misc\kp_fuel_consumption.sqf";
kp_vehicle_permissions = compile preprocessFileLineNumbers "scripts\client\misc\vehicle_permissions.sqf";

execVM "scripts\client\actions\intel_manager.sqf";
execVM "scripts\client\actions\recycle_manager.sqf";
execVM "scripts\client\actions\unflip_manager.sqf";
execVM "scripts\client\ammoboxes\ammobox_action_manager.sqf";
execVM "scripts\client\build\build_overlay.sqf";
execVM "scripts\client\build\do_build.sqf";
execVM "scripts\client\commander\enforce_whitelist.sqf";
if (KPLIB_param_mapMarkers) then {execVM "scripts\client\markers\empty_vehicles_marker.sqf";};
execVM "scripts\client\markers\fob_markers.sqf";
if (!KPLIB_param_highCommand && KPLIB_param_mapMarkers) then {execVM "scripts\client\markers\group_icons.sqf";};
execVM "scripts\client\markers\hostile_groups.sqf";
if (KPLIB_param_mapMarkers) then {execVM "scripts\client\markers\huron_marker.sqf";} else {deleteMarkerLocal "huronmarker"};
execVM "scripts\client\markers\sector_manager.sqf";
execVM "scripts\client\markers\spot_timer.sqf";
execVM "scripts\client\misc\broadcast_squad_colors.sqf";
execVM "scripts\client\misc\permissions_warning.sqf";
if (!KPLIB_ace_refuel) then {execVM "scripts\client\misc\resupply_manager.sqf";};
execVM "scripts\client\misc\secondary_jip.sqf";
execVM "scripts\client\misc\synchronise_vars.sqf";
execVM "scripts\client\misc\synchronise_eco.sqf";
execVM "scripts\client\misc\playerNamespace.sqf";
execVM "scripts\client\spawn\redeploy_manager.sqf";
execVM "scripts\client\ui\ui_manager.sqf";
execVM "scripts\client\ui\tutorial_manager.sqf";
execVM "scripts\client\markers\update_production_sites.sqf";
execVM "addons\PAR\fn_init.sqf";

player addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;

    _hcgrp = _unit getVariable ["KPLIB_lastHC", objNull];
    _playerGroup = group _unit;
    
    // Initialize a flag to check if there are AI members in the player's group
    private _hasAIMembers = false;

    // Loop through the player's group and delete AI members
    {
        if (!isPlayer _x) then {
            _x setDamage 1;
            _hasAIMembers = true;
        };
    } forEach units _playerGroup;

    // If the player's group had no AI members and _hcgrp is not null, delete AI members from _hcgrp
    if (!_hasAIMembers && !isNull _hcgrp) then {
        {
            if (!isPlayer _x) then {
                _x setDamage 1;
            };
        } forEach units _hcgrp;
    };

    player setVariable ["KPLIB_lastHC", objNull, true];
}];

if (KPLIB_param_fuelconsumption) then {
    player addEventHandler ["GetInMan", {[_this select 2] spawn kp_fuel_consumption;}];
};
player addEventHandler ["GetInMan", {[_this select 2, _this select 0] call KPLIB_fnc_setVehicleSeized;}];
player addEventHandler ["GetInMan", {[_this select 2] call KPLIB_fnc_setVehicleCaptured;}];
player addEventHandler ["GetInMan", {[_this select 2] call kp_vehicle_permissions;}];
player addEventHandler ["GetInMan", {
    params ["_player"];
    // prevent players from getting into vehicles while carrying
    if (isNull (_player getVariable ["KPLIB_carriedObject", objNull])) exitWith {};
    moveOut _player;
}];
player addEventHandler ["SeatSwitchedMan", {[_this select 2] call kp_vehicle_permissions;}];
player addEventHandler ["HandleRating", {if ((_this select 1) < 0) then {0};}];

// Disable stamina, if selected in parameter
if (!KPLIB_param_fatigue) then {
    player enableStamina false;
    player addEventHandler ["Respawn", {player enableStamina false;}];
};

// Reduce aim precision coefficient, if selected in parameter
if (!KPLIB_param_weaponSway) then {
    player setCustomAimCoef 0.1;
    player addEventHandler ["Respawn", {player setCustomAimCoef 0.1;}];
};

execVM "scripts\client\ui\intro.sqf";

// Commander init
if (player isEqualTo ([] call KPLIB_fnc_getCommander)) then {
    // Start tutorial
    if (KPLIB_param_tutorial) then {
        [] call KPLIB_fnc_tutorial;
    };
    // Request Zeus if enabled
    if (KPLIB_param_zeusCommander) then {
        [] spawn {
            sleep 5;
            [] call KPLIB_fnc_requestZeus;
        };
    };
};
