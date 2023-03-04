#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterJamUtility;

REGISTER_SYSTEM( #"MonsterJamUtility", &__init__, undefined )

function __init__()
{
	clientfield::register( "vehicle", "reinit_vehicle_sounds", VERSION_SHIP, 1, "counter", &reinit_vehicle_sounds, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

// occasionally we have a glitch where engine sounds are stuck on 1.0 the whole time
// not sure what quite causes that
function reinit_vehicle_sounds( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	DEFAULT( self._engine_id, [] );
	DEFAULT( self._engine_id[ localClientNum ], [] );

	if( newVal )
	{
		if( IsDefined( self._engine_id[ localClientNum ][ #"engineidle" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"engineidle" ], 0.05 );
			self._engine_id[ localClientNum ][ #"engineidle" ] = undefined;
		}

		if( IsDefined( self._engine_id[ localClientNum ][ #"engineon" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"engineon" ], 0.05 );
			self._engine_id[ localClientNum ][ #"engineon" ] = undefined;
		}

		if( IsDefined( self._engine_id[ localClientNum ][ #"engineoff" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"engineoff" ], 0.05 );
			self._engine_id[ localClientNum ][ #"engineoff" ] = undefined;
		}

		if( IsDefined( self._engine_id[ localClientNum ][ #"supercharger" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"supercharger" ], 0.05 );
			self._engine_id[ localClientNum ][ #"supercharger" ] = undefined;
		}

		if( IsDefined( self._engine_id[ localClientNum ][ #"enginefat" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"enginefat" ], 0.05 );
			self._engine_id[ localClientNum ][ #"enginefat" ] = undefined;
		}

		if( IsDefined( self._engine_id[ localClientNum ][ #"transmission" ] ) )
		{
			self StopLoopSound( self._engine_id[ localClientNum ][ #"transmission" ], 0.05 );
			self._engine_id[ localClientNum ][ #"transmission" ] = undefined;
		}

		wait 0.1;

		self thread MonsterTruck::engineSounds( localClientNum );
	}
}