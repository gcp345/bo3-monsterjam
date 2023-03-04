#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_globallogic;

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

#precache( "model", "tg_mj_monster_truck_panel_avenger" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_top" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_window_front" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_window_left" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_window_rear" );
#precache( "model", "tg_mj_monster_truck_panel_avenger_window_right" );

#precache( "model", "tg_mj_monster_truck_panel_blacksmith" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_flag" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_top" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_window_front" );
#precache( "model", "tg_mj_monster_truck_panel_blacksmith_window_rear" );

#precache( "model", "tg_mj_monster_truck_panel_bluethunder" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_flag_left" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_flag_right" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_top" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_top_front" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_top_rear" );
#precache( "model", "tg_mj_monster_truck_panel_bluethunder_window" );

#precache( "model", "tg_mj_monster_truck_panel_bountyhunter" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_flag" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_left_front" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_right_front" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_top" );
#precache( "model", "tg_mj_monster_truck_panel_bountyhunter_window" );

#precache( "model", "tg_mj_monster_truck_panel_brutus" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_brutus_window" );

#precache( "model", "tg_mj_monster_truck_panel_bulldozer" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_top" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_top_left" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_top_right" );
#precache( "model", "tg_mj_monster_truck_panel_bulldozer_window" );

#precache( "model", "tg_mj_monster_truck_panel_captcurse" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_flag" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_top" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_window_front" );
#precache( "model", "tg_mj_monster_truck_panel_captcurse_window_rear" );

#precache( "model", "tg_mj_monster_truck_panel_destroyer" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_top" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_top_front" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_top_rear" );
#precache( "model", "tg_mj_monster_truck_panel_destroyer_window" );

#precache( "model", "tg_mj_monster_truck_panel_eltoroloco" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_top" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_top_left" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_top_right" );
#precache( "model", "tg_mj_monster_truck_panel_eltoroloco_window" );

#precache( "model", "tg_mj_monster_truck_panel_gravedigger" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_flag" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_top" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger_window_front" );

#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_flag" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_top" );
#precache( "model", "tg_mj_monster_truck_panel_gravedigger25th_window_front" );

#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_flag" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_left_front" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_right_front" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_top" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlaw_window" );

#precache( "model", "tg_mj_monster_truck_panel_kingkrunch" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_flag_left" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_flag_right" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_top" );
#precache( "model", "tg_mj_monster_truck_panel_kingkrunch_window" );

#precache( "model", "tg_mj_monster_truck_panel_maxd" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_top" );
#precache( "model", "tg_mj_monster_truck_panel_maxd_window" );

#precache( "model", "tg_mj_monster_truck_panel_monstermutt" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_back_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_monstermutt_window" );

#precache( "model", "tg_mj_monster_truck_panel_muttdalmation" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_back_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_muttdalmation_window" );

#precache( "model", "tg_mj_monster_truck_panel_pastrana" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_top" );
#precache( "model", "tg_mj_monster_truck_panel_pastrana_window" );

#precache( "model", "tg_mj_monster_truck_panel_predator" );
#precache( "model", "tg_mj_monster_truck_panel_predator_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_predator_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_predator_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_predator_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_predator_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_predator_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_predator_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_predator_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_predator_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_predator_top" );
#precache( "model", "tg_mj_monster_truck_panel_predator_top_front" );
#precache( "model", "tg_mj_monster_truck_panel_predator_top_rear" );
#precache( "model", "tg_mj_monster_truck_panel_predator_window" );

#precache( "model", "tg_mj_monster_truck_panel_scarletbandit" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_flag" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_left_front" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_right_front" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_top" );
#precache( "model", "tg_mj_monster_truck_panel_scarletbandit_window" );

#precache( "model", "tg_mj_monster_truck_panel_suzuki" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_top" );
#precache( "model", "tg_mj_monster_truck_panel_suzuki_window" );

// UA PATCH

#precache( "xmodel", "tg_mj_monster_truck_panel_airforce" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_front_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_front_right" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_airforce_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_backwardsbob_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_blackstallion_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_devastator" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_front_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_front_right" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_top_rear" );
#precache( "xmodel", "tg_mj_monster_truck_panel_devastator_window" );

#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_back_middle" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_flag" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_front_bumper" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_front_left" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_front_middle" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_front_right" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_left_back" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_left_door" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_left_front" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_right_back" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_right_door" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_right_front" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_top" );
#precache( "model", "tg_mj_monster_truck_panel_ironoutlawq_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_front_horn" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_top_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_top_rear" );
#precache( "xmodel", "tg_mj_monster_truck_panel_jurassicattack_top_right" );

#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_front_grille" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_front_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_front_right" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_originalgravedigger_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_spike" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spike_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_back_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_front_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_front_right" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_spitfire_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_top_front" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_top_rear" );
#precache( "xmodel", "tg_mj_monster_truck_panel_stonecrusher_window" );

#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_back_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_front_bumper" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_front_left" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_front_middle" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_front_right" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_left_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_left_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_right_back" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_right_door" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_top" );
#precache( "xmodel", "tg_mj_monster_truck_panel_warwizard_window" );


