/* 
CORE FUNCTIONS FOR TPW MODS
Author: tpw 
Date: 20230802
Version: 2.00
Requires: CBA A3
Compatibility: N/A

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_core.sqf
2 - Call it with 0 = [["C_MAN","C_MAN","CUP_C","CAF_AG","CAF_AG","C_MAN"],["str1","str2",etc],5,23,1] execvm "tpw_core.sqf"; // where  ["C_MAN","C_MAN","CUP_C","CAF_AG","CAF_AG","C_MAN"] = civilian classname strings for Mediterranean, Oceanian, European, Mideastern, African, Asian maps respectively, ["str1","str2",etc] civs containing these strings in their classnames will be excluded, 5 = reduced civilian ambience will be spawned before this time (-1 to disable), 23 = reduced civilian ambience will be spawned after this time (-1 to disable). 1 = additional AI animations will be enabled after being incapacitated by injury (0=disable)

TPW MODS WILL NOT FUNCTION WITHOUT THIS SCRIPT RUNNING
*/

if (count _this < 5) exitwith {player sidechat "TPW CORE incorrect/no config, exiting."};

// VARS
tpw_core_mapstrings = _this select 0; // Strings to select per map civilians
tpw_core_blacklist = _this select 1; // Civilians to exclude
tpw_core_morning = _this select 2; // Reduced ambience before this time. Set to -1 to disable
tpw_core_night = _this select 3; // Reduced ambience after this time. Set to 25 to disable
tpw_core_extended_enable = _this select 4; // Enable additional AI animations after recovering from incapacitation
tpw_core_active = true;
tpw_mods_version = "20230927"; // will appear on start hint
tpw_core_fem_civs = [];
tpw_core_trees = [];

// MAP SPECIFIC MOD DISABLING
//Maps without roads - no cars
if (worldname in  ["pja307","pja319"]) then
	{
	tpw_car_active = false;
	tpw_park_active = false;
	};

// No aircraft
if (worldname in ["mak_Jungle","isladuala"]) then
	{
	tpw_air_active = false;
	};

// Winter 2035 specific
if (tolower worldname in ["stratis","altis"] && isclass (configfile/"CfgPatches"/"winter_2035")) then
	{
	tpw_winter2035 = true;
	} else
	{
	tpw_winter2035 = false;
	};
	
