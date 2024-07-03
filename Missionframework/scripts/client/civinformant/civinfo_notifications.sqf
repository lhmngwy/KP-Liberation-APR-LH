if (isDedicated) exitWith {};

params ["_notif_id", ["_pos", getpos player], ["_capturedby", player]];

if (KPLIB_civinfo_debug > 0) then {[format ["civinfo_notifications called on: %1 - Parameters: [%2, %3]", debug_source, _notif_id, _pos], "CIVINFO"] remoteExecCall ["KPLIB_fnc_log", 2];};

switch (_notif_id) do {
    case 0: {
        ["lib_civ_informant_start", [markertext ([10000, _pos] call KPLIB_fnc_getNearestSector)]] call BIS_fnc_showNotification;
        private _informant_marker = createMarkerLocal ["informantmarker", _pos];
        _informant_marker setMarkerColorLocal "ColorCIV";
        _informant_marker setMarkerTypeLocal "hd_unknown";
        
        private _informant_zone = createMarkerLocal ["informantzone", _pos];
        _informant_zone setMarkerColorLocal "ColorCIV";
        _informant_zone setMarkerShapeLocal "ELLIPSE";
        _informant_zone setMarkerBrushLocal "FDiagonal";
        _informant_zone setMarkerSizeLocal [150,150];
    };
    case 1: {
        ["lib_civ_informant_success"] call BIS_fnc_showNotification;
        deleteMarkerLocal "informantmarker";
        deleteMarkerLocal "informantzone";
    };
    case 2: {
        ["lib_civ_informant_fail"] call BIS_fnc_showNotification;
        deleteMarkerLocal "informantmarker";
        deleteMarkerLocal "informantzone";
    };
    case 3: {
        ["lib_civ_informant_death"] call BIS_fnc_showNotification;
        deleteMarkerLocal "informantmarker";
        deleteMarkerLocal "informantzone";
    };
    case 4: {
        ["lib_civ_hvt_start", [markertext ([10000, _pos] call KPLIB_fnc_getNearestSector)]] call BIS_fnc_showNotification;
        private _marker = createMarkerLocal ["HVT_marker", _pos];
        _marker setMarkerColorLocal KPLIB_color_enemyActive;
        _marker setMarkerTypeLocal "hd_unknown";

        private _marker_zone = createMarkerLocal ["HVT_zone", _pos];
        _marker_zone setMarkerColorLocal KPLIB_color_enemyActive;
        _marker_zone setMarkerShapeLocal "ELLIPSE";
        _marker_zone setMarkerBrushLocal "FDiagonal";
        _marker_zone setMarkerSizeLocal [500,500];
    };
    case 5: {
        ["lib_civ_hvt_success"] call BIS_fnc_showNotification;
        deleteMarkerLocal "HVT_marker";
        deleteMarkerLocal "HVT_zone";
    };
    case 6: {
        ["lib_civ_hvt_fail"] call BIS_fnc_showNotification;
        deleteMarkerLocal "HVT_marker";
        deleteMarkerLocal "HVT_zone";
    };
    case 7: {
        ["lib_civ_informant_escort", [name _capturedby]] call BIS_fnc_showNotification;
        deleteMarkerLocal "informantmarker";
        deleteMarkerLocal "informantzone";
    };
    default {[format ["civinfo_notifications.sqf -> no valid value for _notif_id: %1", _notif_id], "ERROR"] remoteExecCall ["KPLIB_fnc_log", 2];};
};
