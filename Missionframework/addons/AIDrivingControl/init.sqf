[] call AIDC_fnc_init; //All vehicles and bargates

//============================================================

//ZEUS
//Thanks to Larrow:
//https://forums.bohemia.net/forums/topic/201526-headless-like-script-to-offload-ai-from-zeuss-client-to-server/

//Dedicated and host
if (isServer) then{
	{
		[_x, "curatorUnitAssigned", {
			params ["_curator", "_player"];

			_curator remoteExec ["AIDC_fnc_zeus", _player];

		}] call BIS_fnc_addScriptedEventHandler;
	}forEach allCurators;
};