// CLOTHES
_trouserlist = [
// A3
"U_Competitor",
"U_C_HunterBody_grn",
"U_C_Poor_1",
"U_C_Poor_2",
"U_IG_Guerilla2_2",
"U_IG_Guerilla2_3",
"U_IG_Guerilla3_1",
"U_IG_Guerilla3_2",
"U_I_G_resistanceLeader_F",
"U_I_L_Uniform_01_tshirt_olive_F",
"U_NikosBody",
"U_Marshal",
"U_C_Journalist",
"U_Rangemaster",
"U_C_Mechanic_01_F",
"U_NikosAgedBody",
"u_c_man_casual_1_f",
"u_c_man_casual_2_f",
"u_c_man_casual_3_f",
"u_i_c_soldier_bandit_2_f",
"u_i_c_soldier_bandit_3_f",
"U_B_GEN_Commander_F",
"U_C_IDAP_Man_cargo_F",
"U_C_IDAP_Man_casual_F",
"U_C_IDAP_Man_Jeans_F",
"U_C_IDAP_Man_Tee_F",
"U_I_L_Uniform_01_camo_F",
"U_I_L_Uniform_01_deserter_F",
"U_I_L_Uniform_01_tshirt_black_F",
"U_I_L_Uniform_01_tshirt_olive_F",
"U_I_L_Uniform_01_tshirt_skull_F",
"U_I_L_Uniform_01_tshirt_sport_F",
"U_C_Uniform_Scientist_01_F",
"U_C_Uniform_Scientist_01_formal_F",
"U_C_Uniform_Scientist_02_formal_F",
"U_C_Uniform_Farmer_01_F",
"U_C_E_LooterJacket_01_F",
"U_O_R_Gorka_01_black_F",

// GM
"gm_gc_civ_uniform_man_01_80_blk",
"gm_gc_civ_uniform_man_01_80_blu",
"gm_gc_civ_uniform_man_01_80_brn",
"gm_gc_civ_uniform_man_02_80_brn",
"gm_gc_civ_uniform_man_03_80_blu",
"gm_gc_civ_uniform_man_03_80_grn",
"gm_gc_civ_uniform_man_03_80_gry",
"gm_gc_civ_uniform_man_04_80_blu",
"gm_gc_civ_uniform_man_04_80_gry",

// EO
"eo_hoodie_bandit",
"eo_hoodie_kabeiroi",
"eo_hoodie_red",
"eo_hoodie_grey",
"eo_hoodie_blue",
"eo_retro_bandit",
"eo_retro_kabeiroi",
"eo_retro_red",
"eo_retro_grey",
"eo_retro_green",
"eo_bandit_1",
"eo_diamond_1",
"eo_survivor_1",
"eo_independant_1",
"eo_shirt_check",
"eo_shirt_stripe",
"eo_shirt_bandit",
"eo_shirt_kabeiroi",
"eou_gorka_5",
"eou_gorka_7",
"eou_gorka_3",
"eou_gorka_6",
"eou_gorka_24",
"eou_gorka_22",
"eou_gorka_34",
"eou_gorka_28",
"eou_gorka_9",
"eou_gorka_12",
"eou_gorka_17",
"eou_gorka_2",
"eou_gorka_18",
"eou_gorka_10",
"eou_gorka_11",
"eou_gorka_13",
"eou_gorka_14",
"eou_gorka_15",

// DADPAT
"tg_u_dadpat_blue_hi",
"tg_u_dadpat_red_hi",
"tg_u_dadpat_grn_palm",
"tg_u_dadpat_prp_palm",
"tg_u_dadpat_tacky",
"tg_u_dadpat_floral",
"tg_u_dadpat_orng_plaid",
"tg_u_dadpat_blue_plaid",
"tg_u_dadpat_red_plaid",
"tg_u_dadpat_grn_plaid",

// ARGANINY
"arg_shirt_checked_red_uniform",
"arg_shirt_checked_green_uniform",
"arg_shirt_checked_blue_uniform",
"arg_shirt_checked_bluegreen_texture_uniform",
"arg_shirt_checked_grey_uniform",
"arg_shirt_checked_pink_uniform",
"arg_shirt_checked_purple_uniform",
"arg_shirt_checked_tartan_uniform",
"arg_shirt_checked_yellow_01_texture_uniform",
"arg_shirt_blue_gold_watch_uniform",
"arg_shirt_bundeswehr_gold_watch_uniform",
"arg_shirt_green_gold_watch_uniform",
"arg_shirt_ice_grey_gold_watch_uniform",
"arg_shirt_olive_gold_watch_uniform",
"arg_shirt_orange_gold_watch_uniform",
"arg_shirt_skol_gold_watch_uniform",
"arg_shirt_white_gold_watch_uniform",
"arg_shirt_yellow_gold_watch_uniform",
"arg_shirt_vaulttec_normal_logo_uniform",
"arg_shirt_vaulttec_normal_text_uniform",
"arg_shirt_vaulttec_vault_boy_uniform",
"arg_shirt_redrocket_normal_uniform",
"arg_shirt_robco_normal_grey_uniform",
"arg_shirt_robco_normal_bnw_uniform",
"arg_shirt_nukacola_normal_red_white_uniform",
"arg_shirt_nukacola_normal_white_red_uniform",
"arg_shirt_nukacola_normal_white_red_logo_one_uniform",
"arg_shirt_nukacola_normal_white_red_logo_two_uniform",
"arg_shirt_nukacola_normal_white_red_logo_with_bottle_uniform",

//
"AL_dirtyblue_jacket_supreblack_jumper_black_jeans_timbs",
"AL_dirtyblue_jacket_supreblue_jumper_black_jeans_timbs",
"AL_dirtyblue_jacket_supregrey_jumper_black_jeans_timbs",
"AL_dirtyblue_jacket_suprepurple_jumper_black_jeans_timbs",
"AL_dirtyblue_jacket_thrasher_jumper_black_jeans_timbs",
"AL_dark_jacket_supreblack_jumper_blue_jeans_timbs",
"AL_dark_jacket_supreblue_jumper_blue_jeans_timbs",
"AL_dark_jacket_supregrey_jumper_blue_jeans_timbs",
"AL_dark_jacket_suprepurple_jumper_blue_jeans_timbs",
"AL_dark_jacket_thrasher_jumper_blue_jeans_timbs",
"AL_dark_jacket_supreblack_jumper_grey_jeans_timbs",
"AL_dirtyblue_jacket_supreblack_jumper_grey_jeans_timbs",
"AL_dark_jacket_supreblue_jumper_grey_jeans_timbs",
"AL_dirtyblue_jacket_supreblue_jumper_grey_jeans_timbs",
"AL_dark_jacket_supregrey_jumper_grey_jeans_timbs",
"AL_dirtyblue_jacket_supregrey_jumper_grey_jeans_timbs",
"AL_dark_jacket_suprepurple_jumper_grey_jeans_timbs",
"AL_dirtyblue_jacket_suprepurple_jumper_grey_jeans_timbs",
"AL_dark_jacket_thrasher_jumper_grey_jeans_timbs",
"AL_dirtyblue_jacket_thrasher_jumper_grey_jeans_timbs",

// Skyline
"Skyline_Character_U_SecouristeA_01_F",
"Skyline_Character_U_SecouristeB_01_F",
"Skyline_Character_U_SecouristeB_02_F",
"Skyline_Character_U_Infirmier_01_F",
"Skyline_Character_U_Infirmier_02_F",
"Skyline_Character_U_Infirmier_03_F",
"Skyline_Character_U_CivilA_01_F",
"Skyline_Character_U_CivilA_02_F",
"Skyline_Character_U_CivilA_03_F",
"Skyline_Character_U_CivilA_04_F",
"Skyline_Character_U_CivilA_05_F",
"Skyline_Character_U_CivilA_06_F",
"Skyline_Character_U_CivilA_07_F",
"Skyline_Character_U_CivilA_08_F",
"Skyline_Character_U_CivilA_09_F",
"Skyline_Character_U_CivilA_10_F",
"Skyline_Character_U_Chasseur_01_F",
"Skyline_Character_U_Chasseur_02_F",
"Skyline_Character_U_Chasseur_03_F",
"Skyline_Character_U_Chasseur_04_F",
"Skyline_Character_U_Chasseur_05_F",
"Skyline_Character_U_CivilB_01_F",
"Skyline_Character_U_CivilB_02_F",
"Skyline_Character_U_CivilB_03_F",
"Skyline_Character_U_CivilB_04_F",
"Skyline_Character_U_CivilB_05_F",
"Skyline_Character_U_CivilB_06_F",
"Skyline_Character_U_CivilB_07_F",
"Skyline_Character_U_CivilB_08_F",
"Skyline_Character_U_Pompier_01_F",
"Skyline_Character_U_Pompier_02_F",
"Skyline_Character_U_CivilC_01_F",
"Skyline_Character_U_CivilC_02_F",
"Skyline_Character_U_CivilC_03_F",
"Skyline_Character_U_CivilC_04_F",
"Skyline_Character_U_CivilC_05_F",
"Skyline_Character_U_CivilC_06_F",
"Skyline_Character_U_CivilC_07_F",
"Skyline_Character_U_CivilD_01_F",
"Skyline_Character_U_CivilE_01_F",
"Skyline_Character_U_CivilE_02_F",
"Skyline_Character_U_CivilE_03_F",
"Skyline_Character_U_CivilE_04_F",
"Skyline_Character_U_CivilE_05_F",
"Skyline_Character_U_CivilE_06_F",
"Skyline_Character_U_CivilE_07_F",

// Crasus
"CR_MuricaShirt",
"CR_AnimeShirt",
"CR_GunsShirt",
"CR_ShrekShirt",
"CR_TargetShirt",
"CR_PresidenteShirt",
"CR_CheShirt",
"CR_MisfitShirt",
"CR_SpidercatShirt",
"CR_CenaShirt",
"CR_MothShirt",
"CR_CatShirt",
"CR_ISISShirt",
"CR_BloodShirt",
"CR_ColgateShirt",

// Art of War
"U_C_ArtTShirt_01_v1_F",
"U_C_ArtTShirt_01_v2_F",
"U_C_ArtTShirt_01_v3_F",
"U_C_ArtTShirt_01_v4_F",
"U_C_ArtTShirt_01_v5_F",
"U_C_ArtTShirt_01_v6_F",
"U_C_FormalSuit_01_tshirt_black_F",
"U_C_FormalSuit_01_tshirt_gray_F",

// Krazy
"u_krzy_forestranger_polo",
"u_krzy_huntingclothes_coyote",
"u_krzy_huntingclothes_grn_olv",
"u_krzy_huntingclothes_grn_coy",
"u_krzy_huntingclothes_olive",
"u_krzy_huntingclothes_red_olv",
"u_krzy_huntingclothes_red_coy",
"u_krzy_huntingshirt_blu_aut",
"u_krzy_huntingshirt_blu_coy",
"u_krzy_huntingshirt_blu_olv",
"u_krzy_huntingshirt_red_aut",
"u_krzy_huntingshirt_red_coy",
"u_krzy_huntingshirt_red_olv",
"u_krzy_huntingshirt_grn_aut",
"u_krzy_huntingshirt_grn_coy",
"u_krzy_huntingshirt_grn_olv",

// CSLA
"FIA_uniCitizen",
"FIA_uniCitizen2",
"FIA_uniCitizen3",
"FIA_uniCitizen4",
"FIA_uniDoctor",
"FIA_uniForeman",
"FIA_uniForeman2",
"FIA_uniFunctionary",
"FIA_uniFunctionary2",
"FIA_uniVillager",
"FIA_uniVillager2",
"FIA_uniVillager3",
"FIA_uniVillager4",
"FIA_uniWorker",
"FIA_uniWorker2",
"FIA_uniWorker3",
"FIA_uniWorker4",
"FIA_uniWoodlander",
"FIA_uniWoodlander2",
"FIA_uniWoodlander3",
"FIA_uniWoodlander4",

// SOF
"coverall_uniform",
"coverall_tan_uniform",
"coverall_tan_2_uniform",
"cargo_uniform",
"cargo_blue_uniform",
"cargo_green_uniform",
"cargo_grey_uniform",
"cargo_tan_uniform",
"cargo_red_uniform",
"cargob_blue_uniform",
"cargob_green_uniform",
"cargob_grey_uniform",
"cargob_tan_uniform",
"cargob_red_uniform",
"cargob_black_uniform",
"cpcu_uniform",
"cpcu_grey_uniform",
"cpcu_brown_uniform",
"cpcut_grey_uniform",
"cpcut_brown_uniform",
"cpcut_uniform",
"jpcu_uniform",
"jpcu_grey_uniform",
"jpcu_brown_uniform",
"cargot_uniform",
"cargot_black_uniform",
"cargot_red_uniform",
"cargot_green_uniform",
"cargot_blue_uniform",
"cargotb_white_uniform",
"cargotb_black_uniform",
"cargotb_red_uniform",
"cargotb_greem_uniform",
"cargotb_blue_uniform",
"hoodie_uniform",
"hoodie_brown_uniform",
"hoodie_red_uniform",
"hoodie_white_uniform",
"jeans_uniform",
"jeans_red_uniform",
"jeans_white_uniform",
"jeans_green_uniform",
"jeans_black_uniform",
"jeans_stripe1_uniform",
"jeans_stripe2_uniform",
"INS1_uniform",
"INS2_uniform",
"INS2_black_uniform",
"INS2_red_uniform",
"INS2_green_uniform",
"INS2_blue_uniform",
"INS3_uniform",
"INS4_uniform",
"INS4_black_uniform",
"INS4_red_uniform",
"INS4_green_uniform",
"INS4_blue_uniform",
"police_uniform",
"Tracksuit_uniform",
"Sweat_uniform",
"sweat_green_uniform",
"sweat_white_uniform",
"sweat_red_uniform",

// Project BJC
"Project_BJC",
"Project_BJC_1",
"Project_BJC_2",
"Project_BJC_3",
"Project_BJC_Cargo",
"Project_BJC_Cargo1",
"Project_BJC_Cargo2",
"Project_BJC_Cargo3",
"Project_BJC_Cargo4",
"Project_BJC_Cargo5",
"Project_BJC_Cargo6",
"Project_BJC_Cargo8",
"Project_BJC_Cargo9",
"Project_BJC_Cargo10",
"Project_BJC_Cargo12",
"Project_BJC_Cargo13",
"Project_BJC_Cargo14",
"Project_BJC_Shirt_Cargo",
"Project_BJC_Shirt_Cargo1",
"Project_BJC_Shirt_Cargo2",
"Project_BJC_Shirt_Cargo4",
"Project_BJC_Shirt_Cargo5",
"Project_BJC_Shirt_Cargo6",
"Project_BJC_Shirt_Cargo8",
"Project_BJC_Shirt_Cargo9",
"Project_BJC_Shirt_Cargo10",
"Project_BJC_Shirt_Cargo12",
"Project_BJC_Shirt_Cargo13",
"Project_BJC_Shirt_Cargo14",
"Project_BJC_Shirt_Cut_Cargo4",
"Project_BJC_Shirt_Cut_Cargo5",
"Project_BJC_Shirt_Cut_Cargo6",
"Project_BJC_Shirt_Cut_Cargo8",
"Project_BJC_Shirt_Cut_Cargo9",
"Project_BJC_Shirt_Cut_Cargo10",
"Project_BJC_Shirt_Cut_Cargo12",
"Project_BJC_Shirt_Cut_Cargo13",
"Project_BJC_Shirt_Cut_Cargo14",
"Project_BJC_Shirt_Jean",
"Project_BJC_Shirt_Jean1",
"Project_BJC_Shirt_Cut_Jean",
"Project_BJC_Shirt_Cut_Jean1",
"Project_BJC_Shirt_Cut_Jean2",
"Project_BJC_Shirt_Cut_Jean3",
"Project_BJC_Shirt_Jean2",
"Project_BJC_Shirt_Jean3",
"Project_BJC_PCU_Cargo",
"Project_BJC_PCU_Cargo1",
"Project_BJC_PCU_Cargo2",
"Project_BJC_PCU_Cargo4",
"Project_BJC_PCU_Cargo5",
"Project_BJC_PCU_Cargo6",
"Project_BJC_PCU_Cargo8",
"Project_BJC_PCU_Cargo9",
"Project_BJC_PCU_Cargo10",
"Project_BJC_PCU_Cargo12",
"Project_BJC_PCU_Cargo13",
"Project_BJC_PCU_Cargo14",
"Project_BJC_PCU_Cargo26",
"Project_BJC_PCU_Cargo27",
"Project_BJC_PCU_Cargo28",
"Project_BJC_PCU_Jean",
"Project_BJC_PCU_Jean1",
"Project_BJC_PCU_Jean2",
"Project_BJC_PCU_Jean3",
"Project_BJC_PCU_Jean5",
"Project_BJC_blk",
"Project_BJC_blk_1",
"Project_BJC_blk_2",
"Project_BJC_blk_3",
"Project_BJC_Shirt_Jean_blk",
"Project_BJC_Shirt_Jean_blk1",
"Project_BJC_Shirt_Cut_Jean_blk",
"Project_BJC_Shirt_Cut_Jean_blk1",
"Project_BJC_Shirt_Cut_Jean_blk2",
"Project_BJC_Shirt_Cut_Jean_blk3",
"Project_BJC_Shirt_Jean_blk2",
"Project_BJC_Shirt_Jean_blk3",
"Project_BJC_PCU_Jean_blk",
"Project_BJC_PCU_Jean_blk1",
"Project_BJC_PCU_Jean_blk2",
"Project_BJC_PCU_Jean_blk3",
"Project_BJC_PCU_Jean_blk5",

// Tryk
"TRYK_U_B_Denim_T_WH",
"TRYK_U_B_Denim_T_BK",
"TRYK_U_denim_jersey_blu",
"TRYK_U_denim_jersey_blk",

// PMC Expansion
"PMC_Jeans_Shirt_BLU",
"PMC_Jeans_Shirt_BLU_Dirty",
"PMC_Jeans_Shirt_WHT",
"PMC_Jeans_Shirt_WHT_Dirty",
"PMC_Jeans_BLK_Shirt_BLU",
"PMC_Jeans_BLK_Shirt_BLU_Dirty",
"PMC_Jeans_BLK_Shirt_WHT",
"PMC_Jeans_BLK_Shirt_WHT_Dirty",
"PMC_Jeans_Shirt_Cut_BLU",
"PMC_Jeans_Shirt_Cut_BLU_Dirty",
"PMC_Jeans_Shirt_Cut_WHT",
"PMC_Jeans_Shirt_Cut_WHT_Dirty",
"PMC_Jeans_BLK_Shirt_Cut_BLU",
"PMC_Jeans_BLK_Shirt_Cut_BLU_Dirty",
"PMC_Jeans_BLK_Shirt_Cut_WHT",
"PMC_Jeans_BLK_Shirt_Cut_WHT_Dirty",
"PMC_Jeans_Tshirt_BLU",
"PMC_Jeans_Tshirt_PPL",
"PMC_Jeans_Tshirt_GRN",
"PMC_Jeans_Tshirt_Noori",
"PMC_Jeans_BLK_Tshirt_BLU",
"PMC_Jeans_BLK_Tshirt_PPL",
"PMC_Jeans_BLK_Tshirt_GRN",
"PMC_Jeans_BLK_Tshirt_Noori",
"PMC_Cargo_TAN_Tshirt_BLU",
"PMC_Cargo_TAN_Tshirt_PPL",
"PMC_Cargo_TAN_Tshirt_GRN",
"PMC_Cargo_TAN_Tshirt_Noori",
"PMC_Cargo_RGR_Tshirt_BLU",
"PMC_Cargo_RGR_Tshirt_PPL",
"PMC_Cargo_RGR_Tshirt_GRN",
"PMC_Cargo_RGR_Tshirt_Noori",
"PMC_Cargo_BLK_Tshirt_BLU",
"PMC_Cargo_BLK_Tshirt_PPL",
"PMC_Cargo_BLK_Tshirt_GRN",
"PMC_Cargo_BLK_Tshirt_Noori",
"PMC_Cargo_MC_Tshirt_BLU",
"PMC_Cargo_MC_Tshirt_PPL",
"PMC_Cargo_BJCP_Tshirt_BLU",
"PMC_Cargo_BJCP_Tshirt_PPL",

// Tenues Civils
"skyzen_tshirt_jean_nike_blanc",
"skyzen_tshirt_jean_nike_noir",
"skyzen_tshirt_jean_nike_jaune",
"skyzen_tshirt_jean_nike_rouge",
"skyzen_tshirt_jean_supreme_noir",
"skyzen_tshirt_jean_supreme_blanc",
"skyzen_tshirt_jean_adidas_blanc",
"skyzen_tshirt_jean_adidas_noir",
"skyzen_tshirt_jean_adidas_rouge",
"skyzen_tshirt_jean_adidas_vert",
"skyzen_tshirt_jean_summer",
"skyzen_tshirt_jean_surf",
"skyzen_tshirt_jean_hulk",
"skyzen_tshirt_jean_jack_jones_marron",
"skyzen_tshirt_jean_jack_jones_rouge",
"skyzen_tshirt_jean_levis_noir",
"skyzen_tshirt_jean_levis_blanc",
"skyzen_tshirt_jean_levis_gris",
"skyzen_tshirt_jean_blanche",
"skyzen_tshirt_jean_bleu",
"skyzen_tshirt_jean_jaune",
"skyzen_tshirt_jean_noir",
"skyzen_tshirt_jean_orange",
"skyzen_tshirt_jean_rose",
"skyzen_tshirt_jean_rouge",
"skyzen_tshirt_jean_vert",
"skyzen_tshirt_jean_marron",

// Timmy Taliban
"U_I_poloshirtpants_11",
"U_I_poloshirtpants_12",
"U_I_poloshirtpants_13",
"U_I_poloshirtpants_14",
"U_I_poloshirtpants_15",
"U_I_poloshirtpants_21",
"U_I_poloshirtpants_22",
"U_I_poloshirtpants_23",
"U_I_poloshirtpants_24",
"U_I_poloshirtpants_25",
"U_I_poloshirtpants_31",
"U_I_poloshirtpants_32",
"U_I_poloshirtpants_33",
"U_I_poloshirtpants_34",
"U_I_poloshirtpants_35",
"U_I_poloshirtpants_41",
"U_I_poloshirtpants_42",
"U_I_poloshirtpants_43",
"U_I_poloshirtpants_44",
"U_I_poloshirtpants_45",
"U_I_poloshirtpants_51",
"U_I_poloshirtpants_52",
"U_I_poloshirtpants_53",
"U_I_poloshirtpants_54",
"U_I_poloshirtpants_55",
"U_I_poloshirtpants_61",
"U_I_poloshirtpants_62",
"U_I_poloshirtpants_63",
"U_I_poloshirtpants_64",
"U_I_poloshirtpants_65",
"U_I_poloshirtpants_71",
"U_I_poloshirtpants_72",
"U_I_poloshirtpants_73",
"U_I_poloshirtpants_74",
"U_I_poloshirtpants_75",
"U_I_poloshirtpants_81",
"U_I_poloshirtpants_82",
"U_I_poloshirtpants_83",
"U_I_poloshirtpants_84",
"U_I_poloshirtpants_85",
"U_I_poloshirtpants_91",
"U_I_poloshirtpants_92",
"U_I_poloshirtpants_93",
"U_I_poloshirtpants_94",
"U_I_poloshirtpants_95",
"U_I_poloshirtpants_101",
"U_I_poloshirtpants_102",
"U_I_poloshirtpants_103",
"U_I_poloshirtpants_104",
"U_I_poloshirtpants_105",
"U_I_solidshirt_11",
"U_I_solidshirt_12",
"U_I_solidshirt_13",
"U_I_solidshirt_14",
"U_I_solidshirt_15",
"U_I_solidshirt_21",
"U_I_solidshirt_22",
"U_I_solidshirt_23",
"U_I_solidshirt_24",
"U_I_solidshirt_25",
"U_I_solidshirt_31",
"U_I_solidshirt_32",
"U_I_solidshirt_33",
"U_I_solidshirt_34",
"U_I_solidshirt_35",
"U_I_solidshirt_41",
"U_I_solidshirt_42",
"U_I_solidshirt_43",
"U_I_solidshirt_44",
"U_I_solidshirt_45",
"U_I_solidshirt_51",
"U_I_solidshirt_52",
"U_I_solidshirt_53",
"U_I_solidshirt_54",
"U_I_solidshirt_55",
"U_I_solidshirt_61",
"U_I_solidshirt_62",
"U_I_solidshirt_63",
"U_I_solidshirt_64",
"U_I_solidshirt_65",
"U_I_solidshirt_71",
"U_I_solidshirt_72",
"U_I_solidshirt_73",
"U_I_solidshirt_74",
"U_I_solidshirt_75",
"U_I_solidshirt_81",
"U_I_solidshirt_82",
"U_I_solidshirt_83",
"U_I_solidshirt_84",
"U_I_solidshirt_85",
"U_I_solidshirt_91",
"U_I_solidshirt_92",
"U_I_solidshirt_93",
"U_I_solidshirt_94",
"U_I_solidshirt_95",
"U_I_solidshirt_101",
"U_I_solidshirt_102",
"U_I_solidshirt_103",
"U_I_solidshirt_104",
"U_I_solidshirt_105",
"U_I_plaidshirt_11",
"U_I_plaidshirt_12",
"U_I_plaidshirt_13",
"U_I_plaidshirt_14",
"U_I_plaidshirt_15",
"U_I_plaidshirt_21",
"U_I_plaidshirt_22",
"U_I_plaidshirt_23",
"U_I_plaidshirt_24",
"U_I_plaidshirt_25",
"U_I_plaidshirt_31",
"U_I_plaidshirt_32",
"U_I_plaidshirt_33",
"U_I_plaidshirt_34",
"U_I_plaidshirt_35",
"U_I_plaidshirt_41",
"U_I_plaidshirt_42",
"U_I_plaidshirt_43",
"U_I_plaidshirt_44",
"U_I_plaidshirt_45",
"U_I_plaidshirt_51",
"U_I_plaidshirt_52",
"U_I_plaidshirt_53",
"U_I_plaidshirt_54",
"U_I_plaidshirt_55",
"U_I_plaidshirt_61",
"U_I_plaidshirt_62",
"U_I_plaidshirt_63",
"U_I_plaidshirt_64",
"U_I_plaidshirt_65",
"U_I_plaidshirt_71",
"U_I_plaidshirt_72",
"U_I_plaidshirt_73",
"U_I_plaidshirt_74",
"U_I_plaidshirt_75",
"U_I_plaidshirt_81",
"U_I_plaidshirt_82",
"U_I_plaidshirt_83",
"U_I_plaidshirt_84",
"U_I_plaidshirt_85",
"U_I_plaidshirt_91",
"U_I_plaidshirt_92",
"U_I_plaidshirt_93",
"U_I_plaidshirt_94",
"U_I_plaidshirt_95",
"U_I_plaidshirt_101",
"U_I_plaidshirt_102",
"U_I_plaidshirt_103",
"U_I_plaidshirt_104",
"U_I_plaidshirt_105",
"U_I_tshirt_11",
"U_I_tshirt_12",
"U_I_tshirt_13",
"U_I_tshirt_14",
"U_I_tshirt_15",
"U_I_tshirt_21",
"U_I_tshirt_22",
"U_I_tshirt_23",
"U_I_tshirt_24",
"U_I_tshirt_25",
"U_I_tshirt_31",
"U_I_tshirt_32",
"U_I_tshirt_33",
"U_I_tshirt_34",
"U_I_tshirt_35",
"U_I_tshirt_41",
"U_I_tshirt_42",
"U_I_tshirt_43",
"U_I_tshirt_44",
"U_I_tshirt_45",
"U_I_tshirt_51",
"U_I_tshirt_52",
"U_I_tshirt_53",
"U_I_tshirt_54",
"U_I_tshirt_55",
"U_I_tshirt_61",
"U_I_tshirt_62",
"U_I_tshirt_63",
"U_I_tshirt_64",
"U_I_tshirt_65",
"U_I_tshirt_71",
"U_I_tshirt_72",
"U_I_tshirt_73",
"U_I_tshirt_74",
"U_I_tshirt_75",
"U_I_tshirt_81",
"U_I_tshirt_82",
"U_I_tshirt_83",
"U_I_tshirt_84",
"U_I_tshirt_85",
"U_I_tshirt_91",
"U_I_tshirt_92",
"U_I_tshirt_93",
"U_I_tshirt_94",
"U_I_tshirt_95",
"U_I_tshirt_101",
"U_I_tshirt_102",
"U_I_tshirt_103",
"U_I_tshirt_104",
"U_I_tshirt_105"

];

tpw_core_trousers = [];
	{
	if (isclass (configfile/"CfgWeapons"/_x)) then 
		{
		tpw_core_trousers pushback _x;
		};
	} foreach _trouserlist;

