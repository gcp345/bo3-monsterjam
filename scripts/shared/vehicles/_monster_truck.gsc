#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck_ai;
#using scripts\shared\vehicles\_monster_truck_boost;
#using scripts\shared\vehicles\_monster_truck_clientfields;
#using scripts\shared\vehicles\_monster_truck_pieces;

#using scripts\cp\_mj_utility;

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
	callback::on_spawned( &on_player_spawned );
	vehicle::add_main_callback( "monster_truck", &MonsterTruckInit );

	DEFAULT( level.monster_jam_trucks_use_freestyle, false );

	// set this to true if you want to disable the mud on the trucks. CF still needs to be registered
	DEFAULT( level.monster_jam_trucks_disable_mud, false );
}

function GetVehicleType()
{
	if( IS_TRUE( level.monster_jam_trucks_use_freestyle ) )
	{
		return "veh_monster_truck_freestyle";
	}

	return "veh_monster_truck";
}

// self == player
function on_player_spawned()
{
	// keep track of other trucks in the game, spawn the player in this truck if it exists
	str_targetname = "monster_truck_" + self GetEntityNumber();
	if( IsDefined( str_targetname ) && str_targetname != "monster_truck_" )
	{
		truck = GetEnt( str_targetname, "targetname" );
		if( IsDefined( truck ) )
		{
			// set the player in the vehicle and lock him in
			truck MakeUsable();
			truck UseVehicle( self, 0 );
			truck MakeUnusable();
			return;
		}
	}

	spawn = self GetMonsterTruckSpawnPos();
	if( !IsDefined( spawn ) )
	{
		origin = self.origin;
		angles = self.angles;
	}
	else
	{
		origin = spawn.origin;
		angles = spawn.angles;
	}

	truck = SpawnVehicle( GetVehicleType(), origin + TRUCK_GENERIC_SPAWN_OFFSET, angles, str_targetname );
	if( IsDefined( truck ) )
	{
		// set the player in the vehicle and lock him in
		truck UseVehicle( self, 0 );
		truck MakeUnusable();
		truck DontInterpolate();

		truck SetMovingPlatformEnabled( true );
		truck.disconnectpathdetail = false;

		truck.takedamage = false;
		truck.team = self.team;
		truck.owner = self;

		// Process spawn callbacks
		if( IsDefined( level._monster_truck_callbacks[ #"spawn" ] ) )
		{
			foreach( callback in level._monster_truck_callbacks[ #"spawn" ] )
			{
				truck thread [[ callback ]] ();
			}
		}

		// assign the truck to the player
		self.truck = truck;

		// set this to 0 in case the player restarted while he respawned
		self CameraActivate( false );

		self thread on_player_disconnect( truck );

		// Make him a god
		self EnableInvulnerability();
	}
}

// self == player
function on_player_disconnect( truck )
{
	ent_num = self GetEntityNumber();
	self waittill( "disconnect" );

	if( IsDefined( truck ) )
	{
		truck Delete();
	}

	truck thread MonsterTruckPieces::CleanUpParts();

	// Let's make sure the truck is gone
	str_targetname = "monster_truck_" + ent_num;
	if( IsDefined( str_targetname ) && str_targetname != "monster_truck_" )
	{
		e_truck = GetEnt( str_targetname, "targetname" );
		if( IsDefined( e_truck ) )
		{
			// Get rid of the truck like this
			e_truck[ 0 ] Delete();
		}
	}
}

// self == truck
function MonsterTruckInit()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	// give the game a frame to process it's owner and allow it to increment on the first frame
	wait 0.1;

	if( !IsDefined( self.truck_type ) )
	{
		self.truck_type = self.owner GetMonsterTruckIndex();
		if( !IsDefined( self.truck_type ) )
		{
			self.truck_type = 0;
		}
	}

	self.vehcheckforpredictedcrash = true; // code field to get veh_predictedcollision notify
	self.predictedCollisionTime = 0.01;

	self thread MonsterTruckPieces::RegisterMonsterTruck();
	self thread MonsterTruckPredictedCollision();
	self thread MonsterTruckOtherVehCollisions();

	// Setup dirt
	// this initializes the variable and cleans the truck up
	self thread MonsterTruckCF::IncrementDirt( 0 );

	// Service utils
	if( !IS_TRUE( level.monster_jam_trucks_disable_mud ) )
	{
		self thread TrackMudDistance();
	}

	self thread RespawnButtonTracker();
	//self thread FourWheelButtonTracker();

	self thread MonsterTruckBoost::BoostInit();
}

function IsValidTruck()
{
	if( IsVehicle( self ) )
	{
		return IsDefined( self ) && IsDefined( self.owner );
	}
	else
	{
		return IsDefined( self ) && IsDefined( self.truck );
	}
}

function GetMonsterTruckIndex()
{	
	if( self istestclient() )
	{
		a_indexes = GetUnpickedTruckIndexes();
		pick = array::random( a_indexes );
		level._monster_truck_data[ pick ].is_picked = true;
		return pick;
	}
	else
	{
		// we don't care what the player has, we are aware multiple real players can choose the same thing.
		// it's just we don't want bots choosing the same truck as us.
		/#
		a_indexes = GetUnpickedTruckIndexes();
		pick = array::random( a_indexes );
		level._monster_truck_data[ pick ].is_picked = true;
		return pick;
		#/
		w_class_item = self GetLoadoutWeapon( 1, "primary" );
		pick = GetItemIndexFromRef( w_class_item.name );
		if( IsDefined( level._monster_truck_data[ pick ] ) )
		{
			level._monster_truck_data[ pick ].is_picked = true;
		}
		else
		{
			// player has something messed up, give him Grave Digger
			pick = TRUCK_INDEX_GRAVEDIGGER;
			level._monster_truck_data[ pick ].is_picked = true;
		}
		return pick;
	}
}

function GetUnpickedTruckIndexes()
{
	a_picks = [];
	for( i = 1; i <= 31/*TRUCK_INDEX_LIMIT*/; i++ )
	{
		if( IsDefined( level._monster_truck_data[ i ] ) ) // added this because people were choosing Iron Outlaw Q-Torque when it wasn't even in the game yet
		{
			if( !IS_TRUE( level._monster_truck_data[ i ].is_picked ) )
			{
				ARRAY_ADD( a_picks, i );
			}
		}
	}

	return a_picks;
}

// 12/22/2022 - Lowered mud_count max from 5 to 2 in order to blend mud much better.
function TrackMudDistance()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self ) )
	{
		wait 0.5;

		speed = self GetSpeedMPH();
		
		mud_count = 0;
		if( Abs( speed ) > 0.1 && self GetThrottle() > 0.5 )
		{
			mud_count = Floor( MapFloat( 3, 0, 0.1, 5, Abs( speed ) ) );
			//if( RandomInt( 100 ) > 99 )
			//{
			//	mud_count = 1;
			//}
		}

		for( i = 0; i < mud_count; i++ )
		{
			self thread MonsterTruckCF::IncrementDirt( 1 );
			WAIT_SERVER_FRAME;
		}
	}
}

function MonsterTruckPredictedCollision()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	if( !IsDefined( self.last_predicted_crash ) )
	{
		self.last_predicted_crash = GetTime() + 1000;
	}

	while( IsDefined( self ) )
	{
		self waittill( "veh_predictedcollision", velocity, normal, ent, stype );
		if( IsDefined( self.last_predicted_crash ) && self.last_predicted_crash <= GetTime() )
		{
			self notify( "veh_collision", velocity, normal, Abs( TRUCK_GENERIC_SPEED_TO_MPH( self GetSpeed() ) ), stype, ent );

			//self.last_predicted_crash = GetTime() + 50;
		}
	}
}

