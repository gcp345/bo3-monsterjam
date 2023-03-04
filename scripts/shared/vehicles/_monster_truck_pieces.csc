#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\clientfield_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterTruckPieces;

REGISTER_SYSTEM( #"MonsterTruckPieces", &__init__, undefined )

function __init__()
{
	SetupMonsterTruckDataArray();
}

// create the piece array here
function SetupMonsterTruckDataArray()
{
	
}