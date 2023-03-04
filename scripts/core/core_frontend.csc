// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\core\core_frontend_fx;
#using scripts\core\core_frontend_sound;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\_character_customization;
#using scripts\shared\callbacks_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#precache( "client_fx", "monster_jam/frontend/fx_monster_truck_select_fireworks_orange" );
#precache( "client_fx", "monster_jam/frontend/fx_monster_truck_select_fireworks_purple" );
#precache( "client_fx", "monster_jam/frontend/fx_monster_truck_select_fireworks_yellow" );

#namespace core_frontend;

function main()
{
	core_frontend_fx::main();
	core_frontend_sound::main();

	level._effect[ #"fireworks_orange" ] = "monster_jam/frontend/fx_monster_truck_select_fireworks_orange";
	level._effect[ #"fireworks_purple" ] = "monster_jam/frontend/fx_monster_truck_select_fireworks_purple";
	level._effect[ #"fireworks_yellow" ] = "monster_jam/frontend/fx_monster_truck_select_fireworks_yellow";

	// let's hook this function
	level.charactercustomizationsetup = &on_localclient_connect;

	util::waitforclient( 0 );
	forcestreamxmodel( "p7_monitor_wall_theater_01" );
}

function on_localclient_connect( localclientnum )
{
	// we took the callback away from this function, so restore it
	character_customization::localclientconnect( localclientnum );

	while( !IsDefined( level.client_menus[ localclientnum ] ) )
	{
		WAIT_CLIENT_FRAME;
	}

	//lui::createcustomcameramenu( "MJChooseTruck", localclientnum, undefined, undefined, &open_zm_buildkits, &close_zm_buildkits );
	//lui::addmenuexploders( "MJChooseTruck", localclientnum, array( "zm_weapon_kick", "zm_weapon_room", "zm_gumball_room_3" ) );

	//lui::createcameramenu("MJChooseTruck", localclientnum, "zm_loadout_position", "c_fe_zm_megachew_vign_camera_2", "c_fe_zm_megachew_vign_camera_2", undefined, &open_zm_bgb, &close_zm_bgb);
	//lui::addmenuexploders("MJChooseTruck", localclientnum, array("zm_gum_kick", "zm_gum_room", "zm_gumball_room_2"));

	//lui::createcameramenu("MJChooseTruck", localclientnum, "zm_loadout_position_shift", "c_fe_zm_megachew_vign_camera_2", "c_fe_zm_megachew_vign_camera_2", undefined, &open_zm_bgb, &close_zm_bgb);
	//lui::addmenuexploders("MJChooseTruck", localclientnum, array("zm_gum_kick", "zm_gum_room", "zm_gumball_room_2"));

	lui::createcameramenu("MJChooseTruck", localclientnum, "zm_weapon_position", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_zm_bgb, &close_zm_bgb);
	lui::addmenuexploders("MJChooseTruck", localclientnum, array("zm_weapon_kick", "zm_weapon_room"));

	lui::createcameramenu("MJStats", localclientnum, "zm_weapon_position", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_zm_bgb, &close_zm_bgb);
	lui::addmenuexploders("MJStats", localclientnum, array("zm_weapon_kick", "zm_weapon_room"));

	level thread wait_for_truck_selection( localclientnum );
}

function open_zm_buildkits( localclientnum, menu_data )
{
	level.weapon_position = struct::get( "zm_loadout_gumball" );
}
function close_zm_buildkits( localclientnum, menu_data )
{
	level.weapon_position = struct::get( "paintshop_weapon_position" );
}

function open_truck_menu(localclientnum, menu_data)
{
	level.n_old_spotshadow = getdvarint("r_maxSpotShadowUpdates");
	setdvar("r_maxSpotShadowUpdates", 24);
	level.weapon_position = struct::get("zm_loadout_gumball");
	playradiantexploder(localclientnum, "zm_gum_room");
	playradiantexploder(localclientnum, "zm_gum_kick");
}

function open_zm_bgb(localclientnum, menu_data)
{
	level.n_old_spotshadow = getdvarint("r_maxSpotShadowUpdates");
	setdvar("r_maxSpotShadowUpdates", 24);
	level.weapon_position = struct::get(menu_data.target_name);
	playradiantexploder(localclientnum, "zm_gum_room");
	playradiantexploder(localclientnum, "zm_gum_kick");
	//level thread onWeaponSpawn( localclientnum );
}

function close_zm_bgb(localclientnum, menu_data)
{
	level.weapon_position = struct::get("paintshop_weapon_position");
	killradiantexploder(localclientnum, "zm_gum_room");
	killradiantexploder(localclientnum, "zm_gum_kick");
	setdvar("r_maxSpotShadowUpdates", level.n_old_spotshadow);
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
}

function onWeaponSpawn( localclientnum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_closed" + localclientnum );

	while( true )
	{
		level util::waittill_any( "CustomClass_update" + localclientnum, "CustomClass_focus" + localclientnum, "CustomClass_remove" + localclientnum, "CustomClass_closed" + localclientnum );
		if( IsDefined( level.weapon_script_model[localclientnum] ) )
		{
			IPrintLnBold( "threading a new rotate function" );
			level.weapon_script_model[localclientnum].angles = level.weapon_position.angles;
			level.weapon_script_model[localclientnum] thread doFlatRotations( localclientnum );
		}
	}
}

function doFlatRotations( localclientnum )
{
	self endon( "death" );
	level endon( "CustomClass_update" + localclientnum );

	while( true )
	{
		self RotateTo( self.angles + VectorScale( ( 0, 1, 0 ), 180 ), 4 );
		wait 4;
	}
}

function wait_for_truck_selection( localclientnum )
{
	level endon( "disconnect" );

	while( true )
	{
		level waittill( "CustomClass_truckChoosen" + localclientnum );
		if( IsDefined( level.weapon_script_model[ localclientnum ] ) )
		{
			if( level.weapon_script_model[ localclientnum ] GetTagOrigin( "tag_firework_fx_00" ) == undefined )
			{
				continue;
			}
			DEFAULT( level.truckfxArray, [] );
			DEFAULT( level.truckfxArray[ localclientnum ], [] );
			level.truckfxArray[ localclientnum ][ 0 ] = PlayFXOnTag( localclientnum, level._effect[ #"fireworks_yellow" ], level.weapon_script_model[ localclientnum ], "tag_firework_fx_00" );
			level.truckfxArray[ localclientnum ][ 1 ] = PlayFXOnTag( localclientnum, level._effect[ #"fireworks_orange" ], level.weapon_script_model[ localclientnum ], "tag_firework_fx_01" );
			level.truckfxArray[ localclientnum ][ 2 ] = PlayFXOnTag( localclientnum, level._effect[ #"fireworks_orange" ], level.weapon_script_model[ localclientnum ], "tag_firework_fx_02" );
			level.truckfxArray[ localclientnum ][ 3 ] = PlayFXOnTag( localclientnum, level._effect[ #"fireworks_purple" ], level.weapon_script_model[ localclientnum ], "tag_firework_fx_03" );

			level.weapon_script_model[ localclientnum ] thread do_misc_truck_stuff( localclientnum );
		}

		level util::waittill_any_timeout( 5, "disconnect", "CustomClass_truckExit" + localclientnum );
		level notify( #"stop_firing_sounds" + localclientnum );

		if( IsDefined( level.truckfxArray[ localclientnum ] ) )
		{
			if( IsDefined( level.truckfxArray[ localclientnum ][ 0 ] ) )
			{
				DeleteFX( localclientnum, level.truckfxArray[ localclientnum ][ 0 ] );
				level.truckfxArray[ localclientnum ][ 0 ] = undefined;
			}
			if( IsDefined( level.truckfxArray[ localclientnum ][ 1 ] ) )
			{
				DeleteFX( localclientnum, level.truckfxArray[ localclientnum ][ 1 ] );
				level.truckfxArray[ localclientnum ][ 1 ] = undefined;
			}
			if( IsDefined( level.truckfxArray[ localclientnum ][ 2 ] ) )
			{
				DeleteFX( localclientnum, level.truckfxArray[ localclientnum ][ 2 ] );
				level.truckfxArray[ localclientnum ][ 2 ] = undefined;
			}
			if( IsDefined( level.truckfxArray[ localclientnum ][ 3 ] ) )
			{
				DeleteFX( localclientnum, level.truckfxArray[ localclientnum ][ 3 ] );
				level.truckfxArray[ localclientnum ][ 3 ] = undefined;
			}
		}
	}
}

function do_misc_truck_stuff( localclientnum )
{
	level endon( "disconnect" );
	level endon( "CustomClass_truckExit" + localclientnum );
	level endon( #"stop_firing_sounds" + localclientnum );

	// give the fireworks a second to start firing
	self PlaySound( localclientnum, "evt_mj_fireworks_start_01" );
	wait( 0.420 );

	self PlaySound( localclientnum, "evt_mj_fireworks01_sloope" );
	self PlaySound( localclientnum, "evt_mj_fireworks02_sloope_s" );

	wait( 0.05 );
	self PlaySound( localclientnum, "evt_mj_monster_startup" );
}