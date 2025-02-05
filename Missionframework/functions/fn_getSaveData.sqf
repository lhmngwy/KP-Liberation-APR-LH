/*
    File: fn_getSaveData.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-03-29
    Last Update: 2020-08-25
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gather current session data for saving.

    Parameter(s):
        NONE

    Returns:
        Save data [ARRAY]
*/

fnc_cleanSerializedItemsOfContainers = {
    private _containers = _this select 0;
    private _containerCount = count _containers;
    private _items = _this select 1;
    private _itemCount = count (_items select 0);

    private _deletionIndexes = [];

    if (_containerCount > 0 && _itemCount > 0) then {
        for "_i" from 0 to _containerCount - 1 do {
            private _containerClass = _containers select _i select 0;

            for "_j" from 0 to _itemCount - 1 do {
                private _itemClass = _items select 0 select _j;

                if (_itemClass == _containerClass) then {
                    _deletionIndexes append [_j];
                };
            };
        };
    };

    private _deletionCount = count _deletionIndexes;
    private _deletedCount = 0;
    if (_deletionCount > 0) then {
        for "_i" from 0 to _deletionCount - 1 do {
            private _index = (_deletionIndexes select _i) - _deletedCount;

            (_items select 0) deleteAt _index;
            (_items select 1) deleteAt _index;
            _deletedCount = _deletedCount + 1;
        };
    };

    _items;
};

fnc_serializeContainerCargo = {
    private _return = [];

    private _target = _this select 0;
    private _containers = everyContainer _target;
    private _containerCount = count _containers; 

    if (_containerCount > 0) then {
        for "_i" from 0 to _containerCount - 1 do { 
            private _container = _containers select _i;
            private _containerClass = _container select 0;
            private _containerRef = _container select 1;

            private _weaponCargo = weaponsItemsCargo _containerRef;
            private _magazineCargo = getMagazineCargo _containerRef;
            private _itemCargo = getItemCargo _containerRef;

            _return append [[_containerClass, _weaponCargo, _magazineCargo, _itemCargo]];
        };
    };

    _return;
};

fnc_serializeCargo = {
    private _return = [];
    private _target = _this select 0;

    private _weaponCargo = weaponsItemsCargo _target;
    private _magazineCargo = getMagazineCargo _target;
    private _itemCargo = getItemCargo _target;
    private _containerCargo = [_target] call fnc_serializeContainerCargo;

    _itemCargo = [_containerCargo, _itemCargo] call fnc_cleanSerializedItemsOfContainers;

    _return = [_weaponCargo, _magazineCargo, _itemCargo, _containerCargo];
    _return;
};

private _objectsToSave = [];
private _resourceStorages = [];
private _aiGroups = [];

private _allObjects = [];
private _allStorages = [];
private _allMines = [];
private _allCrates = [];

// Get all blufor AI groups
private _allBlueGroups = allGroups select {
    (side _x == west) &&                                    // Only BLUFOR groups (assuming west is BLUFOR side)
    count units _x > 1 &&                                   // Groups with more than one member
    {isPlayer _x} count units _x == 0 &&                    // No player units in the group
    {isNull objectParent (leader _x)} &&                    // Make sure it's an infantry group
    {!(((units _x) select {alive _x}) isEqualTo [])} &&     // At least one unit has to be alive
    (groupId _x) find "HQ" == -1                            // Group name does not contain "HQ"
};


