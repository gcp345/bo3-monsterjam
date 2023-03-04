#using scripts\codescripts\struct;

#using scripts\cp\_callbacks;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

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

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_ai;

#using scripts\cp\_mj_music;
#using scripts\cp\_mj_oob;
#using scripts\cp\_mj_score;
#using scripts\cp\_mj_smashables;
#using scripts\cp\_mj_stats;
#using scripts\cp\_mj_utility;

#precache( "string", "UI_RACETYPE_CIRCUIT_FINISHED" );

#namespace circuit;

function autoexec ignore_systems()
{
	// disable the laststand effect
	level.var_be177839 = "";

	//shutdown unwanted systems - doing it in an autoexec is the only clean way to do it
	system::ignore("cybercom");
	system::ignore("healthoverlay");
	system::ignore("challenges");
	system::ignore("rank");
	system::ignore("hacker_tool");
	system::ignore("grapple");
	system::ignore("replay_gun");
	system::ignore("riotshield");
	system::ignore("oed");
	system::ignore("explosive_bolt");
	system::ignore("empgrenade");
	system::ignore("spawning");	
	system::ignore("save");	
}

function main()
{
	// disable mp leaderboard
	level.var_e2c19907 = true;

	globallogic::init();
	
	level.gametype = toLower( GetDvarString( "g_gametype" ) );

	init_flags();

	clientfield::register( "clientuimodel", "MonsterTruckPos", VERSION_SHIP, GetMinBitCountForNum( 6 ), "int" );
	clientfield::register( "clientuimodel", "MonsterTruckPosTotal", VERSION_SHIP, GetMinBitCountForNum( 6 ), "int" );
	clientfield::register( "clientuimodel", "MonsterTruckLaps", VERSION_SHIP, GetMinBitCountForNum( 5 ), "int" );
	clientfield::register( "clientuimodel", "MonsterTruckLapsTotal", VERSION_SHIP, GetMinBitCountForNum( 5 ), "int" );

	clientfield::register( "clientuimodel", "MonsterTruckTimeStart", VERSION_SHIP, 31, "int" );
	clientfield::register( "clientuimodel", "MonsterTruckTimeFinish", VERSION_SHIP, 31, "int" );
	clientfield::register( "clientuimodel", "MonsterTruckTimeState", VERSION_SHIP, 3, "int" );
	
	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 0 );
	util::registerScoreLimit( 0, 0 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 0 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gametype, 15, 0, 1440 );

	level.scoreRoundWinBased 			= false;
	level.teamScorePerKill 			= 0;//GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath 		= 0;//GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot 		= 0;//GetGametypeSetting( "teamScorePerHeadshot" );
	level.teamBased 				= true;
	level.overrideTeamScore 		= true;
	level.onStartGameType 			=&onStartGameType;
	level.onSpawnPlayer 			=&onSpawnPlayer;
	level.onPlayerKilled	 		=&onPlayerKilled;
	level.playerMaySpawn 	 		= &may_player_spawn;
	level.gametypeSpawnWaiter 		= &wait_to_spawn;	

	level.disablePrematchMessages 	= true;
	level.endGameOnScoreLimit	 	= false;
	level.endGameOnTimeLimit 		= false;
	level.respawn_next_checkpoint 	= false;

	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;
	level.onEndGame = &onEndGame;

	// override custom vars
	level.custom_monster_truck_respawn_callback = &custom_monster_truck_respawn_callback;
	level.monster_jam_trucks_enable_ai = true;

	gameobjects::register_allowed_gameobject( "coop" );

	str_targetname = MonsterJamUtility::GetRaceString();
	gameobjects::register_allowed_gameobject( str_targetname );

	level thread setupCheckPoints( str_targetname );
	level thread waitUntilRaceCompletes();

	callback::on_disconnect( &on_player_disconnect );

	// Sets the scoreboard columns and determines with data is sent across the network
	// score is your current position
	// pointstowin is your actual score
	setscoreboardcolumns( "score", "pointstowin", "destructions", "", "", "objtime" );
}

function init_flags()
{
	level flag::init( "start_race" );
	level flag::init( "checkpoints_ready" );
	level flag::init( "finish_race" );

	level.laps = ( MonsterJamUtility::GetRaceLocation() == "area3" ? 2 : 3 ); // big circuits are always 2 laps
}

