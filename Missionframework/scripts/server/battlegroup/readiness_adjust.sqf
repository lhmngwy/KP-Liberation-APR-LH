scriptName "readiness_adjust";

waitUntil {!isNil "KPLIB_saveLoaded" && {KPLIB_saveLoaded}};

while {true} do {
    if (KPLIB_enemyReadiness > count KPLIB_sectors_player) then {
        KPLIB_enemyReadiness = KPLIB_enemyReadiness - (0.5 / (KPLIB_param_difficulty min 1));
    };
    if (KPLIB_enemyReadiness < count KPLIB_sectors_player) then {
        KPLIB_enemyReadiness = KPLIB_enemyReadiness + (0.5 * (KPLIB_param_difficulty min 1));
        stats_readiness_earned = stats_readiness_earned + (0.5 * (KPLIB_param_difficulty min 1));
    };
    if (KPLIB_enemyReadiness < 0) then {KPLIB_enemyReadiness = 0};
    if (KPLIB_enemyReadiness > 100.0 && KPLIB_param_difficulty < 2) then {KPLIB_enemyReadiness = 100.0};
    sleep 300;
};
