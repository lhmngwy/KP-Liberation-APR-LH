params ["_allObjsHide","_allObjsShow"];

_HCNetworkID = missionNamespace getVariable ["A3PE_HCNetworkID", clientOwner];
player setVariable ["A3PE_Hiding", true, [2,clientOwner,_HCNetworkID]];

{
  if !(isObjectHidden _x) then {
    _x hideObject true;
  };
} forEach _allObjsHide;

{
  if (isObjectHidden _x) then {
    _x hideObject false;
  };
} forEach _allObjsShow;

player setVariable ["A3PE_Hiding", false, [2,clientOwner,_HCNetworkID]];