// Fetch all objects near each FOB
private ["_fobPos", "_fobObjects", "_grpUnits", "_fobMines"];
{
    _fobPos = _x;
    _fobObjects = (_fobPos nearObjects (KPLIB_range_fob * 1.2)) select {
        ((toLowerANSI (typeof _x)) in KPLIB_classnamesToSave) &&    // Exclude classnames which are not in the presets
        {alive _x} &&                                               // Exclude dead or broken objects
        {getObjectType _x >= 8} &&                                  // Exclude preplaced terrain objects
        {speed _x < 5} &&                                           // Exclude moving objects (like civilians driving through)
        {isNull attachedTo _x} &&                                   // Exclude attachTo'd objects
        {((getpos _x) select 2) < 10} &&                            // Exclude hovering helicopters and the like
        {!(_x getVariable ["KPLIB_edenObject", false])} &&          // Exclude all objects placed via editor in mission.sqm
        {!(_x getVariable ["KPLIB_preplaced", false])} &&           // Exclude preplaced (e.g. little birds from carrier)
        {!((toLowerANSI (typeOf _x)) in KPLIB_crates)} &&           // Exclude storage crates (those are handled separately)
        typeOf _x != "Land_ClutterCutter_large_F"
    };

    _allObjects = _allObjects + (_fobObjects select {!((toLowerANSI (typeOf _x)) in KPLIB_storageBuildings)});
    _allStorages = _allStorages + (_fobObjects select {(_x getVariable ["KPLIB_storage_type",-1]) == 0});

    // Fetch all mines around FOB
    _fobMines = allMines inAreaArray [_fobPos, KPLIB_range_fob * 1.2, KPLIB_range_fob * 1.2];
    _allMines append (_fobMines apply {[
        getPosWorld _x,
        [vectorDirVisual _x, vectorUpVisual _x],
        typeOf _x,
        _x mineDetectedBy KPLIB_side_player
    ]});
} forEach KPLIB_sectors_fob;

// Fetch all remaining blufor vehicles and supports that are not near a fob
_allObjects = _allObjects + (vehicles select {
    (((toLowerANSI (typeOf _x)) in KPLIB_b_allVeh_classes) ||     // All Blufor vehicles
    ((toLowerANSI (typeOf _x)) in KPLIB_b_support_classes) ||     // All supports
    (_x getVariable ["KPLIB_captured", false])) &&                // All Captured vehicles
    typeOf _x != "B_Quadbike_01_F" &&                             // Exclude Quadbikes
    {alive _x} &&                                                 // Exclude dead or broken objects
    {isNull attachedTo _x} &&                                     // Exclude attachTo'd objects
    {!(_x getVariable ["KPLIB_edenObject", false])} &&            // Exclude all objects placed via editor in mission.sqm
    {!(_x getVariable ["KPLIB_preplaced", false])} &&             // Exclude preplaced (e.g. little birds from carrier)
    {!((toLowerANSI (typeOf _x)) in KPLIB_crates)} &&             // Exclude storage crates (those are handled separately)
    !(_x in _allObjects)                                          // Exclude vehicles already in _allObjects
});

_allObjects = _allObjects + KPLIB_tents;

// Fetch all infantry groups
{
    // Get only living AI units
    _grpUnits = (units _x) select {alive _x};
    // Add to save array
    _aiGroups pushBack [getPosATL (leader _x), (_grpUnits apply {typeOf _x}), groupId _x];
} forEach (_allBlueGroups);

// Save all fetched objects
private ["_savedPos", "_savedVecDir", "_savedVecUp", "_class", "_hasCrew", "_inventory", "_fuel", "_fuelCargo", "_damages"];
{
    // Position data
    _savedPos = getPosWorld _x;
    _savedVecDir = vectorDirVisual _x;
    _savedVecUp = vectorUpVisual _x;
    _class = typeOf _x;
    _hasCrew = false;
	_inventory = [];

    // Determine if vehicle is crewed
    if ((toLowerANSI _class) in KPLIB_b_allVeh_classes) then {
        if (({!isPlayer _x} count (crew _x) ) > 0) then {
            _hasCrew = true;
        };
    };

    // Only save player side, seized or captured objects
    if (
        (!(_class in KPLIB_c_vehicles) || {_x getVariable ["KPLIB_seized", false]}) &&
        (!((toLowerANSI _class) in KPLIB_o_allVeh_classes) || {_x getVariable ["KPLIB_captured", false]})
    ) then {
        
        // Serialize inventory
        _inventory = [_x] call fnc_serializeCargo;
        
        _fuel = fuel _x;
        if (!KPLIB_ace_refuel) then { _fuelCargo = getFuelCargo _x; };
        if (KPLIB_ace_refuel) then { _fuelCargo = _x call ace_refuel_fnc_getFuel; };
        _damages = getAllHitPointsDamage _x;
        
        _objectsToSave pushBack [_class, _savedPos, _savedVecDir, _savedVecUp, _hasCrew, _inventory, _fuel, _fuelCargo, _damages];
    };
	
	
} forEach _allObjects;

