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
#using scripts\shared\util_shared;

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

#precache( "xmodel", "tg_mj_koth_crown" );
#precache( "string", "UI_RACETYPE_KING_CROWN" );

#namespace king;

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

	clientfield::register( "vehicle", "show_king_vehicle", VERSION_SHIP, 1, "int" );
	clientfield::register( "scriptmover", "show_king_object", VERSION_SHIP, 1, "int" );
	
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
	level.monster_jam_trucks_enable_ai = false;

	MonsterTruck::RegisterTruckRespawnCallback( &on_truck_respawn );

	gameobjects::register_allowed_gameobject( "coop" );
	gameobjects::register_allowed_gameobject( "crosscountry" );

	str_targetname = MonsterJamUtility::GetRaceString();
	gameobjects::register_allowed_gameobject( str_targetname );

	// Sets the scoreboard columns and determines with data is sent across the network
	// score is your current position
	// pointstowin is your actual score
	setscoreboardcolumns( "defends", "pointstowin", "destructions", "", "" );
}

function init_flags()
{
	level flag::init( "start_race" );
	level flag::init( "checkpoints_ready" );
	level flag::init( "finish_race" );

	level.koth_limit = 200;
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
	level flag::set( "checkpoints_ready" );
	MonsterJamUtility::FreezeAllControls( true );
	level flag::wait_till( "initial_blackscreen_passed" );

	level thread crownManager();
	level thread waitUntilRaceCompletes();

	MonsterJamUtility::FreezeAllControls( true );
	MonsterJamUtility::DoRaceCountdown();

	wait 3;

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
	/*
	gametype = "crosscountry";//GetDvarString( "ui_gametype" );
	//area = GetDvarString( "ui_location", "area1" );
	str_targetname = gametype + "_spawn_" + self GetEntityNumber();

	struct = struct::get( str_targetname, "targetname" );

	if( IsDefined( struct ) )
	{
		return struct;
	}

	return undefined;
	*/

	str_noteworthy = "crosscountry";//MonsterJamUtility::GetRaceString();

	a_respawns = struct::get_array( str_noteworthy, "script_noteworthy" );
	e_respawn = array::random( a_respawns );
	e_respawn.no_crown = true;

	return e_respawn;
}

// use any spawn that we have in the level
// pick the closest spawn instead
function custom_monster_truck_respawn_callback()
{
	str_noteworthy = "crosscountry";//MonsterJamUtility::GetRaceString();

	a_respawns = struct::get_array( str_noteworthy, "script_noteworthy" );

	a_respawns = ArraySortClosest( a_respawns, self.origin );

	return a_respawns[ 0 ];
}

function crownManager()
{
	level flag::wait_till( "start_race" );

	level endon( "race_ended" );

	while( true )
	{
		WAIT_SERVER_FRAME;
		if( !IsDefined( level.crown_holder ) && !IsDefined( level.crown_powerup ) )
		{
			spawnCrown();
		}
		if( IsDefined( level.crown_holder ) && IsDefined( level.crown_holder.owner ) )
		{

		}
	}
}

function spawnCrown()
{
	v_best_spot = crownFindBestSpot();

	e_crown = Spawn( "script_model", v_best_spot + ( 0, 0, 75 ) );
	e_crown.targetname = "crown_powerup";
	e_crown.angles = ( 15, 0, 0 );
	e_crown SetScale( 2 );
	e_crown SetModel( "tg_mj_koth_crown" );
	e_crown thread spin_until_death();

	e_crown createHudElement();

	e_crown clientfield::set( "show_king_object", 1 );

	e_trigger = Spawn( "trigger_box", e_crown.origin, SPAWNFLAG_TRIGGER_VEHICLE + SPAWNFLAG_TRIGGER_AI_AXIS + SPAWNFLAG_TRIGGER_AI_ALLIES, 80, 80, 80 );
	e_trigger.crown = e_crown;
	e_crown.trigger = e_trigger;

	e_trigger thread waittill_trigger();

	level.crown_powerup = e_crown;
}

function spin_until_death()
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self RotateVelocity( ( 0, 360, 0 ), 5, 1, 1 );
		wait 5;
	}
}

