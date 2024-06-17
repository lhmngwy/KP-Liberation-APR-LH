// Return floor random number in _range
params [["_range", [-10,0,10]], ["_min", 0]];
private _rnd = 0;  

while {!(_rnd != 0) || !(abs _rnd > _min)} do {
	_rnd = (floor random _range);      
};   
_rnd;
