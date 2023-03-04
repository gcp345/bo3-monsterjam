#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\clientfield_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\vehicles\_monster_truck;

#insert scripts\shared\vehicles\_monster_truck.gsh;

#namespace MonsterTruckCF;

REGISTER_SYSTEM( #"MonsterTruckCF", &__init__, undefined )

function __init__()
{
	// Boost
	// Infinite and Free boost
	if( !level.monster_jam_trucks_enable_ua_model )
	{
		clientfield::register( "clientuimodel", "MonsterTruckBoostInfinite", VERSION_SHIP, 7, "float" );
		clientfield::register( "clientuimodel", "MonsterTruckBoostFree", VERSION_SHIP, 7, "float" );
		clientfield::register( "clientuimodel", "MonsterTruckBoostBlown", VERSION_SHIP, 1, "int" );
	}
	else
	{
		clientfield::register( "clientuimodel", "MonsterTruckBoostTank1", VERSION_SHIP, 7, "float" );
		clientfield::register( "clientuimodel", "MonsterTruckBoostTank2", VERSION_SHIP, 7, "float" );
		clientfield::register( "clientuimodel", "MonsterTruckBoostIsSecondTank", 1, 1, "int" );
		clientfield::register( "clientuimodel", "MonsterTruckSpectaclePoints", VERSION_SHIP, 3, "int" );
	}
	
	// Vehicle FX
	clientfield::register( "vehicle", "MonsterTruckBoostFX", VERSION_SHIP, 2, "int" );

	clientfield::register( "vehicle", "truckMud", VERSION_SHIP, 10, "int" );
	clientfield::register( "scriptmover", "truckMud", VERSION_SHIP, 10, "int" );

	clientfield::register( "scriptmover", "truckImpact", VERSION_SHIP, 1, "int" );

	clientfield::register( "vehicle", "truckEngineIndex", VERSION_SHIP, GetMinBitCountForNum( 4 ), "int" );
}


function IncrementDirt( n_count = 1 )
{
	if( !IsDefined( self.n_mud ) )
	{
		self.n_mud = 0;
	}

	if ( IsDefined( self ) )
	{
		n_new_num = self.n_mud + n_count;
		if( n_new_num > 1000 )
		{
			n_new_num = 1000;
		}

		self.n_mud = n_new_num;

		self clientfield::set( "truckMud", Int( self.n_mud ) );

		if( IsDefined( self.truck_parts_models ) )
		{
			for( j = 0; j < self.truck_parts_models.size; j++ )
			{
				part = self.truck_parts_models[ j ];
				if( IsDefined( part ) )
				{
					part clientfield::set( "truckMud", Int( self.n_mud ) );
				}
			}
		}
	}
}