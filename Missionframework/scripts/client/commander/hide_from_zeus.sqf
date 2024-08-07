waitUntil { sleep 0.2; !isNull findDisplay 46 };

[] spawn
{
    _HCNetworkID = missionNamespace getVariable ["A3PE_HCNetworkID", clientOwner];
    while {true} do {
        waitUntil { sleep 0.2; !isNull findDisplay 312 };
        player setVariable ["A3PE_Enabled", false, [2,clientOwner,_HCNetworkID]];
        waitUntil {!(player getVariable ["A3PE_Hiding", false])};
        while {!isNull findDisplay 312} do {
            {
                if (!(isPlayer _x)
                    && (side _x != KPLIB_side_player)
                    && !(_x getVariable ["KPLIB_playerSide", false])
                    && !(_x getVariable ["KPLIB_preplaced", false])) then {
                    _x hideObject true;
                } else {
                    _x hideObject false;
                };
            } forEach allMissionObjects "ALL";
            {if (side _x != KPLIB_side_player) then {_x hideObject true;}} forEach allMines;
            sleep 3;
        };

        {
            _x hideObject false;
        } forEach allMissionObjects "ALL";
        {_x hideObject false;} forEach allMines;
        player setVariable ["A3PE_Enabled", true, [2,clientOwner,_HCNetworkID]];
    };
};
