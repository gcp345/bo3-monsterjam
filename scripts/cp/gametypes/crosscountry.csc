#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#using scripts\cp\_mj_oob;
#using scripts\cp\_mj_score;
#using scripts\cp\_mj_smashables;

#namespace crosscountry;

function main()
{
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
