//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// GENERIC

#define TRUCK_GENERIC_SPAWN_OFFSET								VectorScale( ( 0, 0, 1 ), 5 ) // Little bit of offset so trucks don't telefrag

// Turn radius - NOT USED
#define TRUCK_GENERIC_TURN_ABILITY_DEFAULT						0.3
#define TRUCK_GENERIC_TURN_ABILITY_MAX							1.0
#define TRUCK_GENERIC_TURN_BUTTON								"BUTTON_X"

#define TRUCK_GENERIC_SPEED_TO_MPH(__n)							( ( __n * 100 ) / 1760 )	// needed for csc							

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MUD

#define TRUCK_MUD_MIN_REVEAL									0.0 	// off
#define TRUCK_MUD_MAX_REVEAL									1.0 	// max number the dirt can reveal to
#define TRUCK_MUD_N_STEP										0.001	// Step value for dirt
#define TRUCK_MUD_TOTAL_COUNT									3 		// max number mud can increment per frame (integers only)
#define TRUCK_MUD_TOTAL_COUNT_DONUT								5 		// max number mud can increment per frame fore donuts (integers only)
#define TRUCK_MUD_DECREMENT_CHANCE								10 		// chance that speed won't decrement mud count, resulting in a mud increment (integers only)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// BOOST

#define TRUCK_BOOST_FREE_CLAMP_MAX								100.0 		// how long the free (blue) boost can last in milliseconds
#define TRUCK_BOOST_INFINITE_CLAMP_MAX							100.0 		// how long the infinite (red) boost can last in milliseconds

#define TRUCK_BOOST_UA_BOOST_START								25.0 		// limit of boost

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// INDEXES

#define TRUCK_INDEX_DEFAULTTRUCK								0
#define TRUCK_INDEX_GRAVEDIGGER									1
#define TRUCK_INDEX_MONSTERMUTT									2
#define TRUCK_INDEX_BOUNTYHUNTER								3
#define TRUCK_INDEX_BULLDOZER									4
#define TRUCK_INDEX_BLUETHUNDER									5
#define TRUCK_INDEX_KINGKRUNCH									6
#define TRUCK_INDEX_DESTROYER									7
#define TRUCK_INDEX_BLACKSMITH									8
#define TRUCK_INDEX_ELTOROLOCO									9
#define TRUCK_INDEX_SUZUKI										10
#define TRUCK_INDEX_PREDATOR									11
#define TRUCK_INDEX_MAXD										12
#define TRUCK_INDEX_SCARLETBANDIT								13
#define TRUCK_INDEX_CAPTCURSE									14
#define TRUCK_INDEX_AVENGER										15
#define TRUCK_INDEX_PASTRANA									16
#define TRUCK_INDEX_IRONOUTLAW									17
#define TRUCK_INDEX_BRUTUS										18
#define TRUCK_INDEX_MUTTDALMATION								19
#define TRUCK_INDEX_GRAVEDIGGER25TH								20

// DLC INDEXES

#define TRUCK_INDEX_AU_STONECRUSHER								21
#define TRUCK_INDEX_AU_SPIKE									22
#define TRUCK_INDEX_AU_IRONOUTLAWQ								23
#define TRUCK_INDEX_AU_WARWIZARD								24
#define TRUCK_INDEX_AU_SPITFIRE									25
#define TRUCK_INDEX_AU_JURASSICATTACK							26
#define TRUCK_INDEX_AU_BLACKSTALLION							27
#define TRUCK_INDEX_AU_DEVASTATOR								28
#define TRUCK_INDEX_AU_BACKWARDSBOB								29
#define TRUCK_INDEX_AU_AIRFORCE									30
#define TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER						31

#define TRUCK_INDEX_LIMIT										50 // need this for _mj_unlockables

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// PIECE

#define TRUCK_PIECE_COLLISION_INIT								5000
#define TRUCK_PIECE_COLLISION_DIST_SCALE						150

// part distances defines
#define TRUCK_PIECE_COLLISION_ORIGIN 							120
#define TRUCK_PIECE_COLLISION_PART								120
#define TRUCK_PIECE_COLLISION_PART_SIDE							110		// make this less so they don't come off quite as easy

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// DEBUG

#define TRUCK_DEBUG_SERVER(__s) 								/#iprintln("MONSTER TRUCK SERVER: " + __s);#/
#define TRUCK_DEBUG_CLIENT(__s) 								/#iprintlnbold("MONSTER TRUCK CLIENT: " + __s);#/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////