function MonsterTruckOtherVehCollisions()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	DEFAULT( self.last_fake_crash, GetTime() + 1000 );

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;

		a_other_vehicles = GetVehicleArray();

		// scale to account for speeds
		dist_check = MapFloat( 0, 80, 200, 250, Abs( self GetSpeedMPH() ) );
		dist_check_sq = dist_check * dist_check;

		foreach( vehicle in a_other_vehicles )
		{
			if( self.last_fake_crash >= GetTime() )
			{
				continue;
			}

			if( vehicle == self )
			{
				continue;
			}

			if( DistanceSquared( self.origin + AnglesToForward( self.angles ) * 55, vehicle.origin + AnglesToForward( vehicle.angles ) * 55 ) > dist_check_sq )//DistanceSquared( self.origin, vehicle.origin ) > dist_check_sq )
			{
				continue;
			}

			n_speed = TRUCK_GENERIC_SPEED_TO_MPH( self GetSpeed() );//Abs( TRUCK_GENERIC_SPEED_TO_MPH( self GetSpeed() ) - TRUCK_GENERIC_SPEED_TO_MPH( vehicle GetSpeed() ) );

			v_normal = VectorScale( VectorNormalize( self.origin - vehicle.origin ), -1 );

			self notify( "veh_collision", vehicle.origin, v_normal, n_speed, "concrete", vehicle );
			self.last_fake_crash = GetTime() + 250;
		}
	}
}

