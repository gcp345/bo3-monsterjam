// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\core_frontend_fx;
#using scripts\core\core_frontend_sound;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace core_frontend;

function main()
{
	precache();
	core_frontend_fx::main();
	core_frontend_sound::main();
	setdvar("compassmaxrange", "2100");
}

function precache()
{
}

