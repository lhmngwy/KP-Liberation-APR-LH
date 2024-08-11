params ["_curator"];

_curator addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_entity"];

	_entity remoteExec ["AIDC_fnc_init"]; //Remote execution, all machines, no JIP
}];