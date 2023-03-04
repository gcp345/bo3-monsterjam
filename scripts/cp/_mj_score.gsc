#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_stats;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_boost;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#precache( "eventstring", "monster_spectacle" );

#namespace MonsterJamScore;

REGISTER_SYSTEM( #"MonsterJamScore", &__init__, undefined )

#define SCORE_STATE_HIDE						0
#define SCORE_STATE_SHOW						1
#define SCORE_STATE_CASHIN						2
#define SCORE_STATE_CANCEL						3

function __init__()
{
	// enable/disable first time bonus
	DEFAULT( level.monster_jam_trucks_enable_first_time_bonus, false );

	DEFAULT( level.monster_jam_trucks_trick_timeout, ( level.monster_jam_trucks_enable_ua_model ? 5000 : 3000 ) );

	// This shows you how many points you have going in your combo
	clientfield::register( "clientuimodel", "MonsterTruckScore", VERSION_SHIP, 15, "int" );

	// Combo Multiplier
	clientfield::register( "clientuimodel", "MonsterTruckScoreMultiplier", VERSION_SHIP, 6, "int" );

	// What score type is it? (Wheelie, Donut, etc.)
	clientfield::register( "clientuimodel", "MonsterTruckScoreType", VERSION_SHIP, 3, "int" );

	// Bit state for score: (0 = hide, 1 = show, 2 = new trick, 3 = cash in, 4 = combo cancel)
	clientfield::register( "clientuimodel", "MonsterTruckScoreState", VERSION_SHIP, 3, "int" );

	// The score to show at the top
	clientfield::register( "clientuimodel", "MonsterTruckScoreTotal", VERSION_SHIP, 20, "int" );

	// Is this a first time bonus? 0 for no, 1 for yes
	clientfield::register( "clientuimodel", "MonsterTruckScoreFTB", VERSION_SHIP, 1, "int" );

	// these need to always be registered or other scripts will break without it
	RegisterTrickType( "monster_smash", false, &util::empty, 450 );
	RegisterTrickType( "smash", false, &util::empty, 300 );
	RegisterTrickType( "crush", false, &util::empty, 100 );
	RegisterTrickType( "air_time", true, &CheckForAirTime, 200 );
	RegisterTrickType( "donut", true, &CheckForDonut, 200 );
	RegisterTrickType( "wheelie", true, &CheckForWheelie, 100 );

	// default if nothing is happening
	RegisterTrickType( "none" );

	callback::on_spawned( &on_player_spawned );

	MonsterTruck::RegisterTruckRespawnCallback( &on_truck_respawn );
}

function private RegisterTrickType( str_type, b_script_count = true, func_loop = &util::empty, n_ua_boost_weight )
{
	if( !IsDefined( level._mj_tricktypes ) )
	{
		level._mj_tricktypes = [];
	}

	struct = SpawnStruct();
	struct.index = level._mj_tricktypes.size + 1;
	struct.should_script_count = b_script_count;
	struct.loop = func_loop;
	struct.weight = n_ua_boost_weight; // this determines how many points are needed to earn a spectacle point

	level._mj_tricktypes[ str_type ] = struct;
}

function on_player_spawned()
{
	WAIT_SERVER_FRAME;

	self.truck thread InitTricks();
	self.truck thread CountPointsForUI();

	if( level.monster_jam_trucks_enable_ua_model )
	{
		self.truck thread setupAirControl();
	}
	//self.truck thread EmptyPointsOnRespawn();
}

function private UpdateUI( new_state )
{
	if( IsDefined( new_state ) )
	{
		self clientfield::set_player_uimodel( "MonsterTruckScoreState", new_state );
	}

	if( IsDefined( self.truck.current_trick ) && IsDefined( level._mj_tricktypes[ self.truck.current_trick ] ) )
	{
		self clientfield::set_player_uimodel( "MonsterTruckScoreType", level._mj_tricktypes[ self.truck.current_trick ].index );
	}
	else
	{
		self clientfield::set_player_uimodel( "MonsterTruckScoreType", level._mj_tricktypes[ "none" ].index );
	}

	if( IsDefined( self.truck.multiplier ) )
	{
		self clientfield::set_player_uimodel( "MonsterTruckScoreMultiplier", self.truck.multiplier );
	}
	else
	{
		self clientfield::set_player_uimodel( "MonsterTruckScoreMultiplier", 0 );
	}
}

function private CountPointsForUI()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self ) )
	{
		if( self CanCashIn() )
		{
			n_points = 0;
			tricks = GetArrayKeys( level._mj_tricktypes );
			foreach( str_trick in tricks )
			{
				trick = self.a_tricks[ str_trick ];
				if( trick.points > 0 )
				{
					n_points += trick.points;
				}
			}

			self.owner clientfield::set_player_uimodel( "MonsterTruckScore", n_points );
		}
		else
		{
			self.owner clientfield::set_player_uimodel( "MonsterTruckScore", 0 );
		}
		WAIT_SERVER_FRAME;
	}
}

