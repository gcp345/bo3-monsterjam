#using scripts\codescripts\struct;

#using scripts\cp\_callbacks;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\shared\array_shared;
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

#using scripts\cp\_mj_music;
#using scripts\cp\_mj_oob;
#using scripts\cp\_mj_score;
#using scripts\cp\_mj_smashables;
#using scripts\cp\_mj_utility;

#namespace crosscountry;

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
	level.custom_monster_truck_spawn_callback = &custom_monster_truck_spawn_callback;

	gameobjects::register_allowed_gameobject( "coop" );

	str_targetname = MonsterJamUtility::GetRaceString();
	gameobjects::register_allowed_gameobject( str_targetname );

	// Sets the scoreboard columns and determines with data is sent across the network
	// score is your current position
	// pointstowin is your actual score
	setscoreboardcolumns( "pointstowin", "destructions", "", "", "" );
}

function init_flags()
{
	level flag::init( "start_race" );
	level flag::init( "checkpoints_ready" );
	level flag::init( "finish_race" );
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

	level thread startRace();
}

function startRace()
{
	level flag::wait_till( "all_players_spawned" );
	MonsterJamUtility::FreezeAllControls( true );
	level flag::wait_till( "initial_blackscreen_passed" );
	MonsterJamUtility::FreezeAllControls( true );

	//iprintlnbold( "GO!" );
	level flag::set( "start_race" );
	MonsterJamUtility::FreezeAllControls( false );

	wait 2;
	level flag::set( "start_soundtrack" );
}

function onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("CROSSCOUNTRY:onSpawnPlayer");
//self spawn( self.origin, self.angles, "coop" );
	pixendevent();
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

// this is cross country: anybody can spawn in when they would like to
function may_player_spawn()
{
	return true;
}

// use our predefined 'crosscountry' spawns
function custom_monster_truck_spawn_callback()
{
	gametype = GetDvarString( "ui_gametype" );
	//area = GetDvarString( "ui_location", "area1" );
	str_targetname = gametype + "_spawn_" + self GetEntityNumber();

	struct = struct::get( str_targetname, "targetname" );

	if( IsDefined( struct ) )
	{
		return struct;
	}

	return undefined;
}

// use any spawn that we have in the level
// pick the closest spawn instead
function custom_monster_truck_respawn_callback()
{
	str_noteworthy = MonsterJamUtility::GetRaceString();

	a_respawns = struct::get_array( str_noteworthy, "script_noteworthy" );

	best_respawn = a_respawns[ 0 ];
	best_score = 100000;

	foreach( respawn in a_respawns )
	{
		if( respawn.script_string !== "respawn_point" )
		{
			continue;
		}

		score = Distance( self.origin, respawn.origin );
		if( score < best_score )
		{
			best_respawn = respawn;
			best_score = score;
		}
	}

	return best_respawn;
}