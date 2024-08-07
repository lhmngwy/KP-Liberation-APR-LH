#include "\a3\ui_f\hpp\definedikcodes.inc"

if (!isDedicated && hasInterface) then {
  _HCNetworkID = missionNamespace getVariable ["A3PE_HCNetworkID", clientOwner];
  player setVariable ["A3PE_Enabled", true, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_ViewDistance", 10000, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_IsConnectedUav", UAVControl (getConnectedUAV player), [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_ShownUAVFeed", shownUAVFeed, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_ForceRenderDistance", 200, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_HigherQualityAI", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_HigherQualityDead", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_HigherQualityPlayer", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_HigherQualityVehicles", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_EnablePlayerHide", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_EnableVehicleHide", false, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_EnableDeadHide", true, [2,clientOwner,_HCNetworkID]];
  player setVariable ["A3PE_EnableAIHide", true, [2,clientOwner,_HCNetworkID]];
};

if (!hasInterface && {!isDedicated && {!(missionNamespace getVariable ["A3PE_HCOverride", false])}}) then {
  missionNamespace setVariable ["A3PE_HCOverride", true, true];
  missionNamespace setVariable ["A3PE_HCNetworkID", clientOwner, true];
  [] spawn {
    while {true} do {
      _allUnits = allUnits;
      _allDeadMen = allDeadMen;
      _allPlayers = allPlayers;
      _vehicles = vehicles;
      {
        _PlayerEnabled = _x getVariable ["A3PE_Enabled", false];
        if (_PlayerEnabled == true) then {
          [_x,_allUnits,_allDeadMen,_allPlayers,_vehicles] call A3PE_fnc_hideServer;
        };
      } forEach allPlayers;
    }; // While Loop
  }; // Spawn
}; //Is Headless Client


if (isServer) then {
  [] spawn {
    while {!(missionNamespace getVariable ["A3PE_HCOverride", false])} do {
      _allUnits = allUnits;
      _allDeadMen = allDeadMen;
      _allPlayers = allPlayers;
      _vehicles = vehicles;
      {
        _PlayerEnabled = _x getVariable ["A3PE_Enabled", false];
        if (_PlayerEnabled == true) then {
          [_x,_allUnits,_allDeadMen,_allPlayers,_vehicles] call A3PE_fnc_hideServer;
        };
      } forEach allPlayers;
    }; // While Loop
  }; // Spawn
}; // isServer
