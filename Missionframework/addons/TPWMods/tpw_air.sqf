/* 
TPW AIR - Spawn ambient flybys of helicopters and aircraft
Author: tpw 
Date: 20230121
Version: 1.34
Requires: CBA A3
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_air.sqf
2 - Call it with 0 = [10,300,2,[50,250,500],0,[str1,str2,etc]] execvm "tpw_air.sqf"; where 10 = delay until flybys start (s), 300 = maximum time between flybys (sec). 0 = disable, 2 = maximum aircraft at a given time,[50,250,500] flying heights to randomly select, 0 = all aircraft (1 = civilian aircraft excluded, 2 = military aircraft excluded)
*/

if (count _this < 5) exitwith {player sidechat "TPW AIR incorrect/no config, exiting."};
if (_this select 1 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// VARIABLES
tpw_air_version = "1.34"; // Version string
tpw_air_delay = _this select 0; // delay until flybys start
tpw_air_time = _this select 1; // maximum time between flybys
tpw_air_max = _this select 2; // maximum number of aircraft at a given time
tpw_air_heights = _this select 3; // flying heights to randomly select
tpw_air_civexclude = _this select 4; // 0 = all aircraft, 1 = civilian aircraft excluded, 2 = military aircraft excluded
tpw_air_include = _this select 5; // List of strings of planes to include. If empty will use all available

tpw_air_active = true; // Global enable/disabled
tpw_air_speeds = ["NORMAL","FULL"]; // speeds for spawned aircraft
tpw_air_inflight = 0;

// ONLY ADD PLANES FROM INCLUDE LIST IF AVAILABLE
tpw_air_aircraft = [];
	{
	private ["_cfg"];
	_cfg = (configFile >> "CfgVehicles");
	_car = _x;
	_x = [_x, "!",""] call CBA_fnc_replace;
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			_side = getNumber ((_cfg select _i) >> "side");
			if ( (_cfgName isKindOf "plane" ||_cfgName isKindOf "helicopter" ) && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_x,str _cfgname] call BIS_fnc_inString} ) then 
				{
				if (tpw_air_civexclude == 0) then
					{
					tpw_air_aircraft pushback _cfgname;
					};
				if (tpw_air_civexclude == 1 && _side != 3)	then
					{
					tpw_air_aircraft pushback _cfgname;
					};
				if (tpw_air_civexclude == 2 && _side == 3)	then
					{
					tpw_air_aircraft pushback _cfgname;
					};
				};
			};
		};
	} foreach tpw_air_include;

// LIST OF AIRCRAFT - Thanks to Larrow for the code
if (tpw_air_aircraft isequalto []) then
	{
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg)-1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( ((_cfgName isKindOf "plane") || (_cfgName isKindOf "helicopter")) && (getNumber ((_cfg select _i) >> "scope") == 2) ) then  
				{
				if (tpw_air_civexclude == 0) then
					{
					tpw_air_aircraft pushback _cfgName;
					};
				if (tpw_air_civexclude == 1 && getNumber ((_cfg select _i) >> "side") != 3)	then
					{
					tpw_air_aircraft pushback _cfgName;
					};
				if (tpw_air_civexclude == 2 && getNumber ((_cfg select _i) >> "side") == 3)	then
					{
					tpw_air_aircraft pushback _cfgName;
					};	
				};	
			};
		};	
	};

// AIRCRAFT SPAWN AND FLYBY
tpw_air_fnc_flyby =
	{
	private ["_pxoffset","_pyoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos","_heli","_height","_speed","_aircraft","_aircrafttype","_grp","_time","_pilot","_wp0"];
	position (_this select 0) params ["_px","_py"];
	
	// Timer - aircraft will be removed after timout
	_time = time + 300;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_pxoffset = random 750;
	_pyoffset = random 750;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 3000 + (random 3000);
	
	// Pick random aircraft, height and speed
	_aircrafttype = selectrandom tpw_air_aircraft;
	_height = selectrandom tpw_air_heights;
	_speed =  selectrandom tpw_air_speeds;

	// Calculate start and end positions of flyby
	_startx = _px + (_dist * sin _dir) + _pxoffset;
	_endx = _px - (_dist * sin _dir) + _pxoffset;
	_starty = _py + (_dist * cos _dir) + _pyoffset;
	_endy = _py - (_dist * cos _dir) + _pyoffset;
	_startpos = [_startx,_starty,_height];
	_endpos = [_endx,_endy,_height];

	tpw_air_inflight = tpw_air_inflight + 1;
	[_startpos, _endpos, _height, _speed, _aircrafttype, civilian] call BIS_fnc_ambientFlyby;
	
	waitUntil {sleep 5; time > _time };
	tpw_air_inflight = tpw_air_inflight - 1;
	publicvariable "tpw_air_inflight";
	};

// RUN IT
sleep tpw_air_delay;
while {true} do 
	{
		player sidechat "loop";
		private ["_air","_counter"];
		// Spawn new aircraft as necessary	
		if (tpw_air_active && tpw_air_inflight < tpw_air_max) then 
		{
			[player] spawn tpw_air_fnc_flyby;
			sleep tpw_air_time / 2 + (random tpw_air_time/ 2);
		};
	sleep 33.33;	
	};