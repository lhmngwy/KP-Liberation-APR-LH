/*
	Description:
	Initiates script version of AIDC and engineoff FSM on vehicles and adds handleDamage EH to bargates.

	Usage:
	//Local only (JIP)
	[] call AIDC_fnc_init; //All vehicles and bargates
	object call AIDC_fnc_init; //One vehicle or bargate
	[object1, object2,...] call AIDC_fnc_init; //Multiple vehicles and/or gates

	//Remote Execution
	[] remoteExec ["AIDC_fnc_init"];
	object remoteExec ["AIDC_fnc_init"];
	[object1, object2, ...] remoteExec ["AIDC_fnc_init"];

	Returns:
	true
*/

//Init params
private _vehicles = [];
private _bargates = [];
private _vehicletypes = ["Car", "Motorcycle", "Tank"];
private _bargatetypes = ["Land_BarGate_01_open_F", "Land_BarGate_F", "Land_RoadBarrier_01_F"];

null = call {
	//One vehicle or one bargate
	if (_this isEqualType objNull) exitWith{
		if !(_vehicletypes findIf {_this isKindOf _x} isEqualTo -1) then{_vehicles pushBack _this};
		if !(_bargatetypes findIf {_this isKindOf _x} isEqualTo -1) then{_bargates pushBack _this};
	};

	if (_this isEqualType []) exitWith{
		//EMPTY param (all vehicles and bargates)
		if (count _this < 1) then{
			_vehicles = vehicles select {private _object = _x; !(_vehicletypes findIf {_object isKindOf _x} isEqualTo -1)}; //All vehicles sorted
			_bargates = (allMissionObjects "Wall_F") select {private _object = _x; !(_bargatetypes findIf {_object isKindOf _x} isEqualTo -1)}; //All bargates
		}else{
		//Array of vehicle(s) and/or bargate(s)
			{
				private _object = _x;

				if !(_vehicletypes findIf {_object isKindOf _x} isEqualTo -1) then{
					_vehicles pushBack _object;
				};

				if !(_bargatetypes findIf {_object isKindOf _x} isEqualTo -1) then{
					_bargates pushBack _object;
				};
			}forEach _this;
		};
	};
};

//Vehicles
{
	//Add Event Handler
	_x addEventHandler ["Getin", {if ((_this # 1) isEqualTo "driver") then{_this spawn AIDC_fnc_main; _this execFSM "addons\AIDrivingControl\engineoff.fsm"}}];

	//Start function if driver inside //(runs a duplicate on config only, not script version)
	if !(isNull (driver _x)) then{null=[_x,"driver",(driver _x)] spawn AIDC_fnc_main; [_x,"driver",(driver _x)] execFSM "addons\AIDrivingControl\engineoff.fsm"};
}forEach _vehicles;

//Bargates
{
	//Add Event Handler
	_x addEventHandler ["HandleDamage", {0}];
}forEach _bargates;

true