#using scripts\codescripts\struct;

#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;

#using scripts\shared\ai\systems\shared;

#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;

#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_utility;

#using scripts\shared\vehicles\_monster_truck;

#namespace MonsterTruckAI;

REGISTER_SYSTEM( #"MonsterTruckAI", &__init__, undefined )

function __init__()
{
	// allows for two tracks for setup
	DEFAULT( level.monster_jam_head2head_mode, false );

	// spawn fake ai for the game to manipulate
	DEFAULT( level.monster_jam_spawn_fake_ai, false );

	if( IS_TRUE( level.monster_jam_trucks_enable_ai ) )
	{
		enable_truck_ai();
	}
}

function enable_truck_ai()
{
	// give the ai the correct track to start on
	str_spawn = MonsterJamUtility::GetRaceString();
	str_targetname = str_spawn + "_track";

	if( IS_TRUE( level.monster_jam_head2head_mode ) )
	{
		e_node = GetVehicleNode( str_targetname + "0", "targetname" );
		if( IsDefined( e_node ) )
		{
			level thread MonsterJamUtility::FindTrackTime( e_node );
		}

		e_node = GetVehicleNode( str_targetname + "1", "targetname" );
		if( IsDefined( e_node ) )
		{
			level thread MonsterJamUtility::FindTrackTime( e_node );
		}
	}
	else
	{
		e_node = GetVehicleNode( str_targetname, "targetname" );
		if( IsDefined( e_node ) )
		{
			level thread MonsterJamUtility::FindTrackTime( e_node );
		}
	}

	level flag::wait_till( "all_players_spawned" );
	level flag::wait_till( "checkpoints_ready" );

	lobbysize = GetPlayers().size;
	maxlobbysize = GetDvarInt( "com_maxclients", 6 );
	bots_to_spawn = maxlobbysize - lobbysize;

	for( i = 0; i < bots_to_spawn; i++ )
	{
		ai = AddTestClient();
		if( IsDefined( ai ) && !IS_TRUE( level.monster_jam_spawn_fake_ai ) )
		{
			ai thread setup_truck( str_targetname );
		}
	}
}

function setup_truck( str_targetname )
{
	wait 1;

	truck = self.truck;

	if( IsDefined( truck ) )
	{
		// truck is now a ai
		//truck MakeSentient();

		if( IsDefined( level.monster_jam_ai_custom_track_callback ) )
		{
			self thread [[ level.monster_jam_ai_custom_track_callback ]]();
			return;
		}

		if( IS_TRUE( level.monster_jam_head2head_mode ) )
		{
			n_index = self GetEntityNumber() % 2;
			n_path_start = GetVehicleNode( str_targetname + n_index, "targetname" );
		}
		else
		{
			n_path_start = GetVehicleNode( str_targetname, "targetname" );
		}

		level flag::wait_till( "start_race" );
		truck.drivepath = true;

		if( IsDefined( n_path_start ) )
		{
			truck DrivePath( n_path_start );
		}

		truck SetDrivePathPhysicsScale( 1 );

		truck thread start_stuck_watchers();
		truck thread boost_watcher();
		truck thread race_completionist();
		truck thread watch_for_nodes( n_path_start );
		truck thread stopOnCompletion();
	}
}

function stopOnCompletion()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	level waittill( "stop_ai_trucks" );

	if( IsDefined( self ) )
	{
		self thread loopGoalPos();
	}
}

function watch_for_nodes( e_node )
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );

	DEFAULT( self.ai_current_node, e_node );

	while( IsDefined( self ) )
	{
		self waittill( "reached_node", new_node );
		if( new_node != self.ai_current_node )
		{
			self.ai_current_node = new_node;
		}
	}
}

function start_stuck_watchers()
{
	DEFAULT( self.next_respawn_time, GetTime() );
	self thread driving_into_something_watcher();
	self thread upside_down_watcher();
}

#define STUCK_DIST			30
#define STUCK_DIST_SQ		( STUCK_DIST * STUCK_DIST )