function onStartGameType()
{
	level.displayRoundEndText = false;
	setClientNameMode("auto_change");

	game["switchedsides"] = false;
	
	// now that the game objects have been deleted place the influencers
//	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.playerteams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_COOP" );
		util::setObjectiveHintText( team, &"OBJECTIVES_COOP_HINT" );
		util::setObjectiveScoreText( team, &"OBJECTIVES_COOP" );

		spawnlogic::add_spawn_points( team, "cp_coop_spawn" );
		spawnlogic::add_spawn_points( team, "cp_coop_respawn" );
	}

	spawning::updateAllSpawnPoints();


	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );

	level thread updatePlayerPositions();
	level thread startRace();
}

function onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("CIRCUIT:onSpawnPlayer");
//self spawn( self.origin, self.angles, "coop" );
	self thread wait_until_start();
	self thread position_distance_tracker();
	pixendevent();
}

function wait_until_start()
{
	self.cur_checkpoint = -1;
	self.checkpoints = [];
	self.laps_completed = 1;
}

function onEndGame( winningTeam )
{
	ExitLevel( false );	//back to lobby
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
}

function wait_to_spawn()
{
	return true;
}

// if the race started already, he can't spawn
function may_player_spawn()
{
	if( level flag::get( "start_race" ) )
	{
		return false;
	}

	return true;
}

//1/14/2023 - Added a sort so smashables wouldn't conflict
function sortEntArray( a_ents )
{
	a_new_ents = [];
	foreach( ent in a_ents )
	{
		// Is it a trigger?
		if( ent.classname != "trigger_multiple" )
		{
			continue;
		}

		// must contain the checkpoint script_string
		if( !IsDefined( ent.script_string ) || ent.script_string != "checkpoint" )
		{
			continue;
		}

		ARRAY_ADD( a_new_ents, ent );
	}

	return a_new_ents;
}

function setupCheckPoints( str_targetname )
{
	checkpoints = GetEntArray( str_targetname, "script_gameobjectname" );
	checkpoints = sortEntArray( checkpoints );
	if( !IsDefined( checkpoints ) || checkpoints.size == 0 )
	{
		/#
		assertmsg( "No checkpoints found!" );
		#/
		return;
	}

	level.start_line = checkpoints[ 0 ];

	foreach( checkpoint in checkpoints )
	{
		if( IsDefined( checkpoint.script_noteworthy ) && checkpoint.script_noteworthy === "start" )
		{
			level.start_line = checkpoint;
		}
	}

	// this is our way of checking if we found a start/finish line
	if( !IsDefined( level.start_line.script_noteworthy ) || level.start_line.script_noteworthy !== "start" )
	{
		/#
		assertmsg( "No start point found!" );
		#/
		return;
	}

	// create the array: we need to index and order the checkpoint ourselves
	level.checkpoints = [];

	b_full_lap = false;

	// finish line is always 0
	level.start_line.index = 0;
	next_index = 1;

	prev_checkpoint = level.start_line;
	ARRAY_ADD( level.checkpoints, prev_checkpoint );

	while( !b_full_lap )
	{
		e_next_checkpoint = GetEnt( prev_checkpoint.target, "targetname" );
		if( IsDefined( e_next_checkpoint ) )
		{
			if( IsDefined( e_next_checkpoint.script_noteworthy ) && e_next_checkpoint.script_noteworthy === "start" )
			{
				b_full_lap = true;
				break;
			}

			ARRAY_ADD( level.checkpoints, e_next_checkpoint );

			e_next_checkpoint.index = next_index;
			next_index++;
			prev_checkpoint = e_next_checkpoint;
		}
	}

	array::thread_all( checkpoints, &checkPointThink );

	level flag::set( "checkpoints_ready" );
}

