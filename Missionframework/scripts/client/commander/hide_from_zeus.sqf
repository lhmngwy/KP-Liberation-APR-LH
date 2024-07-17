[] spawn
{
    while {true} do {
        waitUntil { sleep 0.2; !isNull findDisplay 312 };
        {if ((side _x != side player)
             && !(_x getVariable ["KPLIB_playerSide", false])
             && !(_x getVariable ["KPLIB_preplaced", false])) then {
                _x hideObject true;}} forEach allMissionObjects "ALL";
        {if (side _x != side player) then {_x hideObject true;}} forEach allMines;
        waitUntil { sleep 0.2; isNull findDisplay 312 };
    };
};

[] spawn
{
    while {true} do {
        waitUntil { sleep 0.2; isNull findDisplay 312 };
        {if ((side _x != side player)
             && !(_x getVariable ["KPLIB_playerSide", false])
             && !(_x getVariable ["KPLIB_preplaced", false])) then {
                _x hideObject false;}} forEach allMissionObjects "ALL";
        {if (side _x != side player) then {_x hideObject false;}} forEach allMines;
        waitUntil { sleep 0.2; !isNull findDisplay 312 };
    };
};