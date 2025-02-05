scriptName "cleanup_vehicles";

private [ "_nextvehicle", "_nearestfob", "_reset_ticker" ];

_cleanup_classnames = [];
{
    _cleanup_classnames append _x;
} forEach [KPLIB_b_light_classes, KPLIB_b_heavy_classes, KPLIB_b_air_classes];

while { KPLIB_param_vehicleCleanup > 0 } do {

    sleep 600;

    {
        _reset_ticker = true;
        _nextvehicle = _x;
        _nearestfob = [ getpos _nextvehicle ] call KPLIB_fnc_getNearestFob;
        if ( count _nearestfob == 3 ) then {
            if ( ( _nextvehicle distance _nearestfob > ( 1.2 * KPLIB_range_fob ) ) && ( _nextvehicle distance startbase > ( 1.2 * KPLIB_range_fob ) ) ) then {
                if ((toLowerANSI (typeof _nextvehicle)) in _cleanup_classnames) then {
                    if ( count ( crew _nextvehicle ) == 0 ) then {
                        _nextvehicle setVariable [ "KPLIB_empty_vehicle_ticker", ( _nextvehicle getVariable [ "KPLIB_empty_vehicle_ticker", 0 ] ) + 1 ];
                        _reset_ticker = false;
                    };
                };
            };
        } ;

        if ( _reset_ticker ) then {
            _nextvehicle setVariable  [ "KPLIB_empty_vehicle_ticker", 0 ];
        };

        if (  _nextvehicle getVariable [ "KPLIB_empty_vehicle_ticker", 0 ] >= ( 6 * KPLIB_param_vehicleCleanup ) ) then {
            deleteVehicle _nextvehicle;
        };

        sleep 0.5;
    } foreach vehicles;
};