#namespace MonsterTruckPieces;

REGISTER_SYSTEM( #"MonsterTruckPieces", &__init__, undefined )

function __init__()
{
	SetupMonsterTruckDataArray();
}

// create the piece array here
function SetupMonsterTruckDataArray()
{
	// add piece setup here
	level._monster_truck_data = [];

	// setup the default truck
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_DEFAULTTRUCK, "UI_TRUCK_DEFAULTTRUCK", "tg_mj_monster_truck_chassis_defaulttruck" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DEFAULTTRUCK, "tg_mj_monster_truck_panel_suzuki_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_DEFAULTTRUCK, 4 );

	// GRAVE DIGGER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_GRAVEDIGGER, "UI_TRUCK_GRAVEDIGGER", "tg_mj_monster_truck_chassis_gravedigger" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_window_front", "tag_window_front" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_GRAVEDIGGER, 1 );

	// MONSTER MUTT
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_MONSTERMUTT, "UI_TRUCK_MONSTERMUTT", "tg_mj_monster_truck_chassis_monstermutt" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_back_bumper", "tag_back_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MONSTERMUTT, "tg_mj_monster_truck_panel_monstermutt_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_MONSTERMUTT, 3 );

	// BOUNTY HUNTER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_BOUNTYHUNTER, "UI_TRUCK_BOUNTYHUNTER", "tg_mj_monster_truck_chassis_bountyhunter" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_left_front", "tag_left_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_right_front", "tag_right_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BOUNTYHUNTER, "tg_mj_monster_truck_panel_bountyhunter_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_BOUNTYHUNTER, 3 );

	// BULLDOZER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_BULLDOZER, "UI_TRUCK_BULLDOZER", "tg_mj_monster_truck_chassis_bulldozer" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_top_left", "tag_top_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_top_right", "tag_top_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BULLDOZER, "tg_mj_monster_truck_panel_bulldozer_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckPieceCallback( TRUCK_INDEX_BULLDOZER, "tag_top", &BullHornGib );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_BULLDOZER, 2 );

	// BLUE THUNDER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_BLUETHUNDER, "UI_TRUCK_BLUETHUNDER", "tg_mj_monster_truck_chassis_bluethunder" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_flag_left", "tag_flag_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_flag_right", "tag_flag_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_top_front", "tag_top_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLUETHUNDER, "tg_mj_monster_truck_panel_bluethunder_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_BLUETHUNDER, 3 );

	// KING KRUNCH
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_KINGKRUNCH, "UI_TRUCK_KINGKRUNCH", "tg_mj_monster_truck_chassis_kingkrunch" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_flag_left", "tag_flag_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_flag_right", "tag_flag_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_KINGKRUNCH, "tg_mj_monster_truck_panel_kingkrunch_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_KINGKRUNCH, 4 );

	// DESTROYER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_DESTROYER, "UI_TRUCK_DESTROYER", "tg_mj_monster_truck_chassis_destroyer" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_top_front", "tag_top_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_DESTROYER, "tg_mj_monster_truck_panel_destroyer_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_DESTROYER, 2 );

	// BLACKSMITH
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_BLACKSMITH, "UI_TRUCK_BLACKSMITH", "tg_mj_monster_truck_chassis_blacksmith" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_back_middle", "tag_back_middle" );
	//MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_window_front", "tag_window_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tg_mj_monster_truck_panel_blacksmith_window_rear", "tag_window_rear" );
	MonsterTruckPieces::RegisterTruckHide( TRUCK_INDEX_BLACKSMITH, "tag_flag" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_BLACKSMITH, 1 );

	// EL TORO LOCO
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_ELTOROLOCO, "UI_TRUCK_ELTOROLOCO", "tg_mj_monster_truck_chassis_eltoroloco" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_top_left", "tag_top_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_top_right", "tag_top_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_ELTOROLOCO, "tg_mj_monster_truck_panel_eltoroloco_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckPieceCallback( TRUCK_INDEX_ELTOROLOCO, "tag_top", &BullHornGib );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_ELTOROLOCO, 2 );

	// SUZUKI
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_SUZUKI, "UI_TRUCK_SUZUKI", "tg_mj_monster_truck_chassis_suzuki" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SUZUKI, "tg_mj_monster_truck_panel_suzuki_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_SUZUKI, 4 );

	// PREDATOR
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_PREDATOR, "UI_TRUCK_PREDATOR", "tg_mj_monster_truck_chassis_predator" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_top_front", "tag_top_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PREDATOR, "tg_mj_monster_truck_panel_predator_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_PREDATOR, 2 );

	// MAXD
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_MAXD, "UI_TRUCK_MAXD", "tg_mj_monster_truck_chassis_maxd" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MAXD, "tg_mj_monster_truck_panel_maxd_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_MAXD, 1 );

	// SCARLET BANDIT
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_SCARLETBANDIT, "UI_TRUCK_SCARLETBANDIT", "tg_mj_monster_truck_chassis_scarletbandit" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_left_front", "tag_left_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_right_front", "tag_right_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_SCARLETBANDIT, "tg_mj_monster_truck_panel_scarletbandit_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_SCARLETBANDIT, 3 );

	// CAPTAIN'S CURSE
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_CAPTCURSE, "UI_TRUCK_CAPTCURSE", "tg_mj_monster_truck_chassis_captcurse" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_window_front", "tag_window_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_CAPTCURSE, "tg_mj_monster_truck_panel_captcurse_window_rear", "tag_window_rear" );
	//MonsterTruckPieces::RegisterTruckHide( TRUCK_INDEX_CAPTCURSE, "tag_flag" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_CAPTCURSE, 1 );

	// AVENGER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AVENGER, "UI_TRUCK_AVENGER", "tg_mj_monster_truck_chassis_avenger" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_window_front", "tag_window_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_window_left", "tag_window_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_window_rear", "tag_window_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AVENGER, "tg_mj_monster_truck_panel_avenger_window_right", "tag_window_right" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AVENGER, 2 );

	// PASTRANA
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_PASTRANA, "UI_TRUCK_PASTRANA", "tg_mj_monster_truck_chassis_pastrana" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_PASTRANA, "tg_mj_monster_truck_panel_pastrana_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_PASTRANA, 4 );

	// IRON OUTLAW
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_IRONOUTLAW, "UI_TRUCK_IRONOUTLAW", "tg_mj_monster_truck_chassis_ironoutlaw" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_left_front", "tag_left_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_right_front", "tag_right_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_IRONOUTLAW, "tg_mj_monster_truck_panel_ironoutlaw_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_IRONOUTLAW, 3 );

	// BRUTUS
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_BRUTUS, "UI_TRUCK_BRUTUS", "tg_mj_monster_truck_chassis_brutus" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_BRUTUS, "tg_mj_monster_truck_panel_brutus_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_BRUTUS, 4 );

	// MONSTER MUTT - DALMATION
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_MUTTDALMATION, "UI_TRUCK_MUTTDALMATION", "tg_mj_monster_truck_chassis_muttdalmation" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_back_bumper", "tag_back_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_MUTTDALMATION, "tg_mj_monster_truck_panel_muttdalmation_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_MUTTDALMATION, 3 );

	// GRAVE DIGGER 25TH ANNIVERSARY
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_GRAVEDIGGER25TH, "UI_TRUCK_GRAVEDIGGER25TH", "tg_mj_monster_truck_chassis_gravedigger25th" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER25TH, "tg_mj_monster_truck_panel_gravedigger25th_window_front", "tag_window_front" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_GRAVEDIGGER25TH, 1 );

	// UA PATCH

	// STONE CRUSHER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_STONECRUSHER, "UI_TRUCK_STONECRUSHER", "tg_mj_monster_truck_chassis_stonecrusher" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_top_front", "tag_top_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_STONECRUSHER, "tg_mj_monster_truck_panel_stonecrusher_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_STONECRUSHER, 1 );

	// SPIKE UNLEASHED
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_SPIKE, "UI_TRUCK_SPIKE", "tg_mj_monster_truck_chassis_spike" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPIKE, "tg_mj_monster_truck_panel_spike_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_SPIKE, 1 );

	// IRON OUTLAW - Q TORQUE
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_IRONOUTLAWQ, "UI_TRUCK_IRONOUTLAWQ", "tg_mj_monster_truck_chassis_ironoutlawq" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_flag", "tag_flag" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_left_front", "tag_left_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_right_front", "tag_right_front" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_IRONOUTLAWQ, "tg_mj_monster_truck_panel_ironoutlawq_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_IRONOUTLAWQ, 3 );

	// WAR WIZARD
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_WARWIZARD, "UI_TRUCK_WARWIZARD", "tg_mj_monster_truck_chassis_warwizard" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_WARWIZARD, "tg_mj_monster_truck_panel_warwizard_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_WARWIZARD, 1 );

	// SPITFIRE
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_SPITFIRE, "UI_TRUCK_SPITFIRE", "tg_mj_monster_truck_chassis_spitfire" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_back_bumper", "tag_back_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_SPITFIRE, "tg_mj_monster_truck_panel_spitfire_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_SPITFIRE, 1 );

	// JURASSIC ATTACK
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_JURASSICATTACK, "UI_TRUCK_JURASSICATTACK", "tg_mj_monster_truck_chassis_jurassicattack" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_front_horn", "tag_front_horn" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_top_left", "tag_top_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_JURASSICATTACK, "tg_mj_monster_truck_panel_jurassicattack_top_right", "tag_top_right" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_JURASSICATTACK, 1 );

	// BLACK STALLION
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_BLACKSTALLION, "UI_TRUCK_BLACKSTALLION", "tg_mj_monster_truck_chassis_blackstallion" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BLACKSTALLION, "tg_mj_monster_truck_panel_blackstallion_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_BLACKSTALLION, 1 );

	// DEVASTATOR
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_DEVASTATOR, "UI_TRUCK_DEVASTATOR", "tg_mj_monster_truck_chassis_devastator" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_top_rear", "tag_top_rear" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_DEVASTATOR, "tg_mj_monster_truck_panel_devastator_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_DEVASTATOR, 1 );

	// BACKWARDS BOB
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_BACKWARDSBOB, "UI_TRUCK_BACKWARDSBOB", "tg_mj_monster_truck_chassis_backwardsbob" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_BACKWARDSBOB, "tg_mj_monster_truck_panel_backwardsbob_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_BACKWARDSBOB, 1 );

	// AIR FORCE AFTERBURNER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_AIRFORCE, "UI_TRUCK_AIRFORCE", "tg_mj_monster_truck_chassis_airforce" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_AIRFORCE, "tg_mj_monster_truck_panel_airforce_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_AIRFORCE, 1 );

	// ORIGINAL GRAVE DIGGER
	MonsterTruckPieces::RegisterTruckInfo( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "UI_TRUCK_ORIGINALGRAVEDIGGER", "tg_mj_monster_truck_chassis_originalgravedigger" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_back_middle", "tag_back_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_front_bumper", "tag_front_bumper" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_front_grille", "tag_front_grille" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_front_left", "tag_front_left" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_front_middle", "tag_front_middle" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_front_right", "tag_front_right" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_left_back", "tag_left_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_left_door", "tag_left_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_right_back", "tag_right_back" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_right_door", "tag_right_door" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_top", "tag_top" );
	MonsterTruckPieces::RegisterTruckPiece( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, "tg_mj_monster_truck_panel_originalgravedigger_window", "tag_window" );
	MonsterTruckPieces::RegisterTruckEngineIndex( TRUCK_INDEX_AU_ORIGINALGRAVEDIGGER, 1 );
}

