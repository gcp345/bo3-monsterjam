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

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_utility;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_ai;
#insert scripts\shared\vehicles\_monster_truck.gsh;

#precache( "lui_menu_data", "truck_unlocks_subscription" );

#namespace MonsterJamStats;

REGISTER_SYSTEM( #"MonsterJamStats", &__init__, undefined )

#define BIT_NOT_UNLOCKED					"0"
#define BIT_UNLOCKED 						"1"
#define BIT_JUST_UNLOCKED					"2" // if it's 2, it means we need to show the unlock menu

function __init__()
{
	if( MonsterJamUtility::isValidUnlockablesTrack() )
	{
		callback::on_spawned( &on_player_spawned );

		for( i = 1; i <= TRUCK_INDEX_LIMIT; i++ )
		{
			level initFakeStat( "truckid" + i );
		}

		start_index = TRUCK_INDEX_LIMIT;
		level initFakeStat( "monsterpoints" );
		level initFakeStat( "objectsdestroyed" );
		level initFakeStat( "highestpoints" );
		level initFakeStat( "highestmultiplier" );
		level initFakeStat( "racescompleted" );
		level initFakeStat( "raceswon" );
		level initFakeStat( "distance" );
		level initFakeStat( "monsterspectacles" );
	}
}

function on_player_spawned()
{
	WAIT_SERVER_FRAME;

	if( !self isValidForStats() )
	{
		return;
	}

	str_data = GetDvarString( "truck_unlocks_data_" + self.playername, "" );
	if( str_data == "" )
	{
		counter = 0;
		while( str_data == "" && counter <= 150 )
		{
			str_data = GetDvarString( "truck_unlocks_data_" + self.playername, "" );
			counter++;
			wait 0.1;
		}
	}

	//if( str_data != "" )
	{
		data = StrTok( str_data, "," );

		for( i = 1; i <= TRUCK_INDEX_LIMIT; i++ )
		{
			self initPlayerStat( "truckid" + i, ( IsDefined( data[ i - 1 ] ) ? data[ i - 1 ] : BIT_NOT_UNLOCKED ) );
		}

		start_index = TRUCK_INDEX_LIMIT;
		self initPlayerStat( "monsterpoints", ( IsDefined( data[ start_index ] ) ? data[ start_index ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "objectsdestroyed", ( IsDefined( data[ start_index + 1 ] ) ? data[ start_index + 1 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "highestpoints", ( IsDefined( data[ start_index + 2 ] ) ? data[ start_index + 2 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "highestmultiplier", ( IsDefined( data[ start_index + 3 ] ) ? data[ start_index + 3 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "racescompleted", ( IsDefined( data[ start_index + 4 ] ) ? data[ start_index + 4 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "raceswon", ( IsDefined( data[ start_index + 5 ] ) ? data[ start_index + 5 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "distance", ( IsDefined( data[ start_index + 6 ] ) ? data[ start_index + 6 ] : BIT_NOT_UNLOCKED ) );
		self initPlayerStat( "monsterspectacles", ( IsDefined( data[ start_index + 7 ] ) ? data[ start_index + 7 ] : BIT_NOT_UNLOCKED ) );
	}

	/#
	if( GetDvarInt( "scr_truck_stat_test", 0 ) == 1 )
	{
		self thread unlockEveryTruck();
	}
	#/

	// unlock all of these just in case
	self unlockTruck( TRUCK_INDEX_GRAVEDIGGER );
	self unlockTruck( TRUCK_INDEX_MONSTERMUTT );
	self unlockTruck( TRUCK_INDEX_BOUNTYHUNTER );
	self unlockTruck( TRUCK_INDEX_BULLDOZER );
	self unlockTruck( TRUCK_INDEX_BLUETHUNDER );
	self unlockTruck( TRUCK_INDEX_KINGKRUNCH );

	self thread truckUnlockonPoints( TRUCK_INDEX_DESTROYER, 25000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_BLACKSMITH, 75000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_ELTOROLOCO, 150000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_SUZUKI, 255000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_PREDATOR, 375000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_MAXD, 495000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_SCARLETBANDIT, 675000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_CAPTCURSE, 855000 );
	self thread truckUnlockonPoints( TRUCK_INDEX_AVENGER, 1080000 );

	self thread trackDistance();
}

function hasTruckAlready( n_truck_index )
{
	if( !self isValidForStats() )
	{
		return;
	}

	if( IsDefined( n_truck_index ) )
	{
		data = self.pers[ "truckid" + n_truck_index ];//self GetStructFromHashID( "truckid" + n_truck_index );
		if( IsDefined( data ) )
		{
			return data !== BIT_NOT_UNLOCKED;
		}
	}

	return false;
}

function unlockTruck( n_truck_index )
{
	if( !MonsterJamUtility::isValidUnlockablesTrack() )
	{
		return;
	}

	if( !self isValidForStats() )
	{
		return;
	}

	if( !self hasTruckAlready( n_truck_index ) )
	{
		data = self.pers[ "truckid" + n_truck_index ];//self GetStructFromHashID( "truckid" + n_truck_index );
		if( IsDefined( data ) )
		{
			data = BIT_UNLOCKED;
		}
	}
}

function GetStructFromHashID( hash_id )
{
	if( !self isValidForStats() )
	{
		return;
	}

	for( i = 0; i < level._monster_jam_unlocks.size; i++ )
	{
		data = level._monster_jam_unlocks[ i ];
		if( data.hash_id == hash_id )
		{
			return data;
		}
	}

	return undefined;
}

// this is so the values stay sorted.
function initFakeStat( hash_id )
{
	DEFAULT( level._monster_jam_unlocks, [] );

	data = SpawnStruct();
	data.hash_id = hash_id;
	ARRAY_ADD( level._monster_jam_unlocks, data );
}

function initPlayerStat( hash_id, value = BIT_NOT_UNLOCKED )
{
	DEFAULT( self.pers, [] );

	self.pers[ hash_id ] = value;
}

function incrementStat( hash_id, value )
{
	if( !self isValidForStats() )
	{
		return;
	}

	if( IsDefined( self.pers[ hash_id ] ) )
	{
		// cast the number to a int, add the value and cast it back to a string.
		current_data = Int( self.pers[ hash_id ] );
		current_data += value;
		current_data += "";
		self.pers[ hash_id ] = current_data;
	}
}

function setStatUnderCondition( hash_id, value, b_less_than = false )
{
	if( !self isValidForStats() )
	{
		return;
	}

	if( IsDefined( self.pers[ hash_id ] ) )
	{
		// cast the number to a int, add the value and cast it back to a string.
		if( b_less_than )
		{
			if( value < Int( self.pers[ hash_id ] ) )
			{
				self.pers[ hash_id ] = value + "";
			}
		}
		else
		{
			if( value > Int( self.pers[ hash_id ] ) )
			{
				self.pers[ hash_id ] = value + "";
			}
		}
	}
	else
	{
		/#
		iprintlnbold( "stat " + hash_id + " was undefined!" );
		#/
	}
}

function uploadStats()
{
	if( !MonsterJamUtility::isValidUnlockablesTrack() )
	{
		return;
	}

	if( !self isValidForStats( true ) )
	{
		return;
	}

	if( !IsDefined( level._monster_jam_unlocks ) )
	{
		return;
	}

	str_data = "";
	for( i = 0; i < level._monster_jam_unlocks.size; i++ )
	{
		s_data = level._monster_jam_unlocks[ i ];
		value = self.pers[ s_data.hash_id ];
		if( IS_EQUAL( str_data, "" ) )
		{
			str_data = value;
		}
		else
		{
			str_data = str_data + "," + value;
		}
	}

	// set the controller value to this
	self SetControllerUIModelValue( "truck_unlocks_subscription", str_data );
}

function private unlockEveryTruck()
{
	for( i = 7; i <= TRUCK_INDEX_LIMIT; i++ )
	{
		self unlockTruck( i );
	}
}

function private truckUnlockonPoints( n_truck_index, n_points )
{
	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	if( self hasTruckAlready( n_truck_index ) )
	{
		return;
	}

	data = self.pers[ "monsterpoints" ];//self GetStructFromHashID( "monsterpoints" );

	while( IsDefined( self ) && IsDefined( data ) )
	{
		if( Int( data ) >= n_points )
		{
			self unlockTruck( n_truck_index );
			break;
		}
		WAIT_SERVER_FRAME;
	}
}

function private truckUnlockonSpectaclePoints( n_truck_index, n_points )
{
	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	if( self hasTruckAlready( n_truck_index ) )
	{
		return;
	}

	data = self.pers[ "monsterspectacles" ];//self GetStructFromHashID( "monsterpoints" );

	while( IsDefined( self ) && IsDefined( data ) )
	{
		if( Int( data ) >= n_points )
		{
			self unlockTruck( n_truck_index );
			break;
		}
		WAIT_SERVER_FRAME;
	}
}

function private trackDistance()
{
	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	data = self.pers[ "distance" ];//self GetStructFromHashID( "distance" );

	while( IsDefined( self ) && IsDefined( data ) )
	{
		wait 0.1;
		if( !IsDefined( self.prev_dist_origin ) )
		{
			self.prev_dist_origin = self.origin;
			continue;
		}

		if( !self isValidForStats() )
		{
			continue;
		}

		if( IS_TRUE( self.completed_race ) )
		{
			continue;
		}

		// get the distance in inches
		n_dist = Distance( self.prev_dist_origin, self.origin );

		// round it to 2 decimals
		n_dist = Ceil( n_dist * 100 ) / 100;

		// convert this distance into miles, round it to 3 decimals
		n_dist = Ceil( ( n_dist / 63360 ) * 1000 ) / 1000;

		if( n_dist > 0.0 )
		{
			// cast the number to a float, add the value and cast it back to a string.
			current_data = Float( data );
			current_data = current_data + n_dist;
			current_data = current_data + "";
			data = current_data;
		}

		self.prev_dist_origin = self.origin;
	}
}


function isValidForStats( b_is_end_game = false )
{
	if( self istestclient() )
	{
		return false;
	}

	if( !b_is_end_game ) // MAYBE: if a player is spectating somebody else, the info will sync to them
	{
		if( IsDefined( self.sessionstate ) && self.sessionstate == "spectator" )
		{
			return false;
		}
	}

	return true;
}