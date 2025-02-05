[] call compile preprocessFileLineNumbers "scripts\client\misc\init_markers.sqf";
[] call KPLIB_fnc_initArsenal;

spawn_camera = compile preprocessFileLineNumbers "scripts\client\spawn\spawn_camera.sqf";
cinematic_camera = compile preprocessFileLineNumbers "scripts\client\ui\cinematic_camera.sqf";
write_credit_line = compile preprocessFileLineNumbers "scripts\client\ui\write_credit_line.sqf";
do_load_box = compile preprocessFileLineNumbers "scripts\client\ammoboxes\do_load_box.sqf";
kp_fuel_consumption = compile preprocessFileLineNumbers "scripts\client\misc\kp_fuel_consumption.sqf";
kp_vehicle_permissions = compile preprocessFileLineNumbers "scripts\client\misc\vehicle_permissions.sqf";

KPLIB_tents = [];
publicVariable "KPLIB_tents";

if (KPLIB_param_playerMenu == 2) then {
    ["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;
};

execVM "scripts\client\actions\intel_manager.sqf";
execVM "scripts\client\actions\recycle_manager.sqf";
execVM "scripts\client\actions\unflip_manager.sqf";
execVM "scripts\client\ammoboxes\ammobox_action_manager.sqf";
execVM "scripts\client\build\build_overlay.sqf";
execVM "scripts\client\build\do_build.sqf";
execVM "scripts\client\commander\enforce_whitelist.sqf";
if (KPLIB_param_zeusLimited) then { execVM "scripts\client\commander\hide_from_zeus.sqf" };
execVM "scripts\client\markers\fob_markers.sqf";
execVM "scripts\client\markers\hostile_groups.sqf";
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

execVM "addons\AIDrivingControl\init.sqf";
execVM "addons\PAR\fn_init.sqf";

if (KPLIB_param_mapMarkers) then { execVM "addons\SoliderTracker\QS_icons.sqf" };

[["C_MAN","C_MAN","CUP_C","CAF_AG","CAF_AG","C_MAN"],[],5,23,1] execvm "addons\TPWMods\tpw_core.sqf";
if (count KPLIB_c_vehAir > 0) then {[10,600,2,[100,250,500],2,KPLIB_c_vehAir] execvm "addons\TPWMods\tpw_air.sqf";};
[600,2000,15,2] execvm "addons\TPWMods\tpw_boats.sqf";
[10,10,200,100,60,10,1] execvm "addons\TPWMods\tpw_animals.sqf";
[1,1,1,1,1,0,0,[0],12,1,1] execvm "addons\TPWMods\tpw_soap.sqf";

player addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;

    _unit call KPLIB_fnc_respawnPenalty;
}];

if (KPLIB_param_fuelconsumption) then {
    player addEventHandler ["GetInMan", {[_this select 2] spawn kp_fuel_consumption;}];
};
player addEventHandler ["GetInMan", {[_this select 2, _this select 0] call KPLIB_fnc_setVehicleSeized;}];
player addEventHandler ["GetInMan", {[_this select 2] call KPLIB_fnc_setVehicleCaptured;}];
player addEventHandler ["GetOutMan", {[_this select 2] call KPLIB_fnc_setVehicleCaptured;}];
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
};

if ((KPLIB_param_zeusLimited) && (isClass (configfile >> "CfgPatches" >> "zen_context_actions"))) then {
    ["HealUnits"] call zen_context_menu_fnc_removeAction;
    ["Captives"] call zen_context_menu_fnc_removeAction;
    ["Loadout"] call zen_context_menu_fnc_removeAction;
    ["Inventory"] call zen_context_menu_fnc_removeAction;
    ["VehicleAppearance"] call zen_context_menu_fnc_removeAction;
    ["VehicleLogistics"] call zen_context_menu_fnc_removeAction;
    ["EditableObjects"] call zen_context_menu_fnc_removeAction;
    ["TeleportPlayers"] call zen_context_menu_fnc_removeAction;
    ["TeleportZeus"] call zen_context_menu_fnc_removeAction;
};