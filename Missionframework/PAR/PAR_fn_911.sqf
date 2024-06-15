params ["_wnded","_medic"];

_medic setHitPointDamage ["hitLegs",0];
_medic allowDamage false;
_medic setCaptive true;

private _grpmedic = createGroup [civilian, true];
[_medic] joinSilent _grpmedic;
_grpmedic setBehaviourStrong "AWARE";

unassignVehicle _medic;
if (!isnull objectParent _medic) then {
  doGetOut _medic;
  sleep 3;
};
_medic stop true;
sleep 1;
{_medic disableAI _x} count ["TARGET","AUTOTARGET","AUTOCOMBAT","SUPPRESSION"];
_medic setUnitPos "UP";
_medic setSpeedMode "FULL";
_medic allowFleeing 0;
_medic allowDamage true;
_medic stop false;

private _dist = (_wnded distance2D _medic);
if ( _dist <= 6 ) then {
  [_wnded, _medic] spawn PAR_fn_sortie
} else {
  if (_dist < 25) then {
    _medic doMove (getPosATL _wnded);
  } else {
    _medic doMove (getPos _wnded);
  };
  sleep 5;
  [_wnded, _medic] spawn PAR_fn_checkMedic;
};
