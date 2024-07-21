waitUntil { sleep 0.2; !isNull findDisplay 46 };

[] spawn
{
    while {true} do {
        waitUntil { sleep 0.2; !isNull findDisplay 312 };
        {if (!(isPlayer _x)
             && (side _x != KPLIB_side_player)
             && !(_x getVariable ["KPLIB_playerSide", false])
             && !(_x getVariable ["KPLIB_preplaced", false])) then {
                _x hideObject true;}} forEach allMissionObjects "ALL";
        {if (side _x != KPLIB_side_player) then {_x hideObject true;}} forEach allMines;
        waitUntil { sleep 0.2; isNull findDisplay 312 };
        {if (!(isPlayer _x)
             && (side _x != KPLIB_side_player)
             && !(_x getVariable ["KPLIB_playerSide", false])
             && !(_x getVariable ["KPLIB_preplaced", false])) then {
                _x hideObject false;}} forEach allMissionObjects "ALL";
        {if (side _x != KPLIB_side_player) then {_x hideObject false;}} forEach allMines;
    };
};