function checkPointThink()
{
	level endon( "race_ended" );

	b_start_line = IsDefined( self.script_noteworthy ) && self.script_noteworthy === "start";
	this_index = self.index;

	n_next = this_index + 1;
	// check if the next checkpoint is the finish line
	if( n_next == level.checkpoints.size )
	{
		n_next = 0;
	}
	next_index = level.checkpoints[ n_next ].index;

	n_prev = this_index - 1;
	// check if this is the first checkpoint
	if( n_prev < 0 )
	{
		n_prev = level.checkpoints.size - 1;
	}
	prev_index = level.checkpoints[ n_prev ].index;

	while( true )
	{
		self waittill( "trigger", e_who );
		if( IsDefined( e_who ) )
		{
			// get the correct entity
			player = e_who;
			if( IsVehicle( e_who ) )
			{
				player = e_who.owner;
			}

			if( !IsPlayer( player ) )
			{
				//IPrintLnBold( "Whatever passed through me was not a player or vehicle!" );
				continue;
			}

			if( IS_TRUE( player.completed_race ) )
			{
				continue;
			}

			if( !IsDefined( player.cur_checkpoint ) )
			{
				player.cur_checkpoint = -1;
			}

			if( b_start_line )
			{
				if( player.cur_checkpoint == -1 )
				{
					player.cur_checkpoint = 0;
					if( !IsInArray( player.checkpoints, self ) )
					{
						ARRAY_ADD( player.checkpoints, self );
					}
					//IPrintLnBold( "Started the race!" );
				}

				// check if the players checkpoint size is equal to level
				else if( player.checkpoints.size == level.checkpoints.size )
				{
					player.checkpoints = [];
					player.cur_checkpoint = 0;
					player.laps_completed++;

					//IPrintLnBold( "Completed a lap!" );

					if( player.laps_completed > level.laps )
					{
						player thread player_completed_race();
					}
				}

				else
				{
					// check if this checkpoint is included
					if( !IsInArray( player.checkpoints, self ) )
					{
						ARRAY_ADD( player.checkpoints, self );
					}
					//IPrintLnBold( "NOT A FULL LAP!" );
				}
			}
			else
			{
				// he has already been through this checkpoint, ignore
				if( player.cur_checkpoint == this_index )
				{
					continue;
				}

				// he's coming to the correct checkpoint, do some checks
				if( player.cur_checkpoint == prev_index )
				{
					// check if this checkpoint is included
					if( !IsInArray( player.checkpoints, self ) )
					{
						//IPrintLnBold( "Went through the correct checkpoint!" );
						player.cur_checkpoint = this_index;
						ARRAY_ADD( player.checkpoints, self );
					}
				}

				// he turned around
				if( player.cur_checkpoint < this_index )
				{
					player.truck thread MonsterTruck::doRespawn( 1 );
					player thread MonsterJamUtility::SetOOBCamera( 1, player GetPlayerCameraPos(), player.truck );
					continue;
				}

				// somehow he got ahead, respawn this player since he cheated
				if( player.cur_checkpoint > this_index )
				{
					// trucks can get confused sometimes so respawn them only
					if( player istestclient() )
					{
						player.truck thread MonsterTruck::doRespawn( 0.05 );
					}
					continue;
				}
			}
		}
	}
}

function startRace()
{
	level flag::wait_till( "all_players_spawned" );
	MonsterJamUtility::FreezeAllControls( true );
	level flag::wait_till( "checkpoints_ready" );
	level flag::wait_till( "initial_blackscreen_passed" );

	MonsterJamUtility::FreezeAllControls( true );
	MonsterJamUtility::DoRaceCountdown();

	for( i = 3; i > 0; i-- )
	{
		//IPrintLnBold( i );
		wait( 1 );
	}

	//iprintlnbold( "GO!" );
	level flag::set( "start_race" );
	level.start_time = GetTime();
	foreach( player in level.players )
	{
		player clientfield::set_player_uimodel( "MonsterTruckTimeStart", level.start_time );
		player clientfield::set_player_uimodel( "MonsterTruckTimeState", 1 );
	}
	MonsterJamUtility::FreezeAllControls( false );

	wait 2;
	level flag::set( "start_soundtrack" );
}

function player_completed_race()
{
	// if this variable is undefined, this player wins
	if( !IsDefined( level.completionists ) )
	{
		level.completionists = [];
	}

	ARRAY_ADD( level.completionists, self );
	self.finish_pos = level.completionists.size;

	//self playsoundtoplayer( "mus_mj_finish_place_" + self.finish_pos, self );
	self thread MonsterJamUtility::ShowPlayerRank();

	MonsterJamUtility::TruckUpdateStatus( self.truck, &"UI_RACETYPE_CIRCUIT_FINISHED", 2 );
	self.complete_time = GetTime();

	n_time = self.complete_time - level.start_time;

	self clientfield::set_player_uimodel( "MonsterTruckTimeFinish", n_time );
	self clientfield::set_player_uimodel( "MonsterTruckTimeState", 2 );

	self.objtime = Int( n_time / 1000 );
	self.pers[ "objtime" ] = self.objtime;

	self.completed_race = true;
	self FreezeControls( true );
}

