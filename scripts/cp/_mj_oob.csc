// OOB - Out Of Bounds
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\cp\_mj_utility;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#precache( "client_fx", "water/fx_water_splash_xxlg" );

#namespace MonsterJamOOB;

REGISTER_SYSTEM( #"MonsterJamOOB", &__init__, undefined )

function __init__()
{
	//util::register_system( "oob_mgr", &setup_oob_xcam );

	clientfield::register( "vehicle", "water_splash", VERSION_SHIP, 1, "counter", &play_splash_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "scriptmover", "water_splash", VERSION_SHIP, 1, "counter", &play_splash_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	callback::on_localplayer_spawned( &on_localplayer_spawned );
}

//player = GetLocalPlayer( localClientNum );
//PlayMainCamXCam( localClientNum, "ui_cam_oob", 0, "cam_topscorers", "topscorers", player.origin, player.angles + ( 0, 180, 0 ) );
function on_localplayer_spawned( localClientNum )
{
	
}

function setup_oob_xcam( localClientNum, State, oldState )
{
	tokens = StrTok( State, "|" );
	player = GetLocalPlayer( localClientNum );

	if( tokens[ 0 ] == "clear" )
	{
		StopMainCamXCam( localClientNum );
		return;
	}

	v_origin = ( Float( tokens[ 0 ] ), Float( tokens[ 1 ] ), Float( tokens[ 2 ] ) );
	v_angles = ( 0, Float( tokens[ 4 ] ), Float( tokens[ 5 ] ) );//( Float( tokens[ 3 ] ), Float( tokens[ 4 ] ), Float( tokens[ 5 ] ) );

	PlayMainCamXCam( localClientNum, "ui_cam_oob", 0, "cam_topscorers", "topscorers", v_origin, v_angles );
}

function play_splash_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if( newVal )
	{
		PlayFX( localClientNum, "water/fx_water_splash_xxlg", self.origin + VectorScale( ( 0, 0, 1 ), 48 ) );
		self PlaySound( localClientNum, "veh_monster_truck_land_water_hard" );
	}
}