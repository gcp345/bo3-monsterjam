#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;
#insert scripts\shared\vehicles\_monster_truck.gsh;

#using scripts\cp\_mj_score;
#using scripts\cp\_mj_utility;

#namespace MonsterJamComm;

REGISTER_SYSTEM( "MonsterJamComm", &__init__, undefined )

function __init__()
{
	// enable/disable the commentator
	DEFAULT( level.monster_jam_use_commentator, false );

	if( IS_TRUE( level.monster_jam_use_commentator ) )
	{
		DEFAULT( level.monster_jam_commentator_prefix, "vox_sd_" );
		level thread setup_commentator();
		callback::on_spawned( &on_player_spawned );
	}
}

function on_player_spawned()
{
	DEFAULT( self.monster_jam_commentator_speaking, false );
	DEFAULT( self.monster_jam_commentator_interupt, false );

	self thread setupPlayerVox();
}

function private setup_commentator()
{
	setupTruckIntros();
	setupCommonSounds();


	level thread setupGlobalVox();
}

function private setupTruckIntros()
{
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER, "fs_intro_01", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER, "fs_intro_02", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MONSTERMUTT, "fs_intro_05", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MONSTERMUTT, "fs_intro_06", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BOUNTYHUNTER, "fs_intro_21", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BOUNTYHUNTER, "fs_intro_22", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BULLDOZER, "fs_intro_15", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BULLDOZER, "fs_intro_16", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLUETHUNDER, "fs_intro_19", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLUETHUNDER, "fs_intro_20", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_KINGKRUNCH, "fs_intro_35", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_KINGKRUNCH, "fs_intro_36", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_DESTROYER, "fs_intro_39", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_DESTROYER, "fs_intro_40", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLACKSMITH, "fs_intro_13", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLACKSMITH, "fs_intro_14", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_ELTOROLOCO, "fs_intro_09", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_ELTOROLOCO, "fs_intro_10", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SUZUKI, "fs_intro_29", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SUZUKI, "fs_intro_30", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PREDATOR, "fs_intro_43", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PREDATOR, "fs_intro_44", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MAXD, "fs_intro_03_seven", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MAXD, "fs_intro_04", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SCARLETBANDIT, "fs_intro_25", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SCARLETBANDIT, "fs_intro_26", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_CAPTCURSE, "fs_intro_11", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_CAPTCURSE, "fs_intro_12", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_AVENGER, "fs_intro_31", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_AVENGER, "fs_intro_32", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PASTRANA, "fs_intro_17", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PASTRANA, "fs_intro_18", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_IRONOUTLAW, "fs_intro_23", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_IRONOUTLAW, "fs_intro_24", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BRUTUS, "fs_intro_37", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BRUTUS, "fs_intro_38", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MUTTDALMATION, "fs_intro_07", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MUTTDALMATION, "fs_intro_08", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER25TH, "fs_intro_33", false );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER25TH, "fs_intro_34", false );

	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER, "fs_intro_samboyd_01", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER, "fs_intro_samboyd_02", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MONSTERMUTT, "fs_intro_samboyd_05", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MONSTERMUTT, "fs_intro_samboyd_06", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BOUNTYHUNTER, "fs_intro_samboyd_21", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BOUNTYHUNTER, "fs_intro_samboyd_22", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BULLDOZER, "fs_intro_samboyd_15", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BULLDOZER, "fs_intro_samboyd_16", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLUETHUNDER, "fs_intro_samboyd_19", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLUETHUNDER, "fs_intro_samboyd_20", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_KINGKRUNCH, "fs_intro_samboyd_35", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_KINGKRUNCH, "fs_intro_samboyd_36", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_DESTROYER, "fs_intro_samboyd_39", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_DESTROYER, "fs_intro_samboyd_40", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLACKSMITH, "fs_intro_samboyd_13", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BLACKSMITH, "fs_intro_samboyd_14", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_ELTOROLOCO, "fs_intro_samboyd_09", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_ELTOROLOCO, "fs_intro_samboyd_09_alt", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_ELTOROLOCO, "fs_intro_samboyd_10", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SUZUKI, "fs_intro_samboyd_29", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SUZUKI, "fs_intro_samboyd_30", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PREDATOR, "fs_intro_samboyd_43", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PREDATOR, "fs_intro_samboyd_44", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MAXD, "fs_intro_samboyd_03", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MAXD, "fs_intro_samboyd_04", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SCARLETBANDIT, "fs_intro_samboyd_25", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_SCARLETBANDIT, "fs_intro_samboyd_26", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_CAPTCURSE, "fs_intro_samboyd_11", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_CAPTCURSE, "fs_intro_samboyd_12", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_AVENGER, "fs_intro_samboyd_31", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_AVENGER, "fs_intro_samboyd_32", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PASTRANA, "fs_intro_samboyd_17", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_PASTRANA, "fs_intro_samboyd_18", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_IRONOUTLAW, "fs_intro_samboyd_23", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_IRONOUTLAW, "fs_intro_samboyd_24", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BRUTUS, "fs_intro_samboyd_37", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_BRUTUS, "fs_intro_samboyd_38", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MUTTDALMATION, "fs_intro_samboyd_07", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_MUTTDALMATION, "fs_intro_samboyd_08", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER25TH, "fs_intro_samboyd_33", true );
	RegisterTruckIntro( "freestyle", TRUCK_INDEX_GRAVEDIGGER25TH, "fs_intro_samboyd_34", true );
}

