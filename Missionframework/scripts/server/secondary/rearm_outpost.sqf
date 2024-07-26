// Initialize variables
_ammo_present = false;
_player_outpost = [];
_required_value = 200;

// Find a random friendly outpost owned by the player
{
    if (_x in KPLIB_sectors_military) then {
        _player_outpost pushBack _x;
    };
} forEach KPLIB_sectors_player;

// Check if outpost array is empty
if(count _player_outpost isEqualTo 0) exitWith {
    // If empty, throw error in log and call proper intel notification
    ["There are no friendly outpost to spawn ammo at!", "ERROR"] call KPLIB_fnc_log; 
    [17] remoteExec ["remote_call_intel"];
};

// Select a random outpost from the player-owned towns array for the ammo drop-off
_objective_outpost = selectRandom _player_outpost;


// Create a 50m radius marker at the selected outpost
secondary_objective_position = getMarkerPos _objective_outpost;
secondary_objective_position_marker = secondary_objective_position;
publicVariable "secondary_objective_position_marker";
uiSleep 1;

// Start the secondary mission
KPLIB_secondary_in_progress = 3; publicVariable "KPLIB_secondary_in_progress";
[15] remoteExec ["remote_call_intel"];

// Add a note in the log
[format ["Starting Rearm Outpost objective in %1", _objective_outpost], "NOTIFICATION"] call KPLIB_fnc_log;


// Loop until 2x ammo crates have been brought to within 50m of objective
while {!_ammo_present} do {

    // Initialize total value of ammo crates to 0
    _total_value = 0;
    // Initialize _ammo_in_zone is array
    _ammo_in_zone = [];

    // Get list of all objects within the ammo check radius of the marker
    _objects_to_check = vehicles inAreaArray [secondary_objective_position, 50, 50];
    
    // Loop through all objects and check if they are the correct ammo crates and not currently attached to a vehicle
    {
        if (typeOf _x isEqualTo KPLIB_b_crateAmmo && isNull attachedTo _x) then {
            // If they are the right crate, add to the ammo array to be counted
            _ammo_in_zone pushBack _x;
        };
    } forEach _objects_to_check;

    // If there are no ammo, wait for a period of time and check again
    if (count _ammo_in_zone isEqualTo 0) then {
        hintSilent "";
        uiSleep 5;
    } else {
    
        // Loop through all ammo crates in the zone and add up their values
        {_total_value = _total_value + (_x getVariable ["KPLIB_crate_value", 0]);} forEach _ammo_in_zone;
        
        // If the total value is less than the required value, wait for a period of time and check again
        if (_total_value < _required_value) then {
        
            // Notify players of current ammo status in area
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_WAITING", _total_value, _required_value, 5, localize "STR_AMMO"];
            uiSleep 1;
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_WAITING", _total_value, _required_value, 4, localize "STR_AMMO"];
            uiSleep 1;
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_WAITING", _total_value, _required_value, 3, localize "STR_AMMO"];
            uiSleep 1;
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_WAITING", _total_value, _required_value, 2, localize "STR_AMMO"];
            uiSleep 1;
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_WAITING", _total_value, _required_value, 1, localize "STR_AMMO"];
            uiSleep 1;
            hintSilent format [localize "STR_SECONDARY_LOGIMISSION_CHECKING", _total_value, _required_value, localize "STR_AMMO"];
            uiSleep 1;
            
        } else {
            
            _consume_value = _required_value;
            {
                private _crate_value = _x getVariable ["KPLIB_crate_value",0];
                if (_consume_value != 0) then {
                    if (_consume_value >= _crate_value) then {
                        _consume_value = _consume_value - _crate_value;
                        _total_value = _total_value - _crate_value;
                        deleteVehicle _x;
                    } else {
                        _x setVariable ["KPLIB_crate_value", _crate_value - _consume_value, true];
                        _consume_value = 0;
                    };
                } else {
                };
            } forEach _ammo_in_zone;
            if (_consume_value == 0) then {_ammo_present = true;};
        };
    };
};
hintSilent "";

KPLIB_enemyReadiness = round (KPLIB_enemyReadiness - 8);
[16] remoteExec ["remote_call_intel"];
stats_secondary_objectives = stats_secondary_objectives + 1;
KPLIB_secondary_in_progress = -1; publicVariable "KPLIB_secondary_in_progress";
uiSleep 1;
[] spawn KPLIB_fnc_doSave;
[format ["Rearm Outpost secondary objective complete at %1. reduced enemy readiness to %2",_objective_outpost, KPLIB_enemyReadiness], "NOTIFICATION"] call KPLIB_fnc_log;
