/*
	AI Driving Control

	Author:
	RCA3

	Description:
	Gives more control to AI drivers.
	Script uses nearEntities to find vehicles/men, calculates relative angles to nearest one and applies forceSpeed depending on situation.

	Usage:
	GetIn EventHandler:
	this addEventHandler ["Getin", {_this spawn AIDC_fnc_main}];

	Dependencies:
	functions\fn_vehiclesaround.sqf
	functions\fn_vehiclessort.sqf

	Returns:
	_driver forceSpeed -1;
*/

params ["_car", "_role", "_driver"];

//Exit non-wheeled, non-driver, player as driver, NOAIDRIVINGCONTROL variable and non-local drivers
if (!(_car isKindOf "Car" || _car isKindOf "Motorcycle" || _car isKindOf "Tank") || {!(_role isEqualTo "driver")} || {isPlayer _driver} || {_car getVariable "NOAIDRIVINGCONTROL"} || {!(local _driver)}) exitWith{};

private _bboxwcoefdef = [2, 2] select (_car isKindOf "Tank"); //tanks are wider
private _bboxlcoefdef = [2, 2] select (_car isKindOf "Tank"); //tanks may be longer

private _bboxwcoef = _car getVariable ["AIDCBBOXWIDTHCOEF", _bboxwcoefdef];
private _bboxlcoef = _car getVariable ["AIDCBBOXLENGTHCOEF", _bboxlcoefdef];