/@
"Name: RegisterTruckInfo( <index>, <str_name>, <str_chassis>, <str_fir_loc>, <str_sec_loc> )"
"Summary: Register a Truck
"Module: MonsterTruck"
"MandatoryArg: <index> Index of the truck.
"MandatoryArg: <str_name> Localized string of truck.
"MandatoryArg: <str_chassis> String name of model.
"Example: RegisterTruckInfo( TRUCK_INDEX_GRAVEDIGGER, "UI_TRUCK_GRAVEDIGGER", "tg_mj_monster_truck_chassis_gravedigger" );"
"SPMP: both"
@/
function RegisterTruckInfo( index, str_name, str_chassis )
{
	Assert( IsDefined( index ), "'index' is a required parameter for RegisterTruckInfo!" );
	Assert( IsDefined( str_name ), "'str_name' is a required parameter for RegisterTruckInfo!" );
	Assert( IsDefined( str_chassis ), "'str_chassis' is a required parameter for RegisterTruckInfo!" );

	data = SpawnStruct();
	data.name = str_name;
	data.chassis = str_chassis;
	data.is_picked = false;

	level._monster_truck_data[ index ] = data;
}

/@
"Name: RegisterTruckPiece( <index>, <str_part>, <str_tag_name> )"
"Summary: Register a Truck piece
"Module: MonsterTruck"
"MandatoryArg: <index> Index of the truck.
"MandatoryArg: <str_part> String value of a model.
"MandatoryArg: <str_tag_name> Bone location of where this part is on the vehicle.
"Example: RegisterTruckPiece( TRUCK_INDEX_GRAVEDIGGER, "tg_mj_monster_truck_panel_gravedigger_front_middle", "tag_front_middle" );"
"SPMP: both"
@/
function RegisterTruckPiece( index, str_part, str_tag_name )
{
	Assert( IsDefined( index ), "'index' is a required parameter for RegisterTruckPiece!" );
	Assert( IsDefined( str_part ), "'str_part' is a required parameter for RegisterTruckPiece!" );
	Assert( IsDefined( str_tag_name ), "'str_tag_name' is a required parameter for RegisterTruckPiece!" );
	
	if( !IsDefined( level._monster_truck_data[ index ].parts ) )
	{
		level._monster_truck_data[ index ].parts = [];
	}

	data = SpawnStruct();
	data.tag = str_tag_name;
	data.part = str_part;

	ARRAY_ADD( level._monster_truck_data[ index ].parts, data );

	RegisterTruckPieceCallback( index, str_tag_name, &globallogic::blank );
}

