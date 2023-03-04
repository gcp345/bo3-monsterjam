#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\shared\duplicaterender.gsh;

#using scripts\shared\vehicles\_monster_truck;

#using scripts\cp\_mj_oob;
#using scripts\cp\_mj_score;
#using scripts\cp\_mj_smashables;

#namespace king;

function main()
{
	clientfield::register( "vehicle", "show_king_vehicle", VERSION_SHIP, 1, "int", &update_dr_flag_material, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "scriptmover", "show_king_object", VERSION_SHIP, 1, "int", &update_dr_flag_material, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	duplicate_render::set_dr_filter_offscreen( "reveal_ki_dp", 50, "reveal_king_dp", undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, "mc/hud_outline_model_z_yellow", DR_CULL_ALWAYS );
}

function update_dr_flag_material( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self duplicate_render::update_dr_flag( localClientNum, "reveal_king_dp", newVal == 1 );
	self duplicate_render::update_dr_filters( localClientNum );
}

function onprecachegametype()
{
}

function onstartgametype()
{
}

function autoexec ignore_systems()
{
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
