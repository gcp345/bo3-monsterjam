#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\shared\vehicles\_driving_fx;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;
#using scripts\shared\vehicles\_monster_truck_clientfields;
#using scripts\shared\vehicles\_monster_truck_pieces;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterTruckAnim;

#using_animtree( "mj" );

REGISTER_SYSTEM( #"MonsterTruckAnim", &__init__, undefined )

function __init__()
{

}

function anim_init( localClientNum )
{
	self UseAnimTree( #animtree );

	self thread driver_thread( localClientNum );

	// start the suspension stuff
	self thread suspension_thread( localClientNum, "back" );
	self thread suspension_thread( localClientNum, "front" );

	self thread drivetrain_thread( localClientNum );
}

#define PLAYBACK_TIME 					1
#define TIME_TO_TRANSITION 				0.01

#define TIME_TO_TRANSITION_SUSPENSION 	0.001

// this is so the drivetrain actually spins really fast
#define PLAYBACK_TIME_DRIVETRAIN 		10

function driver_thread( localClientNum )
{
	self endon( "entityshutdown" );

	str_steer_anim = "o_monster_jam_driver_turn_straight";

	while( IsDefined( self ) )
	{
		n_steering = self GetSteering();
		n_weight = 0;

		b_is_straight = false;

		self ClearAnim( "o_monster_jam_driver_turn_straight", TIME_TO_TRANSITION );
		self ClearAnim( "o_monster_jam_driver_turn_left", TIME_TO_TRANSITION );
		self ClearAnim( "o_monster_jam_driver_turn_right", TIME_TO_TRANSITION );

		self ClearAnim( "o_monster_jam_steeringbar_straight", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_steeringbar_left", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_steeringbar_right", TIME_TO_TRANSITION_SUSPENSION );

		if( n_steering == 0 )
		{
			b_is_straight = true;
		}
		else
		{
			n_weight = Abs( n_steering );
			str_steer_anim = "o_monster_jam_driver_turn_right";
			if( n_steering > 0 )
			{
				str_steer_anim = "o_monster_jam_driver_turn_left";
			}
		}

		self setSteeringAnimWeights( b_is_straight, str_steer_anim == "o_monster_jam_driver_turn_left", math::clamp( n_weight, 0, 1 ) );


		WAIT_CLIENT_FRAME;
	}
}

// 2/17/2023 - did steering bar shit through here now
function setSteeringAnimWeights( b_is_straight, b_is_left, n_weight )
{
	if( b_is_straight )
	{
		self SetAnim( "o_monster_jam_driver_turn_straight", 1, TIME_TO_TRANSITION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_driver_turn_left", 0, TIME_TO_TRANSITION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_driver_turn_right", 0, TIME_TO_TRANSITION, PLAYBACK_TIME );
		
		self SetAnim( "o_monster_jam_steeringbar_straight", 1, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_steeringbar_left", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_steeringbar_right", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
	}
	else
	{
		if( b_is_left )
		{
			self SetAnim( "o_monster_jam_driver_turn_straight", 1 - n_weight, TIME_TO_TRANSITION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_driver_turn_left", n_weight, TIME_TO_TRANSITION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_driver_turn_right", 0, TIME_TO_TRANSITION, PLAYBACK_TIME );
			
			self SetAnim( "o_monster_jam_steeringbar_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_steeringbar_left", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_steeringbar_right", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
		else
		{
			
			self SetAnim( "o_monster_jam_driver_turn_straight", 1 - n_weight, TIME_TO_TRANSITION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_driver_turn_left", 0, TIME_TO_TRANSITION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_driver_turn_right", n_weight, TIME_TO_TRANSITION, PLAYBACK_TIME );
			
			self SetAnim( "o_monster_jam_steeringbar_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_steeringbar_left", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_steeringbar_right", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
	}
}

// since aim constraints do not exist in BO3, we have to simulate it ourselves
function suspension_thread( localClientNum, str_wheel )
{
	self endon( "entityshutdown" );

	str_left_wheel = "tag_wheel_" + str_wheel + "_left_spin";
	str_left_height = "tag_wheel_" + str_wheel + "_left_min";

	str_right_wheel = "tag_wheel_" + str_wheel + "_right_spin";
	str_right_height = "tag_wheel_" + str_wheel + "_right_min";

	// for up and down movements.
	n_middle = 935.1;
	n_max_height = 1226.5;
	n_divisor = n_max_height - n_middle;

	// for side to side movements
	n_max_angle = 90;

	while( IsDefined( self ) )
	{
		n_weight = 0;

		// reset the up and down
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_down", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_straight", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_up", TIME_TO_TRANSITION_SUSPENSION );

		// and the left and right
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_left", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_right", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_straight", TIME_TO_TRANSITION_SUSPENSION );

		// lets do up and down movement first
		v_left_wheel = self GetTagOrigin( str_left_wheel );
		v_right_wheel = self GetTagOrigin( str_right_wheel );

		n_left_height = DistanceSquared( v_left_wheel, self GetTagOrigin( str_left_height ) );
		n_right_height = DistanceSquared( v_right_wheel, self GetTagOrigin( str_right_height ) );
		f_avg = ( n_left_height + n_right_height ) / 2;
		f_rounded = ( Ceil( f_avg * 10 ) ) / 10;

		// sometimes it will throw a really weird number we can't account for
		f_rounded = Min( f_rounded, n_max_height );
		//iprintlnbold( "Wheel height avg:" + f_rounded );

		if( f_rounded == n_middle )
		{
			self setSuspensionAnimWeight( localClientNum, str_wheel, true, undefined, undefined );
		}
		else
		{
			b_is_down = false;
			if( f_rounded > n_middle )
			{
				b_is_down = true;
				n_weight = ( f_rounded - n_middle ) / n_divisor;
				// max height is 35, animation goes to 40
				n_weight = n_weight * 0.5;
			}
			else
			{
				n_weight = 1 - ( f_rounded / n_middle );
				n_weight = n_weight * 0.5;
			}

			// height ranges from 30-35, starts at 33
			

			self setSuspensionAnimWeight( localClientNum, str_wheel, false, b_is_down, n_weight );
		}

		n_angle = self GetWheelAngles( str_wheel ) - 90;

		if( n_angle == 0 )
		{
			self setSuspensionAngleAnimWeight( localClientNum, str_wheel, true, undefined, undefined );
		}
		else
		{
			n_angle_weight = Abs( n_angle );
			if( n_angle > 0 )
			{
				self setSuspensionAngleAnimWeight( localClientNum, str_wheel, false, true, n_angle_weight );
			}
			else
			{
				self setSuspensionAngleAnimWeight( localClientNum, str_wheel, false, false, n_angle_weight );
			}
		}

		WAIT_CLIENT_FRAME;
	}
}

function drivetrain_thread( localClientNum )
{
	self endon( "entityshutdown" );

	while( IsDefined( self ) )
	{
		self ClearAnim( "o_monster_jam_drivetrain_forward", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_drivetrain_neutral", TIME_TO_TRANSITION_SUSPENSION );
		self ClearAnim( "o_monster_jam_drivetrain_reverse", TIME_TO_TRANSITION_SUSPENSION );

		n_throttle = self GetThrottle();

		if( n_throttle != 0 )
		{
			n_weight = math::clamp( Abs( n_throttle ), 0, 1 );
			if( n_throttle > 0 )
			{
				self SetAnim( "o_monster_jam_drivetrain_forward", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
				self SetAnim( "o_monster_jam_drivetrain_neutral", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
				self SetAnim( "o_monster_jam_drivetrain_reverse", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
			}
			else
			{
				self SetAnim( "o_monster_jam_drivetrain_forward", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
				self SetAnim( "o_monster_jam_drivetrain_neutral", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
				self SetAnim( "o_monster_jam_drivetrain_reverse", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
			}
		}
		else
		{
			self SetAnim( "o_monster_jam_drivetrain_forward", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
			self SetAnim( "o_monster_jam_drivetrain_neutral", 1, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
			self SetAnim( "o_monster_jam_drivetrain_reverse", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME_DRIVETRAIN );
		}

		WAIT_CLIENT_FRAME;
	}
}

function GetWheelAngles( str_wheel )
{
	angles_to_right = AnglesToUp( self.angles );

	str_left_wheel = "tag_wheel_" + str_wheel + "_left_spin";
	str_right_wheel = "tag_wheel_" + str_wheel + "_right_spin";

	v_left_wheel = self GetTagOrigin( str_left_wheel );
	v_right_wheel = self GetTagOrigin( str_right_wheel );

	dotProduct = VectorDot( VectorNormalize( angles_to_right ), VectorNormalize( v_left_wheel - v_right_wheel ) );
	n_angle = ACos( dotProduct / ( Length( angles_to_right ) * Length( v_left_wheel - v_right_wheel ) ) );

	// it's flat at 90, make sure it doesn't get over 180 or under 0
	n_angle = math::clamp( n_angle, 0, 180 );

	return n_angle;
}

function setSuspensionAnimWeight( localClientNum, str_wheel, b_is_straight, b_is_down, n_weight )
{
	if( b_is_straight )
	{
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_down", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_straight", 1, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_up", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
	}
	else
	{
		if( b_is_down )
		{
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_down", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_up", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
		else
		{
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_down", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_up", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
	}
}

function setSuspensionAngleAnimWeight( localClientNum, str_wheel, b_is_straight, b_is_left, n_weight )
{
	if( b_is_straight )
	{
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_left", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_right", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_straight", 1, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
	}
	else
	{
		if( b_is_left )
		{
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_left", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_right", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
		else
		{
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_left", 0, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_right", n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
			self SetAnim( "o_monster_jam_suspension_" + str_wheel + "_axel_straight", 1 - n_weight, TIME_TO_TRANSITION_SUSPENSION, PLAYBACK_TIME );
		}
	}
}