/@
"Name: RegisterTruckHide( <index>, <str_tag_name> )"
"Summary: Register a bone to hide on the truck
"Module: MonsterTruck"
"MandatoryArg: <index> Index of the truck.
"MandatoryArg: <str_tag_name> Bone location of where this part is on the vehicle.
"Example: RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tag_flag" );"
"SPMP: both"
@/
function RegisterTruckHide( index, str_tag_name )
{
	Assert( IsDefined( index ), "'index' is a required parameter for RegisterTruckHide!" );
	Assert( IsDefined( str_tag_name ), "'str_tag_name' is a required parameter for RegisterTruckHide!" );
	
	if( !IsDefined( level._monster_truck_data[ index ].hidden_tags ) )
	{
		level._monster_truck_data[ index ].hidden_tags = [];
	}

	ARRAY_ADD( level._monster_truck_data[ index ].hidden_tags, str_tag_name );
}

/@
"Name: RegisterTruckPieceCallback( <index>, <str_tag_name>, <func_callback> )"
"Summary: Register a callback for when a part gibs
"Module: MonsterTruck"
"MandatoryArg: <index> Index of the truck.
"MandatoryArg: <str_tag_name> Bone location of where this part is on the vehicle.
"MandatoryArg: <func_callback> Callback function for the part.
"Example: RegisterTruckPieceCallback( TRUCK_INDEX_BULLDOZER, "tag_top", &BullHornGib );"
"SPMP: both"
@/
function RegisterTruckPieceCallback( index, str_tag_name, func_callback )
{
	Assert( IsDefined( index ), "'index' is a required parameter for RegisterTruckPieceCallback!" );
	Assert( IsDefined( str_tag_name ), "'str_tag_name' is a required parameter for RegisterTruckPieceCallback!" );
	Assert( IsDefined( func_callback ), "'func_callback' is a required parameter for RegisterTruckPieceCallback!" );
	
	if( !IsDefined( level._monster_truck_data[ index ].callbacks ) )
	{
		level._monster_truck_data[ index ].callbacks = [];
	}

	level._monster_truck_data[ index ].callbacks[ str_tag_name ] = func_callback;
}

