[] spawn
{
    while {true} do {
        waitUntil { sleep 1; !isNull findDisplay 312};
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject true;}} forEach allUnits;
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject true;}} forEach vehicles;
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject true;}} forEach allMines;
        waitUntil { sleep 1; isNull findDisplay 312};
    };
};

[] spawn
{
    while {true} do {
        waitUntil { sleep 1; isNull findDisplay 312};
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject false;}} forEach allUnits;
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject false;}} forEach vehicles;
        {if (side _x isEqualTo east || side _x isEqualTo resistance) then {_x hideObject false;}} forEach allMines;
        waitUntil { sleep 1; !isNull findDisplay 312};
    };
};