function updatePlayerPositions()
{
	level flag::wait_till( "all_players_spawned" );
	level flag::wait_till( "checkpoints_ready" );

	level flagsys::wait_till( "load_main_complete" );

	while( true )
	{
		WAIT_SERVER_FRAME;

		updatePlayerLobbySize();

		a_positions = [];
		b_sort = false;

		// code borrowed from Rush mode
		foreach( player in GetPlayers() )
		{
			if( IsDefined( player.sessionstate ) && player.sessionstate === "spectator" )
			{
				continue;
			}

			player clientfield::set_player_uimodel( "MonsterTruckLapsTotal", level.laps );
			laps_completed = Int( Min( player.laps_completed, level.laps ) );
			player clientfield::set_player_uimodel( "MonsterTruckLaps", laps_completed );

			if( !IsDefined( player.current_pos ) )
			{
				player.current_pos = -1;
			}

			if( !IsDefined( player.previous_pos ) )
			{
				player.previous_pos = -1;
			}

			ARRAY_ADD( a_positions, player.track_completion );
		}

		a_positions = array::sort_by_value( a_positions, false );
		_updatePlayerPositions( a_positions );
	}
}

function _updatePlayerPositions( a_positions )
{
	new_pos = 0;

	// code borrowed from Rush mode
	foreach( position in a_positions )
	{
		new_pos++;

		foreach( player in GetPlayers() )
		{
			// if the player already finish, don't change him him
			if( IsDefined( player.finish_pos ) )
			{
				player clientfield::set_player_uimodel( "MonsterTruckPos", player.finish_pos );
				player MonsterJamUtility::SetPlayerGlobalPos( player.finish_pos );
				continue;
			}

			if( IsDefined( player.track_completion ) && player.track_completion == position )
			{
				player.previous_pos = player.current_pos;
				player.current_pos = new_pos;
				player clientfield::set_player_uimodel( "MonsterTruckPos", player.current_pos );
				player MonsterJamUtility::SetPlayerGlobalPos( player.current_pos );
				continue;
			}
			continue;
		}
	}
}

function updatePlayerLobbySize()
{
	players = GetPlayers();
	count = 0;
	foreach( player in players )
	{
		if( IsDefined( player.sessionstate ) && player.sessionstate === "spectator" )
		{
			continue;
		}
		count++;
	}
	foreach( player in players )
	{
		player clientfield::set_player_uimodel( "MonsterTruckPosTotal", count );
	}
}

function position_distance_tracker()
{
	self endon( "disconnect" );

	// wait until checkpoints have been created
	level flag::wait_till( "checkpoints_ready" );

	while( IsDefined( self ) )
	{
		WAIT_SERVER_FRAME;

		if( IS_TRUE( self.completed_race ) )
		{
			continue;
		}

		if( self.cur_checkpoint == -1 )
		{
			dist = Distance( self.origin, level.checkpoints[ 0 ].origin );
			self.track_completion = dist * -1; // make it negative so it knows how to sort it
			continue;
		}

		next_idx = self.cur_checkpoint + 1;
		// check if the next checkpoint is the finish line
		if( next_idx == level.checkpoints.size )
		{
			next_idx = 0;
		}
		next_chk = level.checkpoints[ next_idx ];

		curr_idx = self.cur_checkpoint;
		// check if this is the first checkpoint
		if( curr_idx < 0 )
		{
			curr_idx = level.checkpoints.size - 1;
		}
		curr_chk = level.checkpoints[ curr_idx ];

		player_dist = Distance( self.origin, next_chk.origin );
		chk_dist = Distance( curr_chk.origin, next_chk.origin );

		// we don't want the number floating over 1 by mistake
		track_completion = Min( MapFloat( 0, chk_dist, ( next_idx == 0 ? 1 : ( next_idx / ( level.checkpoints.size ) ) ), ( curr_idx / ( level.checkpoints.size ) ), player_dist ), 0.9999 );

		if( IsDefined( self.laps_completed ) )
		{
			track_completion = self.laps_completed + track_completion;
		}
		self.track_completion = track_completion;
	}
}