/@
"Name: RegisterTruckEngineIndex( <index>, <n_engine_index> )"
"Summary: Register the engine index for this truck
"Module: MonsterTruck"
"MandatoryArg: <index> Index of the truck.
"MandatoryArg: <n_engine_index> The index that the truck will use.
"Example: RegisterTruckPiece( TRUCK_INDEX_BLACKSMITH, "tag_flag" );"
"SPMP: both"
@/
function RegisterTruckEngineIndex( index, n_engine_index )
{
	Assert( IsDefined( index ), "'index' is a required parameter for RegisterTruckEngineIndex!" );
	Assert( IsDefined( n_engine_index ), "'n_engine_index' is a required parameter for RegisterTruckEngineIndex!" );
	
	level._monster_truck_data[ index ].engine = n_engine_index;
}

// self == vehicle
function RegisterMonsterTruck()
{
	Assert( IsDefined( self.truck_type ), "'self.truck_type' is undefined!" );
	
	self SetModel( level._monster_truck_data[ self.truck_type ].chassis );

	foreach( s_piece in level._monster_truck_data[ self.truck_type ].parts )
	{
		if( !IsDefined( self.truck_parts ) )
		{
			self.truck_parts = [];
		}

		struct = SpawnStruct();
		struct.gibbed = false;
		struct.part = s_piece.part;
		struct.tag = s_piece.tag;

		ARRAY_ADD( self.truck_parts, struct );
	}

	if( IsDefined( level._monster_truck_data[ self.truck_type ].hidden_tags ) )
	{
		for( i = 0; i < level._monster_truck_data[ self.truck_type ].hidden_tags.size; i++ )
		{
			self HidePart( level._monster_truck_data[ self.truck_type ].hidden_tags[ i ] );
		}
	}

	if( IsDefined( level._monster_truck_data[ self.truck_type ].engine ) )
	{
		self clientfield::set( "truckEngineIndex", level._monster_truck_data[ self.truck_type ].engine );
	}

	self thread CheckForTruckCollision();
	self thread CheckForTruckLanding();
}

#define F_MAX_DOT_PRODUCT_DEGREES				0.85
#define F_MIN_DOT_PRODUCT_DEGREES				0.45

