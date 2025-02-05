params ["_player","_allUnits","_allDeadMen","_allPlayers","_vehicles"];
_ViewDistance = _player getVariable ["A3PE_ViewDistance", 10000];
_IsConnectedUav = _player getVariable ["A3PE_IsConnectedUav", [objNull, ""]];
_ShownUAVFeed = _player getVariable ["A3PE_ShownUAVFeed", false];
_ForceRenderDistance = _player getVariable ["A3PE_ForceRenderDistance", 200];
_HigherQualityAI = _player getVariable ["A3PE_HigherQualityAI", false];
_HigherQualityDead = _player getVariable ["A3PE_HigherQualityDead", false];
_EnablePlayerHide = _player getVariable ["A3PE_EnablePlayerHide", false];
_HigherQualityPlayer = _player getVariable ["A3PE_HigherQualityPlayer", false];
_HigherQualityVehicles = _player getVariable ["HigherQualityVehicles", false];
_EnableVehicleHide = _player getVariable ["A3PE_EnableVehicleHide", false];
_EnableDeadHide = _player getVariable ["A3PE_EnableDeadHide", true];
_EnableAIHide = _player getVariable ["A3PE_EnableAIHide", true];
_UAV = getConnectedUAV _player;

_allObjsHide = [];
_allObjsShow = [];
if (_EnableAIHide) then {
{
  _CheckedUnit = _x;
  _vis = 0;
  _selections = ["rightleg","leftleg","rightarm","leftarm","head"];

  if (!isPlayer _CheckedUnit) then {
    if (_ViewDistance > _player distance2D _CheckedUnit) then {
      if (_player distance2D _CheckedUnit > _ForceRenderDistance) then {
        if (isNull objectParent _CheckedUnit) then {
              {
                if (_vis == 0) then { // Skips if unit was already calculated to be seen
                  _pos = _CheckedUnit selectionPosition _x;
                  _pos2 = _CheckedUnit modelToWorld _pos;
                    if (isNull objectParent _player) then {
                      _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    } else {
                      _visnum = [(vehicle _player), "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    };
                    if (_IsConnectedUav select 1 != "" || _ShownUAVFeed) then {
                      _visnum = [_UAV, "VIEW", _CheckedUnit] checkVisibility [getPosASL _UAV, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    };
                    if (_HigherQualityAI) then {
                      _visnumFront = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [0,5,1]), AGLToASL _pos2];  // front
                      _visnumLeft = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [-5,0,1]), AGLToASL _pos2];  // left
                      _visnumRight = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [5,0,1]), AGLToASL _pos2];  // right
                      _vis = _vis + _visnumFront + _visnumLeft + _visnumRight;
                    };
                };
              } forEach _selections;

              if (_vis == 0) then {
              _allObjsHide pushBack _CheckedUnit;
              } else {
              _allObjsShow pushBack _CheckedUnit;
              };
          } else {_allObjsShow pushBack _CheckedUnit;};
        } else {_allObjsShow pushBack _CheckedUnit;};
      } else {_allObjsHide pushBack _CheckedUnit;};
  }; //isPlayer
} forEach _allUnits;
};

if (_EnableDeadHide) then {
{
  _CheckedUnit = _x;
  _vis = 0;
  _selections = ["rightleg","leftleg","rightarm","leftarm","head"];

if (!isPlayer _CheckedUnit) then {
  if (_ViewDistance > _player distance2D _CheckedUnit) then {
    if (_player distance2D _CheckedUnit > _ForceRenderDistance) then {
      if (isNull objectParent _CheckedUnit) then {
          _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL (_CheckedUnit modelToWorld [0,0,0.5])];
            {
              if (_vis == 0) then { // Skips if unit was already calculated to be seen
                _pos = _CheckedUnit selectionPosition _x;
                _pos2 = _CheckedUnit modelToWorld _pos;
                  if (isNull objectParent _player) then {
                    _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  } else {
                    _visnum = [(vehicle _player), "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  };
                  if (_IsConnectedUav select 1 != "" || _ShownUAVFeed) then {
                    _visnum = [_UAV, "VIEW", _CheckedUnit] checkVisibility [getPosASL _UAV, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  };
                  if (_HigherQualityDead) then {
                    _visnumFront = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [0,5,1]), AGLToASL _pos2];  // front
                    _visnumLeft = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [-5,0,1]), AGLToASL _pos2];  // left
                    _visnumRight = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [5,0,1]), AGLToASL _pos2];  // right
                    _vis = _vis + _visnumFront + _visnumLeft + _visnumRight;
                  };
              };
            } forEach _selections;

            if (_vis == 0) then {
            _allObjsHide pushBack _CheckedUnit;
            } else {
            _allObjsShow pushBack _CheckedUnit;
            };
        } else {_allObjsShow pushBack _CheckedUnit;};
      } else {_allObjsShow pushBack _CheckedUnit;};
    } else {_allObjsHide pushBack _CheckedUnit;};
  }; //isPlayer
} forEach _allDeadMen;
};


