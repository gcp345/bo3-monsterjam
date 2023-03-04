#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace MonsterJamMusic;

REGISTER_SYSTEM( #"MonsterJamMusic", &__init__, undefined )

function autoexec opt_in()
{
	music::setMusicState( "silent" );
}

function __init__()
{
	//callback::on_spawned( &on_player_spawned );

	RegsiterMusic( "let_it_in", "mus_let_it_in" );
	RegsiterMusic( "prizefighter", "mus_prizefighter" );
	RegsiterMusic( "set_the_speed", "mus_set_the_speed" );
	RegsiterMusic( "roll_you", "mus_roll_you" );
	RegsiterMusic( "greasin_the_wheel", "mus_greasin_the_wheel" );
	RegsiterMusic( "you_cant_ever", "mus_you_cant_ever" );
	RegsiterMusic( "mj_draft_02", "mus_mj_draft_02" );
	RegsiterMusic( "cherry_red", "mus_cherry_red" );
	RegsiterMusic( "sweetwater", "mus_sweetwater" );
	RegsiterMusic( "milligram", "mus_milligram" );
	RegsiterMusic( "mj_draft_01", "mus_mj_draft_01" );
	RegsiterMusic( "mj_draft_03", "mus_mj_draft_03" );
	RegsiterMusic( "mj_draft_09", "mus_mj_draft_09" );
	RegsiterMusic( "mj_draft_12", "mus_mj_draft_12" );
	RegsiterMusic( "mj_draft_13", "mus_mj_draft_13" );
	RegsiterMusic( "mj_draft_14", "mus_mj_draft_14" );
	RegsiterMusic( "believe_it", "mus_believe_it" );

	// Urban Assault Music
	RegsiterMusic( "buried_alive", "mus_buried_alive" );
	RegsiterMusic( "bury_me_alive", "mus_bury_me_alive" );
	RegsiterMusic( "cudh", "mus_cudh" );
	RegsiterMusic( "double_twelve", "mus_double_twelve" );
	RegsiterMusic( "drawing_dead", "mus_drawing_dead" );
	RegsiterMusic( "drive_fast", "mus_drive_fast" );
	RegsiterMusic( "drive_real", "mus_drive_real" );
	RegsiterMusic( "fourteen", "mus_fourteen" );
	RegsiterMusic( "mississippi", "mus_mississippi" );
	RegsiterMusic( "only_one", "mus_only_one" );
	RegsiterMusic( "packed_bat", "mus_packed_bat" );
	RegsiterMusic( "silver_olympus", "mus_silver_olympus" );
	RegsiterMusic( "baron", "mus_baron" );
	RegsiterMusic( "three", "mus_three" );
	RegsiterMusic( "nine", "mus_nine" );
	RegsiterMusic( "thirteen", "mus_thirteen" );
	RegsiterMusic( "thunderbird", "mus_thunderbird" );
	RegsiterMusic( "transamerica", "mus_transamerica" );
	RegsiterMusic( "turnpike", "mus_turnpike" );
	RegsiterMusic( "ywsyls", "mus_ywsyls" );

	// stops song on fast restart
	music::setMusicState( "silent" );

	level flag::init( "start_soundtrack" );

	level thread start_soundtrack();
}

function RegsiterMusic( state, sound )
{
	if( !IsDefined( level._mj_music ) )
	{
		level._mj_music = [];
	}

	data = SpawnStruct();
	data.mus = state;
	data.snd = sound;

	ARRAY_ADD( level._mj_music, data );
}
/*
function on_player_spawned()
{
	music::setMusicState( "silent", self );
	self thread soundtrackInit();
}

function soundtrackInit()
{
	self endon( "disconnect" );

	level flag::wait_till( "start_soundtrack" );

	// setup a personal one
	self._mj_music = level._mj_music;

	wait 3;

	while( true )
	{
		// reset the soundtrack if it's empty
		if( self._mj_music.size <= 0 )
		{
			self._mj_music = level._mj_music;
		}

		song = array::random( self._mj_music );

		if( IsDefined( song ) )
		{
			ArrayRemoveValue( self._mj_music, song );

			music::setMusicState( song.mus, self );

			playBackTime = SoundGetPlaybackTime( song.snd );

			if( !IsDefined( playBackTime ) || playBackTime <= 0 )
			{
				playBackTime = 1;
			}
			else
			{
				playBackTime = playBackTime * 0.001;
			}

			wait( playBackTime );
		}

		// add some delay in between songs
		wait 2;
	}
}
*/

function start_soundtrack()
{
	// delay music slightly after race starts
	wait 3;

	level endon( "end_soundtrack" );

	level flag::wait_till( "start_soundtrack" );

	a_songs = level._mj_music;

	while( true )
	{
		// reset the soundtrack if it's empty
		if( a_songs.size <= 0 )
		{
			a_songs = level._mj_music;
		}

		song = array::random( a_songs );

		if( IsDefined( song ) )
		{
			ArrayRemoveValue( a_songs, song );

			music::setMusicState( song.mus );

			playBackTime = SoundGetPlaybackTime( song.snd );
			if( !IsDefined( playBackTime ) || playBackTime <= 0 )
			{
				playBackTime = 1;
			}
			else
			{
				playBackTime = playBackTime * 0.001;
			}
			wait( playBackTime );
		}

		// add some delay in between songs
		wait 2;
	}
}

function finish_soundtrack()
{
	level notify( "end_soundtrack" );

	music::setMusicState( "silent" );
}