private _carbb = 0 boundingBoxReal _car;
private _carp1 = _carbb # 0;
private _carp2 = _carbb # 1;
private _carwidth = (abs ((_carp2 # 0) - (_carp1 # 0))) / 2; //half width
private _carlength = (abs ((_carp2 # 1) - (_carp1 # 1))) / 2; //half length

#define AIDCBUFFER (15 + (_carlength * 8))
#define AIDCBUFFERHALF (AIDCBUFFER / 2)

#define AIDCCLOSEGAP (20 + (_carlength * 2))

#define AIDCCARWIDTHTIGHT (_carwidth * 2)
#define AIDCCARWIDTHWIDE (_carwidth * 8)

#define AIDCSLEEPT (sleep 0.2)
#define AIDCSLEEPBOX (sleep 3)

#define AIDCBBOXW ((1 max _carwidth) * _bboxwcoef)
#define AIDCBBOXL ((1 max _carlength) * _bboxlcoef) //1.5

#define AIDCCAR _car

#define AIDCCARSPEED(SPEED) AIDCCAR forceSpeed SPEED;
#define AIDCCARFOLLOW(LEADER) AIDCCAR doFollow LEADER;

private _stopcar = objNull;
private _t = 0;

private _groupcar = group _car;

private _side = side _driver;
private _sides = [west, east, civilian, resistance];
_sidefriends = _sides select {[_side, _x] call BIS_fnc_sideIsFriendly};

#define AIDCSIDEFRIENDS _sidefriends

private _frontcar = objNull;
private _dist = 0;
private _carfrontpos = [0,0,0];
private _cardir = 0;

private _scan = false;

private _followtime = time + 10;

#define AIDCAIMODES ["VEHICLE PLANNED", "LEADER PLANNED"]

//Group convoy distance aka help prevent losing formation
private _convoyseparation = _car getVariable ["AIDCCONVOYSEPARATION", AIDCBUFFERHALF];
_car setConvoySeparation _convoyseparation;

//Gates
AIDCCARSPEED(0); //wait for objects scan
private _bargatetypes = ["Land_BarGate_01_open_F", "Land_BarGate_F", "Land_RoadBarrier_01_F"];
private _gates = (allMissionObjects "Wall_F") select {private _object = _x; _bargatetypes findIf {_object isKindOf _x} isNotEqualTo -1};

//Randomization for execution time
sleep (random 3);

while {alive _driver && !(isNull (objectParent _driver))} do{
	_carfrontpos = _car modelToWorld [0,_carlength,0]; //position of front of vehicle (hood)
	_cardir = getDir _car;

	//Find front car
	if (isNull _stopcar) then{
		//All vehicles around
		private _carspeed = (speed _car + 30) * 1.25;
		private _carsarray = [_car,_carspeed] call AIDC_fnc_vehiclesaround;

		//Append gates
		_carsarray append (_gates select {_x distance _car <= _carspeed});

		if (_carsarray isNotEqualTo []) then{
			//Men inside bounding box
			while {true} do{
				scopeName "menbboxarea";

				private _menbboxidx = _carsarray findIf {_x isKindOf "Man" && {_x inArea [getPos _car,AIDCBBOXW,AIDCBBOXL,_cardir,true]} && {(side _x) in AIDCSIDEFRIENDS} && {isNull (objectParent _x)} && {alive _x}}; //&& {abs ((getPosATL _x) # 2) <= abs ((getPosATL AIDCCAR) # 2)} //indoors-sidewalks

				if (_menbboxidx isEqualTo -1 || {!alive _driver} || {isNull (objectParent _driver)} || {(behaviour _driver) isEqualTo "STEALTH"} || (vehicleMoveInfo _car) # 0 isEqualTo "DirectByComander") then{
					breakOut "menbboxarea";
				}else{
					AIDCCARSPEED(2);

					AIDCSLEEPBOX;
				};
			};

			//Vehicles relative direction front
			private _carsinfrontarray = [];
			_carsinfrontarray = _carsarray select {cos ((_carfrontpos getDir _x) - _cardir) > 0};

			//Nearest vehicle in front
			if (_carsinfrontarray isNotEqualTo []) then{
				//Sort front cars
				private _carsinfrontsorted = [_carsinfrontarray, _carfrontpos] call AIDC_fnc_vehiclessort;

				//Front car and front car distance
				_dist = (_carsinfrontsorted # 0) # 0;
				_frontcar = (_carsinfrontsorted # 0) # 1;

				_scan = true;
			}else{
				_scan = false;
			};
		}else{
			_scan = false;
		};
	}else{
		_scan = [false, true] select (cos ((_carfrontpos getDir _stopcar) - _cardir) > 0); //Vehicle in front

		if (_scan) then{
			//Stop car
			_frontcar = _stopcar;
			_dist = _carfrontpos distance _frontcar;
		};
	};

	if (_scan && {!((behaviour _driver) isEqualTo "STEALTH")}) then{ //Scan and bypass scan on STEALTH
		switch (true) do{
			//Gates
			case (_gates findIf {_frontcar isEqualTo _x} isNotEqualTo -1):{
				if (_frontcar animationPhase "Door_1_rot" < 1 && {damage _frontcar < 1}) then{ //There's a gate ahead lowered undamaged
					if (_dist > 15) then{
						AIDCCARSPEED(10); //slow down
						_stopcar = objNull;
					}else{
						AIDCCARSPEED(0); //stop
						_stopcar = _frontcar;
					};
				}else{
					//Speed up
					AIDCCARSPEED(-1);
					_stopcar = objNull;
				};
			};

			//Men
			case (_frontcar isKindOf "Man"):{
				//Friendlies check and indoors check
				if (!((side _frontcar) in AIDCSIDEFRIENDS) || {abs ((getPosATL _frontcar) # 2) > abs ((getPosATL _car) # 2)}) exitWith{AIDCCARSPEED(-1); _stopcar = objNull}; //CARSPEED(10)

				//Friendlies check
				//if !((side _frontcar) in AIDCSIDEFRIENDS) exitWith{AIDCCARSPEED(-1); _stopcar = objNull};

				private _reldir = (_carfrontpos getDir _frontcar) - _cardir;
				private _heading = [abs _reldir, 360 - (abs _reldir)] select (abs _reldir > 180);
				private _speed = -1;
				private _seg = 2*_dist*(sin _heading/2); //chord length https://en.wikipedia.org/wiki/Circular_segment
				private _distsqr = sqrt (_dist^2-_carwidth^2);

				_speed = (_seg + (_distsqr / 4)) max 0;

				if (_speed isEqualTo 0) then{
					_stopcar = _frontcar;
				}else{
					_stopcar = objNull;

					//Unstuck vehicle
					_groupcar setCurrentWaypoint [_groupcar, currentWaypoint _groupcar]; //Arma bug?
				};

				AIDCCARSPEED(_speed);
			};

			//Cars
			case (_frontcar isKindOf "LandVehicle"):{
				//Same group front car in formation aka auto drive, on road vs offroad and enemy
				if (((group _frontcar) isEqualTo _groupcar && {!((expectedDestination _driver) # 1 in AIDCAIMODES)}) || {isOnRoad ASLToAGL getPosASL _car && {!(isOnRoad ASLToAGL getPosASL _frontcar)}} || {!((side _frontcar) in AIDCSIDEFRIENDS)}) exitWith{
					AIDCCARSPEED(-1);
					_stopcar = objNull;
				};

				//Bypass destroyed, empty, not alive, same group (not leader without player) car.
				if (!(canMove _frontcar) || {isNull (driver _frontcar)} || {!(alive (driver _frontcar))} || {(group _frontcar) isEqualTo _groupcar && (leader _groupcar) in _car && !(isPlayer (leader _groupcar))}) exitWith{
					AIDCCARSPEED(5);
					_stopcar = objNull;
				};

				private _reldir = (_carfrontpos getDir _frontcar) - _cardir;
				private _heading = [abs _reldir, 360 - (abs _reldir)] select (abs _reldir > 180);
				private _heading360 = [_reldir, 360 - abs _reldir] select (_reldir < 0);
				private _delta = [getDir _frontcar, _cardir] call BIS_fnc_getAngleDelta; //180�-0�R -180�-0�L
				private _speedfront = speed _frontcar / 3.6; //km/h > m/s
				private _speed = -1;
				private _moving = !(floor _speedfront isEqualTo 0);
				private _seg = 2*_dist*(sin _heading/2); //chord length https://en.wikipedia.org/wiki/Circular_segment

				if (abs _delta > 150) exitWith{ //oncoming traffic at < 30� rotation
					AIDCCARSPEED(10);
					_stopcar = objNull;
				};

				if ((_heading + abs _delta) % 360 < 90 && {_seg <= 15}) then{ //Facing both left and right
					if (_dist > AIDCBUFFER) then{
						if (_moving) then{
							_speed = _speedfront * 1.25;
						}else{
							_speed = 20; //approach stopped
						};
						_stopcar = objNull;
					}else{
						if (_moving) then{
							_speed = [_speedfront, (speed _car / 3.6) * 0.65 max 0] select (_dist < (speed _car / 3.6) * 2 max AIDCCLOSEGAP);
							_stopcar = [objNull, _frontcar] select (_speed isEqualTo 0); //move if buffer or stop if don't
						}else{
							_speed = [0, (speed _car / 3.6) * 0.25 max 5] select (_dist > AIDCCLOSEGAP); //close gaps
							_stopcar = [objNull, _frontcar] select (_dist < AIDCCLOSEGAP); //move if buffer or stop if don't
						};
					};
					_t = 0;
				}else{ //outside of angle
					if (_heading360 < 180) then{ //right
						if (_dist > AIDCBUFFERHALF) then{ //slow down
							_speed = 20; //approach
							_t = 0;
							_stopcar = objNull;
						}else{
							if (_delta < 0) then{ //frontcar facing left
								if (_seg > AIDCCARWIDTHWIDE) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + 0.2, 0] select _moving; //timer
									if (_t < 5) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							}else{ //frontcar facing right
								if (_seg > AIDCCARWIDTHTIGHT) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + 0.2, 0] select _moving; //timer
									if (_t < 3) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							};
						};
					}else{ //left
						if (_dist > AIDCBUFFERHALF) then{ //slow down
							_speed = 20; //approach
							_t = 0;
							_stopcar = objNull;
						}else{
							if (_delta < 0) then{ //frontcar facing left
								if (_seg > AIDCCARWIDTHWIDE) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + 0.2, 0] select _moving; //timer
									if (_t < 5) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							}else{ //frontcar facing right
								if (_seg > AIDCCARWIDTHTIGHT) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + 0.2, 0] select _moving; //timer
									if (_t < 3) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							};
						};
					};
				};

				//Speed up
				AIDCCARSPEED(_speed);
			};

			//Default
			default{
				//Speed up
				AIDCCARSPEED(-1);
				_stopcar = objNull;
			};
		};
	}else{
		//Speed up
		AIDCCARSPEED(-1);
		_stopcar = objNull;

		if (time > _followtime  && {speed _car < 1} && {!((expectedDestination _driver) # 1 in AIDCAIMODES)} && {_driver distance (formationPosition _driver) > 50} && {!(isPlayer (leader _groupcar))}) then{
			AIDCCARFOLLOW(leader _groupcar);
			_followtime = time + 10;

			private _formpos = formationPosition _driver;
			_driver commandMove _formpos;
			_driver moveTo _formpos;
		};
	};

	AIDCSLEEPT;
};

_driver forceSpeed -1;