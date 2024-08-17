scriptName "remote_call_sector";

if ( isDedicated ) exitWith {};

if ( isNil "sector_timer" ) then { sector_timer = 0 };
if ( isNil "pause_sector_timer" ) then { pause_sector_timer = false };

params [ "_sector", "_status" ];

if ( _status == 0 ) then {
    [ "lib_sector_captured", [ markerText _sector ] ] call BIS_fnc_showNotification;
};

if ( _status == 1 ) then {
    [ "lib_sector_attacked", [ markerText _sector ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal ( markerpos _sector );
    sector_timer = KPLIB_vulnerability_timer;
};

if ( _status == 2 ) then {
    [ "lib_sector_lost", [ markerText _sector ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal markers_reset;
    sector_timer = 0;
};

if ( _status == 3 ) then {
    [ "lib_sector_safe", [ markerText _sector ] ] call BIS_fnc_showNotification;
    "opfor_capture_marker" setMarkerPosLocal markers_reset;
    sector_timer = 0;
};

if ( _status == 4 ) then {
    pause_sector_timer = true;
};

if ( _status == 5 ) then {
    pause_sector_timer = false;
};

{ _x setMarkerColorLocal KPLIB_color_enemy; } foreach (KPLIB_sectors_all - KPLIB_sectors_player);
{ _x setMarkerColorLocal KPLIB_color_player; } foreach KPLIB_sectors_player;