function CheckForTruckCollision()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	DEFAULT( self._ent_ignore_collisions, [] );
	DEFAULT( self.next_collision_time, GetTime() + TRUCK_PIECE_COLLISION_INIT );

	while( IsDefined( self ) )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity, stype, otherent );

		// play the car crash sound effect
		// this also will force collisions no matter what
		b_should_do_collision = hit_intensity >= 15;
		if( IsDefined( otherent ) && IsVehicle( otherent ) )
		{
			if( otherent.notsolid === true || self.notsolid === true )
			{
				continue;
			}

			if( !IsInArray( self._ent_ignore_collisions, otherent ) )
			{
				b_should_do_collision = true;
				//self thread ignore_collision_until_backoff( otherent );
				stype = "concrete";
			}
		}

		if( !IsDefined( otherent ) || !IsInArray( self._ent_ignore_collisions, otherent ) )
		{
			land_vel = hit_intensity;

			TRUCK_DEBUG_SERVER( land_vel );

			n_start_index = ( b_should_do_collision ? 1 : 0 );
			n_land = Int( MapFloat( 0, 50, n_start_index, 3, land_vel ) );
			
			// prevents you from hearing a clang noise every collision
			str_imp = "none";
			f_shake = 0.01;
			switch( n_land )
			{
				case 1:
				{
					str_imp = "lgt";
					f_shake = 0.3;
					break;
				}
				case 2:
				{
					str_imp = "med";
					f_shake = 0.4;
					break;
				}
				case 3:
				{
					str_imp = "hard";
					f_shake = 0.8;
					break;
				}
			}

			DEFAULT( stype, "default" );

			ScreenShake( self.origin, f_shake, f_shake, f_shake, 0.5, 0, -1, 0, 7, 1, 1, 1, self.owner );

			if( str_imp !== "none" )
			{
				str_alias = "veh_monster_truck_land_" + stype + "_" + str_imp;
				TRUCK_DEBUG_SERVER( str_alias );
				PlaySoundAtPosition( str_alias, self.origin );
			}
		}

		DEFAULT( hitn, ( 0, 0, 1 ) );
		DEFAULT( hip, ( self.origin + ( hitn * VectorScale( ( 1, 1, 0 ), TRUCK_PIECE_COLLISION_DIST_SCALE ) ) + ( 0, 0, 15 ) ) );

		// based on our hit normal, spawn a test model to check where the location was
		ent_check = Spawn( "script_model", hip );
		ent_check.angles = self.angles;
		ent_check SetModel( "tag_origin" );

		ent_check clientfield::set( "truckImpact", 1 );

		if( IsDefined( self.next_collision_time ) && self.next_collision_time <= GetTime() && b_should_do_collision )
		{
			velocity = self GetVelocity();

			// collisions mess players up, so only do it for vehicle -> vehicle collisions
			if( IsDefined( otherent ) )
			{
				// prevents high speed flinging
				if( IsVehicle( otherent ) )
				{
					my_speed = Abs( TRUCK_GENERIC_SPEED_TO_MPH( self GetSpeed() ) );
					enemy_speed = Abs( TRUCK_GENERIC_SPEED_TO_MPH( otherent GetSpeed() ) );
					n_speed_diff = Abs( my_speed - enemy_speed );

					n_face_to_ent = self GetFaceValue( otherent );
					n_face_to_me = otherent GetFaceValue( self );
					b_is_facing = ( n_face_to_ent > F_MIN_DOT_PRODUCT_DEGREES && n_face_to_me > F_MIN_DOT_PRODUCT_DEGREES );
					b_is_behind = self IsBehindMe( otherent ) && !b_is_facing;

					self thread ignore_collision_until_backoff( otherent );

					if( my_speed < enemy_speed && b_is_facing || b_is_behind )
					{
						n_hit_intensity = ( ( n_face_to_ent > F_MAX_DOT_PRODUCT_DEGREES && n_face_to_me > F_MAX_DOT_PRODUCT_DEGREES ) ? enemy_speed : n_speed_diff );

						n_multiplier =  MapFloat( 0, 80, 0.075, 0.15, n_hit_intensity );
						n_height_launch = MapFloat( 0, 100, 0, MapFloat( 0.0, F_MAX_DOT_PRODUCT_DEGREES, 20, 90, n_face_to_ent ), n_hit_intensity );

						if( n_multiplier > 0 )
						{
							self LaunchVehicle( ( 100 * n_multiplier, 100 * n_multiplier, n_height_launch ), VectorScale( hitn, -50 ), true );
							self.next_collision_time = GetTime() + 250;
						}
					}
					else
					{
						n_hit_intensity = n_speed_diff;

						n_multiplier =  MapFloat( 0, 80, 0.025, 0.055, n_hit_intensity );
						n_height_launch = MapFloat( 20, 80, 0, 20, n_hit_intensity );
						if( n_multiplier > 0 )
						{
							self LaunchVehicle( ( 30 * n_multiplier, 30 * n_multiplier, n_multiplier ), VectorScale( hitn, 2 ), true );
							self.next_collision_time = GetTime() + 250;
						}
					}
				}
				else
				{
					continue;
				}
				
			}

			pieces_to_take = Int( MapFloat( 0, 85, 0, 4, hit_intensity ) );

			if( IsDefined( self.truck_parts ) && 
				DistanceSquared( self.origin, ent_check.origin ) > TRUCK_PIECE_COLLISION_ORIGIN * TRUCK_PIECE_COLLISION_ORIGIN && pieces_to_take > 0 ) // if they hit a small bump, we don't want parts going everywhere
			{
				a_pieces = [];

				foreach( data in self.truck_parts )
				{
					if( IS_TRUE( data.gibbed ) )
					{
						continue;
					}

					if( !self HasPart( data.tag ) )
					{
						continue;
					}

					piece_origin = self GetTagOrigin( data.tag );
					dist_sq = TRUCK_PIECE_COLLISION_PART * TRUCK_PIECE_COLLISION_PART;

					if( IsSubStr( data.tag, "tag_left" ) || IsSubStr( data.tag, "tag_right" ) )
					{
						dist_sq = TRUCK_PIECE_COLLISION_PART_SIDE * TRUCK_PIECE_COLLISION_PART_SIDE;
					}

					if( IsDefined( piece_origin ) )
					{
						if( DistanceSquared( piece_origin, ent_check.origin ) > dist_sq )
						{
							//TRUCK_DEBUG_SERVER( data.tag + " was too far!" );
							continue;
						}

						ARRAY_ADD( a_pieces, data );
					}
				}

				if( IsDefined( a_pieces ) && a_pieces.size > 0 )
				{
					a_pieces = array::randomize( a_pieces );

					for( i = 0; i < pieces_to_take; i++ )
					{
						data = a_pieces[ i ];

						self thread GibPart( data, hitn );
					}
				}

				//TRUCK_DEBUG_SERVER( "there was " + a_pieces.size + " pieces in the array" );
			}
		}

		ent_check Delete();

		//self.next_collision_time = GetTime() + 250;
	}
}