// Save all storages and resources
private ["_supplyValue", "_ammoValue", "_fuelValue"];
{
    // Position data
    _savedPos = getPosWorld _x;
    _savedVecDir = vectorDirVisual _x;
    _savedVecUp = vectorUpVisual _x;
    _class = typeOf _x;

    // Resource variables
    _supplyValue = 0;
    _ammoValue = 0;
    _fuelValue = 0;

    // Sum all stored resources of current storage
    {
        switch ((typeOf _x)) do {
            case KPLIB_b_crateSupply: {_supplyValue = _supplyValue + (_x getVariable ["KPLIB_crate_value",0]);};
            case KPLIB_b_crateAmmo: {_ammoValue = _ammoValue + (_x getVariable ["KPLIB_crate_value",0]);};
            case KPLIB_b_crateFuel: {_fuelValue = _fuelValue + (_x getVariable ["KPLIB_crate_value",0]);};
            default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
        };
    } forEach (attachedObjects _x);

    // Add to saving with corresponding resource values
    _resourceStorages pushBack [_class, _savedPos, _savedVecDir, _savedVecUp, _supplyValue, _ammoValue, _fuelValue];
} forEach _allStorages;

// Save crates at blufor sectors which spawn crates on activation
{
    _allCrates append (
        ((nearestObjects [markerPos _x, KPLIB_crates, KPLIB_range_sectorCapture]) select {isNull attachedTo _x}) apply {
            [typeOf _x, _x getVariable ["KPLIB_crate_value", 0], getPosATL _x]
        }
    );
} forEach (KPLIB_sectors_player select {_x in KPLIB_sectors_factory || _x in KPLIB_sectors_city});

// Pack all stats in one array
private _stats = [
    stats_ammo_produced,
    stats_ammo_spent,
    stats_blufor_soldiers_killed,
    stats_blufor_soldiers_recruited,
    stats_blufor_teamkills,
    stats_blufor_vehicles_built,
    stats_blufor_vehicles_killed,
    stats_civilian_buildings_destroyed,
    stats_civilian_vehicles_killed,
    stats_civilian_vehicles_killed_by_players,
    stats_civilian_vehicles_seized,
    stats_civilians_healed,
    stats_civilians_killed,
    stats_civilians_killed_by_players,
    stats_fobs_built,
    stats_fobs_lost,
    stats_fuel_produced,
    stats_fuel_spent,
    stats_hostile_battlegroups,
    stats_ieds_detonated,
    stats_opfor_killed_by_players,
    stats_opfor_soldiers_killed,
    stats_opfor_vehicles_killed,
    stats_opfor_vehicles_killed_by_players,
    stats_player_deaths,
    stats_playtime,
    stats_prisoners_captured,
    stats_readiness_earned,
    stats_reinforcements_called,
    stats_resistance_killed,
    stats_resistance_teamkills,
    stats_resistance_teamkills_by_players,
    stats_secondary_objectives,
    stats_sectors_liberated,
    stats_sectors_lost,
    stats_potato_respawns,
    stats_supplies_produced,
    stats_supplies_spent,
    stats_vehicles_recycled
];

// Pack the weights in one array
private _weights = [
    infantry_weight,
    armor_weight,
    air_weight
];

// Pack the save data in the save array
[
    KPLIB_version,
    date,
    _objectsToSave,
    _resourceStorages,
    _stats,
    _weights,
    _aiGroups,
    KPLIB_sectors_player,
    KPLIB_enemyReadiness,
    KPLIB_sectors_fob,
    KPLIB_permissions,
    KPLIB_vehicle_to_military_base_links,
    KPLIB_civ_rep,
    KPLIB_clearances,
    KPLIB_guerilla_strength,
    KPLIB_logistics,
    KPLIB_production,
    KPLIB_production_markers,
    resources_intel,
    _allMines,
    _allCrates,
    KPLIB_sectorTowers
] // return
