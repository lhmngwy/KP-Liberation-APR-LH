params ["_carsinfrontarray", "_carfrontpos"];

//Sort front cars
private _carsinfrontsorted = [];
_carsinfrontsorted = _carsinfrontarray apply {[_carfrontpos distance _x, _x]}; //https://community.bistudio.com/wiki/sort Example 4
_carsinfrontsorted sort true;

_carsinfrontsorted