_shortlist = [
// A3
"U_C_Poloshirt_blue",
"U_C_Poloshirt_burgundy",
"U_C_Poloshirt_redwhite",
"U_C_Poloshirt_salmon",
"U_C_Poloshirt_stripped",
"U_C_Poloshirt_tricolour",
"u_c_man_casual_4_f",
"u_c_man_casual_5_f",
"u_c_man_casual_6_f",
"u_i_c_soldier_bandit_1_f",
"u_i_c_soldier_bandit_4_f",
"u_i_c_soldier_bandit_5_f",
"U_C_IDAP_Man_shorts_F",
"U_C_IDAP_Man_TeeShorts_F",
"U_C_Uniform_Scientist_02_F",

// DADPAT
"tg_u_dadpat_shorts_blue_hi",
"tg_u_dadpat_shorts_red_hi",
"tg_u_dadpat_shorts_grn_palm",
"tg_u_dadpat_shorts_prp_palm",
"tg_u_dadpat_shorts_tacky",
"tg_u_dadpat_shorts_floral",
"tg_u_dadpat_shorts_orng_plaid",
"tg_u_dadpat_shorts_blue_plaid",
"tg_u_dadpat_shorts_red_plaid",
"tg_u_dadpat_shorts_grn_plaid",

// Crasus
"CR_Postal_Dude_Shirt",
"cg_beats1",
"cg_burgerking1",
"cg_lego1",
"cg_mario1",
"cg_pepsi1",
"cg_ea1",
"cg_ferrari1",
"cg_fightclub1",
"cg_gameover1",
"cg_gamerepeat1",
"cg_homer1",
"cg_kfc1",
"cg_lambo1",
"cg_lsd1",
"cg_masterrace1",
"cg_pika1",
"cg_turtles1",
"cg_awesome1",
"cg_dad1",
"cg_deeznuts1",
"cg_evolution1",
"cg_hearts1",
"cg_loading1",
"cg_mayan1",
"cg_strippers1",
"CR_Hawaii_Shirt",

// SOF
"Shorts_uniform",
"Shorts_blue_uniform",
"Shorts_green_uniform",
"Shorts_grey_uniform",
"Shorts_tan_uniform",
"Shorts_red_uniform",
"Shortsb_blue_uniform",
"Shortsb_green_uniform",
"Shortsb_grey_uniform",
"Shortsb_tan_uniform",
"Shortsb_red_uniform",
"Shortsb_black_uniform",

// Tenues Civils
"skyzen_tenue_ete_nike_blanc",
"skyzen_tenue_ete_nike_noir",
"skyzen_tenue_ete_nike_jaune",
"skyzen_tenue_ete_nike_rouge",
"skyzen_tenue_ete_supreme_noir",
"skyzen_tenue_ete_supreme_blanc",
"skyzen_tenue_ete_adidas_blanc",
"skyzen_tenue_ete_adidas_noir",
"skyzen_tenue_ete_adidas_rouge",
"skyzen_tenue_ete_adidas_vert",
"skyzen_tenue_ete_summer",
"skyzen_tenue_ete_surf",
"skyzen_tenue_ete_hulk",
"skyzen_tenue_ete_jack_jones_marron",
"skyzen_tenue_ete_jack_jones_rouge",
"skyzen_tenue_ete_levis_noir",
"skyzen_tenue_ete_levis_blanc",
"skyzen_tenue_ete_levis_gris",
"skyzen_tenue_ete_blanche",
"skyzen_tenue_ete_blanche_rouge",
"skyzen_tenue_ete_blanche_bleu",
"skyzen_tenue_ete_bleu",
"skyzen_tenue_ete_jaune",
"skyzen_tenue_ete_noir",
"skyzen_tenue_ete_orange",
"skyzen_tenue_ete_rose",
"skyzen_tenue_ete_rouge",
"skyzen_tenue_ete_vert",
"skyzen_tenue_ete_marron"

];
tpw_core_shorts = [];
	{
	if (isclass (configfile/"CfgWeapons"/_x)) then 
		{
		tpw_core_shorts pushback _x;
		};
	} foreach _shortlist;

_hatlist = 
["H_Cap_red",
"H_Cap_blu",
"H_Cap_oli",
"H_Cap_tan",
"H_Cap_blk",
"H_Cap_blk_CMMG",
"H_Cap_brn_SPECOPS",
"H_Cap_tan_specops_US",
"H_Cap_khaki_specops_UK",
"H_Cap_grn",
"H_Cap_grn_BI",
"H_Cap_blk_Raven",
"H_Cap_blk_ION",
"H_Cap_oli_hs",
"H_Cap_press",
"H_Cap_usblack",
"H_Cap_surfer",
"H_Cap_police",
"H_Cap_oli_Syndikat_F",
"H_Cap_tan_Syndikat_F",
"H_Cap_blk_Syndikat_F",
"H_Cap_grn_Syndikat_F",
"H_Cap_White_IDAP_F",
"H_Cap_Orange_IDAP_F",
"H_Cap_Black_IDAP_F",
"VSM_BackwardsHat_Peltor_OD",
"VSM_BackwardsHat_Peltor_black",
"VSM_BackwardsHat_Peltor_cmmg",
"VSM_BackwardsHat_Peltor_us",
"VSM_BackwardsHat_Peltor_ion",
"VSM_Beanie_OD",
"VSM_Beanie_black",
"VSM_Beanie_tan",
"rhs_beanie",
"rhs_beanie_green",
"h_krzy_beanie_orange",
"h_krzy_cap_orange",
"h_krzy_hat_livonia",
"h_krzy_hat_safari_brown",
"TPW_CAP_01_ABSTRACT",
"TPW_CAP_01_AMCU",
"TPW_CAP_01_ARID",
"TPW_CAP_01_ATACS",
"TPW_CAP_01_DARK",
"TPW_CAP_01_DIGI",
"TPW_CAP_01_GHOSTEX",
"TPW_CAP_01_MCAM",
"TPW_CAP_01_OCP",
"TPW_CAP_01_OD",
"TPW_CAP_01_PLA",
"TPW_CAP_01_TAN",
"TPW_CAP_01_WDL",	
"TPW_CAP_01_USWDL",	
"TPW_CAP_01_SURPAT",	
"TPW_CAP_01_BLUE",
"H_Watchcap_blk_hsless",
"H_Watchcap_blu_hsless",
"H_Watchcap_black_hsless",
"H_Watchcap_brown_hsless",
"H_Watchcap_green_hsless",
"H_Watchcap_red_hsless",
"H_Watchcap_blueblack_hsless",
"H_Watchcap_blackred_hsless",
"H_Watchcap_grey_hsless",
"H_Watchcap_greyblack_hsless",
"H_Watchcap_greyblue_hsless",
"H_Watchcap_greyred_hsless",
"H_Watchcap_blue2_hsless",
"H_Watchcap_yellow_hsless",
"H_Watchcap_drkgrey_hsless",
"H_Watchcap_blackyellow_hsless",
"H_Watchcap_wdlkhk_hsless",
"H_Watchcap_wdl_hsless",
"H_Watchcap_aaf_hsless",
"skyzen_beanie_noir",
"skyzen_beanie_blanc",
"skyzen_beanie_marron",
"skyzen_beanie_vert",
"skyzen_beanie_rouge",
"skyzen_cap_supreme_blanche",
"skyzen_cap_supreme_noir",
"skyzen_cap_nike_blanche",
"skyzen_cap_nike_noir",
"skyzen_cap_nike_jaune",
"skyzen_cap_adidas_jaune",
"skyzen_cap_adidas_noir",
"skyzen_cap_adidas_blanche",
"skyzen_cap_adidas_rouge",
"skyzen_cap_adidas_bleu",
"skyzen_cap_lacoste_blanche",
"skyzen_cap_fila_blanche",
"skyzen_cap_fila_bleu",
"skyzen_cap_noir",
"skyzen_cap_blanche",
"skyzen_cap_orange",
"skyzen_cap_rose"
	
];
tpw_core_hats = [];
	{
	if (isclass (configfile/"CfgWeapons"/_x)) then 
		{
		tpw_core_hats pushback _x;
		};
	} foreach _hatlist;


_speclist = [
"G_Spectacles",
"G_Spectacles_Tinted",
"G_Shades_Black",
"G_Shades_Green",
"G_Shades_Red",
"G_Squares",
"G_Squares_Tinted",
"G_Sport_BlackWhite",
"G_Sport_Blackyellow",
"G_Sport_Greenblack",
"G_Sport_Checkered",
"G_Sport_Red",
"G_Aviator",
"G_Lady_Mirror",
"G_Lady_Dark",
"G_Lady_Red",
"G_Lady_Blue"
];
tpw_core_specs = [];
	{
	if (isclass (configfile/"CfgGlasses"/_x)) then 
		{
		tpw_core_specs pushback _x;
		};
	} foreach _speclist;

// Screen out uniforms based on exclusion strings
for "_i" from 0 to (count tpw_core_trousers - 1) do	
	{	
	_item = tpw_core_trousers select _i;
		{
		if ([_x,str _item] call BIS_fnc_inString) then
			{
			tpw_core_trousers set [_i, -1];
			};
		} foreach tpw_core_blacklist;
	};
tpw_core_trousers = tpw_core_trousers - [-1];

for "_i" from 0 to (count tpw_core_shorts - 1) do	
	{	
	_item = tpw_core_shorts select _i;
		{
		if ([_x,str _item] call BIS_fnc_inString) then
			{
			tpw_core_shorts set [_i, -1];
			};
		} foreach tpw_core_blacklist;
	};
tpw_core_shorts = tpw_core_shorts - [-1];

for "_i" from 0 to (count tpw_core_hats - 1) do	
	{	
	_item = tpw_core_hats select _i;
		{
		if ([_x,str _item] call BIS_fnc_inString) then
			{
			tpw_core_hats set [_i, -1];
			};
		} foreach tpw_core_blacklist;
	};
tpw_core_hats = tpw_core_hats - [-1];

tpw_core_fnc_clothes =
	{
	private ["_clothes"];
	
	// Appropriate clothing for climate
	if (!isnil "tpw_fog_temp" &&  {tpw_fog_temp < 12 } && {!(tolower worldname in tpw_core_mideast)}) then
		{
		_coldhatlist = 
		[
		"VSM_Beanie_OD",
		"VSM_Beanie_black",
		"VSM_Beanie_tan",
		"rhs_beanie",
		"rhs_beanie_green",
		"h_krzy_beanie_orange",
		"h_krzy_cap_orange",
		"h_krzy_hat_livonia",
		"h_krzy_hat_safari_brown",
		"H_Watchcap_blk_hsless",
		"H_Watchcap_blu_hsless",
		"H_Watchcap_black_hsless",
		"H_Watchcap_brown_hsless",
		"H_Watchcap_green_hsless",
		"H_Watchcap_red_hsless",
		"H_Watchcap_blueblack_hsless",
		"H_Watchcap_blackred_hsless",
		"H_Watchcap_grey_hsless",
		"H_Watchcap_greyblack_hsless",
		"H_Watchcap_greyblue_hsless",
		"H_Watchcap_greyred_hsless",
		"H_Watchcap_blue2_hsless",
		"H_Watchcap_yellow_hsless",
		"H_Watchcap_drkgrey_hsless",
		"H_Watchcap_blackyellow_hsless",
		"H_Watchcap_wdlkhk_hsless",
		"H_Watchcap_wdl_hsless",
		"H_Watchcap_aaf_hsless",
		"USP_THM_BEANIE",
		"USP_THM_BEANIE_TAN",
		"USP_THM_BEANIE_RGR",
		"TRYK_H_WOOLHAT"	
		];		
		
		_coldtrouserlist = [
		"U_C_HunterBody_grn",
		"U_IG_Guerilla3_1",
		"U_IG_Guerilla3_2",
		"U_B_GEN_Commander_F",
		"U_I_L_Uniform_01_camo_F",
		"U_C_E_LooterJacket_01_F",
		"U_O_R_Gorka_01_black_F",

		"gm_gc_civ_uniform_man_01_80_blk",
		"gm_gc_civ_uniform_man_01_80_blu",
		"gm_gc_civ_uniform_man_01_80_brn",
		"gm_gc_civ_uniform_man_02_80_brn",
		"gm_gc_civ_uniform_man_04_80_blu",
		"gm_gc_civ_uniform_man_04_80_gry",

		"eou_gorka_5",
		"eou_gorka_7",
		"eou_gorka_3",
		"eou_gorka_6",
		"eou_gorka_24",
		"eou_gorka_22",
		"eou_gorka_34",
		"eou_gorka_28",
		"eou_gorka_9",
		"eou_gorka_12",
		"eou_gorka_17",
		"eou_gorka_2",
		"eou_gorka_18",
		"eou_gorka_10",
		"eou_gorka_11",
		"eou_gorka_13",
		"eou_gorka_14",
		"eou_gorka_15",

		"AL_dirtyblue_jacket_supreblack_jumper_black_jeans_timbs",
		"AL_dirtyblue_jacket_supreblue_jumper_black_jeans_timbs",
		"AL_dirtyblue_jacket_supregrey_jumper_black_jeans_timbs",
		"AL_dirtyblue_jacket_suprepurple_jumper_black_jeans_timbs",
		"AL_dirtyblue_jacket_thrasher_jumper_black_jeans_timbs",
		"AL_dark_jacket_supreblack_jumper_blue_jeans_timbs",
		"AL_dark_jacket_supreblue_jumper_blue_jeans_timbs",
		"AL_dark_jacket_supregrey_jumper_blue_jeans_timbs",
		"AL_dark_jacket_suprepurple_jumper_blue_jeans_timbs",
		"AL_dark_jacket_thrasher_jumper_blue_jeans_timbs",
		"AL_dark_jacket_supreblack_jumper_grey_jeans_timbs",
		"AL_dirtyblue_jacket_supreblack_jumper_grey_jeans_timbs",
		"AL_dark_jacket_supreblue_jumper_grey_jeans_timbs",
		"AL_dirtyblue_jacket_supreblue_jumper_grey_jeans_timbs",
		"AL_dark_jacket_supregrey_jumper_grey_jeans_timbs",
		"AL_dirtyblue_jacket_supregrey_jumper_grey_jeans_timbs",
		"AL_dark_jacket_suprepurple_jumper_grey_jeans_timbs",
		"AL_dirtyblue_jacket_suprepurple_jumper_grey_jeans_timbs",
		"AL_dark_jacket_thrasher_jumper_grey_jeans_timbs",
		"AL_dirtyblue_jacket_thrasher_jumper_grey_jeans_timbs",

		"FIA_uniCitizen",
		"FIA_uniCitizen2",
		"FIA_uniCitizen3",
		"FIA_uniCitizen4",
		"FIA_uniForeman",
		"FIA_uniForeman2",
		"FIA_uniVillager",
		"FIA_uniVillager2",
		"FIA_uniWoodlander",
		"FIA_uniWoodlander2",
		"FIA_uniWoodlander3",
		"FIA_uniWoodlander4",

		"cpcu_uniform",
		"cpcu_grey_uniform",
		"cpcu_brown_uniform",
		"cpcut_grey_uniform",
		"cpcut_brown_uniform",
		"cpcut_uniform",
		"jpcu_uniform",
		"jpcu_grey_uniform",
		"jpcu_brown_uniform",
		"cargot_uniform",
		"cargot_black_uniform",
		"cargot_red_uniform",
		"cargot_green_uniform",
		"cargot_blue_uniform",
		"cargotb_white_uniform",
		"cargotb_black_uniform",
		"cargotb_red_uniform",
		"cargotb_greem_uniform",
		"cargotb_blue_uniform",
		"hoodie_uniform",
		"hoodie_brown_uniform",
		"hoodie_red_uniform",
		"hoodie_white_uniform",
		"INS1_uniform",
		"INS2_uniform",
		"INS2_black_uniform",
		"INS2_red_uniform",
		"INS2_green_uniform",
		"INS2_blue_uniform",
		"INS4_uniform",
		"INS4_black_uniform",
		"INS4_red_uniform",
		"INS4_green_uniform",
		"INS4_blue_uniform",
		"police_uniform",
		"Tracksuit_uniform",
		"Sweat_uniform",
		"sweat_green_uniform",
		"sweat_white_uniform",
		"sweat_red_uniform",

		"Project_BJC_Shirt_Cargo",
		"Project_BJC_Shirt_Cargo1",
		"Project_BJC_Shirt_Cargo2",
		"Project_BJC_Shirt_Cargo4",
		"Project_BJC_Shirt_Cargo5",
		"Project_BJC_Shirt_Cargo6",
		"Project_BJC_Shirt_Cargo8",
		"Project_BJC_Shirt_Cargo9",
		"Project_BJC_Shirt_Cargo10",
		"Project_BJC_Shirt_Cargo12",
		"Project_BJC_Shirt_Cargo13",
		"Project_BJC_Shirt_Cargo14",
		"Project_BJC_Shirt_Jean",
		"Project_BJC_Shirt_Jean1",
		"Project_BJC_Shirt_Jean2",
		"Project_BJC_Shirt_Jean3",
		"Project_BJC_PCU_Cargo",
		"Project_BJC_PCU_Cargo1",
		"Project_BJC_PCU_Cargo2",
		"Project_BJC_PCU_Cargo4",
		"Project_BJC_PCU_Cargo5",
		"Project_BJC_PCU_Cargo6",
		"Project_BJC_PCU_Cargo8",
		"Project_BJC_PCU_Cargo9",
		"Project_BJC_PCU_Cargo10",
		"Project_BJC_PCU_Cargo12",
		"Project_BJC_PCU_Cargo13",
		"Project_BJC_PCU_Cargo14",
		"Project_BJC_PCU_Cargo26", 
		"Project_BJC_PCU_Cargo27",
		"Project_BJC_PCU_Cargo28", 
		"Project_BJC_PCU_Jean",
		"Project_BJC_PCU_Jean1",
		"Project_BJC_PCU_Jean2",
		"Project_BJC_PCU_Jean3",
		"Project_BJC_PCU_Jean5",
		"Project_BJC_Shirt_Jean_blk",
		"Project_BJC_Shirt_Jean_blk1",
		"Project_BJC_Shirt_Jean_blk2",
		"Project_BJC_Shirt_Jean_blk3",
		"Project_BJC_PCU_Jean_blk",
		"Project_BJC_PCU_Jean_blk1",
		"Project_BJC_PCU_Jean_blk2",
		"Project_BJC_PCU_Jean_blk3",
		"Project_BJC_PCU_Jean_blk5",

		"TRYK_U_B_Denim_T_WH",
		"TRYK_U_B_Denim_T_BK",
		"TRYK_U_denim_jersey_blu",
		"TRYK_U_denim_jersey_blk",
		"PMC_Jeans_Shirt_BLU",
		"PMC_Jeans_Shirt_BLU_Dirty",
		"PMC_Jeans_Shirt_WHT",
		"PMC_Jeans_Shirt_WHT_Dirty",
		"PMC_Jeans_BLK_Shirt_BLU",
		"PMC_Jeans_BLK_Shirt_BLU_Dirty",
		"PMC_Jeans_BLK_Shirt_WHT",
		"PMC_Jeans_BLK_Shirt_WHT_Dirty",

		"TRYK_U_denim_jersey_blu",
		"TRYK_U_denim_jersey_blk"
		];
		tpw_core_trousers = [];
			{
			if (isclass (configfile/"CfgWeapons"/_x)) then 
				{
				tpw_core_trousers pushback _x;
				} 
			} foreach _coldtrouserlist;
		tpw_core_hats = [];
			{
			if (isclass (configfile/"CfgWeapons"/_x)) then 
				{
				tpw_core_hats pushback _x;
				};
			} foreach _coldhatlist;

		};
	
	if (!isnil "tpw_fog_temp" &&  {tpw_fog_temp > 25 } && {!(tolower worldname in tpw_core_mideast)}) then
		{
		_clothes = tpw_core_trousers + tpw_core_shorts + tpw_core_shorts  + tpw_core_shorts + tpw_core_shorts  + tpw_core_shorts + tpw_core_shorts;
		} else
		{
		_clothes = tpw_core_trousers;
		};	
	_clothes
	};


