#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterJamScore;

REGISTER_SYSTEM( #"MonsterJamScore", &__init__, undefined )

function __init__()
{	
	// This shows you how many points you have going in your combo
	clientfield::register( "clientuimodel", "MonsterTruckScore", VERSION_SHIP, 15, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	// Combo Multiplier
	clientfield::register( "clientuimodel", "MonsterTruckScoreMultiplier", VERSION_SHIP, 6, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	// What score type is it? (Wheelie, Donut, etc.)
	clientfield::register( "clientuimodel", "MonsterTruckScoreType", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	// Bit state for score: (0 = hide, 1 = show, 2 = new trick, 3 = cash in, 4 = combo cancel)
	clientfield::register( "clientuimodel", "MonsterTruckScoreState", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	// The score to show at the top
	clientfield::register( "clientuimodel", "MonsterTruckScoreTotal", VERSION_SHIP, 20, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );

	// Is this a first time bonus? 0 for no, 1 for yes
	clientfield::register( "clientuimodel", "MonsterTruckScoreFTB", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );

	MonsterTruck::RegisterTruckSpawnCallback( &on_truck_spawn );
}

function on_truck_spawn( localClientNum )
{
}