function waittill_trigger()
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self waittill( "trigger", e_who );

		if( IsDefined( e_who ) )
		{
			if( IsEntity( e_who ) && !IsVehicle( e_who ) && IsDefined( e_who.owner ) ) // this could potientally be a part flying towards this
			{
				e_who = e_who.owner;
			}
			else if( IsPlayer( e_who ) )
			{
				e_who = e_who.truck;
			}

			level.crown_holder = e_who;
			level.crown_holder thread updateCrown( true );
			MonsterJamUtility::TruckUpdateStatus( e_who, &"UI_RACETYPE_KING_CROWN", 0 );

			self.crown Delete();
			if( IsDefined( self.crown.king_headicon ) )
			{
				self.crown.king_headicon Destroy();
			}
			self Delete();

			level.crown_powerup = undefined;
		}
	}
}

function updateCrown( b_stays = true )
{
	if( b_stays )
	{
		if( !IsDefined( self.crown_model ) )
		{
			self.crown_model = Spawn( "script_model", self GetTagOrigin( "j_spine4" ) + ( 0, 0, 43 ) );
			self.crown_model SetScale( 1.5 );
			self.crown_model SetModel( "tg_mj_koth_crown" );
			self.crown_model.angles = self.angles;
			self.crown_model LinkTo( self );
			self.crown_model clientfield::set( "show_king_object", 1 );
		}
		self.team = "axis";
		self.owner.team = "axis";

		self createHudElement();
	}
	else
	{
		if( IsDefined( self.crown_model ) )
		{
			self.crown_model Delete();
			self.crown_model = undefined;
		}
		if( IsDefined( self.king_headicon ) )
		{
			self.king_headicon Destroy();
		}
		self.team = "allies";
		self.owner.team = "allies";
	}
}

function createHudElement()
{
	headicon = NewTeamHudElem("allies");
	headicon.archived = true;
	headicon.x = 0;
	headicon.y = 0;
	headicon.z = 42;
	headicon.alpha = .8;
	headicon.color = ( 1, 1, 0 );
	headicon setShader("hud_status_dead", 6, 6);
	headicon SetWayPoint( false ); // false = uniform size in 3D instead of uniform size in 2D
	headicon SetTargetEnt( self );

	self.king_headicon = headicon;
}

function crownFindBestSpot()
{
	a_respawns = struct::get_array( "crosscountry", "script_noteworthy" );

	v_spots = [];
	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
		a_player_respawns = ArraySortClosest( a_respawns, player.truck.origin );
		v_spots[ i ] = a_player_respawns[ a_player_respawns.size - 1 ].origin;
	}

	v_farthest_point = v_spots[ 0 ];
	for( i = 1; i < v_spots.size; i++ )
	{
		v_farthest_point = v_farthest_point + v_spots[ i ];
	}
	n_spots_size = v_spots.size;
	v_farthest_point = ( v_farthest_point[ 0 ] / n_spots_size, v_farthest_point[ 1 ] / n_spots_size, v_farthest_point[ 2 ] / n_spots_size );

	a_sorted_spots = ArraySortClosest( a_respawns, v_farthest_point );

	return a_sorted_spots[ 0 ].origin;
}

function on_truck_respawn()
{
	if( IsDefined( level.crown_holder ) && level.crown_holder == self )
	{
		level.crown_holder thread updateCrown( false );
		level.crown_holder = undefined;
	}
}

function waitUntilRaceCompletes()
{
	level flag::wait_till( "start_race" );

	level.winner = undefined;

	while( true )
	{
		WAIT_SERVER_FRAME;
		b_end_game = false;//level.players.size <= 1;

		foreach( player in level.players )
		{
			if( IsDefined( player.sessionstate ) && player.sessionstate === "spectator" )
			{
				continue;
			}

			if( IsDefined( player.defends ) && player.defends == level.koth_limit ) // race should end as soon as one finishes
			{
				level.winner = player;
				b_end_game = true;
				break;
			}
		}

		if( b_end_game )
		{
			level notify( "stop_ai_trucks" );
			level notify( "race_ended" );

			SetMatchFlag( "disableIngameMenu", 1 );

			foreach( player in level.players )
			{
				player SetClientUIVisibilityFlag( "weapon_hud_visible", 0 );
				player SetClientMiniScoreboardHide( true );

				if( player == level.winner )
				{
					player MonsterJamStats::incrementStat( "raceswon", 1 );
				}
				player MonsterJamStats::incrementStat( "racescompleted", 1 );
			}

			wait 2;
			level thread MonsterJamUtility::CloseandShowResults();
			//IPrintLnBold( "the results are in! " + level.completionists[ 0 ].playername + " is the winner!" );
			wait 6;
			MonsterJamMusic::finish_soundtrack();
			level thread lui::screen_fade_out( 1.5 );
			wait 2;
			thread globallogic::endgame( level.winner.team, &"COOP_GAME_OVER" );
		}
	}
}