// GRAB CIVS FROM CONFIG
tpw_core_fnc_grabciv =
	{
	private ["_cfg","_str"];
	tpw_core_civs = [];
	_cfg = (configFile >> "CfgVehicles");
	_str = _this select 0;
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "camanbase") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString}) then 
				{
				tpw_core_civs set [count tpw_core_civs,_cfgname];
				};
			};
		};		

		
	// Use default BIS civs if custom string can't be found
	if (count tpw_core_civs < 2)then 
		{
		_str = "c_man";
		for "_i" from 0 to ((count _cfg) -1) do 
			{
			if (isClass ((_cfg select _i) ) ) then 
				{
				_cfgName = configName (_cfg select _i);
				if ( (_cfgName isKindOf "camanbase") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString}) then 
					{
					tpw_core_civs set [count tpw_core_civs,_cfgname];
					};
				};
			};	
		};	
	_str
	};
	
// GRAB FEMALE CIVS FROM CONFIG
tpw_core_fnc_grabfemciv =
	{
	_women = [
	"Max_Woman1",
	"Max_Woman3",
	"Max_W_pol",
	"Max_Woman1",
	"Max_Woman3",
	"Max_W_pol",
	"Max_Woman1",
	"Max_Woman3",
	"Max_W_pol",
	//"Max_W_Army1",
	//"Max_W_Army2",
	"Max_W_guard",
	"Max_W_doctor",
	"wb_gen_soldier_f",
	"max_w_prisoner"
	/*,
	"fsog3_gen3_female_m81",
	"fsog3_gen3_female_multi",
	"fsog3_gen3_female_natow",
	"fsog3_gen3_female_ctrg"*/
	];
	
	if (!isnil "tpw_fog_temp" &&  {tpw_fog_temp < 12 } && {!(tolower worldname in tpw_core_mideast)}) then
		{
		_women = [
			"Max_Woman1",
			"Max_Woman1",
			"Max_Woman1",
			"Max_Woman3"];
		};
		{
		if (isclass (configfile/"CfgVehicles"/_x)) then
			{
			tpw_core_fem_civs set [count tpw_core_fem_civs,_x];
			};
		} foreach _women;
	};


// GRAB FEMALE TAK CIVS FROM CONFIG
tpw_core_fnc_grabfemtak =
	{
	_women = ["Max_Taky_woman1",
	"Max_Taky_woman2",
	"Max_Taky_woman5",
	"Max_Tak2_woman1",
	"Max_Tak2_woman2",
	"Max_Tak2_woman4",
	"Max_Tak_woman2",
	"Max_Tak_woman4",
	"Max_Tak_woman6"];		
		{
		if (isclass (configfile/"CfgVehicles"/_x)) then
			{
			tpw_core_fem_civs set [count tpw_core_fem_civs,_x];
			};
		} foreach _women;
	};	
	
// FEMALE FACES (Max Joiner and Timberwolf)
tpw_core_femfacelist = [
"max_facews1",
"max_facews2",
"max_facews3",
"max_facews7",
"max_facews8",
"max_facews9",
"max_facews10",
//"max_female1",
//"max_female4",
//"max_female6",
//"max_female7",
//"max_female8",
"max_female9",
"max_female10",
"max_female11",
"max_female15",
//"max_female16",
"max_face1",
//"max_face3",
"max_face4",
"facew36",
"facew37",
//"valentinafit",
"b_female_bun_01",
"b_female_bun_03"
];

tpw_core_blackfemfacelist = [
"max_facews4",
"max_facews5",
"max_facews6",
"max_female16",
"max_face2",
"max_face15",
"facew06",
"facew28",
"facew29",
"facew30",
"facew31",
"facew32",
"facew33",
"facew34",
"facew39"
];



tpw_core_femfaces = [];
	{
	if (isclass (configfile/"CfgFaces"/"Man_A3"/_x)) then 
		{
		tpw_core_femfaces pushback _x;
		};
	} foreach tpw_core_femfacelist;	
	
tpw_core_blackfemfaces = [];
	{
	if (isclass (configfile/"CfgFaces"/"Man_A3"/_x)) then 
		{
		tpw_core_blackfemfaces pushback _x;
		};
	} foreach tpw_core_blackfemfacelist;		

// REGION SPECIFIC CIVILIANS
tpw_core_fnc_civs =
	{
	private ["_civstring","_mideast","_african","_asian","_ethnicity","_ext"];
	private _civstrings = _this select 0;
	
	tpw_core_european = [	
		"bush_island_51",
		"carraigdubh",
		"chernarus",
		"chernarus_summer",
		"chernarusredux",
		"fdf_isle1_a",
		"mbg_celle2",
		"woodland_acr",
		"bootcamp_acr",
		"thirsk",
		"thirskw",
		"utes",
		"gsep_mosch",
		"gsep_zernovo",
		"bornholm",
		"anim_helvantis_v2",
		"wgl_palms",
		"colleville",
		"staszow",
		"baranow",
		"panovo",
		"ivachev",
		"xcam_taunus",
		"abramia",
		"napfwinter",
		"beketov",
		"chernarus_winter",
		"utes_winter",
		"thirskw",
		"arctic",
		"hellanmaa",
		"blud_vidda",
		"ruha",
		"sennoe",
		"chernarus_2035",
		"kapaulio",
		"vis",
		"atmt_trava",
		"wl_rosche",
		"tem_summa",
		"gm_weferlingen_summer",
		"gm_weferlingen_winter",
		"enoch",
		"tem_cham",
		"tem_chamw",
		"tem_suursaariv",
		"tem_chernarus",
		"tem_ihantala",
		"tem_vinjesvingenc",
		"esseker",
		"vt7",
		"cup_chernarus_a3",
		"jns_tria",
		"vkn_halsoy_terrain",
		"oski_corran",
		"rof_mok",
		"stozec",
		"oski_ire",
		"maksniemi",
		"elovyi",
		"zdanice",
		"wbg_limestone",
		"chernarusplus",
		"brf_sumava",
		"lubyanka",
		"swu_public_novogorsk_map",
		"jumo",
		"vtf_lybor",
		"spe_normandy"
		];

	tpw_core_greek = [
		"stratis",
		"altis",
		"imrali",
		"pja314",
		"malden",
		"bozcaada",
		"tembelan",
		"porquerolles",
		"hebontes",
		"pianosa_aut",
		"montellav3",
		"juju_orglandes",
		"rof_ammoulliani",
		"sehreno"
		];
	
	tpw_core_mideast = [
		"mcn_aliabad",
		"mcn_hazarkot",
		"bmfayshkhabur",
		"clafghan",
		"fallujah",
		"fata",
		"hellskitchen",
		"hellskitchens",
		"mcn_hazarkot",
		"praa_av",
		"reshmaan",
		"shapur_baf",
		"takistan",
		"torabora",
		"tup_qom",
		"zargabad",
		"pja307",
		"pja306",
		"pja308",
		"pja310",
		"mountains_acr",
		"tunba",
		"kunduz",
		"mog",
		"waziristan",
		"dya",
		"lythium",
		"pja319",
		"huntersvalley",
		"farkhar",
		"altiplano",
		"mog",
		"tem_anizay",
		"cup_kunduz",
		"khoramshahr",
		"afghanistan",
		"uzbin",
		"swu_public_salman_map",
		"cup_kunduz",
		"rut_mandol",
		"sefrouramal",
		"bastek",
		"bala_murghab",
		"northtakistan",
		"bala_murghab_summer",
		"bala_murghab_winter",
		"farabad",
		"albasrah",
		"swu_public_afghan_map",
		"juju_sahatra"
		];
	
	tpw_core_african = [
		"mak_jungle",
		"pja305",
		"tropica",
		"tigeria",
		"tigeria_se",
		"sara",
		"saralite",
		"sara_dbe1",
		"porto",
		"intro",
		"kidal",
		"isladuala3",
		"bsoc_brasil",
		"lingor3",
		"dingor",
		"seanglola",
		"sfp_wamako",
		"tem_kujari",
		"ctm_front",
		"bozoum",
		"edaly_map_alpha",
		"juju_kalahari",
		"shang_richat",
		"swu_public_rhode_map",
		"UMB_Colombia"
		];
		
	tpw_core_asian = [
		"pja312",
		"prei_khmaoch_luong",
		 "us101_cao_bang",
		 "dakrong",
		 "uns_dong_ha",
		 "rungsat",
		 "csj_sea",
		 "csj_lowlands",
		 "phu_bai",
		 "uns_ptv",
		 "rockwall",
		 "rhspkl",
		 "cam_lao_nam",
		 "vn_khe_sanh",
         "vn_the_bra"
		];
		
	tpw_core_oceania = [
		"tanoa",
		"pulau",
		"126map",
		"islapera"
	];	
	
	// Ethnicity based on worldname
	_ethnicity = "default"; // Default
	if (tolower worldname in tpw_core_european) then {_ethnicity = "european"};
	if (tolower worldname in tpw_core_greek) then {_ethnicity = "greek"};
	if (tolower worldname in tpw_core_mideast) then {_ethnicity = "mideast"};
	if (tolower worldname in tpw_core_african) then {_ethnicity = "african"};
	if (tolower worldname in tpw_core_asian) then {_ethnicity = "asian"};
	if (tolower worldname in tpw_core_oceania) then {_ethnicity = "oceania"};
	
	// Greeks (eg Altis/Stratis)
	if (_ethnicity == "greek") then 
		{
		_civstring = [_civstrings select 0] call tpw_core_fnc_grabciv;
	
		// Screen out non-Greeks from BIS civs
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if ((["unarmed",str _civ] call BIS_fnc_inString)  || (["euro",str _civ] call BIS_fnc_inString) || (["asia",str _civ] call BIS_fnc_inString)||(["afro",str _civ] call BIS_fnc_inString)||(["tanoa",str _civ] call BIS_fnc_inString)) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];
			};
		// Females
		[] call tpw_core_fnc_grabfemciv;	
		};	
	
	// Oceania (eg Tanoa)
	if (_ethnicity == "oceania") then 
		{
		_civstring = [_civstrings select 1] call tpw_core_fnc_grabciv;
	
		// Screen out non-Tanoans from BIS civs
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if !(["tanoa",str _civ] call BIS_fnc_inString) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];	
			};
		};	
	
	// Europeans (eg Chernarus)
	if (_ethnicity == "european") then 
		{
		_civstring = [_civstrings select 2] call tpw_core_fnc_grabciv;
	
		// Screen out non-Europeans from BIS civs
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if !(["euro",str _civ] call BIS_fnc_inString) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];		
			};

		// Females
		[] call tpw_core_fnc_grabfemciv;	
		};
		
	// Mid East (eg Takistan)
	if (_ethnicity == "mideast") then 
		{
		_civstring = [_civstrings select 3] call tpw_core_fnc_grabciv;
	
		// Use Persian soldiers as civs
		if (_civstring == "c_man") then
			{
			tpw_core_civs = ["o_soldier_f"];	
			};
		
		// Females
		[] call tpw_core_fnc_grabfemtak;		
			
		};

	// Africans (eg N'Ziwasogo)
	if (_ethnicity == "african") then 
		{
		_civstring = [_civstrings select 4] call tpw_core_fnc_grabciv;
	
		// Screen out non-Africans from BIS civs
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if !(["afro",str _civ] call BIS_fnc_inString) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];	
			};

		// Females
		[] call tpw_core_fnc_grabfemciv;	
			
		};
		
	// Asians (eg Prei Khmaoch Luong)
	if (_ethnicity == "asian") then 
		{
		_civstring = [_civstrings select 5] call tpw_core_fnc_grabciv;
	
		// Screen out non-Asians from BIS civs
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if !(["asia",str _civ] call BIS_fnc_inString) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];	
			};
		};	

	// Default - ethnic mix
	if (_ethnicity == "default") then 
		{
		_civstring = "c_man";
		_civstring = [_civstring] call tpw_core_fnc_grabciv;
	
		// Screen out unarmed combatants only
		if (_civstring == "c_man") then
			{
			for "_i" from 0 to (count tpw_core_civs - 1) do	
				{	
				_civ = tpw_core_civs select _i;
				if (["unarmed",str _civ] call BIS_fnc_inString) then
					{
					tpw_core_civs set [_i, -1];
					};
				};
			tpw_core_civs = tpw_core_civs - [-1];	
			};
		// Females
		[] call tpw_core_fnc_grabfemciv;	
		};	

	// No pilot, diver, VR civs	
	for "_i" from 0 to (count tpw_core_civs - 1) do	
		{	
		_unit = tpw_core_civs select _i;
		if ((["pilot",str _unit] call BIS_fnc_inString)||(["diver",str _unit] call BIS_fnc_inString)||(["vr",str _unit] call BIS_fnc_inString)) then
			{
			tpw_core_civs set [_i, -1];
			};
		};	
		
	// User blacklist
	for "_i" from 0 to (count tpw_core_civs - 1) do	
		{	
		_unit = tpw_core_civs select _i;
			{
			if ([_x,str _unit] call BIS_fnc_inString) then
				{
				tpw_core_civs set [_i, -1];
				};
			} foreach tpw_core_blacklist;
		};
	tpw_core_civs = tpw_core_civs - [-1];

		
	tpw_core_ethnicity = _ethnicity;	
	};	

