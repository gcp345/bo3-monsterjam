// OOB - Out Of Bounds
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_utility;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterJamOOB;

REGISTER_SYSTEM( #"MonsterJamOOB", &__init__, undefined )

function __init__()
{
	//util::registerClientSys( "oob_mgr" );

	clientfield::register( "vehicle", "water_splash", VERSION_SHIP, 1, "counter" );
	clientfield::register( "scriptmover", "water_splash", VERSION_SHIP, 1, "counter" );

	oob_trigs = GetEntArray( "mj_oob", "targetname" );

	foreach( trig in oob_trigs )
	{
		trig thread oob_think();
	}
}

function oob_think()
{
	while( IsDefined( self ) )
	{
		self waittill( "trigger", e_who );

		if( IsDefined( e_who ) )
		{
			if( IsPlayer( e_who ) )
			{
				continue;
			}

			if( IsVehicle( e_who ) )
			{
				if( IS_TRUE( e_who.is_in_oob ) )
				{
					continue;
				}

				self thread do_trigger_special_effect( e_who );

				e_who thread MonsterTruck::doRespawn( 1 );
				e_who.owner thread MonsterJamUtility::SetOOBCamera( 1, e_who.owner GetPlayerCameraPos(), e_who );
			}
		}
	}
}

function do_trigger_special_effect( ent )
{
	if( IsPlayer( ent ) )
	{
		return;
	}

	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	switch( self.script_noteworthy )
	{
		case "water":
		{
			ent clientfield::increment( "water_splash" );
			break;
		}

		default:
		{
			break;
		}
	}
}