function private InitTricks()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	self.current_trick = "none";
	self.multiplier = 0;

	self.owner clientfield::set_player_uimodel( "MonsterTruckScoreFTB", 0 );
	self.owner UpdateUI( SCORE_STATE_HIDE );

	// this gives the player some time in between tricks
	self.trick_stop_time = GetTime();

	// Setup a personal array for our player
	tricks = GetArrayKeys( level._mj_tricktypes );
	foreach( trick in tricks )
	{
		data = SpawnStruct();
		data.points = 0;
		data.counting = false;
		data.is_counting = false;
		data.ua_counter = level._mj_tricktypes[ trick ].weight;
		data.is_first_time_bonus = ( IS_TRUE( level.monster_jam_trucks_enable_first_time_bonus ) ? true : false );
		self.a_tricks[ trick ] = data;

		if( IsDefined( level._mj_tricktypes[ trick ].loop ) )
		{
			self thread [[ level._mj_tricktypes[ trick ].loop ]] ();
		}
	}

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;

		if( IS_TRUE( self.owner.completed_race ) )
		{
			continue;
		}

		foreach( str_trick in tricks )
		{
			trick = self.a_tricks[ str_trick ];
			if( IS_TRUE( trick.counting ) && self ShouldCountTrick( str_trick ) )
			{
				if( self ShouldIncrementMultipler( str_trick ) )
				{
					self.multiplier++;
					// If this is Freestyle, enable the first time bonus
					if( IS_TRUE( trick.is_first_time_bonus ) )
					{
						trick.is_first_time_bonus = false;
						self.multiplier++;
						self.owner clientfield::set_player_uimodel( "MonsterTruckScoreFTB", 1 );
					}
					else
					{
						self.owner clientfield::set_player_uimodel( "MonsterTruckScoreFTB", 0 );
					}
					self notify( #"new_trick", str_trick, self.current_trick, self.multiplier );
				}

				self.current_trick = str_trick;
				self.owner UpdateUI( SCORE_STATE_SHOW );
				if( level._mj_tricktypes[ str_trick ].should_script_count )
				{
					self thread countTrick( str_trick );
					// Increase the timeout
					self.trick_stop_time = GetTime() + level.monster_jam_trucks_trick_timeout;
				}
				else
				{
					self thread delayset( trick );
				}
				continue;
			}
		}

		// should we cash the points in?
		if( self.trick_stop_time < GetTime() && self CanCashIn() )
		{
			self notify( #"cashin_multiplier", self.multiplier );
			self CashPointsIn();
			self.owner clientfield::set_player_uimodel( "MonsterTruckScoreFTB", 0 );
			self.current_trick = "none";
			self.multiplier = 0;
			self.owner UpdateUI( SCORE_STATE_CASHIN );
		}
	}
}

function private delayset( data )
{
	WAIT_SERVER_FRAME;
	data.counting = false;
}

function GivePoints( str_type, n_value )
{
	truck = self;
	if( IsPlayer( self ) )
	{
		truck = self.truck;
	}
	
	if( !IsDefined( str_type ) || !IsDefined( truck.a_tricks ) )
	{
		return;
	}

	if( !IsDefined( level._mj_tricktypes[ str_type ] ) )
	{
		Assert( IsDefined( level._mj_tricktypes[ str_type ] ), str_type + " is not a valid score type!" );
		return;
	}

	trick = truck.a_tricks[ str_type ];

	trick.counting = true;
	trick.points += n_value;

	// Increase the timeout
	truck.trick_stop_time = GetTime() + level.monster_jam_trucks_trick_timeout;

	truck notify( "trick_stop_" + str_type, n_value );
}

function CanCashIn()
{
	tricks = GetArrayKeys( level._mj_tricktypes );
	foreach( str_trick in tricks )
	{
		trick = self.a_tricks[ str_trick ];
		if( trick.points > 0 )
		{
			return true;
		}
	}

	return false;
}

function ShouldIncrementMultipler( str_trick )
{
	// if this trick is about to end, allow another multiplier
	if( self.trick_stop_time - GetTime() < 1500 && self.trick_stop_time - GetTime() > 0 )
	{
		return true;
	}

	return self.current_trick != str_trick;
}