function IsSelfFaster( v_self_velocity, v_enemy_velocity )
{
	n_wins = 0;
	for( i = 0; i < 3; i++ )
	{
		if( Abs( v_self_velocity[ i ] ) > Abs( v_enemy_velocity[ i ] ) )
		{
			n_wins++;
		}
	}
	return n_wins >= 2;
}

function IsBehindMe( e_enemy )
{
	v_behind_self = self.origin + ( AnglesToForward( self.angles ) * -45 );
	v_forward_self = self.origin + ( AnglesToForward( self.angles ) * -45 );
	v_behind_enemy = e_enemy.origin + ( AnglesToForward( e_enemy.angles ) * -45 );
	v_forward_enemy = e_enemy.origin + ( AnglesToForward( e_enemy.angles ) * 45 );

	n_first_distance = DistanceSquared( v_behind_self, v_forward_enemy );
	n_second_distance = DistanceSquared( v_behind_enemy, v_forward_self );

	iprintlnbold( n_first_distance + n_second_distance );

	return n_first_distance < n_second_distance && ( n_first_distance + n_second_distance ) > ( 180 * 180 );
}

function GetFaceValue(facee)
{
	orientation = self.angles;
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return dotProduct;
}

// this is so launchvehicle collisions can't be spammed constantly
#define COLLISION_DISTANCE ( 300 * 300 )
function ignore_collision_until_backoff( otherent )
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	ARRAY_ADD( self._ent_ignore_collisions, otherent );

	while( ( DistanceSquared( self.origin, otherent.origin ) < COLLISION_DISTANCE ) && IsDefined( self ) && IsDefined( otherent ) )
	{
		WAIT_SERVER_FRAME;
	}

	// happens very rarely but check for it just in case. this happens in stuff like head to head
	if( !IsDefined( otherent ) )
	{
		self._ent_ignore_collisions = array::remove_undefined( self._ent_ignore_collisions );
	}
	else
	{
		ArrayRemoveValue( self._ent_ignore_collisions, otherent );
	}
}

function CheckForTruckLanding()
{
	self.owner endon( "disconnect" );
	self endon( "entityshutdown" );

	if( !IsDefined( self.next_jump_time ) )
	{
		self.next_jump_time = GetTime() + TRUCK_PIECE_COLLISION_INIT;
	}

	while( IsDefined( self ) )
	{
		self waittill( "veh_landed" );
		velocity = self GetVelocity();

		a_pieces = [];

		// if a truck lands and pops up, this prevents that
		if( GetTime() <= self.next_jump_time )
		{
			self.next_jump_time = GetTime() + 1000; // this also prevents it too
			continue;
		}

		if( RandomInt( 100 ) > 25 )
		{
			self.next_jump_time = GetTime() + 1000;
			continue;
		}

		if( IsDefined( self.truck_parts ) )
		{
			// trace the ground pos given a bone origin
			// this will randomize part results
			pos = self.origin;
			a_trace = GroundTrace( pos, pos + ( Vectorscale( ( 0, 0, -1 ), 10000 ) ), 0, undefined ); // todo: we can get surfacetype from this so maybe add a land sound???
			v_ground_pos = GetClosestPointOnNavMesh( a_trace[ "position" ], 256 );

			if( !IsDefined( v_ground_pos ) )
			{
				v_ground_pos = pos;
			}

			// based on our hit normal, spawn a test model to check where the location was
			ent_check = Spawn( "script_model", v_ground_pos + VectorScale( ( 0, 0, 1 ), 5 ) );
			ent_check.angles = self.angles;
			ent_check SetModel( "tag_origin" );

			//ent_check clientfield::set( "truckImpact", 1 );

			foreach( data in self.truck_parts )
			{
				if( IS_TRUE( data.gibbed ) )
				{
					continue;
				}

				if( !self HasPart( data.tag ) )
				{
					continue;
				}

				piece_origin = self GetTagOrigin( data.tag );
				dist_sq = TRUCK_PIECE_COLLISION_PART * TRUCK_PIECE_COLLISION_PART - 30;

				if( IsSubStr( data.tag, "tag_left" ) || IsSubStr( data.tag, "tag_right" ) )
				{
					dist_sq = TRUCK_PIECE_COLLISION_PART_SIDE * TRUCK_PIECE_COLLISION_PART_SIDE - 30;
				}

				if( IsDefined( piece_origin ) )
				{
					if( DistanceSquared( piece_origin, ent_check.origin ) > dist_sq )
					{
						TRUCK_DEBUG_SERVER( data.tag + " was too far!" );
						continue;
					}
					ARRAY_ADD( a_pieces, data );
				}

				ARRAY_ADD( a_pieces, data );
			}

			// remove any negative value
			height = Abs( velocity[ 2 ] ); 

			// added a negative number so we don't have parts falling off at very small heights
			pieces_to_take = Max( Floor( MapFloat( 0, 400, -2, 2, height ) ), 0 );
			TRUCK_DEBUG_SERVER( pieces_to_take );

			if( pieces_to_take > 0 && IsDefined( a_pieces ) && a_pieces.size > 0 )
			{
				a_pieces = array::randomize( a_pieces );

				for( i = 0; i < pieces_to_take; i++ )
				{
					data = a_pieces[ i ];

					self thread GibPart( data );
				}
			}

			ent_check Delete();

			self.next_jump_time = GetTime() + 1000;
		}
	}
}

