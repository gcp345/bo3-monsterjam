#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck_boost;
#using scripts\shared\vehicles\_monster_truck_clientfields;
#using scripts\shared\vehicles\_monster_truck_pieces;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterTruckBoost;

REGISTER_SYSTEM( #"MonsterTruckBoost", &__init__, undefined )

function __init__()
{
	// set this to true if destructibles give free boost, this is disabled in freestyle
	DEFAULT( level.monster_jam_trucks_enable_free_boost, true );
}

function BoostInit()
{
	// use the old boost system
	if( !level.monster_jam_trucks_enable_ua_model )
	{
		self.boostInfinite = TRUCK_BOOST_INFINITE_CLAMP_MAX; // this script completely controls this
		self.boostFree = 0;//TRUCK_BOOST_FREE_CLAMP_MAX; // _mj_smashables controls this number, but we can also control if the player can use it

		self thread BoostButton();
		self thread TrackBoost();
		self thread RegenBoost();
	}
	else
	{
		self.boostInfinite = TRUCK_BOOST_UA_BOOST_START;
		self.boostFree = 0;
		self thread BoostButtonUA();
		self thread TrackBoostUA();
	}
}

function private RegenBoost()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;
		if( self CanBoost() )
		{
			if( self IsBoostButtonPressed() ) // don't refill the boost while he is still boosting
			{
				continue;
			}

			self.boostInfinite = Min( TRUCK_BOOST_INFINITE_CLAMP_MAX, self.boostInfinite + 0.5 );
		}
	}
}

function private TrackBoost()
{
	player = self.owner;

	player endon( "disconnect" );
	self endon( "entityshutdown" );

	while( IsDefined( player ) )
	{
		if( self CanBoost() ) // player still has some boost
		{
			player clientfield::set_player_uimodel( "MonsterTruckBoostInfinite", self.boostInfinite / TRUCK_BOOST_INFINITE_CLAMP_MAX );
			player clientfield::set_player_uimodel( "MonsterTruckBoostFree", self.boostFree / TRUCK_BOOST_FREE_CLAMP_MAX );
		}
		else
		{
			player clientfield::set_player_uimodel( "MonsterTruckBoostInfinite", 1 - ( ( self.boost_time - GetTime() ) / 15000 ) ); // reuse the clientfield to track the cooldown
		}
		WAIT_SERVER_FRAME;
	}
}

// self == truck
function private BoostButton()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	b_freestyle = IS_TRUE( level.monster_jam_trucks_use_freestyle );

	DEFAULT( self.boost_time, GetTime() );

	// set it initially
	self SetVehMaxSpeed( 80 );

	while( IsDefined( self )  )
	{
		WAIT_SERVER_FRAME;

		if( self CanBoost() )
		{
			while( !self IsBoostButtonPressed() )
			{
				WAIT_SERVER_FRAME;
			}
			self thread TruckBoosting( b_freestyle );

			self clientfield::set( "MonsterTruckBoostFX", 1 );

			str_notify = self util::waittill_any_return( "stop_boosting", "engine_blown" );
			b_blown = str_notify === "engine_blown";
			if( b_blown )
			{
				self.owner PlaySoundToPlayer( "boostleveloverload", self.owner );
				self thread BoostSetCooldown();
				self clientfield::set( "MonsterTruckBoostFX", 2 );
			}
			else
			{
				self clientfield::set( "MonsterTruckBoostFX", 0 );
			}
			self SetVehMaxSpeed( 80 );
		}
	}
}

function private TruckBoosting( b_freestyle )
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( "engine_blown" );

	while( IsDefined( self ) && self IsBoostButtonPressed() )
	{
		WAIT_SERVER_FRAME;

		b_should_boost = self DecrementBoostCounter();
		if( b_should_boost )
		{
			self truckLaunchBoost();
			continue;
		}

		// he pushed it too far!
		self notify( "engine_blown" );
	}

	self notify( "stop_boosting" );
}

function private DecrementBoostCounter( n_decrement = 1.0 )
{
	// if the truck has this var enabled, don't take any boost
	if( IS_TRUE( self.infinite_boost_powerup ) )
	{
		return true;
	}

	if( IsDefined( self.boostFree ) && self.boostFree > 0 && IS_TRUE( level.monster_jam_trucks_enable_free_boost ) )
	{
		self.boostFree -= n_decrement;
		return true;
	}
	else if( IsDefined( self.boostInfinite ) )
	{
		self.boostInfinite -= n_decrement;
		return self.boostInfinite > 0;
	} 
}

function private BoostSetCooldown()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	self.boost_time = GetTime() + 15000;

	self.owner clientfield::set_player_uimodel( "MonsterTruckBoostBlown", 1 );

	while( IsDefined( self ) && self.boost_time > GetTime() )
	{
		WAIT_SERVER_FRAME;
	}

	self.boostInfinite = TRUCK_BOOST_INFINITE_CLAMP_MAX;
	self clientfield::set( "MonsterTruckBoostFX", 0 );
	self.owner clientfield::set_player_uimodel( "MonsterTruckBoostBlown", 0 );
}

