#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_stats;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_ai;
#insert scripts\shared\vehicles\_monster_truck.gsh;

#precache( "eventstring", "truck_notify" );
#precache( "eventstring", "start_race" );

#precache( "menu", "EndGameRank" );
#precache( "menu", "EndGameResults" );

#namespace MonsterJamUtility;

REGISTER_SYSTEM_EX( #"MonsterJamUtility", &__init__, &__main__, undefined )

function autoexec opt_in()
{
	
}

function __init__()
{
	clientfield::register( "vehicle", "reinit_vehicle_sounds", VERSION_SHIP, 1, "counter" );
}

function __main__()
{
	level flag::init( "initial_blackscreen_passed" );

	level thread onallplayersready();
}

function SetOOBCamera( waitTime = 1, v_cam_pos = self GetPlayerCameraPos(), e_look_at )
{
	if( IsDefined( self.truck ) )
	{
		if( IS_TRUE( self.truck.is_in_oob ) )
		{
			return;
		}
		
		self.truck notify( "oob_single" );
		self.truck endon( "oob_single" );
	
		self.truck.is_in_oob = true;
	}

	self CameraActivate( true );
	self CameraSetPosition( v_cam_pos );
	if( IsDefined( e_look_at ) )
	{
		self CameraSetLookAt( e_look_at );
	}

	if( IsInt( waitTime ) || IsFloat( waitTime ) )
	{
		wait( waitTime - 0.015 );
	}
	else
	{
		self util::waittill_any( waitTime, "disconnect" );
	}

	self CameraActivate( false );

	if( IsDefined( self.truck ) )
	{
		self.truck clientfield::increment( "reinit_vehicle_sounds" );

		wait 0.1;

		self.truck.is_in_oob = false;
	}
}

function fake_physicslaunch( target_pos, power )
{
	start_pos = self.origin;
	gravity = GetDvarInt( "bg_gravity" ) * -1;

	dist = Distance( start_pos, target_pos );
	time = dist / power;
	delta = target_pos - start_pos;

	drop = ( 0.5 * gravity ) * ( time * time );
	velocity = ( delta[ 0 ] / time, delta[ 1 ] / time, ( delta[ 2 ] - drop ) / time );

	level thread draw_line_ent_to_pos( self, target_pos );

	self MoveGravity( velocity, time );

	return time;
}

function draw_line_ent_to_pos( ent, pos, end_on )
{
	/#
		ent endon( "death" );
		ent notify( "stop_draw_line_ent_to_pos" );
		ent endon( "stop_draw_line_ent_to_pos" );
		if( isdefined( end_on ) )
		{
			ent endon( end_on );
		}
		while( true )
		{
			line( ent.origin, pos );
			wait( 0.05 );
		}
	#/
}

function onallplayersready()
{
	level flag::wait_till( "start_coop_logic" );

	array::thread_all( level.players, &initialblack );

	FreezeAllControls( true );
	while( !AreTexturesLoaded() )
	{
		FreezeAllControls( true );
		wait( 0.05 );
	}

	n_black_screen = 5;
	level thread fade_out_intro_screen( n_black_screen, 2, true );
}

function fade_out_intro_screen( hold_black_time = 5, fade_out_time = 2.5, destroyed_afterwards = true )
{
	lui::screen_fade_out( 0, undefined );

	if( isdefined( hold_black_time ) )
	{
		wait( hold_black_time );
	}
	else
	{
		wait( 0.2 );
	}

	if( !isdefined( fade_out_time ) )
	{
		fade_out_time = 1.5;
	}

	array::thread_all( level.players, &initialblackend );
	//level clientfield::set( "sndZMBFadeIn", 1 );
	lui::screen_fade_in( fade_out_time, undefined );
	wait( 1.6 );
	level flag::set( "initial_blackscreen_passed" );
}

function initialblack()
{
	self CloseMenu( "EndGameRank" );
	self CloseMenu( "EndGameResults" );
	self CloseMenu( "InitialBlack" );
	self OpenMenu( "InitialBlack" );
}

function initialblackend()
{
	self CloseMenu( "InitialBlack" );
}

function FreezeAllControls( b_freeze = false )
{
	foreach( player in level.players )
	{
		player FreezeControls( b_freeze );
	}
}

function GetRaceString()
{
	gametype = GetDvarString( "ui_gametype" );
	area = GetRaceLocation();
	return ( ( gametype == "znml" ) ? gametype : gametype + "_" + area );
}

function GetRaceLocation()
{
	return GetDvarString( "ui_location", "area1" );
}

function isValidUnlockablesTrack()
{
	gametype = GetDvarString( "ui_gametype" );
	return gametype !== "king" && gametype !== "";
}

// this allows us to calculate the whole track length.
// 1/25/2023 - Added support for a head to head mode
function FindTrackTime( e_node )
{
	DEFAULT( level.track_node_array, [] );
	DEFAULT( level.track_node_times, [] );

	start_index = e_node.targetname;
	n_index = level.track_node_array.size;

	DEFAULT( level.track_node_array[ n_index ], [] );
	DEFAULT( level.track_node_times[ n_index ], [] );

	// add our start node
	start_node = e_node;

	if( !IsDefined( start_node ) )
	{
		return;
	}

	ARRAY_ADD( level.track_node_array[ n_index ], start_node );

	// add this node too
	current_node = GetVehicleNode( e_node.target, "targetname" );

	if( !IsDefined( current_node ) )
	{
		return;
	}

	ARRAY_ADD( level.track_node_array[ n_index ], current_node );

	n_time = GetTimeFromVehicleNodeToNode( start_node, current_node );
	level.total_track_time = n_time;
	ARRAY_ADD( level.track_node_times[ n_index ], n_time );

	// calculate the rest of them until we reach the start again.
	while( current_node.targetname != start_node.targetname )
	{
		next_node = GetVehicleNode( current_node.target, "targetname" );
		n_time = GetTimeFromVehicleNodeToNode( current_node, next_node );
		level.total_track_time += n_time;

		// this node is good, add it too.
		current_node = next_node;
		ARRAY_ADD( level.track_node_array[ n_index ], current_node );
		ARRAY_ADD( level.track_node_times[ n_index ], n_time );
	}

	level flag::wait_till( "start_race" );
	TRUCK_DEBUG_SERVER( level.total_track_time );
}

// returns the approx. time this truck will finish.
// self == a player

#define INCHES_TO_MILES_SQ			63360 * 63360
function CalculateFinishTime( start_index = 0 )
{
	e_truck = self.truck;

	n_add_time = 0;

	e_start_node = level.track_node_array[ start_index ][ 0 ];

	// 99% of the time, this is defined, but check for it just in case.
	current_node = e_truck.ai_current_node;
	if( !IsDefined( current_node ) )
	{
		current_node = ArrayGetClosest( e_truck.origin, level.track_node_array[ start_index ] );
	}

	// get the node in front of him
	next_node = GetVehicleNode( current_node.target, "targetname" );
	next_node_index = VehicleNodeToArrayIndex( next_node, start_index );

	if( IsDefined( next_node ) && IsDefined( next_node_index ) )
	{
		// Do a map float to precisely calculate the distance
		n_add_time += e_truck GetTimeFromNodeDistance( current_node, next_node, start_index );

		// let's get the time it takes for the truck to realistically reach the end
		while( next_node.targetname != e_start_node.targetname && next_node_index != 0 )
		{
			n_add_time += level.track_node_times[ start_index ][ next_node_index ];
			
			next_node = GetVehicleNode( next_node.target, "targetname" );
			next_node_index = VehicleNodeToArrayIndex( next_node, start_index );
		}
	}

	// lets stack any additional laps they haven't completed yet.
	if( self.laps_completed < level.laps )
	{
		for( i = self.laps_completed; i < level.laps; i++ )
		{
			n_add_time += level.total_track_time;
		}
	}

	n_complete_time = GetTime() + ( n_add_time * 1000 );
	TRUCK_DEBUG_SERVER( n_complete_time );
	return Int( n_complete_time );
}

function GetTimeFromNodeDistance( node1, node2, n_index )
{
	node_index = VehicleNodeToArrayIndex( node1, n_index );
	ent_dist = Distance( self.origin, node2.origin );
	node_dist = Distance( node1.origin, node2.origin );

	return MapFloat( node_dist, 0, level.track_node_times[ n_index ][ node_index ], 0, ent_dist );
}

function VehicleNodeToArrayIndex( e_node, n_index )
{
	if( !IsDefined( n_index ) )
	{
		return undefined;
	}
	
	for( i = 0; i < level.track_node_array[ n_index ].size; i++ )
	{
		if( e_node == level.track_node_array[ n_index ][ i ] )
		{
			return i;
		}
	}

	return undefined;
}

function TruckUpdateStatus( e_truck, loc_string, n_update_val = 0 ) // 0 = global - 1 = self - 2 = everyone but self
{
	n_index = e_truck.truck_type;
	if( !IsDefined( n_index ) )
	{
		n_index = 0;
	}

	switch( n_update_val )
	{
		case 1:
		{
			e_truck.owner LUINotifyEvent( &"truck_notify", 2, n_index, loc_string );
			break;
		}
		case 2:
		{
			foreach( player in level.players )
			{
				if( player != e_truck.owner )
				{
					player LUINotifyEvent( &"truck_notify", 2, n_index, loc_string );
				}
			}
			break;
		}
		default:
		{
			LUINotifyEvent( &"truck_notify", 2, n_index, loc_string );
			break;
		}
	}
}

function DoRaceCountdown()
{
	LUINotifyEvent( &"start_race", 0 );
}

function ShowPlayerRank( n_wait )
{
	// set this to cash the player's points in
	if( IsDefined( self.truck ) )
	{
		self.truck.trick_stop_time = GetTime() - 500;
	}

	if( self istestclient() )
	{
		return;
	}

	self OpenMenu( "EndGameRank" );
	self.rank_showing = true;

	if( IsDefined( n_wait ) )
	{
		wait( n_wait );
		self CloseMenu( "EndGameRank" );
		self.rank_showing = false;
	}
}

function CloseandShowResults()
{
	foreach( player in level.players )
	{
		if( player istestclient() )
		{
			continue;
		}

		player thread MonsterJamStats::uploadStats();

		if( IS_TRUE( player.rank_showing ) )
		{
			player CloseMenu( "EndGameRank" );
			player.rank_showing = false;
		}

		player OpenMenu( "EndGameResults" );
	}
}
	
// TODO: SORT IN LUA
function SetPlayerGlobalPos( pos )
{
	self.score = pos;
	self.pers[ "score" ] = self.score;
}

function SetScoreboardColumnsAndGlobals( column1, column2, column3, column4, column5 )
{
	setscoreboardcolumns( column1, column2, column3, column4, column5, "plants" );
}