function waitUntilRaceCompletes()
{
	level flag::wait_till( "start_race" );

	while( true )
	{
		WAIT_SERVER_FRAME;
		b_end_game = true;
		foreach( player in level.players )
		{
			if( IsDefined( player.sessionstate ) && player.sessionstate === "spectator" )
			{
				continue;
			}

			if( player istestclient() ) // we don't care about test clients finishing
			{
				continue;
			}

			if( !IS_TRUE( player.completed_race ) )
			{
				b_end_game = false;
			}
		}

		if( b_end_game )
		{
			level notify( "stop_ai_trucks" );
			level notify( "race_ended" );

			SetMatchFlag( "disableIngameMenu", 1 );

			SortUnfinishedPlayers();

			foreach( player in level.players )
			{
				player SetClientUIVisibilityFlag( "weapon_hud_visible", 0 );
				player SetClientMiniScoreboardHide( true );

				if( player == level.completionists[ 0 ] )
				{
					player MonsterJamStats::incrementStat( "raceswon", 1 );
				}
				player MonsterJamStats::incrementStat( "racescompleted", 1 );
			}

			wait 2;
			level thread MonsterJamUtility::CloseandShowResults();
			wait 6;
			MonsterJamMusic::finish_soundtrack();
			level thread lui::screen_fade_out( 1.5 );
			wait 2;
			thread globallogic::endgame( level.completionists[ 0 ].team, &"COOP_GAME_OVER" );
		}
	}
}

function SortUnfinishedPlayers()
{
	WAIT_SERVER_FRAME;
	a_temp_players = [];
	a_temp_times = [];
	foreach( player in level.players )
	{
		if( !player istestclient() )
		{
			continue;
		}

		if( IS_TRUE( player.completed_race ) )
		{
			continue;
		}

		ARRAY_ADD( a_temp_players, player );

		player.temp_time = ( player MonsterJamUtility::CalculateFinishTime( 0 ) - level.start_time ); // 0 is the default index for time calculations
		ARRAY_ADD( a_temp_times, player.temp_time );
	}

	start_pos = level.completionists.size;

	a_temp_times = array::sort_by_value( a_temp_times, true );
	foreach( n_time in a_temp_times )
	{
		start_pos++;
		foreach( player in a_temp_players )
		{
			if( IsDefined( player.finish_pos ) )
			{
				continue;
			}

			if( player.temp_time == n_time )
			{
				// if this variable is undefined, this player wins
				if( !IsDefined( level.completionists ) )
				{
					level.completionists = [];
				}

				ARRAY_ADD( level.completionists, player );
				player.finish_pos = level.completionists.size;

				player MonsterJamUtility::SetPlayerGlobalPos( player.finish_pos );
	
				player.objtime = Int( n_time / 1000 );
				player.pers[ "objtime" ] = player.objtime;

				player.completed_race = true;
			}
		}
	}
}

function custom_monster_truck_respawn_callback()
{
	str_noteworthy = MonsterJamUtility::GetRaceString();
	
	curr_idx = self.cur_checkpoint;
	// check if this is the first checkpoint
	if( !IsDefined( curr_idx ) || curr_idx < 0 )
	{
		curr_idx = level.checkpoints.size - 1;
	}
	curr_chk = level.checkpoints[ curr_idx ];

	a_respawns = struct::get_array( curr_chk.target, "targetname" );

	best_respawn = a_respawns[ 0 ];
	best_score = DistanceSquared( self.origin, best_respawn.origin );

	for( i = 1; i < a_respawns.size; i++ )
	{
		respawn = a_respawns[ i ];
		if( !IsDefined( respawn.script_noteworthy ) )
		{
			Assert( "Respawn at " + respawn.origin + " is missing gametype information!" );
			continue;
		}

		if( !IsSubStr( respawn.script_noteworthy, str_noteworthy ) )
		{
			continue;
		}

		if( respawn.script_string !== "respawn_point" )
		{
			continue;
		}

		score = DistanceSquared( self.origin, respawn.origin );
		if( score < best_score )
		{
			best_respawn = respawn;
			best_score = score;
		}
	}

	return best_respawn;
}

function on_player_disconnect()
{
	if( IsDefined( level.completionists ) )
	{
		if( IsInArray( level.completionists, self ) )
		{
			ArrayRemoveValue( level.completionists, self );
		}
	}
}