function GetMonsterTruckSpawnPos()
{
	if( IsDefined( level.custom_monster_truck_spawn_callback ) )
	{
		struct = self [[ level.custom_monster_truck_spawn_callback ]]();
		if( IsDefined( struct ) )
		{
			return struct;
		}
	}

	str_spawn = MonsterJamUtility::GetRaceString();
	str_targetname = str_spawn + "_spawn_" + self GetEntityNumber();

	struct = struct::get( str_targetname, "targetname" );

	if( IsDefined( struct ) )
	{
		return struct;
	}

	return undefined;
}

function GetMonsterTruckRespawnPos()
{
	if( IsDefined( level.custom_monster_truck_respawn_callback ) )
	{
		struct = self [[ level.custom_monster_truck_respawn_callback ]]();
		if( IsDefined( struct ) )
		{
			return struct;
		}
	}

	str_spawn = MonsterJamUtility::GetRaceString();
	str_targetname = str_spawn + "_spawn_" + self GetEntityNumber();

	struct = struct::get( str_targetname, "targetname" );

	if( IsDefined( struct ) )
	{
		return struct;
	}

	return undefined;
}

function FourWheelButtonTracker()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self.owner ) )
	{
		WAIT_SERVER_FRAME;
		self SetVehicleType( GetVehicleType() );

		while( !self.owner UseButtonPressed() )
		{
			WAIT_SERVER_FRAME;
		}

		self SetVehicleType( GetVehicleType() + "_4wheel" );
		WAIT_SERVER_FRAME;

		while( self.owner UseButtonPressed() )
		{
			WAIT_SERVER_FRAME;
		}
	}
}

function RespawnButtonTracker()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;
		if( IS_TRUE( self.is_respawning ) )
		{
			continue;
		}

		while( !self.owner ActionSlotOneButtonPressed() )
		{
			WAIT_SERVER_FRAME;
		}

		self thread doRespawn();
	}
}