if (_EnablePlayerHide) then {
{
  _CheckedUnit = _x;
  _vis = 0;
  _selections = ["rightleg","leftleg","rightarm","leftarm","head"];

    if (_ViewDistance > _player distance2D _CheckedUnit) then {
      if (_player distance2D _CheckedUnit > _ForceRenderDistance) then {
        if (isNull objectParent _CheckedUnit) then {
              {
                if (_vis == 0) then { // Skips if unit was already calculated to be seen
                  _pos = _CheckedUnit selectionPosition _x;
                  _pos2 = _CheckedUnit modelToWorld _pos;
                    if (isNull objectParent _player) then {
                      _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    } else {
                      _visnum = [(vehicle _player), "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    };
                    if (_IsConnectedUav select 1 != "" || _ShownUAVFeed) then {
                      _visnum = [_UAV, "VIEW", _CheckedUnit] checkVisibility [getPosASL _UAV, AGLToASL _pos2];
                      _vis = _vis + _visnum;
                    };
                    if (_HigherQualityPlayer) then {
                      _visnumFront = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [0,5,1]), AGLToASL _pos2];  // front
                      _visnumLeft = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [-5,0,1]), AGLToASL _pos2];  // left
                      _visnumRight = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [5,0,1]), AGLToASL _pos2];  // right
                      _vis = _vis + _visnumFront + _visnumLeft + _visnumRight;
                    };
                };
              } forEach _selections;

              if (_vis == 0) then {
              _allObjsHide pushBack _CheckedUnit;
              } else {
              _allObjsShow pushBack _CheckedUnit;
              };
          } else {_allObjsShow pushBack _CheckedUnit;};
        } else {_allObjsShow pushBack _CheckedUnit;};
      } else {_allObjsHide pushBack _CheckedUnit;};
} forEach _allPlayers;
};

if (_EnableVehicleHide) then {
{
  _CheckedUnit = _x;
  _vis = 0;
  _selections = selectionNames _CheckedUnit;

if (!isPlayer _CheckedUnit) then {
  if (_ViewDistance > _player distance2D _CheckedUnit) then {
    if (_player distance2D _CheckedUnit > _ForceRenderDistance) then {
      if (isNull objectParent _CheckedUnit) then {
          _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL (_CheckedUnit modelToWorld [0,0,0.5])];
            {
              if (_vis == 0) then { // Skips if unit was already calculated to be seen
                _pos = _CheckedUnit selectionPosition _x;
                _pos2 = _CheckedUnit modelToWorld _pos;
                  if (isNull objectParent _player) then {
                    _visnum = [_player, "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  } else {
                    _visnum = [(vehicle _player), "VIEW", _CheckedUnit] checkVisibility [eyePos _player, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  };
                  if (_IsConnectedUav select 1 != "" || _ShownUAVFeed) then {
                    _visnum = [_UAV, "VIEW", _CheckedUnit] checkVisibility [getPosASL _UAV, AGLToASL _pos2];
                    _vis = _vis + _visnum;
                  };
                  if (_HigherQualityVehicles) then {
                    _visnumFront = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [0,5,1]), AGLToASL _pos2];  // front
                    _visnumLeft = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [-5,0,1]), AGLToASL _pos2];  // left
                    _visnumRight = [_player, "VIEW", _CheckedUnit] checkVisibility [AGLToASL (_player modelToWorld [5,0,1]), AGLToASL _pos2];  // right
                    _vis = _vis + _visnumFront + _visnumLeft + _visnumRight;
                  };
              };
            } forEach _selections;

            if (_vis == 0) then {
            _allObjsHide pushBack _CheckedUnit;
            } else {
            _allObjsShow pushBack _CheckedUnit;
            };
        } else {_allObjsShow pushBack _CheckedUnit;};
      } else {_allObjsShow pushBack _CheckedUnit;};
    } else {_allObjsHide pushBack _CheckedUnit;};
  }; //isPlayer
} forEach _vehicles;
};

[_allObjsHide,_allObjsShow] remoteExecCall ["A3PE_fnc_hideClient", _player];