function truckLaunchBoost()
{
	if( !self IsTouchingGround() )
	{
		return;
	}

	self SetVehMaxSpeed( 150 );

	max_speed = 130;
	scaler = 0.05;//MapFloat( 0, 1, 0.05, 0.075, Abs( self GetSteering() ) );
	//forward = AnglesToForward( self.angles );
	speed = self GetSpeedMPH();
	n_launch = ( MapFloat( 0, max_speed, max_speed, 0, Abs( speed ) ) ) * scaler;

	if( speed < 0 && self GetThrottle() < self GetBrake() )
	{
		//self LaunchVehicle( forward * ( ( MapFloat( 0, max_speed, max_speed, 0, Abs( speed ) ) ) * -1 ) * scaler );
		self LaunchVehicle( ( -n_launch, 0, 0 ), ( 0, 0, 0 ), true );
	}
	else
	{
		//self LaunchVehicle( forward * ( MapFloat( 0, max_speed, max_speed, 0, Abs( speed ) ) ) * scaler );
		self LaunchVehicle( ( n_launch, 0, 0 ), ( 0, 0, 0 ), true );
	}

	// do a screen shake to simulate the power
	ScreenShake( self.origin, 0.15, 0.15, 0.15, 0.5, 0, -1, 0, 7, 1, 1, 1, self.owner );
}

function CanBoost()
{
	return ( IsDefined( self.boost_time ) && self.boost_time <= GetTime() ) && !IS_TRUE( self.owner.completed_race );
}

function ResetBoostForTruck()
{
	// Reset boost blown timer
	self.boost_time = GetTime();

	// reset the boost vars
	self.boostInfinite = ( !level.monster_jam_trucks_enable_ua_model ? TRUCK_BOOST_INFINITE_CLAMP_MAX : 0 ); // UA model resets your boost entirely
	self.boostFree = 0; // lose your free boost because you suck

	// reset clientfields
	self clientfield::set( "MonsterTruckBoostFX", 0 );
	self.owner clientfield::set_player_uimodel( "MonsterTruckBoostBlown", 0 );

	self SetVehMaxSpeed( 80 );
}

function IsBoostButtonPressed()
{
	if( self.owner istestclient() )
	{
		return IS_TRUE( self.bot_is_boosting );
	}
	else
	{
		return self.owner BoostButtonPressed() && self.owner AreControlsFrozen() == 0;
	}
}

function IsTouchingGround( test_number = 280 )
{
	if( !IsDefined( self ) || !IsVehicle( self ) )
	{
		return false;
	}

	v_tag_origin = self.origin;//self GetTagOrigin( "tag_body_animate" );

	a_trace = GroundTrace( v_tag_origin + TRUCK_GENERIC_SPAWN_OFFSET, v_tag_origin + ( Vectorscale( ( 0, 0, -1 ), 10000 ) ), 0, self )[ "position" ];
	v_ground_pos = a_trace;//GetClosestPointOnNavMesh( a_trace, 256 );

	if( !IsDefined( v_ground_pos ) )
	{
		return false;
	}

	return DistanceSquared( v_tag_origin, v_ground_pos ) <= test_number; // keep adjusting this number.
}

function GiveBoost( n_boost )
{
	// only the old model handles this stuff
	if( !level.monster_jam_trucks_enable_ua_model )
	{
		self.boostFree = Min( TRUCK_BOOST_FREE_CLAMP_MAX, self.boostFree + n_boost );
	}
}

// UA MODELS

// self == truck
// no infinite boost, but you can't blow your engine.
function private BoostButtonUA()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	b_freestyle = IS_TRUE( level.monster_jam_trucks_use_freestyle );

	// set this even though we don't use it
	DEFAULT( self.boost_time, GetTime() );
	self SetVehMaxSpeed( 80 );

	while( IsDefined( self )  )
	{
		WAIT_SERVER_FRAME;

		if( self CanBoost() && self.boostInfinite > 0.0 )
		{
			while( !self IsBoostButtonPressed() )
			{
				WAIT_SERVER_FRAME;
			}
			self thread TruckBoostingUA( b_freestyle );

			self clientfield::set( "MonsterTruckBoostFX", 1 );

			self waittill( "stop_boosting" ); 
			self clientfield::set( "MonsterTruckBoostFX", 0 );
			self SetVehMaxSpeed( 80 );
		}
	}
}

function private TruckBoostingUA( b_freestyle )
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	// bots kind of need more boost to keep up with players
	is_bot = self.owner istestclient();

	while( IsDefined( self ) && self IsBoostButtonPressed() )
	{
		WAIT_SERVER_FRAME;

		b_should_boost = self DecrementBoostCounter( ( is_bot ? 0.25 : 0.5 ) );
		if( b_should_boost )
		{
			self truckLaunchBoost();
			continue;
		}
		break; // not enough boost, break the loop
	}

	self notify( "stop_boosting" );
}

function private TrackBoostUA()
{
	player = self.owner;

	player endon( "disconnect" );
	self endon( "entityshutdown" );

	while( IsDefined( player ) )
	{
		if( self.boostInfinite > TRUCK_BOOST_FREE_CLAMP_MAX )
		{
			n_extra_boost = self.boostInfinite - TRUCK_BOOST_FREE_CLAMP_MAX;
			player clientfield::set_player_uimodel( "MonsterTruckBoostTank1", 1 );
			player clientfield::set_player_uimodel( "MonsterTruckBoostTank2", n_extra_boost / 50 );
			player clientfield::set_player_uimodel( "MonsterTruckBoostIsSecondTank", 1 );
		}
		else
		{
			player clientfield::set_player_uimodel( "MonsterTruckBoostTank1", self.boostInfinite / TRUCK_BOOST_FREE_CLAMP_MAX );
			player clientfield::set_player_uimodel( "MonsterTruckBoostTank2", 0 );
			player clientfield::set_player_uimodel( "MonsterTruckBoostIsSecondTank", 0 );
		}
		WAIT_SERVER_FRAME;
	}
}