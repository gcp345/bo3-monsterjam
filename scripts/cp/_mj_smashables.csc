#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_score;
#using scripts\cp\_mj_utility;

#using_animtree( "mj" );

#namespace MonsterJamSmashables;

REGISTER_SYSTEM( #"MonsterJamSmashables", &__init__, undefined )

function __init__()
{
	clientfield::register( "scriptmover", "crush_car", VERSION_SHIP, 7, "float", &set_crush_car_state, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function set_crush_car_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if( !self HasAnimTree() )
	{
		self UseAnimTree( #animtree );
	}
	DEFAULT( self.script_animation, "a_crush_car_suv_crush" );
	self ClearAnim( self.script_animation, 0.2 );
	self SetAnimRestart( self.script_animation, newVal, 0.2, 1 );
}