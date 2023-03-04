#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\shared\vehicles\_driving_fx;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck_anim;
#using scripts\shared\vehicles\_monster_truck_clientfields;
#using scripts\shared\vehicles\_monster_truck_pieces;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#using_animtree( "mj" );

#namespace MonsterTruck;

REGISTER_SYSTEM( #"MonsterTruck", &__init__, undefined )

function autoexec opt_in()
{
	SetDvar( "vehicle_riding", 1 );
	SetDvar( "scr_veh_driversarehidden", 0 );
	SetDvar( "vehicle_collision_prediction_time", "0.05" );
	SetDvar( "vehicle_selfCollision", "1" );
	//SetDvar( "phys_vehicleWheelEntityCollision", 0 );
	//SetDvar( "phys_disableEntsAndDynEntsCollision", 1 );

	DEFAULT( level.monster_jam_trucks_enable_ua_model, GetDvarInt( "scr_enable_ua", 0 ) == 1 );
}

function __init__()
{
	vehicle::add_vehicletype_callback( "monster_truck", &MonsterTruckClientInit );
}

// this is per client except splitscreen
function MonsterTruckClientInit( localClientNum )
{
	self thread driving_fx::jump_landing_thread( localClientNum );
	self thread driving_fx::suspension_thread( localClientNum );
	self thread driving_fx::collision_thread( localClientNum );

	self MonsterTruckAnim::anim_init( localClientNum );

	// engine sounds DO exist in ape, but...
	// - We need to dynamically change the engine sound
	// - Other players need to hear a different engine sound
	self thread engineSounds( localClientNum );

	// Process spawn callbacks
	if( IsDefined( level._monster_truck_callbacks[ #"spawn" ] ) )
	{
		foreach( callback in level._monster_truck_callbacks[ #"spawn" ] )
		{
			self thread [[ callback ]] ( localClientNum );
		}
	}
}

function RegisterTruckSpawnCallback( callback )
{
	if( !IsDefined( level._monster_truck_callbacks ) )
		level._monster_truck_callbacks = [];

	if( !IsDefined( level._monster_truck_callbacks[ #"spawn" ] ) )
		level._monster_truck_callbacks[ #"spawn" ] = [];

	ARRAY_ADD( level._monster_truck_callbacks[ #"spawn" ], callback );
}

// Playing loop sounds IS per client
// we have to check if players are splitscreen because they stack (since they are differnet clients but same computer)
function engineSounds( localClientNum )
{
	self endon( "entityshutdown" );
	self notify( "engineSounds" );
	self endon( "engineSounds" );

	while( !IsDefined( self.truck_sound_index ) && IsDefined( self ) ) // 1/18/2023 - added a quick isdefined check incase they go oob
	{
		WAIT_CLIENT_FRAME;
	}

	if( IsSplitScreen() && !IsSplitScreenHost( localClientNum ) ) // disable setup for splitscreen players
	{
		return;
	}

	self thread engineSetState( localClientNum, "onhigh", 0.0 );
	self thread engineSetState( localClientNum, "idle", 1.0 );

	while( IsDefined( self ) )
	{
		WAIT_CLIENT_FRAME;

		speed = Abs( self GetSpeed() );

		if( speed <= 50 && self driving_fx::any_wheel_colliding() ) // player could be upside so check for that
		{
			self thread engineSetState( localClientNum, "idle", 1.0 );
			continue;
		}

		max_speed = self GetMaxSpeed() * 0.95;

		pitch = audio::scale_speed( 0, max_speed, 0.07, 0.9, speed );

		if( speed >= max_speed )
		{
			pitch = 0.98;
		}

		// no wheel friction so the engine can rev as high as it can
		if( !self driving_fx::any_wheel_colliding() )
		{
			pitch = audio::scale_speed( 0, 1, 0.0, 0.98, Abs( self GetThrottle() ) );
		}

		// increase pitch on boosting
		if( IS_TRUE( self.truck_boosting ) )
		{
			pitch = 1.15;
		}

		self thread engineSetState( localClientNum, "onhigh", pitch );
	}
}

function engineSetState( localClientNum, state, pitch = 1.0 )
{
	DEFAULT( self._engine_id, [] );
	DEFAULT( self._engine_id[ localClientNum ], [] );
	
	str_sound = self GetSoundPrefix( localClientNum );

	if( !IsDefined( self._engine_id[ localClientNum ][ #"engineidle" ] ) )
	{
		self._engine_id[ localClientNum ][ #"engineidle" ] = self PlayLoopSound( str_sound + "_idle", 1.5 );
	}

	if( !IsDefined( self._engine_id[ localClientNum ][ #"engineon" ] ) )
	{
		self._engine_id[ localClientNum ][ #"engineon" ] = self PlayLoopSound( str_sound + "_onhigh", 1.5 );
	}

	if( !IsDefined( self._engine_id[ localClientNum ][ #"supercharger" ] ) && self.truck_sound_index == 4 && str_sound == "monster1_hot" )
	{
		self._engine_id[ localClientNum ][ #"supercharger" ] = self PlayLoopSound( "sc_onhigh", 1.5 ); // high superscharger squel at high rpm
	}

//	if( !IsDefined( self._engine_id[ localClientNum ][ #"enginefat" ] ) )
//	{
//		self._engine_id[ localClientNum ][ #"enginefat" ] = self PlayLoopSound( "enginefat02", 1.5 ); // makes it sound more dense
//	}

	//if( !IsDefined( self._engine_id[ localClientNum ][ #"transmission" ] ) )
	//{
	//	self._engine_id[ localClientNum ][ #"transmission" ] = self PlayLoopSound( "tw_onhigh", 1.5 );
	//}


	if( IsDefined( pitch ) )
	{
		if( state == "idle" )
		{
			SetSoundPitch( self._engine_id[ localClientNum ][ #"engineidle" ], 0.9 );
			SetSoundVolume( self._engine_id[ localClientNum ][ #"engineidle" ], 1.0 );
			SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], 0.0 );
			SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.0 );
//			SetSoundPitch( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
//			SetSoundVolume( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
			if( self.truck_sound_index == 4 && str_sound == "monster1_hot" )
			{
				SetSoundPitch( self._engine_id[ localClientNum ][ #"supercharger" ], 0.0 );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"supercharger" ], 0.0 );
			}
		}
		else if( state == "offhigh" )
		{
			SetSoundPitch( self._engine_id[ localClientNum ][ #"engineidle" ], 0.0 );
			SetSoundVolume( self._engine_id[ localClientNum ][ #"engineidle" ], 0.0 );
			if( self.truck_sound_index == 4 && str_sound == "monster1_hot" )
			{
				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], pitch );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.3 );
//				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineoff" ], pitch );
//				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineoff" ], 0.3 );
				SetSoundPitch( self._engine_id[ localClientNum ][ #"supercharger" ], pitch );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"supercharger" ], 0.9 ); // supercharger whine is prevelant on trucks like King Krunch
			}
			else
			{
				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], 0.0 );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.0 );
//				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineoff" ], pitch );
//				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineoff" ], 0.7 );
			}
		}
		else
		{
			SetSoundPitch( self._engine_id[ localClientNum ][ #"engineidle" ], 0.0 );
			SetSoundVolume( self._engine_id[ localClientNum ][ #"engineidle" ], 0.0 );
			if( self.truck_sound_index == 4 && str_sound == "monster1_hot" )
			{
				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], pitch );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.3 );
//				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
//				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
				SetSoundPitch( self._engine_id[ localClientNum ][ #"supercharger" ], pitch );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"supercharger" ], 0.9 ); // supercharger whine is prevelant on trucks like King Krunch
			}
			else
			{
				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], pitch );
				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.7 );
//				SetSoundPitch( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
//				SetSoundVolume( self._engine_id[ localClientNum ][ #"engineoff" ], 0.0 );
			}
		}
	}

	/*
	if( self.truck_sound_index == 4 && str_sound == "monster1_hot" )
	{
		SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], pitch );
		SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.7 );
		SetSoundPitch( self._engine_id[ localClientNum ][ #"supercharger" ], pitch );
		SetSoundVolume( self._engine_id[ localClientNum ][ #"supercharger" ], 0.3 ); // supercharger whine is prevelant on trucks like King Krunch
	}
	else
	{
		SetSoundPitch( self._engine_id[ localClientNum ][ #"engineon" ], pitch );
		SetSoundVolume( self._engine_id[ localClientNum ][ #"engineon" ], 0.7 );
	}
	*/
	//SetSoundPitch( self._engine_id[ localClientNum ][ #"enginefat" ], pitch );
	//SetSoundVolume( self._engine_id[ localClientNum ][ #"enginefat" ], 1.0 );
	//SetSoundPitch( self._engine_id[ localClientNum ][ #"transmission" ], pitch );
	//SetSoundVolume( self._engine_id[ localClientNum ][ #"transmission" ], 1.0 );
}

function IsDoingDonut()
{
	return Abs( self GetSteering() ) >= 0.8 && ( 0 < Abs( self GetSpeed() ) && 6 > Abs( self GetSpeed() ) );
}

function GetSoundPrefix( localClientNum )
{
	ourClient = false;

	driverlocalclient = self GetLocalClientDriver();
	if( isdefined( driverlocalclient ) )
	{
		driver = GetLocalPlayer( driverlocalclient );
		if( isdefined( driver ) )
		{
			ourClient = driver == GetLocalPlayer( localClientNum );
		}
	}

	if( !ourClient )
	{
		return "monster3_t1";
	}

	if( self.truck_sound_index == 3 )
	{
		return "monster3_t2";
	}

	// researched this with the actual game by deleting files: they use the same hot sound.
	if( self.truck_sound_index == 4 || self.truck_sound_index == 1 )
	{
		return "monster1_hot";
	}

	return "monster" + self.truck_sound_index;
}

function axel_thread( localClientNum )
{

}