function GibPart( data, hit_normal )
{
	if( !IsDefined( data ) )
	{
		return;
	}

	// check this again to make sure we don't get duplicate parts flying off
	if( IS_TRUE( data.gibbed ) )
	{
		return;
	}

	// get rid of priority parts first
	/* 12/23/22 - No such thing exist in MJ 2007, it's literally just distancing checking
	if( IsSubStr( data.tag, "tag_flag" ) )
	{
		data = self GetPartPriority( data, "tag_back_middle" );
	}

	if( IsSubStr( data.tag, "tag_front" ) && data.tag != "tag_front_bumper" )
	{
		data = self GetPartPriority( data, "tag_front_bumper" );
	}

	if( IsSubStr( data.tag, "tag_back" ) && data.tag != "tag_back_bumper" )
	{
		data = self GetPartPriority( data, "tag_back_bumper" );
	}
	*/

	// only checking because we could have a different part here
	if( IsDefined( data ) )
	{
		velocity = self GetVelocity();
		start_pos = self GetTagOrigin( data.tag );
		start_angles = self GetTagAngles( data.tag );
					
		if( IsDefined( data.part ) )
		{
			e_part = Spawn( "script_model", start_pos );
			e_part.angles = start_angles;
			e_part.targetname = "monster_truck_part";
			e_part SetModel( data.part );
			e_part NotSolid();
			e_part PhysicsLaunch( start_pos, ( IsDefined( hit_normal ) ? VectorScale( hit_normal, 1.0 ) : ( 0, 0, 0.25 ) ) );

			// so the vehicle can keep track of me
			e_part.owner = self;

			e_part thread MonsterTruckPieces::ApplyMudToPart();
		}

		DEFAULT( self.truck_parts_models, [] );
		ARRAY_ADD( self.truck_parts_models, e_part );

		self HidePart( data.tag );

		data.gibbed = true;

		if( IsDefined( level._monster_truck_data[ self.truck_type ].callbacks[ data.tag ] ) )
		{
			self thread [[ level._monster_truck_data[ self.truck_type ].callbacks[ data.tag ] ]]( hit_normal );
		}

		level notify( "part_lost", self, data );
	}
}

function GetPart( str_tag_name )
{
	if( IsDefined( self.truck_parts ) )
	{
		for( i = 0; i < self.truck_parts.size; i++ )
		{
			data = self.truck_parts[ i ];
			if( data.tag == str_tag_name ) // check to make sure the part is gibbed before returning it
			{
				return data;
			}
		}
	}

	return undefined;
}

function GetPartPriority( data, str_tag_name )
{
	if( !self HasPart( str_tag_name ) )
	{
		return data;
	}

	if( str_tag_name == data.tag )
	{
		return data;
	}

	if( IsDefined( self.truck_parts ) )
	{
		for( i = 0; i < self.truck_parts.size; i++ )
		{
			new_data = self.truck_parts[ i ];
			if( new_data.tag == str_tag_name ) // check to make sure the part is gibbed before returning it
			{
				if( !new_data.gibbed )
				{
					return new_data;
				}
			}
		}
	}

	return data;
}

function ApplyMudToPart()
{
	n_mud = self.owner.n_mud;

	// Hasn't got any dirt on himself yet
	if( !IsDefined( n_mud ) )
	{
		n_mud = 0;
	}

	self clientfield::set( "truckMud", Int( n_mud ) );
}

function CleanUpParts()
{
	if( IsDefined( self.truck_parts_models ) && self.truck_parts_models.size > 0 )
	{
		for( i = 0; i < self.truck_parts_models.size; i++ )
		{
			part = self.truck_parts_models[ i ];
			if( IsDefined( part ) )
			{
				part notify( "truck_cleanup" );
				part Delete();
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MISC
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function BullHornGib( hitn )
{
	self thread GibPart( self GetPart( "tag_top_left" ), hitn );
	self thread GibPart( self GetPart( "tag_top_right" ), hitn );
}