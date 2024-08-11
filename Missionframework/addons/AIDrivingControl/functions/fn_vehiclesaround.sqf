params ["_car", "_carspeed"];

//All vehicles around
private _carsarray = _car nearEntities [["CAManBase", "Car", "Motorcycle", "Tank"], _carspeed]; //from center

_carsarray deleteAt (_carsarray findIf {_x isEqualTo _car});

_carsarray