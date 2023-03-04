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

#precache( "client_fx", "monster_jam/boost/fx_monster_truck_boost_blown" );
#precache( "client_fx", "monster_jam/boost/fx_monster_truck_boost_flame" );

#precache( "client_fx", "monster_jam/impacts/fx_monster_truck_impact_asphalt" );

#namespace MonsterTruckCF;

REGISTER_SYSTEM( #"MonsterTruckCF", &__init__, undefined )

function __init__()
{
	// Boost
	// Infinite and Free boost
	if( !level.monster_jam_trucks_enable_ua_model )
	{
		clientfield::register( "clientuimodel", "MonsterTruckBoostInfinite", VERSION_SHIP, 7, "float", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
		clientfield::register( "clientuimodel", "MonsterTruckBoostFree", VERSION_SHIP, 7, "float", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
		clientfield::register( "clientuimodel", "MonsterTruckBoostBlown", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	}
	else
	{
		clientfield::register( "clientuimodel", "MonsterTruckBoostTank1", VERSION_SHIP, 7, "float", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
		clientfield::register( "clientuimodel", "MonsterTruckBoostTank2", VERSION_SHIP, 7, "float", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
		clientfield::register( "clientuimodel", "MonsterTruckBoostIsSecondTank", 1, 1, "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
		clientfield::register( "clientuimodel", "MonsterTruckSpectaclePoints", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	}

	// Vehicle FX
	clientfield::register( "vehicle", "MonsterTruckBoostFX", VERSION_SHIP, 2, "int", &set_vehicle_boosting, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "vehicle", "truckMud", VERSION_SHIP, 10, "int", &set_vehicle_dirt, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "scriptmover", "truckMud", VERSION_SHIP, 10, "int", &set_vehicle_dirt, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "scriptmover", "truckImpact", VERSION_SHIP, 1, "int", &play_damage_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "vehicle", "truckEngineIndex", VERSION_SHIP, GetMinBitCountForNum( 4 ), "int", &set_vehicle_engine_index, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	level._effect[ #"truck_boost" ] = "monster_jam/boost/fx_monster_truck_boost_flame";
	level._effect[ #"truck_blown" ] = "monster_jam/boost/fx_monster_truck_boost_blown";

	level._effect[ #"truck_impact" ] = "monster_jam/impacts/fx_monster_truck_impact_asphalt";

	level.monster_jam_boost_sound = ( level.monster_jam_trucks_enable_ua_model ? "boost3" : "boostfat01" );
}

function set_vehicle_boosting( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if( !IsDefined( self.boost_fx ) )
	{
		self.boost_fx = [];
	}

	if( !IsDefined( self._engine_id ) )
	{
		self._engine_id = [];
	}

	if( newVal > 0 )
	{
		// blown engine
		if( newVal == 2 )
		{
			self.truck_boosting = false;
			self thread setVehicleBoostFX( localClientNum, level._effect[ #"truck_blown" ] );
			self thread setVehicleBoostSound( localClientNum, false );
		}
		else
		{
			self.truck_boosting = true;
			self thread setVehicleBoostFX( localClientNum, level._effect[ #"truck_boost" ] );
			self thread setVehicleBoostSound( localClientNum, true );
		}
	}
	else
	{
		self.truck_boosting = false;
		self thread setVehicleBoostFX( localClientNum, "none" );
		self thread setVehicleBoostSound( localClientNum, false );
	}
}


function set_vehicle_dirt( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self notify( #"mud_update" );
	self endon( #"mud_update" );
	self endon( "entityshutdown" );

	if( IsDefined( newVal ) )
	{
		if ( isdefined( self ) && ( newVal / 1000 ) <= TRUCK_MUD_MAX_REVEAL )
		{
			self.n_mud = newVal / 1000;
			self setVectors( localClientNum, self.n_mud );
		}
	}
}

function set_vehicle_engine_index( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if( newVal > 0 )
	{
		self.truck_sound_index = newVal;
	}
}

function setVehicleBoostFX( localClientNum, fx )
{
	if( IsDefined( self.boost_fx[ #"left" ] ) )
	{
		DeleteFX( localClientNum, self.boost_fx[ #"left" ] );
		self.boost_fx[ #"left" ] = undefined;
	}

	if( IsDefined( self.boost_fx[ #"right" ] ) )
	{
		DeleteFX( localClientNum, self.boost_fx[ #"right" ] );
		self.boost_fx[ #"right" ] = undefined;
	}

	if( fx !== "none" )
	{
		if( !IsDefined( self.boost_fx[ #"left" ] ) )
		{
			self.boost_fx[ #"left" ] = PlayFXOnTag( localClientNum, fx, self, "tag_pipes_left_fx" );
		}

		if( !IsDefined( self.boost_fx[ #"right" ] ) )
		{
			self.boost_fx[ #"right" ] = PlayFXOnTag( localClientNum, fx, self, "tag_pipes_right_fx" );
		}
	}
}

function setVehicleBoostSound( localClientNum, state = false )
{
	if( state )
	{
		if( !IsDefined( self._engine_id[ #"boost" ] ) )
		{
			self._engine_id[ #"boost" ] = self PlayLoopSound( level.monster_jam_boost_sound, 0.1 );
		}
		SetSoundPitch( self._engine_id[ #"boost" ], 1.0 );
	}
	else
	{
		if( IsDefined( self._engine_id[ #"boost" ] ) )
		{
			self StopLoopSound( self._engine_id[ #"boost" ] );
			self._engine_id[ #"boost" ] = undefined;
		}
	}
}

// these are stupid so just set them all
function setVectors( localClientNum, mud )
{
	mud = ( ( mud >= 0 ) ? mud : 0 );
	for( i = 0; i < 8; i++ )
	{
		self MapShaderConstant( localClientNum, 0, "scriptVector" + i, mud, 0, 0, 0 );
	}
}

function play_damage_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	PlayFX( localClientNum, level._effect[ #"truck_impact" ], self.origin, AnglesToForward( self.angles ), AnglesToUp( self.angles ) );
}