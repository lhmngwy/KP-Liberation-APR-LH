scriptName "readiness_increase";

waitUntil {!isNil "KPLIB_saveLoaded" && {KPLIB_saveLoaded}};

while {true} do {
    if (KPLIB_enemyReadiness > count KPLIB_sectors_player) then {
        KPLIB_enemyReadiness = KPLIB_enemyReadiness - (0.5 / KPLIB_param_difficulty);
    };
    if (KPLIB_enemyReadiness < 0) then {KPLIB_enemyReadiness = 0};
    sleep 300;
};
