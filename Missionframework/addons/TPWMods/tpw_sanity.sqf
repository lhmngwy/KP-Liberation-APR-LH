/* 
TPW SANITY - Prevent wheeled/tracked vehicles from constantly running over friendly footbound units.
Author: tpw 
Date: 20190514
Version: 1.01
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_sanity.sqf
2 - Call it with 0 = [1,100,20,5,15,6,1,1] execvm "tpw_sanity.sqf"; where 100 = radius around player to scan for vehicles. 20 = any footbounds within this distance of a vehicle will cause it to slow down. 5 = any footbounds within this radius of a vehicle will cause it to stop. 15 = top speed (metres per sec) of scanned vehicles. 6 = top speed (metres per sec) of vehicles with nearby footbounds. 1= affect all vehicles (0 = affect only TPW MODS vehicles). 1 = collision between AI vehicles and footbound friendlies disabled (0 = collisions enabled)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 7) exitwith {player sidechat "TPW SANITY incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_sanity_version = "1.01"; // Version string
tpw_sanity_scanradius = _this select 0;
tpw_sanity_slowradius = _this select 1;
tpw_sanity_stopradius = _this select 2;
tpw_sanity_scanspeed = _this select 3;
tpw_sanity_slowspeed = _this select 4;
tpw_sanity_affectall = _this select 5;
tpw_sanity_collisiondisabled = _this select 6;
tpw_sanity_active = true;
tpw_sanity_vehicles = [];
tpw_sanity_othervehicles = [];

// SCAN FOR VEHICLES AROUND PLAYER
tpw_sanity_fnc_vehiclescan = 
	{
	while {true} do
		{
		if (tpw_sanity_active) then
			{
			tpw_sanity_vehicles = (player nearentities [["car","tank"],tpw_sanity_scanradius]) select {simulationenabled _x};
			tpw_sanity_vehicles = tpw_sanity_vehicles - [vehicle player];
			if (tpw_sanity_affectall == 0) then
				{
				tpw_sanity_vehicles = tpw_sanity_vehicles select {(_x getvariable ["tpw_veh",-1]) == 1}
				};
				
			tpw_sanity_othervehicles = vehicles - tpw_sanity_vehicles;
				{
				_x forcespeed -1;
				} foreach tpw_sanity_othervehicles;	
				
				{
				_y = _x;
					{
					_y disablecollisionwith _x; 
					_x disablecollisionwith _y; 
					}foreach tpw_sanity_vehicles;
				} foreach tpw_sanity_vehicles;		
			};
		sleep 5;
		}; 
	};

// CARS SLOW DOWN OR STOP NEAR FOOTBOUND UNITS
tpw_sanity_fnc_slowdown =
	{
	private ["_cars","_car","_near","_verynear"];
	while {true} do
		{
		if (tpw_sanity_active) then
			{
				{
				_car = _x;
				_near = (_car nearentities["camanbase",tpw_sanity_slowradius]) select {(side _x) getFriend (side driver _car) > 0.6};
					
				if (count _near > 0) then
					{
					driver _car setspeedmode "LIMITED";
					
					// Disable collisions
					if ( tpw_sanity_collisiondisabled == 1) then
						{
							{
							_car disablecollisionwith _x; 
							_x disablecollisionwith _car; 
							} foreach _near;
						};

					_verynear = _near select {_car distance _x < tpw_sanity_stopradius};
					if (count _verynear > 0) then
						{
						_car forcespeed 1; // stop car
						} else
						{
						_car forcespeed tpw_sanity_slowspeed; // slow car
						};		
					} else
					{
					_car forcespeed tpw_sanity_scanspeed; // moderate car
					};
				} foreach tpw_sanity_vehicles;
			};	
		sleep random 0.5;
		};
	};
	
// RUN IT
sleep 5;	
[] spawn tpw_sanity_fnc_vehiclescan;
[] spawn tpw_sanity_fnc_slowdown;
while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};