function CashPointsIn()
{
	points = 0;
	tricks = GetArrayKeys( level._mj_tricktypes );
	foreach( str_trick in tricks )
	{
		trick = self.a_tricks[ str_trick ];
		if( trick.points > 0 )
		{
			points += trick.points;
			trick.points = 0;
			trick.is_counting = false;
			trick.counting = false;
		}
	}

	if( self.multiplier > 0 )
	{
		self.owner MonsterJamStats::setStatUnderCondition( "highestmultiplier", self.multiplier, false );
		points *= self.multiplier;
	}

	self.owner MonsterJamStats::setStatUnderCondition( "highestpoints", points, false );

	// update the scoreboard
	self.owner.pointstowin += points;
	self.owner.pers[ "pointstowin" ] += self.owner.pointstowin;

	self.owner MonsterJamStats::incrementStat( "monsterpoints", points );

	self notify( #"cashin", points, self.multiplier );

	self.owner clientfield::set_player_uimodel( "MonsterTruckScoreTotal", self.owner.pointstowin );

}

function private countTrick( str_trick )
{
	trick = self.a_tricks[ str_trick ];
	if( trick.is_counting )
	{
		return;
	}

	trick.is_counting = true;
	n_temp_points = 0;

	start_time = GetTime();

	while( trick.counting )
	{
		trick.points += 5;
		n_temp_points += 5;
		WAIT_SERVER_FRAME;
	}

	trick.is_counting = false;
	self notify( "trick_stop_" + str_trick, n_temp_points );
}

// respawning causes you to lose your entire streak
/*
function EmptyPointsOnRespawn()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self ) )
	{
		self waittill( "truck_respawn" );

		tricks = GetArrayKeys( level._mj_tricktypes );
		foreach( str_trick in tricks )
		{
			trick = self.a_tricks[ str_trick ];
			if( trick.points > 0 )
			{
				trick.points = 0;
				trick.counting = false;
			}
		}

		self CashPointsIn();
		self.current_trick = "none";
		self.multiplier = 0;
	}
}
*/

function on_truck_respawn()
{
	if( self CanCashIn() )
	{
		tricks = GetArrayKeys( level._mj_tricktypes );
		foreach( str_trick in tricks )
		{
			trick = self.a_tricks[ str_trick ];
			if( trick.points > 0 )
			{
				trick.points = 0;
				trick.counting = false;
				trick.is_counting = false;
			}
		}

		self CashPointsIn();
		self.owner clientfield::set_player_uimodel( "MonsterTruckScoreFTB", 0 );
		self.current_trick = "none";
		self.multiplier = 0;
		self.owner UpdateUI( SCORE_STATE_CANCEL );
	}
}

// Is this new index a higher priority to count?
function private ShouldCountTrick( str_new_trick )
{
	return 	self.current_trick == "none" ||
			!self.a_tricks[ self.current_trick ].counting || 
			level._mj_tricktypes[ self.current_trick ].index > level._mj_tricktypes[ str_new_trick ].index ||
			self.current_trick == str_new_trick;
}

function private CheckForAirTime()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self ) )
	{
		self waittill( "veh_inair" );

		self thread checkWheelsForGround();
		str_notify = self util::waittill_any_timeout( 0.5, "veh_landed", "veh_fake_land" ); //
		self notify( #"stop_wheel_checks" );

		if( str_notify === "timeout" )
		{
			self.a_tricks[ "air_time" ].counting = true;

			self thread checkWheelsForGround();

			self util::waittill_any_return( "veh_landed", "veh_fake_land", "veh_collision" ); //
			self notify( #"stop_wheel_checks" );

			self.a_tricks[ "air_time" ].counting = false;
		}
	}
}

function checkWheelsForGround()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );
	self endon( #"stop_wheel_checks" );

	while( !self IsAnyWheelTouching() && !self MonsterTruckBoost::IsTouchingGround() )
	{
		WAIT_SERVER_FRAME;
	}
	self notify( "veh_fake_land" );
}

function private CheckForWheelie()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	DEFAULT( self.wheels_touching, [] );
	DEFAULT( self.wheelie_counter, 0 );

	self thread WheelGroundCheck( "front_left" );
	self thread WheelGroundCheck( "front_right" );
	self thread WheelGroundCheck( "back_left" );
	self thread WheelGroundCheck( "back_right" );

	while( IsDefined( self ) )
	{
		self.wheelie_counter = ( self IsDoingWheelie() ? self.wheelie_counter + 1 : 0 );
		self.a_tricks[ "wheelie" ].counting = self.wheelie_counter >= 25;

		WAIT_SERVER_FRAME;
	}
}