// FUNCTION TO SPAWN RANDOM MALE AND FEMALE CIVS	
tpw_core_fnc_spawnciv = 
	{
	private ["_spawnpos","_sqname","_clothes","_civ","_civtype","_faces","_face"];
	_spawnpos = _this select 0;
	_sqname = creategroup [civilian,true];
	_clothes = [] call tpw_core_fnc_clothes;
	// Male
	if (random 1 < 0.75) then
		{
		_civtype = selectrandom tpw_core_civs;
		_civ = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"];
		} else
		{
		// Female
		if (count tpw_core_fem_civs > 0) then
			{
			_civtype = selectrandom tpw_core_fem_civs;
			_civ = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"];
			sleep 0.2;
			removevest _civ;
			removeheadgear _civ;
			removeallweapons _civ;
			removegoggles _civ;
			removeAllAssignedItems _civ;
			_face = selectrandom tpw_core_femfaces;
			if (tolower worldname in tpw_core_african) then
				{
				_face = selectrandom tpw_core_blackfemfaces;
				};
			_civ setface _face;
			} else
			{
			_civtype = selectrandom tpw_core_civs;
			_civ = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"];
			};
		if (!isnil "tpw_fog_temp" && {tpw_fog_temp < 12}) then 
			{
			_civ addheadgear (selectrandom tpw_core_hats);
			};	
		};
	 // Random uniform if using BIS male civs
	if (["c_man",str _civtype] call BIS_fnc_inString) then
		{
		_civ forceAddUniform (selectrandom _clothes);
		removeheadgear _civ;
		if (random 1 > 0.5 || (!isnil "tpw_fog_temp" && {tpw_fog_temp < 12})) then 
			{
			_civ addheadgear (selectrandom tpw_core_hats);
			};
		removegoggles _civ;	
		removevest _civ;
		removebackpack _civ;
		if (random 1 > 0.5) then
			{
			_civ addgoggles (selectrandom tpw_core_specs);
			};
		};	
		
	// Mid east civilians
	if (["o_soldier",str _civtype] call BIS_fnc_inString) then
		{
		// Redress soldiers as civs
		_civ forceAddUniform (selectrandom _clothes);
		removeheadgear _civ;
		_civ addheadgear (selectrandom tpw_core_hats);
		removebackpack _civ;
		removegoggles _civ;
		removevest _civ;	
		_civ unassignItem "NVGoggles_OPFOR";
		_civ removeItem "NVGoggles_OPFOR";
		removeallweapons _civ; 
		};		
	
	// No specs on mideast civs
	if (tolower worldname in tpw_core_mideast) then
		{
		removegoggles _civ;
		};
		
	// Increase variety of SOF	civs
	if ((count getobjecttextures _civ > 1) && {["panther_sof\data\jeans",(getobjecttextures _civ select 1)] call BIS_fnc_inString})then
		{
		_civ setobjecttexture [1, selectrandom ["panther_sof\data\jeans\jeans_h_gris_co.paa","panther_sof\data\jeans\jeans_h_bleu_co.paa","panther_sof\data\jeans\jeans_h_bluefonce_co.paa","panther_sof\data\jeans\jeans_h_gris_co.paa","panther_sof\data\jeans\jeans_h_noir_co.paa"]];
		};

	if ((count getobjecttextures _civ > 1) && {["panther_sof\data\cargo",(getobjecttextures _civ select 1)] call BIS_fnc_inString})then
		{
		_civ setobjecttexture [1, selectrandom ["panther_sof\data\cargo\cargopants_beige_co.paa","panther_sof\data\cargo\cargopants_black_co.paa""panther_sof\data\cargo\cargopants_blue_co.paa""panther_sof\data\cargo\cargopants_green_co.paa"]];
		};
	
	if ((count getobjecttextures _civ > 2) && {["panther_sof_opfor\data\sneakers",(getobjecttextures _civ select 2)] call BIS_fnc_inString})then
		{
		_civ setobjecttexture [2, selectrandom ["panther_sof_opfor\data\sneakers\sneakers_black_co.paa","panther_sof_opfor\data\sneakers\sneakers_tan_co.paa","panther_sof_opfor\data\sneakers\sneakers_gray_co.paa","panther_sof_opfor\data\sneakers\sneakers_white_co.paa"]];
		};	
	if ((count getobjecttextures _civ > 2) && {["panther_sof\data\hikingboots",(getobjecttextures _civ select 2)] call BIS_fnc_inString})then
		{
		_civ setobjecttexture [2, selectrandom ["panther_sof\data\hikingboots\hikingboots_low_beige_co.paa","panther_sof\data\hikingboots\hikingboots_low_blue_co.paa","panther_sof\data\hikingboots\hikingboots_low_red_co.paa"]];
		};	
		
	_civ	
	};	