function private setupCommonSounds()
{
	// Tricks
	RegisterLine( #"airtime_short", "fs_small_jump_01a", false );
	RegisterLine( #"airtime_short", "fs_small_jump_01b", false );
	RegisterLine( #"airtime_short", "fs_small_jump_01c", false );
	RegisterLine( #"airtime_short", "fs_small_jump_02", false );
	RegisterLine( #"airtime_short", "fs_small_jump_03", false );
	RegisterLine( #"airtime_short", "fs_small_jump_04", false );
	RegisterLine( #"airtime_short", "fs_small_jump_05a", false );
	RegisterLine( #"airtime_short", "fs_small_jump_05b", false );
	RegisterLine( #"airtime_short", "fs_small_jump_05c", false );
	RegisterLine( #"airtime_short", "fs_small_jump_06a", false );
	RegisterLine( #"airtime_short", "fs_small_jump_06b", false );
	RegisterLine( #"airtime_short", "fs_small_jump_06c", false );
	RegisterLine( #"airtime_short", "fs_small_jump_07", false );
	RegisterLine( #"airtime_short", "fs_small_jump_08", false );
	RegisterLine( #"airtime_short", "fs_small_jump_09", false );
	RegisterLine( #"airtime_short", "fs_small_jump_10", false );
	RegisterLine( #"airtime_long", "fs_large_jump_01", false );
	RegisterLine( #"airtime_long", "fs_large_jump_02a", false );
	RegisterLine( #"airtime_long", "fs_large_jump_02b", false );
	RegisterLine( #"airtime_long", "fs_large_jump_03", false );
	RegisterLine( #"airtime_long", "fs_large_jump_04", false );
	RegisterLine( #"airtime_long", "fs_large_jump_05a", false );
	RegisterLine( #"airtime_long", "fs_large_jump_05b", false );
	RegisterLine( #"airtime_long", "fs_large_jump_06a", false );
	RegisterLine( #"airtime_long", "fs_large_jump_06b", false );
	RegisterLine( #"airtime_long", "fs_large_jump_07", false );
	RegisterLine( #"airtime_long", "fs_large_jump_08", false );
	RegisterLine( #"airtime_long", "fs_large_jump_09", false );
	RegisterLine( #"airtime_long", "fs_large_jump_10", false );

	RegisterLine( #"donut_short", "fs_donut_short" );
	RegisterLine( #"donut_long", "fs_donut_long" );
	RegisterLine( #"wheelie_short", "fs_wheelie_short" );
	RegisterLine( #"wheelie_long", "fs_wheelie_long" );

	RegisterLine( #"crush_cars", "fs_crush_cars" );

	RegisterLine( #"combo_double", "fs_combo_double" );
	RegisterLine( #"combo_triple", "fs_combo_triple" );

	// Misc.
	RegisterLine( #"lost_part", "com_player_loses_part", true, false );
	RegisterLine( #"blown_engine", "com_blown_engine", true, false );

	// Freestyle Specific
	RegisterLine( #"interrupt", "interrupt" );
	RegisterLine( #"clock_almostfilled", "fs_clock_almostfilled" );
}

function private RegisterTruckIntro( str_gametype, n_truck_index, dialog, bIsSamBoyd = false )
{
	if( bIsSamBoyd )
	{
		RegisterLine( "samboydintro"+str_gametype+n_truck_index, dialog, false );
	}
	else
	{
		RegisterLine( "intro"+str_gametype+n_truck_index, dialog, false );
	}
}

function private GetNumberVariants( aliasprefix )
{
	for( i = 1; i < 10; i++ )
	{
		if( !SoundExists( ( aliasprefix + "_0" ) + i ) )
		{
			return i;
		}
	}

	for( i = 10; i < 101; i++ )
	{
		if( !SoundExists( ( aliasprefix + "_" ) + i ) )
		{
			return i;
		}
	}
}

function RegisterLine( str_dialog, str_alias, bIsPrefix = true, bAllowInterrupt = true )
{
	DEFAULT( level.monster_jam_dialog, [] );
	DEFAULT( level.monster_jam_dialog[ str_dialog ], SpawnStruct() );
	DEFAULT( level.monster_jam_dialog[ str_dialog ].a_lines, [] );
	DEFAULT( level.monster_jam_dialog[ str_dialog ].interrupt, bAllowInterrupt );

	if( bIsPrefix )
	{
		variants = GetNumberVariants( level.monster_jam_commentator_prefix + str_alias );
		for( i = 1; i < variants; i++ )
		{
			if( i < 10 )
			{
				ARRAY_ADD( level.monster_jam_dialog[ str_dialog ].a_lines, str_alias + "_0" + i );
			}
			else
			{
				ARRAY_ADD( level.monster_jam_dialog[ str_dialog ].a_lines, str_alias + "_" + i );
			}
		}
	}
	else
	{
		ARRAY_ADD( level.monster_jam_dialog[ str_dialog ].a_lines, str_alias );
	}
}

function GetRandomLine( str_dialog )
{
	if( !IsDefined( level.monster_jam_dialog[ str_dialog ] ) )
	{
		return undefined;
	}

	if( level.monster_jam_dialog[ str_dialog ].a_lines.size < 1 )
	{
		return undefined;
	}

	return level.monster_jam_commentator_prefix + array::random( level.monster_jam_dialog[ str_dialog ].a_lines );
}

function DoCommentation( str_dialog )
{
	if( self == level )
	{
		foreach( player in level.players )
		{
			player thread DoCommentation( str_dialog );
		}
		return;
	}

	if( !IsDefined( level.monster_jam_dialog ) )
		return;

	if( !IsDefined( str_dialog ) )
		return undefined;

	if( IS_TRUE( self.monster_jam_commentator_speaking ) )
	{
		if( !IS_TRUE( self.monster_jam_commentator_interupt ) )
		{
			if( IS_TRUE( level.monster_jam_dialog[ str_dialog ].interrupt ) )
			{
				self.monster_jam_commentator_interupt = true;
				self waittill( #"commentator_done" );

				str_line = GetRandomLine( #"interrupt" );

				self thread PlayVoxToPlayer( str_line );
				self waittill( #"commentator_done" );

				self.monster_jam_commentator_interupt = false;

				str_line = GetRandomLine( str_dialog );
				self thread PlayVoxToPlayer( str_line );
			}
		}
		else
		{
			return;
		}
	}

	else
	{
		str_line = GetRandomLine( str_dialog );
		self thread PlayVoxToPlayer( str_line );
	}
}

function PlayVoxToPlayer( str_line )
{
	if( !IsDefined( str_line ) )
	{
		WAIT_SERVER_FRAME;
		self notify( #"commentator_done" );
		return;
	}

	self.monster_jam_commentator_speaking = true;
	self IPrintLnBold( "playing: " + str_line + " to " + self.playername );
	self PlaySoundToPlayer( str_line, self );
	playbacktime = SoundGetPlaybackTime( str_line );
	if( !isdefined( playbacktime ) || playbacktime <= 0 )
		waittime = (0.9);
	else
		waittime = (playbackTime * .001) - 0.15;
	
	wait(waittime);
	self.monster_jam_commentator_speaking = false;
	self notify( #"commentator_done" );
}

function private setupGlobalVox()
{
	level thread PartLostNotify();

}

function private setupPlayerVox()
{
	self thread CommentateOnGreaterthan( "trick_stop_donut", #"donut_short", #"donut_long", undefined, 75, 500 );
	self thread CommentateOnGreaterthan( "trick_stop_wheelie", #"wheelie_short", #"wheelie_long", undefined, 25, 500 );
	self thread CommentateOnGreaterthan( "trick_stop_air_time", #"airtime_short", #"airtime_long", undefined, 50, 500 );
	self thread CommentateOnEqualTo( #"cashin_multiplier", undefined, #"combo_double", #"combo_triple", 1, 2, 3 );
	self thread CommentateOnNotify( "engine_blown", #"blown_engine" );
	self thread CommentateOnNotify( "trick_stop_crush", #"crush_cars", 5 );
}

function CommentateOnGreaterthan( str_notify, dialog1, dialog2, dialog3, value1 = 75, value2 = 500, value3 )
{
	WAIT_SERVER_FRAME;

	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self.truck waittill( str_notify, points );
		if( points > value1 )
		{
			if( IsDefined( value3 ) && IsDefined( dialog3 ) )
			{
				if( points > value3 )
					self thread DoCommentation( dialog3 );
				else if( points > value2 )
					self thread DoCommentation( dialog2 );
				else
					self thread DoCommentation( dialog1 );
			}
			else
			{
				if( points > value2 )
					self thread DoCommentation( dialog2 );
				else
					self thread DoCommentation( dialog1 );
			}
		}

		wait 3;
	}
}

function CommentateOnEqualTo( str_notify, dialog1, dialog2, dialog3, value1 = 75, value2 = 500, value3 )
{
	WAIT_SERVER_FRAME;

	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self.truck waittill( str_notify, points );
		if( points > value1 )
		{
			if( IsDefined( value3 ) && IsDefined( dialog3 ) )
			{
				if( points == value3 )
					self thread DoCommentation( dialog3 );
				else if( points == value2 )
					self thread DoCommentation( dialog2 );
				else
					self thread DoCommentation( dialog1 );
			}
			else
			{
				if( points == value2 )
					self thread DoCommentation( dialog2 );
				else
					self thread DoCommentation( dialog1 );
			}
		}

		wait 3;
	}
}

function CommentateOnNotify( str_notify, dialog, waitTime )
{
	WAIT_SERVER_FRAME;

	self endon( "disconnect" );
	self.truck endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self.truck waittill( str_notify );

		self thread DoCommentation( dialog );

		if( IsDefined( waitTime ) )
		{
			wait waitTime;
		}
	}
}

function PartLostNotify()
{
	while( true )
	{
		level waittill( "part_lost", truck );

		if( IsDefined( truck ) && IsDefined( truck.owner ) )
		{
			truck.owner thread DoCommentation( #"lost_part" );
		}

		wait 1;
	}
}