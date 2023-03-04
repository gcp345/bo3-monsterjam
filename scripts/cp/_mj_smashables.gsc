#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_boost;
#insert scripts\shared\vehicles\_monster_truck.gsh;

#using scripts\cp\_mj_score;
#using scripts\cp\_mj_stats;
#using scripts\cp\_mj_utility;

#using_animtree( "mj" );

#namespace MonsterJamSmashables;

REGISTER_SYSTEM( #"MonsterJamSmashables", &__init__, undefined )

/*
Smashables setup

targetname: truck_smashable
script_float: (0-100) How much boost the player gets from hitting this, script will automatically scale this up for points
script_noteworthy: (smash, monster_smash or crush) What kind of smashable is this
script_gameobjectname: Tracks this object should appear in ( circuit_area1, eliminator_area2, etc.). If nothing is specified then it will always spawn
script_parameters: Special params that the smashable can have: stay, notsolid, and fake are valid options. No spacing or commas are required, just list them in a single line.
script_sound: impact type (for sound)

TICK 'VEHICLE', and 'AI_ALLIES'

params for crushables
script_sound is not needed
script_float defines the max boost you can earn.
script_parameters has zero effect

script_string - Specify collision to spawn
*/


function __init__()
{
	clientfield::register( "scriptmover", "crush_car", VERSION_SHIP, 7, "float" );

	smashables = GetEntArray( "truck_smashable", "targetname" );

	foreach( smashable in smashables )
	{
		if( !gameobjects::entity_is_allowed( smashable, level.allowedgameobjects ) )
		{
			smashable thread smashable_delete();
			continue;
		}

		smashable thread smashable_think();
	}

	// create struct spawn locations now too.
	// this allows us to save a lot of script model space so a very large map can have a bunch of destructables.
	a_s_smashables = struct::get_array( "truck_smashable", "targetname" );
	foreach( s_smashable in a_s_smashables )
	{
		if( !gameobjects::entity_is_allowed( s_smashable, level.allowedgameobjects ) )
		{
			continue;
		}

		e_smashable = s_smashable smashable_create();

		e_smashable thread smashable_think();
	}
}

function smashable_delete()
{
	a_e_models = GetEntArray( self.target, "targetname" );
	foreach( e_model in a_e_models )
	{
		e_model Delete();
	}

	self Delete();
}

#define SMASHABLE_SPAWNFLAGS	SPAWNFLAG_TRIGGER_VEHICLE + SPAWNFLAG_TRIGGER_AI_AXIS + SPAWNFLAG_TRIGGER_AI_ALLIES	

function smashable_create()
{
	if( !IsDefined( self.target ) )
	{
		AssertMsg( "undefined smashable targets at " + self.origin );
		return;
	}

	// check if these variables are defined, define them if they aren't
	DEFAULT( self.script_width, 64 );
	DEFAULT( self.script_length, 64 );
	DEFAULT( self.script_height, 64 );
	DEFAULT( self.script_noteworthy, "smash" );
	DEFAULT( self.script_float, 5.0 );
	DEFAULT( self.script_parameters, "" );

	e_trigger = Spawn( "trigger_box", self.origin, SMASHABLE_SPAWNFLAGS, self.script_width, self.script_length, self.script_height );
	e_trigger.target = self.target;
	e_trigger.targetname = "truck_smashable";
	e_trigger.script_noteworthy = self.script_noteworthy;
	e_trigger.script_float = self.script_float;
	e_trigger.script_parameters = self.script_parameters;

	return e_trigger;
}

function smashable_think()
{
	if( !IsDefined( self.script_noteworthy ) )
	{
		self.script_noteworthy = "smash";
	}

	// if the targets are structs, set them up.
	a_structs = struct::get_array( self.target, "targetname" );
	foreach( struct in a_structs )
	{
		e_model = Spawn( "script_model", struct.origin );
		e_model.angles = struct.angles;
		if( IsDefined( struct.model ) )
		{
			e_model SetModel( struct.model );
		}
		e_model.targetname = self.target;
	}

	a_e_models = GetEntArray( self.target, "targetname" );
	foreach( e_model in a_e_models )
	{
		if( self.script_noteworthy !== "crush" )
		{
			e_model NotSolid();
		}
	}

	self thread setupSmashableParams();

	if( self.script_noteworthy === "smash" || self.script_noteworthy === "monster_smash" )
	{
		self thread smashable_think_thread( a_e_models );
	}
	else if( self.script_noteworthy === "crush" )
	{
		self thread crushable_think_thread( a_e_models );
	}
	else
	{
		AssertMsg( "undefined script_noteworthy at " + self.origin );
	}
}

function smashable_think_thread( a_e_models )
{
	while( IsDefined( self ) )
	{
		self waittill( "trigger", e_ent );

		if( IsDefined( e_ent ) )
		{
			e_who = e_ent;
			if( IsEntity( e_ent ) && !IsVehicle( e_ent ) && IsDefined( e_ent.owner ) ) // this could potientally be a part flying towards this
			{
				e_who = e_ent.owner;
			}
			else if( IsPlayer( e_ent ) )
			{
				e_who = e_ent.truck;
			}

			if( e_who.notsolid === true )
			{
				continue;
			}

			speed = Abs( e_who GetSpeed() );
			speed = TRUCK_GENERIC_SPEED_TO_MPH( speed );

			boost = self.script_float;
			if( !IsDefined( boost ) )
			{
				boost = 10.0;
			}

			if( !IsDefined( e_who.boostFree ) )
			{
				e_who.boostFree = 0;
			}

			// update globals
			e_who.owner.destructions++;
			e_who.owner.pers[ "destructions" ]++;

			e_who.owner MonsterJamStats::incrementStat( "objectsdestroyed", 1 );

			if( boost > 0 )
			{
				e_who thread MonsterTruckBoost::GiveBoost( boost );

				e_who thread MonsterJamScore::GivePoints( self.script_noteworthy, Int( boost * 10 ) );
			}

			velocity = e_who GetVelocity();

			if( IsDefined( self.target ) )
			{
				foreach( e_model in a_e_models )
				{
					if( e_model.classname != "script_brushmodel" )
					{
						if( !IS_TRUE( self.params[ "fake" ] ) )
						{
							if( IS_TRUE( self.params[ "notsolid" ] ) )
							{
								e_model NotSolid();
							}

							//e_model SetContents( 0 );

							e_model PhysicsLaunch( self.origin, e_model GetVelocityLaunch( velocity ) );
							e_model thread waitUntilNotMoving( IS_TRUE( self.params[ "stay" ] ) );
						}
						else
						{
							e_model thread do_fake_destroy( e_who );
						}
					}
					else
					{
						e_model Delete();
					}
				}
			}

			stype = self.script_sound;
			if( !IsDefined( stype ) )
			{
				stype = "wood";
			}

			n_speed = Int( MapFloat( 0, 70, 1, 3, speed ) );

			str_imp = "lgt";
			switch( n_speed )
			{
				case 2:
				{
					str_imp = "med";
					break;
				}
				case 3:
				{
					str_imp = "hard";
					break;
				}
			}

			str_alias = "veh_monster_truck_land_" + stype + "_" + str_imp;
			TRUCK_DEBUG_SERVER( str_alias );
			PlaySoundAtPosition( str_alias, self.origin );

			self Delete();
		}
	}
}

function crushable_think_thread( a_e_models )
{
	DEFAULT( self.crushable_health, 100 );
	DEFAULT( self.has_been_damaged, false );

	self CreateVehicleCollision();
	self thread UpdateAnimWeights();

	while( IsDefined( self ) )
	{
		self waittill( "trigger", e_ent );

		e_who = e_ent;
		if( IsEntity( e_ent ) && !IsVehicle( e_ent ) && IsDefined( e_ent.owner ) ) // this could potientally be a part flying towards this
		{
			e_who = e_ent.owner;
		}
		else if( IsPlayer( e_ent ) )
		{
			e_who = e_ent.truck;
		}
		if( e_who.notsolid === true )
		{
			continue;
		}

		n_points = self.script_float;
		if( !IsDefined( n_points ) )
		{
			n_points = 10.0;
		}

		boost = MapFloat( 1, 100, 0, n_points, self.crushable_health );

		if( !IsDefined( e_who.boostFree ) )
		{
			e_who.boostFree = 0;
		}

		// update globals
		if( !self.has_been_damaged )
		{
			e_who.owner.destructions++;
			e_who.owner.pers[ "destructions" ]++;
			self.has_been_damaged = true;
		}

		if( boost > 0 )
		{
			e_who thread MonsterTruckBoost::GiveBoost( boost );

			e_who thread MonsterJamScore::GivePoints( self.script_noteworthy, Int( boost * 10 ) );
		}

		self.crushable_health = Max( 1.0, self.crushable_health - 1 );

		self thread UpdateAnimWeights( 1 - ( self.crushable_health / 100 ) );
	}
}

function CreateVehicleCollision()
{
	if( IsDefined( self.target ) )
	{
		a_e_models = GetEntArray( self.target, "targetname" );
		foreach( e_model in a_e_models )
		{
			e_model.smushed_origin = 0;//e_model.origin + ( 0, 0, -10 );
		}
	}
}

function UpdateAnimWeights( n_weight = 0 )
{
	if( IsDefined( self.target ) )
	{
		a_e_models = GetEntArray( self.target, "targetname" );
		foreach( e_model in a_e_models )
		{
			//DEFAULT( e_model.script_animation, "a_crush_car_suv_crush" );
			//e_model UseAnimTree( #animtree );
			//e_model SetAnim( e_model.script_animation, n_weight, 0.2, 1 );
			e_model clientfield::set( "crush_car", n_weight );

			if( e_model.smushed_origin < 10 )
			{
				e_model MoveZ( -1, 0.2 );
				e_model.smushed_origin++;
			}
		}
	}
}

function waitUntilNotMoving( b_stays )
{
	self waittill( "stationary" );

	self NotSolid();

	if( b_stays )
	{
		return;
	}

	/*if( !IsDefined( self.scale ) )
	{
		self.scale = 1;
	}

	self RotateTo( ( 0, 0, 0 ), 1 );

	for( i = self.scale - 0.05; i >= 0; i -= 0.05 )
	{
		self SetScale( i );
		WAIT_SERVER_FRAME;
	}*/
	self Delete();
}

// launches lighter objects farther
function GetVelocityLaunch( velocity )
{
	max = self GetAbsMaxs();
	avg = 0;
	for( i = 0; i < 3; i++ )
	{
		avg += max[ i ];
	}

	avg = avg / 3;

	multiplier = MapFloat( 0, 10000, 0.002, 0.0005, avg );

	return VectorScale( velocity, multiplier );
}

function do_fake_destroy( e_who )
{
	speed = e_who GetSpeed();
	speed = TRUCK_GENERIC_SPEED_TO_MPH( speed );

	launch = Int( ( ( speed < 0 ) ? MapFloat( 0, -105, -50, -800, speed ) : MapFloat( 0, 105, 50, 800, speed ) ) );
	angles = e_who.angles;

	dest = self.origin + ( ( AnglesToForward( angles ) * launch ) );
	self NotSolid();
	//self Rotate( ( self.angles[ 0 ] + RandomInt( 45 ), self.angles[ 1 ] + RandomInt( 45 ), self.angles[ 2 ] + RandomInt( 45 ) ) );

	//self RotateRoll( self.angles[ 0 ] + 360, 5 );
	//self RotatePitch( self.angles[ 1 ] + 360, 5 );
	//self RotateYaw( self.angles[ 2 ] + 360, 5 );

	self RotateVelocity( VectorScale( ( ( math::cointoss() ? 1 : -1 ), ( math::cointoss() ? 1 : -1 ), ( math::cointoss() ? 1 : -1 ) ), 180 ), 5, 1, 1 );
	for( i = 0; i < 3; i++ )
	{
		time = self MonsterJamUtility::fake_physicslaunch( dest, 450 );
		wait time;
		dest = self.origin + ( ( AnglesToForward( angles ) * launch ) );
	}

	self MoveTo( self.origin - ( 0, 0, 40 ), 1 );

	for( i = 1; i > 0; i -= 0.05 )
	{
		self SetScale( i );
		WAIT_SERVER_FRAME;
	}

	self Delete();
}

/*
Valid params
- stay = destroyed objects will always be around, no collision still
- notsolid = object is set to notsolid as soon as destroyed
- fake = ignores all params, does fake destroy instead
*/
function setupSmashableParams()
{
	self.params = [];

	if( !IsDefined( self.script_parameters ) )
	{
		self.script_parameters = "";
	}

	self.params[ "stay" ] = IsSubStr( self.script_parameters, "stay" );
	self.params[ "notsolid" ] = IsSubStr( self.script_parameters, "notsolid" );
	self.params[ "fake" ] = IsSubStr( self.script_parameters, "fake" );
}