// HABITABLE HOUSES
// Core and DLC buildings
tpw_core_habitable_houses = [ 
// Altis/Stratis
"Land_i_House_Small_01_V1_F",
"Land_i_House_Small_01_V2_F",
"Land_i_House_Small_01_V3_F",
"Land_i_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F",
"Land_i_House_Small_02_V3_F",
"Land_i_House_Small_03_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_i_House_Big_01_V2_F",
"Land_i_House_Big_01_V3_F",
"Land_i_House_Big_02_V1_F",
"Land_i_House_Big_02_V2_F",
"Land_i_House_Big_02_V3_F",
"Land_i_Shop_01_V1_F",
"Land_i_Shop_01_V2_F",
"Land_i_Shop_01_V3_F",
"Land_i_Shop_02_V1_F",
"Land_i_Shop_02_V2_F",
"Land_i_Shop_02_V3_F",
"Land_i_Addon_01_V1_F",
"Land_i_Addon_01_V2_F",
"Land_i_Addon_01_V3_F",
"Land_i_Addon_02_V1_F",
"Land_i_Addon_02_V2_F",
"Land_i_Addon_02_V3_F",
"Land_i_Addon_03_V1_F",
"Land_i_Addon_03_V2_F",
"Land_i_Addon_03_V3_F",

// Tanoa
"Land_house_small_01_F", 
"Land_house_small_02_F",
"Land_house_small_03_F",
"Land_house_small_04_F",
"Land_house_small_05_F",
"Land_house_small_06_F",
"Land_house_big_01_F",
"Land_house_big_02_F",
"Land_house_big_03_F",
"Land_house_big_04_F",
"Land_house_big_05_F",
"Land_slum_01_F",
"Land_slum_02_F",
"Land_slum_03_F",
"Land_slum_04_F",
"Land_slum_05_F",
"Land_slum_house_01_F",
"Land_slum_house_02_F",
"Land_slum_house_03_F",
"Land_slum_house_04_F",
"Land_slum_house_05_F",
"Land_house_native_01_F",
"Land_house_native_02_F",
"Land_hotel_01_F",
"Land_hotel_02_F",
"Land_shop_city_01_F",
"Land_shop_city_02_F",
"Land_shop_city_03_F",
"Land_shop_city_04_F",
"Land_shop_city_05_F",
"Land_shop_city_06_F",
"Land_shop_city_07_F",
"Land_shop_town_01_F",
"Land_shop_town_02_F",
"Land_shop_town_03_F",
"Land_shop_town_04_F",
"Land_shop_town_05_F",
"Land_Warehouse_01_F",
"Land_Warehouse_02_F",
"Land_Warehouse_03_F",
"Land_Temple_Native_01_F",
"Land_Temple_Native_02_F",
"Land_GarageShelter_01_F",
"Land_School_01_F",
"Land_FuelStation_02_workshop_F",
"Land_FuelStation_01_shop_F",
"Land_Multistoreybuilding_01_F",
"Land_Multistoreybuilding_03_F",
"Land_Multistoreybuilding_04_F",

// Malden
"Land_i_House_Small_01_b_blue_F",
"Land_i_House_Small_01_b_pink_F",
"Land_i_House_Small_01_b_yellow_F",
"Land_i_House_Small_01_b_brown_F",
"Land_i_House_Small_01_b_white_F",
"Land_i_House_Small_01_b_whiteblue_F",
"Land_i_House_Small_02_b_blue_F",
"Land_i_House_Small_02_b_pink_F",
"Land_i_House_Small_02_b_yellow_F",
"Land_i_House_Small_02_b_brown_F",
"Land_i_House_Small_02_b_white_F",
"Land_i_House_Small_02_b_whiteblue_F",
"Land_i_House_Small_02_c_blue_F",
"Land_i_House_Small_02_c_pink_F",
"Land_i_House_Small_02_c_yellow_F",
"Land_i_House_Small_02_c_brown_F",
"Land_i_House_Small_02_c_white_F",
"Land_i_House_Small_02_c_whiteblue_F",
"Land_i_House_Big_01_b_blue_F",
"Land_i_House_Big_01_b_pink_F",
"Land_i_House_Big_01_b_yellow_F",
"Land_i_House_Big_01_b_brown_F",
"Land_i_House_Big_01_b_white_F",
"Land_i_House_Big_01_b_whiteblue_F",
"Land_i_House_Big_02_b_blue_F",
"Land_i_House_Big_02_b_pink_F",
"Land_i_House_Big_02_b_yellow_F",
"Land_i_House_Big_02_b_brown_F",
"Land_i_House_Big_02_b_white_F",
"Land_i_House_Big_02_b_whiteblue_F",
"Land_i_Shop_01_b_blue_F",
"Land_i_Shop_01_b_pink_F",
"Land_i_Shop_01_b_yellow_F",
"Land_i_Shop_01_b_brown_F",
"Land_i_Shop_01_b_white_F",
"Land_i_Shop_01_b_whiteblue_F",
"Land_i_Shop_02_b_blue_F",
"Land_i_Shop_02_b_pink_F",
"Land_i_Shop_02_b_yellow_F",
"Land_i_Shop_02_b_brown_F",
"Land_i_Shop_02_b_white_F",
"Land_i_Shop_02_b_whiteblue_F",

// Weferlingen
"land_gm_euro_barracks_01",
"land_gm_euro_barracks_02",
"land_gm_euro_factory_01_01",
"land_gm_euro_factory_01_02",
"land_gm_euro_factory_02",
"land_gm_euro_house_01_e",
"land_gm_euro_house_01_w",
"land_gm_euro_house_01_d",
"land_gm_euro_house_02_e",
"land_gm_euro_house_02_w",
"land_gm_euro_house_02_d",
"land_gm_euro_house_03_e",
"land_gm_euro_house_03_w",
"land_gm_euro_house_04_e",
"land_gm_euro_house_04_w",
"land_gm_euro_house_04_d",
"land_gm_euro_house_05_e",
"land_gm_euro_house_05_w",
"land_gm_euro_house_05_d",
"land_gm_euro_house_06_e",
"land_gm_euro_house_06_w",
"land_gm_euro_house_06_d",
"land_gm_euro_house_07_e",
"land_gm_euro_house_07_w",
"land_gm_euro_house_07_d",
"land_gm_euro_house_08_e",
"land_gm_euro_house_08_w",
"land_gm_euro_house_08_d",
"land_gm_euro_house_09_e",
"land_gm_euro_house_09_w",
"land_gm_euro_house_09_d",
"land_gm_euro_house_10_e",
"land_gm_euro_house_10_w",
"land_gm_euro_house_10_d",
"land_gm_euro_house_11_e",
"land_gm_euro_house_11_w",
"land_gm_euro_house_11_d",
"land_gm_euro_house_12_e",
"land_gm_euro_house_12_w",
"land_gm_euro_house_12_d",
"land_gm_euro_house_13_e",
"land_gm_euro_house_13_w",
"land_gm_euro_house_13_d",
"land_gm_euro_office_01",
"land_gm_euro_office_02",
"land_gm_euro_office_03",
"land_gm_euro_pub_01",
"land_gm_euro_pub_02",
"land_gm_euro_fuelstation_01_w",
"land_gm_euro_fuelstation_02",
"land_gm_euro_shed_01",
"land_gm_euro_shed_02",
"land_gm_euro_shed_03",
"land_gm_euro_shed_04",
"land_gm_euro_shed_05",
"land_gm_euro_shop_01_w",
"land_gm_euro_shop_02_e",
"land_gm_euro_shop_02_w",
"land_gm_euro_church_01",
"land_gm_euro_church_02",
"land_gm_euro_farmhouse_01",
"land_gm_euro_farmhouse_02",
"land_gm_euro_farmhouse_03",
"land_gm_euro_barracks_01_win",
"land_gm_euro_barracks_02_win",
"land_gm_euro_factory_01_01_win",
"land_gm_euro_factory_01_02_win",
"land_gm_euro_factory_02_win",
"land_gm_euro_house_01_e_win",
"land_gm_euro_house_01_w_win",
"land_gm_euro_house_01_d_win",
"land_gm_euro_house_02_e_win",
"land_gm_euro_house_02_w_win",
"land_gm_euro_house_02_d_win",
"land_gm_euro_house_03_e_win",
"land_gm_euro_house_03_w_win",
"land_gm_euro_house_04_e_win",
"land_gm_euro_house_04_w_win",
"land_gm_euro_house_04_d_win",
"land_gm_euro_house_05_e_win",
"land_gm_euro_house_05_w_win",
"land_gm_euro_house_05_d_win",
"land_gm_euro_house_06_e_win",
"land_gm_euro_house_06_w_win",
"land_gm_euro_house_06_d_win",
"land_gm_euro_house_07_e_win",
"land_gm_euro_house_07_w_win",
"land_gm_euro_house_07_d_win",
"land_gm_euro_house_08_e_win",
"land_gm_euro_house_08_w_win",
"land_gm_euro_house_08_d_win",
"land_gm_euro_house_09_e_win",
"land_gm_euro_house_09_w_win",
"land_gm_euro_house_09_d_win",
"land_gm_euro_house_10_e_win",
"land_gm_euro_house_10_w_win",
"land_gm_euro_house_10_d_win",
"land_gm_euro_house_11_e_win",
"land_gm_euro_house_11_w_win",
"land_gm_euro_house_11_d_win",
"land_gm_euro_house_12_e_win",
"land_gm_euro_house_12_w_win",
"land_gm_euro_house_12_d_win",
"land_gm_euro_house_13_e_win",
"land_gm_euro_house_13_w_win",
"land_gm_euro_house_13_d_win",
"land_gm_euro_office_01_win",
"land_gm_euro_office_02_win",
"land_gm_euro_office_03_win",
"land_gm_euro_pub_01_win",
"land_gm_euro_pub_02_win",
"land_gm_euro_fuelstation_01_w_win",
"land_gm_euro_fuelstation_02_win",
"land_gm_euro_shed_01_win",
"land_gm_euro_shed_02_win",
"land_gm_euro_shed_03_win",
"land_gm_euro_shed_05_win",
"land_gm_euro_shed_04_win",
"land_gm_euro_shop_01_w_win",
"land_gm_euro_shop_02_e_win",
"land_gm_euro_shop_02_w_win",
"land_gm_euro_church_01_win",
"land_gm_euro_church_02_win",
"land_gm_euro_mine_01_win",
"land_gm_euro_farmhouse_01_win",
"land_gm_euro_farmhouse_02_win",
"land_gm_euro_farmhouse_03_win",
"land_gm_euro_misc_kiosk_01_win",
"land_gm_euro_misc_garage_01_01_win",
"land_gm_euro_misc_garage_01_02_win",
"land_gm_euro_misc_garage_02_win",

// Livonia
"Land_House_1B01_F",
"Land_House_1W01_F",
"Land_House_1W02_F",
"Land_House_1W03_F",
"Land_House_1W04_F",
"Land_House_1W05_F",
"Land_House_1W06_F",
"Land_House_1W07_F",
"Land_House_1W08_F",
"Land_House_1W09_F",
"Land_House_1W10_F",
"Land_House_1W11_F",
"Land_House_1W12_F",
"Land_House_2B01_F",
"Land_House_2B02_F",
"Land_House_2B03_F",
"Land_House_2B04_F",
"Land_House_2W01_F",
"Land_House_2W02_F",
"Land_House_2W03_F",
"Land_House_2W04_F",
"Land_House_2W05_F",
"Land_workshop_01_f",
"Land_workshop_02_f",
"Land_workshop_03_f",
"Land_barn_01_f",
"Land_barn_02_f",
"Land_barn_03_f",	
"Land_barn_01_large_f",
"Land_barn_02_large_f",
"Land_barn_03_large_f",
"Land_Camp_House_01_brown_F",
"Land_VillageStore_01_f",
"Land_policestation_01_f",
"Land_caravan_01_rust_f",

// OA classes - thanks Spliffz
"Land_House_L_1_EP1", 
"Land_House_L_3_EP1",
"Land_House_L_4_EP1",
"Land_House_L_6_EP1",
"Land_House_L_7_EP1",
"Land_House_L_8_EP1",
"Land_House_L_9_EP1",
"Land_House_K_1_EP1",
"Land_House_K_3_EP1", 
"Land_House_K_5_EP1", 
"Land_House_K_6_EP1", 
"Land_House_K_7_EP1", 
"Land_House_K_8_EP1", 
"Land_Terrace_K_1_EP1",
"Land_House_C_1_EP1",
"Land_House_C_1_v2_EP1", 
"Land_House_C_2_EP1", 
"Land_House_C_3_EP1",
"Land_House_C_4_EP1", 
"Land_House_C_5_EP1", 
"Land_House_C_5_V1_EP1", 
"Land_House_C_5_V2_EP1", 
"Land_House_C_5_V3_EP1", 
"Land_House_C_9_EP1", 
"Land_House_C_10_EP1", 
"Land_House_C_11_EP1", 
"Land_House_C_12_EP1", 
"Land_A_Villa_EP1",
"Land_A_Mosque_small_1_EP1",
"Land_A_Mosque_small_2_EP1",

//"Land_Ind_FuelStation_Feed_EP1",
"Land_Ind_FuelStation_Build_EP1",
"Land_Ind_FuelStation_Shed_EP1",
"Land_Ind_Garage01_EP1",
"Land_A_Mosque_big_minaret_1_EP1",
"Land_A_Mosque_big_hq_EP1",

// A2 classes - thanks Reserve
"Land_HouseV_1I1",  
"Land_HouseV_1I2",
"Land_HouseV_1I3",
"Land_HouseV_1I4",
"Land_HouseV_1L1",
"Land_HouseV_1L2",
"Land_HouseV_1T",
"Land_HouseV_2I",
"Land_HouseV_2L",
"Land_HouseV_2T1",
"Land_HouseV_2T2",
"Land_HouseV_3I1",
"Land_HouseV_3I2",
"Land_HouseV_3I3",
"Land_HouseV_3I4",
"Land_HouseV2_01A",
"Land_HouseV2_01B",
"Land_HouseV2_02",
"Land_HouseV2_03",
"Land_HouseV2_03B",
"Land_HouseV2_04",
"Land_HouseV2_05",
"Land_HouseBlock_A1",
"Land_HouseBlock_A2",
"Land_HouseBlock_A3",
"Land_HouseBlock_B1",
"Land_HouseBlock_B2",
"Land_HouseBlock_B3",
"Land_HouseBlock_C2",
"Land_HouseBlock_C3",
"Land_HouseBlock_C4",
"Land_HouseBlock_C5",
"Land_Church_02",
"Land_Church_02A",
"Land_Church_03",
"Land_A_FuelStation_Build",
"Land_A_FuelStation_Shed",

// Fallujah
"Land_dum_istan2",
"Land_dum_istan2b",
"Land_dum_istan2_01",
"Land_dum_istan2_02",
"Land_dum_istan2_03",
"Land_dum_istan2_03a",
"Land_dum_istan2_04a",
"Land_dum_istan3",
"Land_dum_istan3_hromada",
"Land_dum_istan4",
"Land_dum_istan4_big",
"Land_dum_istan4_big_inverse",
"Land_dum_istan4_detaily1",
"Land_dum_istan4_inverse",
"Land_dum_mesto3_istan",
"Land_hotel",
"Land_stanek_1",
"Land_stanek_1b",
"Land_stanek_1c",
"Land_stanek_2",
"Land_stanek_2b",
"Land_stanek_2c",
"Land_stanek_3",
"Land_stanek_3b",
"Land_stanek_3c",

// JBAD buildings
"Land_jbad_house1", 
"Land_jbad_house3",
"Land_jbad_house5",
"Land_jbad_house6",
"Land_jbad_house7",
"Land_jbad_house8",
"Land_jbad_house1",
"Land_jbad_House_c_1_v2",
"Land_jbad_House_c_2",
"Land_jbad_House_c_3",
"Land_jbad_House_c_4",
"Land_jbad_House_c_5",
"Land_jbad_House_c_9",
"Land_jbad_House_c_10",
"Land_jbad_House_c_11",
"Land_jbad_House_c_12",
"Land_Jbad_Ind_FuelStation_Build",
"Land_jbad_A_GeneralStore_01",
"Land_jbad_A_GeneralStore_01a",
"Land_Jbad_A_Mosque_small_1",
"Land_Jbad_A_Mosque_small_2",
"Land_Jbad_A_Stationhouse",
"Land_Jbad_A_Villa",
"Land_Jbad_Ind_Garage01",
"Land_jbad_House_1_old",
"Land_jbad_House_3_old",
"Land_jbad_House_4_old",
"Land_jbad_House_6_old",
"Land_jbad_House_7_old",
"Land_jbad_House_8_old",
"Land_jbad_House_9_old",
"Land_jbad_House_8_old",
"Land_jbad_House_7_old",
"Land_jbad_House_4_old",
"Land_jbad_House3",
"Land_jbad_House7",
"Land_jbad_House5",
"Land_jbad_shop_01",
"Land_jbad_House6",
"Land_jbad_House_1",
"Land_jbad_House_3_old_h",
"Land_jbad_House_6_old",
"Land_jbad_House_1_old",
"Land_Jbad_opx2_hut2",
"Land_jbad_opx2_h1",
"Land_jbad_House_c_11",
"Land_jbad_House_c_5",
"Land_Jbad_opx2_hut4",
"Land_Jbad_opx2_hut1",
"Land_Jbad_opx2_hut3",
"Land_jbad_market_stalls_02",
"Land_jbad_opx2_garages",
"Land_jbad_House_c_1",
"Land_jbad_House_c_1_v2",
"Land_jbad_opx2_cornershop1",
"Land_jbad_opx2_construct1",
"Land_jbad_opx2_store1",
"Land_jbad_opx2_complex9",
"Land_jbad_mosque_big_addon",
"Land_jbad_opx2_big_f",
"Land_jbad_opx2_construct4",
"Land_jbad_opx2_big_d",
"Land_jbad_opx2_big_c",
"Land_jbad_House_c_9",
"Land_jbad_market_stalls_01",
"Land_jbad_opx2_big_e",
"Land_jbad_House_c_10",
"Land_jbad_opx2_corner2",
"Land_jbad_opx2_apartmentcomplex5",
"Land_jbad_opx2_complex3",
"Land_jbad_opx2_apartmentcomplex4",
"Land_Shop_City_07_F",
"Land_jbad_opx2_big_b",
"Land_Shop_City_03_F",
"Land_jbad_opx2_complex4",
"Land_jbad_opx2_corner1",
"Land_jbad_opx2_complex1",
"Land_jbad_grainstore3",
"Land_jbad_opx2_big",
"Land_jbad_opx2_stores2",
"Land_jbad_opx2_construct2",
"Land_Jbad_opx2_hut_invert1",
"Land_jbad_opx2_tower1",
"Land_Jbad_A_Villa",
"Land_jbad_opx2_construct3",
"Land_Jbad_Ind_Garage01",
"Land_jbad_Ind_TankSmall2",
"Land_jbad_opx2_apartmentcomplex_wip",
"Land_jbad_opx2_complex7",
"Land_jbad_opx2_block1",
"Land_jbad_opx2_complex5",
"Land_jbad_House_9_old",
"Land_jbad_opx2_apartmentcomplex",
"Land_jbad_mosque_big_minaret_1",
"Land_jbad_opx2_complex6",
"Land_jbad_opx2_complex8",
"Land_jbad_opx2_complex2",
"Land_Jbad_Ind_sawmillpen",
"Land_Jbad_Ind_PowerStation",
"Land_jbad_opx2_policestation",
"Land_jbad_mosque_big_wall_gate",
"Land_jbad_mosque_big_minaret_2",
"Land_jbad_mosque_big_wall_corner",
"Land_jbad_mosque_big_wall",
"Land_jbad_mosque_big_hq",
"Land_jbad_House_c_3",
"Land_jbad_House_c_2",
"Land_House_Big_04_F",
"Land_jbad_House_c_4",
"Land_jbad_dum_istan2",
"Land_Jbad_Ind_Workshop01_03",
"Land_Jbad_Ind_Workshop01_02",
"Land_Jbad_Ind_Workshop01_01",
"Land_jbad_A_GeneralStore_01",
"Land_jbad_opx2_garage1",
"Land_jbad_House8",
"Land_jbad_grainstore2",
"Land_jbad_grainstore",
"Land_jbad_shop_04",
"Land_jbad_shop_03",
"Land_jbad_shop_02",
"Land_Jbad_A_Minaret",
"Land_Jbad_A_Mosque_small_2",
"Land_Jbad_Ind_Shed_01",

// Lythium
"land_ffaa_casa_urbana_1",
"land_ffaa_casa_urbana_2",
"land_ffaa_casa_urbana_3",
"land_ffaa_casa_urbana_4",
"land_ffaa_casa_urbana_5",
"land_ffaa_casa_urbana_6",
"land_ffaa_casa_urbana_7",
"land_ffaa_casa_urbana_7A",
"land_ffaa_casa_urbana_8",
"land_ffaa_casa_af_1",
"land_ffaa_casa_af_2",
"land_ffaa_casa_af_3",
"land_ffaa_casa_af_3A",
"land_ffaa_casa_af_4",
"land_ffaa_casa_af_4A",
"land_ffaa_casa_af_5",
"land_ffaa_casa_af_6",
"land_ffaa_casa_af_7",
"land_ffaa_casa_af_8",
"land_ffaa_casa_af_9",
"land_ffaa_casa_af_10",
"land_ffaa_casa_af_10A",
"land_ffaa_casa_sha_1",
"land_ffaa_casa_sha_2",
"land_ffaa_casa_sha_3",
"land_ffaa_casa_barrancon_1",
"land_ffaa_casa_barracon_2",
"land_ffaa_casa_caseta_peq",
"land_ffaa_casa_acc_1",

// Prei Khmoach Luong
"land_blud_hut1",
"land_blud_hut2",
"land_blud_hut3",
"land_blud_hut4",
"land_blud_hut5",
"land_blud_hut6",
"land_blud_hut7",
"land_blud_hut8",
"land_rhspkl_hut_07",
"land_rhspkl_hut_06",
"land_rhspkl_hut_01",
"land_rhspkl_hut_04",
"land_rhspkl_hut_05",
"land_rhspkl_hut_02",
"land_rhspkl_hut_08",
"land_rhspkl_hut_03",

// Chernarus redux
"land_housev_1l1",
"land_housev_1l2",
"land_housev_1t",
"land_housev_2i",
"land_housev_2l",
"land_housev_2t1",
"land_housev_2t2",
"land_housev_3i1",
"land_housev_3i2",
"land_housev_3i3",
"land_housev_3i4",
"land_housev_01a",
"land_housev_01b",

// Unsung - Thanks ReznikDeznik
"LAND_uns_hut2",
"LAND_uns_hut1",
"LAND_uns_hutraised1",
"LAND_uns_hutraised2",
"LAND_uns_villstorage_shelter",
"LAND_uns_villshelter1",
"LAND_uns_villshelter2",
"LAND_CSJ_Yard5",
"LAND_CSJ_Yard3",
"LAND_CSJ_Yard2",
"LAND_CSJ_Yard1",
"LAND_CSJ_Yard4",
"csj_shelter01",
"LAND_CSJ_hut06",
"LAND_CSJ_hut05",
"LAND_CSJ_hut07",
"LAND_CSJ_hut01",
"LAND_CSJ_hut02",
"LAND_uns_hut08",
"Land_MBG_Hut_B",
"Land_MBG_Hut_C",
"Land_MBG_Hut_A",
"LAND_CSJ_village6",
"LAND_CSJ_village5",
"LAND_CSJ_village8",
"LAND_CSJ_riverhut4",
"LAND_CSJ_riverhut3",
"LAND_CSJ_village7",
"LAND_CSJ_village4",
"LAND_CSJ_village1",
"LAND_CSJ_village2",
"LAND_CSJ_village3",
"LAND_CSJ_riverhut1",
"LAND_CSJ_riverhut2",
"LAND_csj_bar",
"LAND_uns_shopOld_01",
"LAND_uns_shopOld_02",
"LAND_uns_shopOld_03",
"LAND_uns_shopOld_04",
"LAND_uns_shopOld_05",
"LAND_uns_shopOld_06",
"LAND_uns_shopOld_07",
"Land_raz_hut04",
"Land_raz_hut07",
"LAND_uns_hut12",
"Land_raz_hut06",
"Land_raz_hut05",
"Land_raz_hut02",
"Land_raz_hut01",
"land_indo_hut_2",
"land_indo_hut_1",

// Chernarus redux
"Land_ds_houseV_1L2",
"Land_ds_houseV_1t",
"Land_ds_houseV_2l",
"Land_ds_houseV_2L",
"Land_ds_houseV_2T1",
"Land_ds_houseV_2T2",
"Land_ds_houseV_3l1",
"Land_ds_houseV_3l2",
"Land_ds_houseV_3l3",
"Land_ds_houseV_3l4",

// Rosche
"Land_MBG_GER_PUB_1",
"Land_MBG_GER_PUB_2",
"Land_MBG_GER_RHUS_1",
"Land_MBG_GER_RHUS_2",
"Land_MBG_GER_RHUS_3",
"Land_MBG_GER_RHUS_4",
"Land_MBG_GER_HUS_1",
"Land_MBG_GER_HUS_2",
"Land_MBG_GER_HUS_3",
"Land_MBG_GER_HUS_4",
"Land_MBG_GER_HUS_4",
"Land_MBG_GER_ESTATE_1",
"Land_MBG_GER_ESTATE_2",
"Land_sara_domek_zluty",
"Land_sara_domek_sedy",
"Land_dum_mesto2",
"Land_dum_mesto_in",
"Land_WL_House_01_A",
"Land_WL_House_02_A",
"Land_WL_House_03_A",
"Land_WL_House_04_A",

// Mogadishu
"land_mbg_brickhouse_01",
"land_mbg_brickhouse_02",
"land_mbg_brickhouse_031",
"mbg_apartments_big_01_EO",
"mbg_apartments_big_02_EO",
"mbg_apartments_big_02b_EO",
"mbg_apartments_big_02c_EO",
"mbg_apartments_big_03_EO",
"mbg_apartments_big_03b_EO",
"mbg_apartments_big_03c_EO",
"mbg_apartments_big_04_EO",
"mbg_brickhouse_01_EO",
"mbg_brickhouse_02_EO",
"mbg_brickhouse_03_EO",
"land_mbg_slum01",
"land_mbg_slum01b",
"land_mbg_slum01c",
"land_mbg_slum01d",
"land_mbg_slum01e",
"land_mbg_slum01f",
"land_mbg_slum01g",
"land_mbg_slum01h",
"land_mbg_slum02",
"land_mbg_slum02b",
"land_mbg_slum02c",
"land_mbg_slum02d",
"land_mbg_slum02e",
"land_mbg_slum02f",
"land_mbg_slum02g",
"land_mbg_slum02h",
"land_mbg_slum03",
"land_mbg_slum03b",
"land_mbg_slum03c",
"land_mbg_slum03d",
"land_mbg_slum03e",
"land_mbg_slum03f",
"land_mbg_slum03g",
"land_mbg_slum03h",
"mbg_slum01_EO",
"mbg_slum01b_EO",
"mbg_slum01c_EO",
"mbg_slum01d_EO",
"mbg_slum01e_EO",
"mbg_slum01f_EO",
"mbg_slum01g_EO",
"mbg_slum01h_EO",
"mbg_slum02_EO",
"mbg_slum02b_EO",
"mbg_slum02c_EO",
"mbg_slum02d_EO",
"mbg_slum02e_EO",
"mbg_slum02f_EO",
"mbg_slum02g_EO",
"mbg_slum02h_EO",
"mbg_slum03_EO",
"mbg_slum03b_EO",
"mbg_slum03c_EO",
"mbg_slum03d_EO",
"mbg_slum03h_EO",

// Montella
"Land_Sara_domek04",
"Land_Brana02nodoor",
"Land_Sara_domek05",
"Land_Deutshe_mini",
"Land_Dum_mesto3",
"Land_OrlHot",
"Land_Sara_domek03",
"Land_Cihlovej_Dum_in",
"Land_Sara_domek01",
"Land_Sara_domek_rosa",

// Corran
"land_panelak1_grey",
"Land_Sara_zluty_statek_in",
"Land_Sara_domek_zluty",

// Cam Lao Nam
"Land_vn_hut_06",
"Land_vn_hut_river_01",
"Land_vn_hut_03",
"Land_vn_hut_01",
"Land_vn_hut_04",
"Land_vn_hut_02",
"Land_vn_hut_05",
"Land_vn_hut_08",
"Land_vn_stallwater_f",
"Land_vn_hut_mont_05",
"Land_vn_hut_mont_04",
"Land_vn_hut_river_02",
"Land_vn_hut_mont_02",
"Land_vn_hut_mont_01",
"Land_vn_hut_river_03",
"Land_vn_hut_village_02",
"Land_vn_woodenshelter_01_f",
"Land_vn_market_stalls_02_ep1",
"Land_vn_shed_06_f",
"Land_vn_shed_07_f",
"Land_vn_hut_village_01",
"Land_vn_marketshelter_f",
"Land_vn_market_stalls_01_ep1",
"Land_vn_shed_05_f",
"Land_vn_hut_old02",
"Land_vn_hut_mont_03",
"Land_vn_temple_statue_01",
"Land_vn_i_shed_ind_old_f",
"Land_vn_pierwooden_02_hut_f",
"Land_vn_garagerow_01_large_f",
"Land_vn_trafostanica_mala",
"Land_vn_sm_01_shed_f",
"Land_vn_slum_01_f",
"Land_vn_cargo_house_slum_f",
"Land_vn_slum_house01_f",
"Land_vn_slum_05_f",
"Land_vn_slum_02_f",
"Land_vn_workshop_03_f",
"Land_vn_sm_01_shelter_narrow_f",
"Land_vn_industrialshed_01_f",
"Land_vn_a_hospital",
"Land_vn_sm_01_shed_unfinished_f",
"Land_vn_slum_04_f",
"Land_vn_metal_shed_f",
"Land_vn_slum_house03_f",
"Land_vn_workshop_02_f",
"Land_vn_workshop_01_grey_f",
"Land_vn_guardhouse_03_f",
"Land_vn_metalshelter_01_f",
"Land_vn_slum_house02_f",
"Land_vn_temple_base_01",
"Land_vn_shop_town_02_f",
"Land_vn_shop_town_03_f",
"Land_vn_shop_town_05_f",
"Land_vn_shop_town_04_f",
"Land_vn_shed_01_f",
"Land_vn_house_small_01_f",
"Land_vn_house_small_06_f",
"Land_vn_garageshelter_01_f",
"Land_vn_shop_town_01_f",
"Land_vn_house_big_05_f",
"Land_vn_garagerow_01_small_f",
"Land_vn_supermarket_01_f",
"Land_vn_house_big_01_f",
"Land_vn_house_small_05_f",
"Land_vn_house_small_04_f",
"Land_vn_house_big_04_f",
"Land_vn_house_small_02_f",
"Land_vn_slum_03_f",
"Land_vn_rail_warehouse_small_f",
"Land_vn_cmp_shed_f",
"Land_vn_shed_small_f",
"Land_vn_a_office01",
"Land_vn_slum_03_01_f",
"Land_vn_shed_03_f",
"Land_vn_guardhouse_02_grey_f",
"Land_vn_shed_02_f",
"Land_Shed_14_F",
"Land_Shed_10_F",
"Land_Shed_09_F",
"Land_i_House_Big_01_b_brown_F",
"Land_i_House_Small_01_b_brown_F",
"Land_Shed_11_F",
"Land_Shed_12_F",
"Land_d_Stone_HouseBig_V1_F",
"Land_Shed_08_brown_F",
"Land_i_Stone_Shed_01_b_clay_F",
"Land_Shed_08_grey_F",
"Land_vn_shed_04_f",
"Land_vn_fuelstation_build_02_f",
"Land_vn_house_c_1_v2_ep1",
"Land_vn_house_c_9_ep1",
"Land_vn_shop_city_02_f",
"Land_vn_shop_city_03_f",
"Land_i_Stone_Shed_01_c_raw_F",
"Land_vn_guardbox_01_smooth_f",
"Land_vn_metalshelter_03_f",
"Land_vn_scf_01_storagebin_medium_f",
"Land_vn_rail_concreteramp_f",
"Land_vn_shed_big_f",
"Land_vn_garageoffice_01_f",
"Land_vn_workshop_02_grey_f",
"Land_vn_mine_01_warehouse_f",
"Land_vn_cementworks_01_brick_f",
"Land_vn_i_barracks_v2_dam_f",
"Land_vn_workshop_04_grey_f",
"Land_vn_workshop_03_grey_f",
"Land_d_House_Small_02_V1_F",
"Land_d_House_Small_01_V1_F",
"Land_vn_workshop_05_grey_f",
"Land_vn_house_c_3_ep1",
"Land_d_House_Big_01_V1_F",
"Land_vn_housev2_04_interier",
"Land_vn_a_municipaloffice",
"Land_vn_house_small_03_f",
"Land_vn_addon_03_f",
"Land_vn_shop_city_06_f",
"Land_vn_shop_city_07_f",
"Land_vn_ind_tanksmall2_ep1",
"Land_vn_barracks_01_grey_f",
"Land_d_Shop_01_V1_F",
"Land_vn_house_c_12_ep1",
"Land_vn_gh_house_1_f",
"Land_vn_workshop_05_f",
"Land_vn_workshop_01_f",
"Land_vn_workshop_04_f",
"Land_vn_gh_pool_f",
"Land_vn_gh_house_2_f",
"Land_vn_shop_city_04_f",
"Land_vn_school_01_01_f",
"Land_vn_gh_gazebo_f",
"Land_i_Stone_Shed_01_c_clay_F",
"Land_d_Stone_Shed_V1_F",
"Land_vn_house_c_11_ep1",
"Land_vn_radar_01_kitchen_f",
"Land_vn_school_01_f",
"Land_vn_sm_01_shelter_wide_f",
"Land_vn_shop_city_05_f",
"Land_vn_unfinished_building_02_f",
"Land_Camp_House_01_brown_F",
"Land_DryToilet_01_F",
"Land_vn_shop_city_01_f",
"Land_vn_waterstation_01_f",
"Land_vn_misc_waterstation",
"Land_d_Stone_HouseSmall_V1_F",
"Land_i_Stone_HouseBig_V1_F",
"Land_vn_unfinished_building_01_f",
"Land_vn_fuelstation_01_shop_f",
"Land_vn_fuelstation_02_roof_f",
"Land_vn_nav_pier_c_t15",
"Land_i_Stone_Shed_V1_F",
"Land_vn_fuelstation_02_workshop_f",
"Land_vn_fuelstation_shed_f",
"Land_vn_house_big_02_f",
"Land_vn_house_big_03_f",
"Land_vn_scf_01_heap_bagasse_f",
"Land_vn_rail_station_small_f",
"Land_House_Big_05_F",
"Land_vn_addon_04_f",
"Land_vn_guardhouse_02_f",
"Land_vn_i_garage_v2_f",
"Land_vn_dpp_01_smallfactory_f",
"Land_vn_ind_vysypka",
"Land_vn_addon_05_f",
"Land_vn_d_addon_02_v1_f",
"Land_vn_scf_01_warehouse_f",
"Land_vn_nav_pier_m_2",
"Land_vn_factory_main_f",
"Land_vn_nav_pier_c_big",
"Land_vn_scf_01_crystallizer_f",
"Land_vn_scf_01_generalbuilding_f",
"Land_PowerStation_01_F",
"Land_vn_scf_01_boilerbuilding_f",
"Land_vn_cementworks_01_grey_f",
"Land_vn_fuelstation_build_f",
"Land_vn_nav_pier_m_1",
"Land_vn_nav_pier_m_end",
"Land_vn_gh_stairs_f",
"Land_vn_factory_02_f",
"Land_i_House_Small_01_V1_dam_F",
"Land_vn_i_addon_03_v1_f",
"Land_vn_rails_bridge_40",
"Land_i_House_Big_01_V2_dam_F",
"Land_i_House_Small_02_V2_dam_F",
"Land_vn_guardbox_01_green_f",
"Land_vn_i_addon_04_v1_f",
"Land_PoliceStation_01_F",
"Land_vn_mobilecrane_01_f",
"Land_vn_hut_stairs_02",
"Land_vn_rail_station_big_f",
"Land_vn_cmp_tower_f",
"Land_vn_cmp_shed_dam_f",
"Land_vn_cmp_hopper_f",
"Land_vn_barracks_01_camo_f",

//Gabreta
"Land_pr_i06",
"Land_dom_I3i_03_V4",
"Land_dom_I3i_03_V3",
"Land_dom_I3i_04",
"Land_dom_I3i_03",
"Land_pr_i05_V2",
"Land_pr_i06_V2",
"Land_pr_i04_V2",
"Land_pr_i03",
"Land_dom_I3i_02_V2",
"Land_dom_I3i_03_V2",
"Land_pr_i05",
"Land_csla_Sara_stodola",
"Land_pr_i02",
"Land_dom_I3i_01",
"Land_dom_I3i_04_caffe",
"Land_dom_I3i_04_shop_V2",
"Land_dom_I3i_02_V3",
"Land_dom_I3i_01_M2",
"Land_dom_I3i_01_V2",
"Land_dom_I3i_02",
"Land_dom_I3i_04_hostinec",
"Land_pr_i04",
"Land_dom_I2i_02",
"Land_dom_I3i_04_hostinec2",
"Land_dom_I3i_04_V2",
"Land_dom_I3i_04_shop",
"Land_hostinec_04",
"Land_dom_I2i_02_M2",
"Land_csla_Church_04",
"Land_pr_i04_M",
"Land_dom_T2i_01_V3",
"Land_dom_I2i_01_V3",
"Land_dom_T2i_01",
"Land_dom_T2i_01_M",
"Land_dom_I2i_01",
"Land_dom_I2i_01_V2",
"Land_dom_I2i_01_V4",
"Land_garage_5",
"Land_csla_A_GeneralStore_01",
"Land_dom_I2i_03_skola_w",
"Land_pr_i01",
"Land_csla_Fire_Station",
"Land_pr_i02_V2",
"Land_dom_L1i_02_V3",
"Land_dom_o2i_01_V3",
"Land_garage",
"Land_dom_I1i_02_V2",
"Land_dom_I1i_07_V2",
"Land_hostinec_01",
"Land_pr_i03_V2",
"Land_pr_i01_V2",
"Land_csla_domA_I2i_04_V2",
"Land_dom_T2i_01_V2",
"Land_pr_i02_V3",
"Land_dom_I1i_08",
"Land_dom_o1i_01_V3",
"Land_csla_Sara_stodola2",
"Land_pr_i04_V3",
"Land_dom_I1i_01_mod",
"Land_dom_L1i_02_M",
"Land_csla_Shed_Ind02",
"Land_csla_Sara_stodola3",
"Land_dom_o2i_02_V3",
"Land_dom_T2i_01_M2",
"Land_dom_o2i_02_V2",
"Land_pr_i03_V3",
"Land_csla_domA_I2i_02",
"Land_dom_I3i_01_V3",
"Land_dom_o2i_02",
"Land_csla_domA_I2i_04",
"Land_hostinec_02",
"Land_dom_I2i_02_M1",
"Land_dom_o2i_03",
"Land_dom_L1i_01c_V2",
"Land_dom_o1i_01_M1",
"Land_dom_o2i_01_M1",
"Land_garage_3",
"Land_dom_o2i_03_V2",
"Land_dom_I1i_02_M",
"Land_dom_o2i_02_M1",
"Land_dom_I1i_07_M2",
"Land_dom_I2i_02_V2",
"Land_dom_I1i_07_V3",
"Land_dom_I2i_03_skola",
"Land_csla_Shed_M02",
"Land_csla_domA_I1i_01",
"Land_csla_Office01",
"Land_dom_I1i_04_M",
"Land_dom_I1i_08_V2",
"Land_dom_L1i_02",
"Land_dom_I1i_05_V2",
"Land_csla_Church_04b",
"Land_dom_shop_01_M1",
"Land_dom_I1i_02",
"Land_dom_L1i_01c",
"Land_dom_I1i_04",
"Land_dom_I1i_02_V3",
"Land_dom_I1i_06_V3",
"Land_dom_L1i_01_M",
"Land_dom_I1i_06",
"Land_csla_Tovarna2",
"Land_dom_I1i_08_V3",
"Land_csla_Barn_Metal",
"Land_dom_I1i_08_M",
"Land_csla_domA_I2i_01",
"Land_pr_i02_V4",
"Land_dom_I1i_07",
"Land_dom_I1i_07_M",
"Land_dom_I1i_01_V2",
"Land_dom_o2i_01",
"Land_csla_Mil_House",
"Land_dom_I1i_03",
"Land_dom_shop_01_V3",
"Land_dom_o1i_01_V2",
"Land_dom_I1i_05_V3",
"Land_dom_I1i_01_V3",
"Land_csla_Hospital_side1",
"Land_dom_L1i_01_V2",
"Land_csla_Hospital_side2",
"Land_dom_I1i_05",
"Land_dom_I1i_04_V3",
"Land_dom_o1i_01",
"Land_dom_L1i_01",
"Land_dom_L1i_01_V3",
"Land_dom_shop_01_V2",
"Land_dom_shop_01",
"Land_csla_HouseBlock_B5",
"Land_csla_HouseBlock_A1_1",
"Land_csla_HouseBlock_C4",
"Land_csla_HouseBlock_C5",
"Land_csla_A_Office02",
"Land_csla_Panelak_4p",
"Land_dom_I1i_04_V2",
"Land_csla_HouseBlock_A3",
"Land_csla_HouseBlock_B3",
"Land_csla_Panelak_2p",
"Land_dom_o2i_01_V2",
"Land_csla_HouseBlock_B2",
"Land_csla_HouseBlock_C1",
"Land_csla_HouseBlock_A2",
"Land_csla_HouseBlock_A1_2",
"Land_CSLA_Hospital",
"Land_csla_HouseBlock_B4",
"Land_csla_domA_I2i_04_V3",
"Land_dom_L1i_01b",
"Land_csla_HouseBlock_C3",
"Land_csla_APub_01",
"Land_csla_HouseBlock_A2_1",
"Land_csla_HouseBlock_A1",
"Land_csla_HouseBlock_B6",
"Land_csla_HouseBlock_C2",
"Land_csla_HouseBlock_D1",
"Land_dom_o2i_03_V3",
"Land_csla_HouseBlock_B1",
"Land_dom_L1i_02_M2",
"Land_dom_L1i_02_V2",
"Land_hostinec_03",
"Land_dom_I1i_03_V2",
"Land_csla_Panelak_8p",
"Land_csla_domA_I2i_03",
"Land_dom_I1i_06_V2",
"Land_dom_I1i_03_V3",
"Land_csla_Nav_Boathouse",
"Land_dom_I2i_02_V3",
"Land_dom_I1i_08_nD",
"Land_dom_I1i_03_nD",

// Western Sahara
"Land_House_L_9_EP1_lxWS",
"Land_Cargo_House_V3_F",
"Land_Cargo_Tower_V3_F",
"Land_House_L_1_EP1_lxWS",
"Land_House_L_3_EP1_lxWS",
"Land_House_L_7_EP1_lxWS",
"Land_House_L_8_EP1_lxWS",
"Land_Misc_Well_L_EP1_lxWS",
"Land_Shed_06_F",
"Land_Slum_House03_F",
"Land_WoodenShelter_01_F",
"Land_Shed_05_F",
"Land_Shed_07_F",
"Land_SM_01_shelter_narrow_F",
"Land_Shed_04_F",
"Land_SM_01_shed_F",

"Land_MetalShelter_01_F",
"Land_Shed_02_F",
"Land_GuardHouse_01_F",
"Land_TBox_F",
"Land_dp_smallFactory_F",
"Land_dp_bigTank_F",
"Land_SCF_01_feeder_lxWS",
"Land_House_Small_02_F",
"Land_SM_01_shelter_wide_F",
"Land_House_K_3_EP1_lxWS",
"Land_Slum_House02_F",
"Land_MilOffices_V1_F",
"Land_i_Shed_Ind_F",
"Land_cmp_Shed_F",
"Land_House_C_5_EP1_off_lxWS",
"land_tower_lxws",
"Land_House_C_5_V3_EP1_off_lxWS",
"Land_cmp_Tower_F",
"Land_House_K_1_EP1_lxWS",
"Land_House_C_12_EP1_off_lxWS",
"Land_House_C_11_EP1_off_lxWS",
"Land_A_Mosque_small_2_EP1_lxWS",
"Land_SM_01_shed_unfinished_F",
"Land_dp_smallTank_F",
"Land_House_C_5_V1_EP1_off_lxWS",
"Land_Shed_Small_F",
"Land_Addon_05_F",
"Land_Warehouse_03_F",
"Land_Communication_anchor_F",
"Land_Dome_Small_F",
"Land_Shed_Big_F",
"Land_cargo_house_slum_F",
"Land_Slum_House01_F",
"Land_Shed_01_F",
"Land_House_C_5_V2_EP1_off_lxWS",
"Land_Barracks_01_grey_F",
"Land_i_House_Small_03_V1_F",
"Land_Shed_03_F",
"Land_Metal_Shed_F",
"Land_TentHangar_V1_F",
"Land_Airport_02_controlTower_F",
"Land_Airport_01_hangar_F",
"Land_i_Garage_V2_F",
"Land_Slum_01_F",
"Land_CarService_F",
"Land_FuelStation_02_roof_lxWS",
"Land_House_Small_01_F",
"Land_FuelStation_Build_F",

// Isla Nueva
"Land_Edaly_Lighthouse_Base_F",
"Land_House_Trinidad_03_O_F",
"Land_Post_office_01_F",
"Land_Car_Shelters_01_F",
"Land_Edaly_Small_hut_01_F",
"Land_Suburb_big_house_03_F",
"Land_House_Trinidad_05_P_F",
"Land_Edaly_havana_house_2_F",
"Land_Edaly_havana_house_1_F",
"Land_Edaly_havana_house_4_F",
"Land_WoodenShelter_01_F",
"Land_Suburb_big_house_01_F",
"Land_Suburb_big_house_02_F",
"Land_Suburban_Bank_01_F",
"Land_Edaly_havana_house_3_F",
"Land_Edaly_Small_Wooden_Shelf_F",
"Land_Edaly_hut_01_Esc",
"Land_Suburb_house_02_F",
"Land_Edaly_hut_01_F",
"Land_Edaly_hut_02_F",
"Land_Suburb_house_01_F",
"Land_Suburb_house_03_F",
"Land_Shop_04_F",
"Land_Edaly_army_hut_02_F",
"Land_SM_01_shelter_narrow_F",
"Land_Police_01_F",
"Land_Car_dealer_01_F",
"Land_House_Trinidad_02_Beige_F",
"Land_House_Trinidad_02_Yellow_F",
"Land_MetalShelter_02_F",
"Land_House_Trinidad_02_Blue_F",
"Land_Edaly_hut_03_F",
"Land_Town_hall_01_F",
"Land_Shop_02_F",
"Land_Hospital_01_F",
"Land_Gas_station_01_F",
"Land_Edaly_campaign_house_3_F",
"Land_Shed_04_F",
"Land_Edaly_Tenement_02_F",
"Land_Edaly_Tenement_03_F",
"Land_Edaly_Tenement_01_F",
"Land_Slum_02_F",
"Land_Caravan_01_green_F",
"Land_Slum_01_F",
"Land_cargo_house_slum_F",
"Land_Edaly_Tenement_S_01_F",
"Land_Metal_Shed_F",
"Land_Caravan_01_rust_F",
"Land_Slum_04_F",
"Land_Shed_03_F",
"Land_Slum_04_ruins_F",
"Land_MetalShelter_01_F",
"Land_Greenhouse_01_damaged_F",
"Land_Workshop_02_grey_F",
"Land_Slum_05_F",
"Land_Shed_12_F",
"Land_Shed_09_F",
"Land_CementWorks_01_brick_F",
"Land_Edaly_Small_Warehouse_01_F",
"Land_Shed_Small_F",
"Land_Edaly_campaign_house_2_F",
"Land_Edaly_campaign_house_1_F",
"Land_Mine_01_warehouse_F",
"Land_Barracks_01_EL",
"Land_GarageOffice_01_F",
"Land_Shed_01_F",
"Land_Barracks_03_F",
"Land_Barracks_04_F",
"Land_Shed_Big_F",
"Land_House_Trinidad_04_S_F",
"Land_Edaly_House_Trinidad_01_F",
"Land_GuardBox_01_green_F",
"Land_House_Trinidad_04_A_F",
"Land_House_Trinidad_03_G_F",
"Land_Airport_01_controlTower_F",
"Land_House_Trinidad_04_R_F",
"Land_ControlTower_02_F",
"Land_Edaly_Dorms_01_F",
"Land_House_Trinidad_05_R_F",
"Land_Radar_01_HQ_F",
"Land_GuardBox_01_brown_F",
"Land_House_Trinidad_03_B_F",
"Land_i_Barracks_V2_F",
"Land_GuardHouse_02_F",
"Land_Shop_01_F",
"Land_Factory_Conv1_10_ruins_F",
"Land_Factory_Hopper_ruins_F",
"Land_Mill_01_F",
"Land_Slum_01_ruins_F",
"Land_Slum_02_ruins_F",
"Land_House_Native_02_F",
"Land_Stables01",
"Land_Shed_07_F",
"Land_Edaly_House_campaign_01_F",
"Land_Shop_rural_03_F",
"Land_Edaly_House_campaign_02_F",
"Land_Edaly_havana_house_6_F",
"Land_Edaly_havana_house_5_F",
"Land_Town_hall_02_F",
"Land_House_Trinidad_05_G_F",
"Land_GuardHouse_02_grey_F",
"Land_House_Trinidad_05_B_F",
"Land_i_Addon_03_V1_F",
"Land_Post_office_02_F",
"Land_Shop_rural_02_F",
"Land_Edaly_hut_02_Esc",
"Land_i_Garage_V1_F",
"Land_Metal_Shed_ruins_F",
"Land_PierWooden_01_16m_F",
"Land_ServiceHangar_01_L_F",
"Land_ServiceHangar_01_R_F",

// Sa'Hatra
"Land_juju_opx2_hut3",
"Land_juju_opx2_hut2",
"Land_juju_opx2_hut1",
"Land_juju_opx2_hut4",
"Land_juju_opx_shop3b",
"Land_juju_opx_shop1",
"Land_juju_opx_shop2",
"Land_juju_opx_shop3",
"Land_juju_opx2_h3",
"Land_juju_opx_h11_b",
"Land_juju_opx_h18",
"Land_juju_opx2_h1",
"Land_juju_opx_h11",
"Land_juju_opx_stores3",
"Land_juju_opx_h19",
"Land_juju_opx2_garage1",
"Land_juju_opx2_complex4",
"Land_juju_opx2_complex8",
"Land_juju_opx2_garages",
"Land_juju_opx2_complex9",
"Land_juju_opx2_complex5",
"Land_juju_opx_h20",
"Land_juju_opx2_stores2",
"Land_juju_opx2_complex3",
"Land_juju_opx2_corner2",
"Land_juju_opx2_policestation",
"Land_juju_opx2_complex6",
"Land_juju_opx2_complex2",
"Land_juju_opx2_complex7",
"Land_juju_opx2_complex1",
"Land_juju_opx2_store1",
"Land_juju_opx2_corner1",
"Land_juju_opx2_h2"
];

