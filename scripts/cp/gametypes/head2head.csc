#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#using scripts\cp\_mj_oob;
#using scripts\cp\_mj_score;
#using scripts\cp\_mj_smashables;

#namespace head2head;

function main()
{
	clientfield::register( "clientuimodel", "MonsterTruckPos", VERSION_SHIP, GetMinBitCountForNum( 6 ), "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "MonsterTruckPosTotal", VERSION_SHIP, GetMinBitCountForNum( 6 ), "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "MonsterTruckLaps", VERSION_SHIP, GetMinBitCountForNum( 5 ), "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "MonsterTruckLapsTotal", VERSION_SHIP, GetMinBitCountForNum( 5 ), "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "clientuimodel", "MonsterTruckTimeStart", VERSION_SHIP, 31, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "MonsterTruckTimeFinish", VERSION_SHIP, 31, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "MonsterTruckTimeState", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
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
