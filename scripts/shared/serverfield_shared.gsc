#insert scripts\shared\shared.gsh;

#namespace serverfield;

/@
"Name: register( <str_field_name>, <n_value> )"
"Summary: Register a client field.  Server fields are variable bit length fields communicated from server to client.
"Module: Serverfield"
"MandatoryArg: <Server field pool name> Which pool the field is allocated from.  Currently supported : "world", "actor", "vehicle", "scriptmover"
"MandatoryArg: <name> Unique name to identify the field.
"MandatoryArg: <version> Number indicating version this field was added in - see _version.gsh for defines.
"MandatoryArg: <num bits> How many bits to use for the field.  Valid values are in the range of 1-32.  Only ask for as many as you need.
"MandatoryArg: <type> Type of the field.  Currently supported types "int" or "float"
"Example: level serverfield::register( "generator_state", 1 );"
"SPMP: both"
@/
function register( str_pool_name, str_name, n_version, n_bits, str_type )
{
	RegisterServerField( str_pool_name, str_name, n_version, n_bits, str_type );
}

/@
"Name: set( <str_field_name>, <n_value> )"
"Summary: Sets a serverfield value on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"MandatoryArg: <n_value>: new value of serverfield"
"Example: level serverfield::set( "generator_state", 1 );"
"SPMP: both"
@/
function set( str_field_name, n_value )
{
	serverfieldsetval(self, str_field_name, n_value );
}


/@
"Name: set_to_player( <str_field_name>, <n_value> )"
"Summary: Sets a serverfield value in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"MandatoryArg: <n_value>: new value of serverfield"
"Example: player serverfield::set_to_player( "is_speaking", 1 );"
"SPMP: both"
@/
function set_to_player( str_field_name, n_value )
{
	serverfieldsetval( self, str_field_name, n_value );
}


/@
"Name: increment_to_player( <str_field_name> )"
"Summary: Increments a serverfield value in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"OptionalArg: [n_increment_count]: how much to increment by."
"Example: player serverfield::increment_to_player( "is_speaking" );"
"SPMP: both"
@/
function increment_to_player( str_field_name, n_increment_count = 1 )
{
	for ( i = 0; i < n_increment_count; i++ )
	{
		ServerFieldIncrement( self, str_field_name );
	}
}


/@
"Name: get( <str_field_name> )"
"Summary: Gets a serverfield value stored on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"Example: n_generator_state = level serverfield::get( "generator_state" );"
"SPMP: both"
@/
function get( str_field_name )
{
	if( self == level )
	{
		return GetWorldServerField( str_field_name );
	}
	else
	{
		return ServerFieldGetValue( self, str_field_name );
	}
}


/@
"Name: get_to_player( <str_field_name> )"
"Summary: Gets a serverfield value stored in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"Example: n_speaking_state = player serverfield::get_to_player( "is_speaking" );"
"SPMP: both"
@/
function get_to_player( field_name )
{
	return ServerFieldGetValue( self, field_name );
}