function doRespawn( n_time = 3 )
{
	self IncrementRespawnCounter();
	
	spawn_pos = self.owner GetMonsterTruckRespawnPos();
	Assert( IsDefined( spawn_pos ), "No valid spawn point found for truck!" );

	str_notify = self util::waittill_any_timeout( n_time, "truck_respawn", "entityshutdown" );

	if( str_notify !== "timeout" )
		return;


	self DontInterpolate();
	if( IsDefined( spawn_pos ) )
	{
		self.origin = spawn_pos.origin + TRUCK_GENERIC_SPAWN_OFFSET;
		self.angles = spawn_pos.angles;
	}
	else
	{
		self.origin = ( 0, 0, 0 ) + TRUCK_GENERIC_SPAWN_OFFSET;
		self.angles = ( 0, 0, 0 );
	}

	forward = AnglesToForward( self.angles );
	self LaunchVehicle( forward * 60 );

	// reset all of the boost vars
	self thread MonsterTruckBoost::ResetBoostForTruck();

	self notify( "truck_respawn" );

	// Process respawn callbacks
	if( IsDefined( level._monster_truck_callbacks[ #"respawn" ] ) )
	{
		foreach( callback in level._monster_truck_callbacks[ #"respawn" ] )
		{
			self thread [[ callback ]] ();
		}
	}

	wait 0.5;

	// Reset this so parts don't go flying off as they respawn
	self.next_collision_time = GetTime() + 1500;
	self.last_predicted_crash = GetTime() + 1500;

	self DecrementRespawnCounter();
}

function IncrementRespawnCounter()
{
	DEFAULT( self.__respawn_counter, 0 );
	DEFAULT( self.is_respawning, false );

	self.__respawn_counter++;

	self.is_respawning = self.__respawn_counter > 0;
	if( self.is_respawning )
	{
		self NotSolid();
		self.notsolid = true;
		self SetContents( 0 );
		self SetPlayerCollision( false );
		self.takedamage = false;
	}
	else
	{
		self Solid();
		self.notsolid = false;
		self SetContents( 8192 );
		self SetPlayerCollision( true );
		self.takedamage = true;
	}
}

function DecrementRespawnCounter()
{
	DEFAULT( self.__respawn_counter, 0 );
	DEFAULT( self.is_respawning, false );

	self.__respawn_counter--;
	if( self.__respawn_counter < 0 )
	{
		self.__respawn_counter = 0;
	}

	self.is_respawning = self.__respawn_counter > 0;
	if( self.is_respawning )
	{
		self NotSolid();
		self.notsolid = true;
		self SetContents( 0 );
		self SetPlayerCollision( false );
		self.takedamage = false;
	}
	else
	{
		self Solid();
		self.notsolid = false;
		self SetContents( 8192 );
		self SetPlayerCollision( true );
		self.takedamage = true;
	}
}

function RegisterTruckRespawnCallback( callback )
{
	if( !IsDefined( level._monster_truck_callbacks ) )
		level._monster_truck_callbacks = [];

	if( !IsDefined( level._monster_truck_callbacks[ #"respawn" ] ) )
		level._monster_truck_callbacks[ #"respawn" ] = [];

	ARRAY_ADD( level._monster_truck_callbacks[ #"respawn" ], callback );
}

function RegisterTruckSpawnCallback( callback )
{
	if( !IsDefined( level._monster_truck_callbacks ) )
		level._monster_truck_callbacks = [];

	if( !IsDefined( level._monster_truck_callbacks[ #"spawn" ] ) )
		level._monster_truck_callbacks[ #"spawn" ] = [];

	ARRAY_ADD( level._monster_truck_callbacks[ #"spawn" ], callback );
}

// TODO: MOVE TO PIECES OR ANOTHER SCRIPT
function CreateFakeDriver( str_model, str_tag )
{
	if( !IsDefined( level._monster_truck_drivers ) )
		level._monster_truck_drivers = [];

	level._monster_truck_drivers[ str_tag ] = str_model;
}

function setupFakeDriver( player )
{
	//driver = Spawn( "script_model", player.origin );
	//driver SetModel( "c_t9_cp_mj_driver_male_body" );
	//driver.angles = player.angles;
	//driver LinkTo( player );
	//driver thread animation::play( "pb_monster_truck_driver_idle", driver );

	str_player_model = "c_t9_cp_mj_driver_male_body_red";//player GetCharacterBodyModel( 0 );

	if( !IsDefined( str_player_model ) || player istestclient() )
	{

	}

	keys = GetArrayKeys( level._monster_truck_drivers );

	for( i = 0; i < keys.size; i++ )
	{
		str_tag = keys[ i ];
		str_model = level._monster_truck_drivers[ str_tag ];
		if( str_player_model !== str_model )
		{
			self HidePart( str_tag );
		}
	}
}