function driving_into_something_watcher()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );
	level endon( "stop_ai_trucks" );
	self endon( "stop_ai" );

	while( IsDefined( self ) )
	{
		wait 0.25;

		if( IS_TRUE( self.is_respawning ) )
		{
			continue;
		}

		if( IsDefined( self.next_respawn_time ) && self.next_respawn_time > GetTime() )
		{
			continue;
		}

		if( IsDefined( self.prev_origin ) )
		{
			dist = DistanceSquared( self.origin, self.prev_origin );
			if( dist <= STUCK_DIST_SQ )
			{
				self thread MonsterTruck::doRespawn( 1 );
				self.next_respawn_time = GetTime() + 1500;
			}
		}

		self.prev_origin = self.origin;
	}
}

function upside_down_watcher()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );
	level endon( "stop_ai_trucks" );
	self endon( "stop_ai" );

	while( IsDefined( self ) )
	{
		wait 2;

		if( IS_TRUE( self.is_respawning ) )
		{
			continue;
		}

		if( IsDefined( self.next_respawn_time ) && self.next_respawn_time > GetTime() )
		{
			continue;
		}

		if( self.angles[ 0 ] > 100 && self.angles[ 0 ] < 260 || self.angles[ 2 ] > 100 && self.angles[ 2 ] < 260 )
		{
			self thread MonsterTruck::doRespawn( 1 );
			self.next_respawn_time = GetTime() + 1500;
		}
	}
}

function race_completionist()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );
	level endon( "stop_ai_trucks" );
	self endon( "stop_ai" );
	owner = self.owner;

	while( IsDefined( owner ) && !IS_TRUE( owner.completed_race ) )
	{
		WAIT_SERVER_FRAME;
	}

	self thread loopGoalPos();
}

function loopGoalPos()
{
	v_stop_pos = self.origin + AnglesToForward( self.angles ) * 60;
	self notify( "bot_stop_boost" );
	self SetVehMaxSpeed( 0.5 );
	self SetVehGoalPos( v_stop_pos, true );
	self notify( "stop_ai" );

	while( IsDefined( self ) )
	{
		wait 1;
		self SetVehGoalPos( self.origin, true );
	}
}

function boost_watcher()
{
	self endon( "entityshutdown" );
	self.owner endon( "disconnect" );
	level endon( "stop_ai_trucks" );
	self endon( "stop_ai" );
	owner = self.owner;

	DEFAULT( self.bot_is_boosting, false );
	DEFAULT( self.ai_next_boost_time, GetTime() );

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;

		if( self.ai_next_boost_time > GetTime() )
		{
			self notify( "bot_stop_boost" ); // send the notify just in case
			continue;
		}

		steering = self GetSteering();
		steering = Abs( steering ); // account for it going left

		// let them boost in straight lines or power through corners
		if( steering > 0.35 && steering < 0.9 )
		{
			self notify( "bot_stop_boost" );
			continue;
		}

		speed = self GetSpeedMPH();
		//speed = Abs( speed ); don't check this, no point of boosting when they mess up

		if( speed > 20 && speed < 60 )
		{
			self notify( "bot_stop_boost" );
			continue;
		}

		// lets not try to blow our engines up
		// but if we have any free boost lets use it
		if( self botShouldStopBoosting() )
		{
			self.ai_next_boost_time = GetTime() + 5000;
			self notify( "bot_stop_boost" );
			continue;
		}

		if( !self.bot_is_boosting )
		{
			self thread botDoBoost( owner );
		}
	}
}

function botShouldStopBoosting()
{
	if( level.monster_jam_trucks_enable_ua_model )
	{
		return !IsDefined( self.boostInfinite ) || self.boostInfinite == 0;
	}
	else
	{
		return !IsDefined( self.boostInfinite ) || self.boostInfinite <= 10;
	}
}

function botDoBoost( bot )
{
	self endon( "entityshutdown" );
	bot endon( "disconnect" );

	self.bot_is_boosting = true;

	self util::waittill_any_timeout( ( self GetSteering() < 0.9 ? 3 : 1.5 ), "bot_stop_boost", "engine_blown" );

	self.bot_is_boosting = false;
}

function setupFreeDrivingParams()
{
	self MakeSentient();
	
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.delete_on_death = 1;
	self.last_jump_chance_time = 0;
	self vehicle::friendly_fire_shield();
	/#
		assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(self.settings.aim_assist)
	{
		self enableaimassist();
	}
	self setneargoalnotifydist(self.settings.near_goal_notify_dist);
	self.goalradius = 999999;
	self.goalheight = 999999;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
}