// SUN ANGLE - ORIGINAL CODE BY CARLGUSTAFFA
tpw_core_fnc_sunangle =
	{
	private ["_lat","_day","_hour"];
	while {true} do 
		{
		_lat = -1 * getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
		_day = 360 * (dateToNumber date);
		_hour = (daytime / 24) * 360;
		tpw_core_sunangle = ((12 * cos(_day) - 78) * cos(_lat) * cos(_hour)) - (24 * sin(_lat) * cos(_day));  
		sleep 33.33; 
		};
	};	
	
// DETERMINE UNIT'S WEAPON TYPE 
tpw_core_fnc_weptype =
	{
	private["_unit","_weptype","_cw","_hw","_pw","_sw"];
	_unit = _this select 0;	
	
	// Weapon type
	_cw = currentweapon _unit;
	_hw = handgunweapon _unit;
	_pw = primaryweapon _unit;
	_sw = secondaryweapon _unit;
	 switch _cw do
		{
		case "": 
			{
			_weptype = 0;
			};
		case _hw: 
			{
			_weptype = 1;
			};
		case _pw: 
			{
			_weptype = 2;
			};
		case _sw: 
			{
			_weptype = 3;
			};
		default
			{
			_weptype = 0;
			};	
		};
	_unit setvariable ["tpw_core_weptype",_weptype];
	};
	