function private WheelGroundCheck( str_wheel )
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	DEFAULT( self.wheels_touching[ str_wheel ], false );

	while( IsDefined( self ) )
	{
		origin = self GetTagOrigin( "tag_wheel_" + str_wheel + "_spin" );
		trace = GroundTrace( origin, origin + ( Vectorscale( ( 0, 0, -1 ), 10000 ) ), 0, self )[ "position" ];
		self.wheels_touching[ str_wheel ] = DistanceSquared( origin, trace ) <= 1000; // 33( the wheel radius ) ^2 = 1089
		WAIT_SERVER_FRAME;
	}
}

function IsDoingWheelie()
{
	return 	( IS_TRUE( self.wheels_touching[ "back_left" ] ) && 
			IS_TRUE( self.wheels_touching[ "back_right" ] ) &&
			!IS_TRUE( self.wheels_touching[ "front_left" ] ) && 
			!IS_TRUE( self.wheels_touching[ "front_right" ] ) );
}

function IsDoingEndo()
{
	return 	( !IS_TRUE( self.wheels_touching[ "back_left" ] ) && 
			!IS_TRUE( self.wheels_touching[ "back_right" ] ) &&
			IS_TRUE( self.wheels_touching[ "front_left" ] ) && 
			IS_TRUE( self.wheels_touching[ "front_right" ] ) );
}

function IsDoingBicycle()
{
	return 	( IS_TRUE( self.wheels_touching[ "back_left" ] ) && 
			!IS_TRUE( self.wheels_touching[ "back_right" ] ) &&
			IS_TRUE( self.wheels_touching[ "front_left" ] ) && 
			!IS_TRUE( self.wheels_touching[ "front_right" ] ) ) ||
			( !IS_TRUE( self.wheels_touching[ "back_left" ] ) && 
			IS_TRUE( self.wheels_touching[ "back_right" ] ) &&
			!IS_TRUE( self.wheels_touching[ "front_left" ] ) && 
			IS_TRUE( self.wheels_touching[ "front_right" ] ) );
}

function IsAnyWheelTouching()
{
	return 	( IS_TRUE( self.wheels_touching[ "back_left" ] ) || 
			IS_TRUE( self.wheels_touching[ "back_right" ] ) ||
			IS_TRUE( self.wheels_touching[ "front_left" ] ) || 
			IS_TRUE( self.wheels_touching[ "front_right" ] ) );
}

function private CheckForDonut()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	self.donut_counter = 0;

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;

		if( Abs( self GetSteering() ) < 0.7 )
		{
			self ResetDonut();
			continue;
		}

		speed = Abs( self GetSpeedMPH() );
		if( speed > 10 || speed < 0.1 )
		{
			self ResetDonut();
			continue;
		}

		if( self GetHandBrake() == 0 )
		{
			self ResetDonut();
			continue;
		}

		if( Abs( self GetThrottle() ) < 0.8 || self GetBrake() == 1 )
		{
			self ResetDonut();
			continue;
		}

		if( !IsDefined( self.donut_origin ) )
		{
			self ResetDonut();
			self.donut_origin = self.origin;
			continue;
		}

		else
		{
			if( DistanceSquared( self.origin, self.donut_origin ) <= ( 85 * 85 ) )
			{
				self.donut_counter++;
			}

			if( self.donut_counter >= 25 )
			{
				self.a_tricks[ "donut" ].counting = true;
			}
		}

		self.donut_origin = self.origin;
	}
}

function ResetDonut()
{
	level notify( "donut_complete", self.donut_counter );
	self.donut_counter = 0;
	self.a_tricks[ "donut" ].counting = false;
}

// air control allows players to position a perfect landing while performing backflips and such
function setupAirControl()
{
	self thread airControlThrottle();
	self thread airControlSteer();

	self thread setupFreeBoost();
	self thread resetSpectaclePoints();
}

// the only reason these are different functions is because we need different wait times for each of the controls.
function airControlThrottle()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	if( self.owner istestclient() )
	{
		return;
	}

	while( IsDefined( self ) )
	{
		wait 0.085;

		if( self MonsterTruckBoost::IsTouchingGround() )
		{
			continue;
		}

		if( self IsAnyWheelTouching() )
		{
			continue;
		}

		n_throttle = self GetThrottle();
		n_brake = self GetBrake();
		if( Abs( n_throttle ) > 0 )
		{
			self LaunchVehicle( ( n_throttle * 1.25, 0, 0 ), ( -150, 0, -150 ), true );
		}
		else if( n_brake > 0 )
		{
			self LaunchVehicle( ( n_brake * 1.25, 0, 0 ), ( 150, 0, 150 ), true );
		}
	}
}

function airControlSteer()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	if( self.owner istestclient() )
	{
		return;
	}

	while( IsDefined( self ) )
	{
		wait 0.075;

		if( self MonsterTruckBoost::IsTouchingGround() )
		{
			continue;
		}

		if( self IsAnyWheelTouching() )
		{
			continue;
		}

		n_steering = self GetSteering();
		if( n_steering != 0 )
		{
			self LaunchVehicle( ( -1.5 * n_steering, 0, 0 ), ( 0, 150, -10 ), true );
		}
	}
}

function setupFreeBoost()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	self.owner clientfield::set_player_uimodel( "MonsterTruckSpectaclePoints", 0 );

	self.spectacle_mult = 1;
	self.spectacle_points = 0;
	self.monster_spectacle = false;

	while( IsDefined( self ) )
	{
		self waittill( #"new_trick", str_new_trick, str_old_trick, n_multiplier );
			
		if( str_new_trick == "none" )
		{
			continue;
		}

		// a new combo always gives a spectacle point
		// every three multipliers gives a spectacle point

		if( n_multiplier == self.spectacle_mult || n_multiplier % 3 == 0 )
		{
			// give two for these sick tricks
			self thread giveSpectaclePoint();

			if( self.monster_spectacle )
			{
				self.spectacle_mult = n_multiplier;
				self.spectacle_points = 0;
			}
		}
		self thread watchTrick( str_new_trick );
	}
}

function watchTrick( str_trick )
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( #"new_trick" );

	b_is_script_count = IsDefined( level._mj_tricktypes[ str_trick ] ) && level._mj_tricktypes[ str_trick ].should_script_count;

	while( IsDefined( self ) )
	{
		if( b_is_script_count )
		{
			WAIT_SERVER_FRAME;
		}
		else
		{
			self waittill( "trick_stop_" + str_trick, n_points );
		}

		s_data = self.a_tricks[ str_trick ];
		if( IsDefined( s_data ) && s_data.points >= s_data.ua_counter )
		{
			self thread giveSpectaclePoint( 1 );
			s_data.ua_counter = s_data.ua_counter + level._mj_tricktypes[ str_trick ].weight; // this is done in case I made the weight a float: you can't do += with a float
		}
	}
}

// this is so when players earn a monster spectacle but still have a on going combo, they can keep earning spectacle points
// ending a combo resets the spectacle points counter and also the multiplier too.
function resetSpectaclePoints()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self waittill( #"cashin", n_points, n_multiplier );
		self clearSpectaclePoints();
	}
}

function giveSpectaclePoint( n_amount = 1 )
{
	for( i = 0; i < n_amount; i++ )
	{
		self notify( "earned_spectacle" );

		self.spectacle_points++;

		self.owner clientfield::set_player_uimodel( "MonsterTruckSpectaclePoints", self.spectacle_points );

		self.monster_spectacle = self.spectacle_points >= 5;

		self.owner thread playSpectacleSound( self.spectacle_points );

		// add some boost!
		if( self.monster_spectacle )
		{
			self.boostInfinite = 150.0;
			self.spectacle_points = 0;

			self.owner LUINotifyEvent( &"monster_spectacle", 0 );
			self.owner MonsterJamStats::incrementStat( "monsterspectacles", 1 );

			self util::waittill_any_timeout( 3, "earned_spectacle" );

			self.owner clientfield::set_player_uimodel( "MonsterTruckSpectaclePoints", self.spectacle_points );
		}
		else if( self.boostInfinite < TRUCK_BOOST_FREE_CLAMP_MAX )
		{
			self.boostInfinite = Min( TRUCK_BOOST_FREE_CLAMP_MAX, self.boostInfinite + 25.0 );
		}
	}
}

function clearSpectaclePoints()
{
	self.owner clientfield::set_player_uimodel( "MonsterTruckSpectaclePoints", 0 );
	tricks = GetArrayKeys( level._mj_tricktypes );
	foreach( str_trick in tricks )
	{
		trick = self.a_tricks[ str_trick ];
		trick.ua_counter = level._mj_tricktypes[ str_trick ].weight;
	}
	self.spectacle_mult = 1;
	self.spectacle_points = 0;
	self.monster_spectacle = false;
	self notify( "cleared_spectacle" );
}

function playSpectacleSound( n_number )
{
	if( n_number == 5 )
	{
		self PlaySoundToPlayer( "megaspectacle", self );
		self PlaySoundToPlayer( "boost_full", self );
	}
	self PlaySoundToPlayer( "boost_up", self );
	WAIT_SERVER_FRAME;
	self PlaySoundToPlayer( "monsterpoint", self );
}