// PREVENT DEAD UNITS FROM FALLING THROUGH GROUND
tpw_core_fnc_dead =
	{	
	private ["_unit","_ct","_dpos","_ipos"];
	_unit = _this select 0;	
	_ct = 0;
	waituntil
		{
		sleep 0.2;
		_ct = _ct + 1;
		_dpos = getposatl _unit;
		(_dpos select 2 < -0.25 || isnull _unit || _ct > 10)
		};
	if (!(isnull _unit) && _ct < 11) then
		{
		_ipos = getposatl _unit;
		_ipos set[2,0];
		_unit setposatl _ipos;
		};
	};	

// DISABLE UNIT WRITHING ON GROUND
tpw_core_fnc_disable = 
	{
	private ["_unit","_anims","_ct"];
	_unit = _this select 0;		
	if !(alive _unit) exitwith {};
	if (_unit == player) exitwith {};
	if (_unit getvariable["tpw_core_disabled",0] == 1) exitwith {};
	_unit setvariable ["tpw_core_disabled",1];
	_unit setvariable ["tpw_core_enabled",0];
	_unit setunconscious true;
	_unit disableai "all";
	_ct = 0;	
	waituntil
		{
		_unit disableai "all";
		sleep 1;
		_ct = _ct + 1;
		(animationstate _unit == "unconsciousrevivedefault" || _ct == 10)
		};	
	_unit disableai "all";
	_unit setunconscious false;	
	_anims = ["Acts_InjuredAngryRifle01","Acts_InjuredCoughRifle02","Acts_InjuredLookingRifle01","Acts_InjuredLookingRifle02","Acts_InjuredLookingRifle03","Acts_InjuredLookingRifle04","Acts_InjuredLookingRifle05"];
	if !(alive _unit) exitwith {};
	_unit setdir (getdir _unit + 150);
	_unit switchmove selectrandom _anims;
	if (isclass (configfile/"CfgPatches"/"SSD_DeathScreams")) then 
		{
		_unit say3d selectrandom [format ["SSD_RattleStomach%1",ceil random 25],format ["SSD_RattleOther%1",ceil random 12],format ["SSD_RattleHeart%1",ceil random 25],format ["SSD_RattleHeart%1",ceil random 25]];
		};
	};

// RE-ENABLE UNIT
tpw_core_fnc_enable = 
	{
	private ["_unit"];
	_unit = _this select 0;		

	if !(alive _unit) exitwith {};
	if (damage _unit > 0.9) exitwith {};
	if (_unit == player) exitwith {};
	if (_unit getvariable["tpw_core_enabled",1] > 0) exitwith {};
	_unit setvariable ["tpw_core_enabled",0.5];
	_unit setvariable ["tpw_core_disabled",0];	
	_unit setvariable ["tpw_core_injurymultiplier",random 1]; 
	sleep 5 + random 15;	
	_unit setdir (getdir _unit - 150);
	_unit switchmove "unconsciousrevivedefault";
	_unit setunconscious false;	
	_unit enableai "all";	
	_unit setunitpos "auto";	
	_unit setcaptive false;
	_unit setvariable ["tpw_core_enabled",1];
	};


// SORT ARRAY OF OBJECTS BASED ON DISTANCE TO PLAYER
tpw_core_fnc_arraysort =
	{
	private _origarray = _this select 0;
	private _distarray = _origarray apply {[_x distance player, _x]}; 
	_distarray sort true;
	private _sortedarray = [];
	{_sortedarray pushback (_x select 1)} foreach _distarray;	
	_sortedarray
	};
	
tpw_core_fnc_arrayrevsort =
	{
	private _origarray = _this select 0;
	private _distarray = _origarray apply {[_x distance player, _x]}; 
	_distarray sort false;
	private _sortedarray = [];
	{_sortedarray pushback (_x select 1)} foreach _distarray;	
	_sortedarray
	};	
	
// OBJECT SCALE
tpw_core_fnc_scale = 
	{
	private _obj = _this select 0;
	private _scale = _this select 1;
	private _pos = getposatl _obj;
	_obj setobjectscale _scale;
	sleep 0.05;
	_obj setposatl _pos;
	};	
	
// NEAR TREES
tpw_core_fnc_neartrees = 
	{
	private _pos = _this select 0;
	private _radius = _this select 1;
	_neartrees = tpw_core_trees select {_x distance _pos < _radius};
	_neartrees
	};	

tpw_core_fnc_nearvegetation = 
	{
	private _pos = _this select 0;
	private _radius = _this select 1;
	_nearvegetation = tpw_core_vegetation select {_x distance _pos < _radius};
	_nearvegetation
	};		
	
// SCAN WHETHER THERE IS NEARBY BATTLE (GUNFIRE/EXPLOSIONS/GRENADES)	
// tpw_core_battletime is advanced by 1-2 minutes every time these events occur
tpw_core_fnc_battle = 
	{
	while {true} do
		{
		if (diag_ticktime > tpw_core_battletime) then	
			{
			tpw_core_battle = false;
			} else
			{
			tpw_core_battle = true;
			};
		sleep 2;	
		};
	};

// NEARBY GUNFIRE
tpw_core_battle = false;
tpw_core_battletime = 0;
player addeventhandler ["firednear",{tpw_core_battletime = diag_ticktime + 60 + random 120}];	
0 = [] spawn tpw_core_fnc_battle;	
		
// CALL OR SPAWN APPROPRIATE FUNCTIONS
tpw_core_housescanflag = 0;
0 = [] spawn tpw_core_fnc_sunangle;	
[tpw_core_mapstrings] spawn tpw_core_fnc_civs;


// NEARBY HABITABLE HOUSES
tpw_core_fnc_houses =
	{
	private ["_housearray","_radius","_return"];
	_housearray = [];
	_radius = _this select 0;
	_return = nearestObjects [position vehicle player,tpw_core_habitable_houses,_radius]; 
	_return
	};
	
tpw_core_fnc_screenhouses =
	{
	private ["_radius","_return"];
	_radius = _this select 0;
	_return = tpw_core_habhouses select {_x distance player < _radius};
	_return = _return select {!(isobjecthidden _x)};
	_return = _return select { !(["estroy",gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayname")] call BIS_fnc_inString)}; 
	_return = _return select { !(["amage",gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayname")] call BIS_fnc_inString)}; 
	_return = _return select { !(["uin",gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayname")] call BIS_fnc_inString)}; 
	_return = _return select { !(["bandon",gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayname")] call BIS_fnc_inString)}; 
	//_return = _return select { !(["stone",gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "displayname")] call BIS_fnc_inString)}; 

	_return	
	};

tpw_core_allhouses = [50000] call tpw_core_fnc_houses;
tpw_core_habitable = [];
_habitable = [];
	{
	_type = typeof _x;
	if !(_type in tpw_core_habitable) then
		{
		_habitable pushback _type;
		};
	} foreach tpw_core_allhouses;
tpw_core_habitable = _habitable;

// OBJECT SCAN
tpw_core_habhouses = [];
sleep 10;
_lastpos = [0,0,0];
while {true} do
	{
	if ((speed player < 20) && (player distance _lastpos > 250) && (!tpw_core_battle)) then
		{
		tpw_core_habhouses = tpw_core_allhouses select {_x distance player < 500};
		tpw_core_vegetation = nearestterrainobjects[player,["tree","small tree","bush"],500,false];
		tpw_core_trees = nearestterrainobjects[player,["tree","small tree"],500,false];		
		_lastpos = position player; 
		};
	sleep 30 + (count tpw_core_habhouses)/2; 
	};
	
// DUMMY LOOP SO SCRIPT DOESN'T TERMINATE
while {true} do
	{
	sleep 10;
	};	