/*
    File: apex.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2017-10-07
    Last Update: 2020-05-25
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        NATO pacific player preset.

    Needed Mods:
        - None

    Optional Mods:
        - https://steamcommunity.com/sharedfiles/filedetails/?id=2177826065
        - https://steamcommunity.com/sharedfiles/filedetails/?id=1752496126
*/

/*
    --- Support classnames ---
    Each of these should be unique.
    The same classnames for different purposes may cause various unpredictable issues with player actions.
    Or not, just don't try!
*/
KPLIB_b_fobBuilding = "Land_Cargo_HQ_V4_F";                                    // This is the main FOB HQ building.
KPLIB_b_fobBox = "B_Slingload_01_Cargo_F";                            // This is the FOB as a container.
KPLIB_b_fobTruck = "B_T_Truck_01_box_F";                              // This is the FOB as a vehicle.
KPLIB_b_arsenal = "B_supplyCrate_F";                                   // This is the virtual arsenal as portable supply crates.
KPLIB_b_mobileRespawn   = ["EO_TentDome_F", "B_T_Truck_01_medical_F", "B_Slingload_01_Medevac_F", "rksla3_lcvpmk5_1_generic_grey"]; // This is the mobile respawn (and medical) truck.
KPLIB_b_potato01 = "B_Heli_Transport_03_unarmed_F";                       // This is Potato 01, a multipurpose mobile respawn as a helicopter.
KPLIB_b_crewUnit = "B_T_Soldier_F";                                       // This defines the crew for vehicles.
KPLIB_b_heliPilotUnit = "B_T_Helipilot_F";                                    // This defines the pilot for helicopters.
KPLIB_b_addHeli = "B_Heli_Light_01_F";                      // These are the additional helicopters which spawn on the Freedom or at Chimera base.
KPLIB_b_addBoat = "B_T_Boat_Transport_01_F";                       // These are the boats which spawn at the stern of the Freedom.
KPLIB_b_logiTruck = "B_T_Truck_01_transport_F";                     // These are the trucks which are used in the logistic convoy system.
KPLIB_b_smallStorage = "ContainmentArea_02_sand_F";             // A small storage area for resources.
KPLIB_b_largeStorage = "ContainmentArea_01_sand_F";             // A large storage area for resources.
KPLIB_b_logiStation = "Land_RepairDepot_01_green_F";                 // The building defined to unlock FOB recycling functionality.
KPLIB_b_airControl = "B_Radar_System_01_F";                     // The building defined to unlock FOB air vehicle functionality.
KPLIB_b_slotHeli = "Land_HelipadSquare_F";                      // The helipad used to increase the GLOBAL rotary-wing cap.
KPLIB_b_slotPlane = "Land_TentHangar_V1_F";                     // The hangar used to increase the GLOBAL fixed-wing cap.
KPLIB_b_crateSupply = "CargoNet_01_box_F";                               // This defines the supply crates, as in resources.
KPLIB_b_crateAmmo = "B_CargoNet_01_ammo_F";                              // This defines the ammunition crates.
KPLIB_b_crateFuel = "CargoNet_01_barrels_F";                             // This defines the fuel crates.

/*
    --- Friendly classnames ---
    Each array below represents one of the 7 pages within the build menu.
    Format: ["vehicle_classname",supplies,ammunition,fuel],
    Example: ["B_APC_Tracked_01_AA_F",300,150,150],
    The above example is the NATO IFV-6a Cheetah, it costs 300 supplies, 150 ammunition and 150 fuel to build.
    IMPORTANT: The last element inside each array must have no comma at the end!
*/
KPLIB_b_infantry = [
    ["B_T_Soldier_F",20,0,0],                                           // Rifleman
    ["B_T_Soldier_LAT_F",30,0,0],                                       // Rifleman (AT)
    ["B_T_Soldier_GL_F",25,0,0],                                        // Grenadier
    ["B_T_Soldier_AR_F",25,0,0],                                        // Autorifleman
    ["B_T_soldier_M_F",30,0,0],                                         // Marksman
    ["B_T_Soldier_AT_F",50,10,0],                                       // AT Specialist
    ["B_T_Soldier_AA_F",50,10,0],                                       // AA Specialist
    ["B_T_Medic_F",30,0,0],                                             // Combat Life Saver
    ["B_T_Engineer_F",30,0,0],                                          // Engineer
    ["B_T_Soldier_Exp_F",30,0,0],                                       // Explosives Specialist
    ["B_T_Recon_F",20,0,0],                                             // Recon Scout
    ["B_T_Recon_LAT_F",30,0,0],                                         // Recon Scout (AT)
    ["B_T_Recon_M_F",30,0,0],                                           // Recon Marksman
    ["B_T_Recon_Medic_F",30,0,0],                                       // Recon Paramedic
    ["B_T_Recon_exp_F",30,0,0],                                         // Recon Demolition Expert
    ["B_T_Sniper_F",70,5,0],                                            // Sniper
    ["B_T_ghillie_tna_F",70,5,0],                                       // Sniper (Jungle)
    ["B_T_Spotter_F",20,0,0],                                           // Spotter
    ["B_T_Crew_F",10,0,0],                                              // Crewman
    ["B_T_Soldier_PG_F",20,0,0],                                        // Para Trooper
    ["B_T_Helicrew_F",10,0,0],                                          // Helicopter Crew
    ["B_T_Helipilot_F",10,0,0],                                         // Helicopter Pilot
    ["B_T_Pilot_F",10,0,0]                                              // Pilot
];

KPLIB_b_vehLight = [
    ["B_T_Quadbike_01_F",20,0,10],                                      // Quad Bike
    ["B_T_LSV_01_unarmed_F",75,0,50],                                   // Prowler
    ["B_T_LSV_01_armed_F",75,40,50],                                    // Prowler (HMG)
    ["B_T_LSV_01_AT_F",75,60,50],                                       // Prowler (AT)
    ["B_T_MRAP_01_F",100,0,50],                                         // Hunter
    ["B_T_MRAP_01_hmg_F",100,40,50],                                    // Hunter (HMG)
    ["B_T_MRAP_01_gmg_F",100,60,50],                                    // Hunter (GMG)
    ["B_UGV_01_F",150,0,50],                                            // UGV Stomper
    ["B_UGV_01_rcws_F",150,40,50],                                      // UGV Stomper (RCWS)
    ["B_T_Boat_Transport_01_F",100,0,25],                               // Assault Boat
    ["B_T_Boat_Armed_01_minigun_F",200,80,75],                          // Speedboat Minigun
    ["B_SDV_01_F",150,0,50]                                             // SDV
];

KPLIB_b_vehHeavy = [
    ["B_T_APC_Wheeled_01_cannon_F",200,75,125],                         // AMV-7 Marshall
    ["B_T_APC_Tracked_01_rcws_F",300,100,150],                          // IFV-6c Panther
    ["B_T_APC_Tracked_01_AA_F",300,250,175],                            // IFV-6a Cheetah
    ["B_T_MBT_01_cannon_F",400,300,200],                                // M2A1 Slammer
    ["B_T_MBT_01_TUSK_F",500,350,225],                                  // M2A4 Slammer UP
    ["B_T_AFV_Wheeled_01_cannon_F",500,500,250],                        // Rhino MGS
    ["B_T_AFV_Wheeled_01_up_cannon_F",550,550,250],                     // Rhino MGS UP
    ["B_T_MBT_01_arty_F",600,1250,300],                                 // M4 Scorcher
    ["B_T_MBT_01_mlrs_F",800,1750,400]                                  // M5 Sandstorm MLRS
];

KPLIB_b_vehAir = [
    ["B_UAV_01_F",75,0,25],                                             // AR-2 Darter
    ["B_UAV_06_F",80,0,30],                                             // AL-6 Pelican (Cargo)
    ["B_Heli_Light_01_F",200,0,100],                                    // MH-9 Hummingbird
    ["B_Heli_Light_01_armed_F",200,100,100],                            // AH-9 Pawnee
    ["B_Heli_Attack_01_F",500,400,200],                                 // AH-99 Blackfoot
    ["B_Heli_Transport_01_F",250,80,150],                               // UH-80 Ghost Hawk
    ["B_Heli_Transport_01_camo_F",250,80,150],                          // UH-80 Ghost Hawk (Camo)
    ["B_Heli_Transport_03_F",300,80,175],                               // CH-67 Huron (Armed)
    ["B_UAV_02_F",400,300,200],                                         // MQ-4A Greyhawk
    ["B_UAV_02_CAS_F",700,500,300],                                     // MQ-4A Greyhawk (CAS)
    ["B_T_UAV_03_F",450,500,250],                                       // MQ-12 Falcon
    ["B_UAV_05_F",500,500,200],                                         // UCAV Sentinel
    ["B_Plane_CAS_01_F",1000,800,400],                                  // A-164 Wipeout (CAS)
    ["B_Plane_Fighter_01_F",1500,1750,450],                             // F/A-181 Black Wasp II
    ["B_Plane_Fighter_01_Stealth_F",1500,1750,450],                     // F/A-181 Black Wasp II (Stealth)
    ["B_T_VTOL_01_armed_F",750,1500,500],                               // V-44 X Blackfish (Armed)
    ["B_T_VTOL_01_infantry_F",750,0,500],                               // V-44 X Blackfish (Infantry)
    ["B_T_VTOL_01_vehicle_F",750,0,500]                                 // V-44 X Blackfish (Vehicle)
];

KPLIB_b_vehStatic = [
    ["B_HMG_01_F",25,40,0],                                             // Mk30A HMG .50
    ["B_HMG_01_high_F",25,40,0],                                        // Mk30 HMG .50 (Raised)
    ["B_HMG_01_A_F",35,40,0],                                           // Mk30 HMG .50 (Autonomous)
    ["B_GMG_01_F",35,60,0],                                             // Mk32A GMG 20mm
    ["B_GMG_01_high_F",35,60,0],                                        // Mk32 GMG 20mm (Raised)
    ["B_GMG_01_A_F",45,60,0],                                           // Mk32 GMG 20mm (Autonomous)
    ["B_T_Static_AT_F",50,100,0],                                       // Static Titan Launcher (AT)
    ["B_T_Static_AA_F",50,100,0],                                       // Static Titan Launcher (AA)
    ["B_Mortar_01_F",80,150,0],                                         // Mk6 Mortar
    ["B_SAM_System_03_F",250,500,0]                                     // MIM-145 Defender
];

KPLIB_b_objectsDeco = [
    ["Land_Cargo_House_V4_F",0,0,0],
    ["Land_Cargo_Patrol_V4_F",0,0,0],
    ["Land_Cargo_Tower_V4_F",0,0,0],
    ["Flag_NATO_F",0,0,0],
    ["Flag_US_F",0,0,0],
    ["Flag_UK_F",0,0,0],
    ["Flag_White_F",0,0,0],
    ["Land_Medevac_house_V1_F",0,0,0],
    ["Land_Medevac_HQ_V1_F",0,0,0],
    ["Flag_RedCrystal_F",0,0,0],
    ["CamoNet_ghex_F",0,0,0],
    ["CamoNet_ghex_open_F",0,0,0],
    ["CamoNet_ghex_big_F",0,0,0],
    ["Land_PortableLight_single_F",0,0,0],
    ["Land_PortableLight_double_F",0,0,0],
    ["Land_LampSolar_F",0,0,0],
    ["Land_LampHalogen_F",0,0,0],
    ["Land_LampStreet_small_F",0,0,0],
    ["Land_LampAirport_F",0,0,0],
    ["Land_HelipadCircle_F",0,0,0],                                     // Strictly aesthetic - as in it does not increase helicopter cap!
    ["Land_HelipadRescue_F",0,0,0],                                     // Strictly aesthetic - as in it does not increase helicopter cap!
    ["PortableHelipadLight_01_blue_F",0,0,0],
    ["PortableHelipadLight_01_green_F",0,0,0],
    ["PortableHelipadLight_01_red_F",0,0,0],
    ["Land_CampingChair_V1_F",0,0,0],
    ["Land_CampingChair_V2_F",0,0,0],
    ["Land_CampingTable_F",0,0,0],
    ["MapBoard_altis_F",0,0,0],
    ["MapBoard_stratis_F",0,0,0],
    ["MapBoard_seismic_F",0,0,0],
    ["Land_Pallet_MilBoxes_F",0,0,0],
    ["Land_PaperBox_open_empty_F",0,0,0],
    ["Land_PaperBox_open_full_F",0,0,0],
    ["Land_PaperBox_closed_F",0,0,0],
    ["Land_DieselGroundPowerUnit_01_F",0,0,0],
    ["Land_ToolTrolley_02_F",0,0,0],
    ["Land_WeldingTrolley_01_F",0,0,0],
    ["Land_Workbench_01_F",0,0,0],
    ["Land_GasTank_01_blue_F",0,0,0],
    ["Land_GasTank_01_khaki_F",0,0,0],
    ["Land_GasTank_01_yellow_F",0,0,0],
    ["Land_GasTank_02_F",0,0,0],
    ["Land_BarrelWater_F",0,0,0],
    ["Land_BarrelWater_grey_F",0,0,0],
    ["Land_WaterBarrel_F",0,0,0],
    ["Land_WaterTank_F",0,0,0],
    ["Land_BagFence_01_round_green_F",0,0,0],
    ["Land_BagFence_01_short_green_F",0,0,0],
    ["Land_BagFence_01_long_green_F",0,0,0],
    ["Land_BagFence_01_corner_green_F",0,0,0],
    ["Land_BagFence_01_end_green_F",0,0,0],
    ["Land_BagBunker_01_small_green_F",0,0,0],
    ["Land_BagBunker_01_large_green_F",0,0,0],
    ["Land_HBarrier_01_tower_green_F",0,0,0],
    ["Land_HBarrier_01_line_1_green_F",0,0,0],
    ["Land_HBarrier_01_line_3_green_F",0,0,0],
    ["Land_HBarrier_01_line_5_green_F",0,0,0],
    ["Land_HBarrier_01_big_4_green_F",0,0,0],
    ["Land_HBarrier_01_wall_4_green_F",0,0,0],
    ["Land_HBarrier_01_wall_6_green_F",0,0,0],
    ["Land_HBarrier_01_wall_corner_green_F",0,0,0],
    ["Land_HBarrier_01_wall_corridor_green_F",0,0,0],
    ["Land_HBarrier_01_big_tower_green_F",0,0,0],
    ["Land_CncBarrierMedium_F",0,0,0],
    ["Land_CncBarrierMedium4_F",0,0,0],
    ["Land_Concrete_SmallWall_4m_F",0,0,0],
    ["Land_Concrete_SmallWall_8m_F",0,0,0],
    ["Land_CncShelter_F",0,0,0],
    ["Land_CncWall1_F",0,0,0],
    ["Land_CncWall4_F",0,0,0],
    ["Land_Sign_WarningMilitaryArea_F",0,0,0],
    ["Land_Sign_WarningMilAreaSmall_F",0,0,0],
    ["Land_Sign_WarningMilitaryVehicles_F",0,0,0],
    ["Land_Razorwire_F",0,0,0],
    ["Land_ClutterCutter_large_F",0,0,0],
    ["Land_Shed_Small_F",0,0,0],
    ["Land_Pier_F",0,0,0],
    ["Land_Sea_Wall_F",0,0,0]
];

KPLIB_b_vehSupport = [
    [(KPLIB_b_mobileRespawn select 0),100,0,0],
    [KPLIB_b_arsenal,100,200,0],
    [KPLIB_b_fobBox,300,500,0],
    [KPLIB_b_fobTruck,300,500,75],
    [KPLIB_b_smallStorage,0,0,0],
    [KPLIB_b_largeStorage,0,0,0],
    [KPLIB_b_logiStation,250,0,0],
    [KPLIB_b_airControl,1000,0,0],
    [KPLIB_b_slotHeli,250,0,0],
    [KPLIB_b_slotPlane,500,0,0],
    ["ACE_medicalSupplyCrate_advanced",50,0,0],
    ["ACE_Box_82mm_Mo_HE",50,40,0],
    ["ACE_Box_82mm_Mo_Smoke",50,10,0],
    ["ACE_Box_82mm_Mo_Illum",50,10,0],
    ["ACE_Wheel",10,0,0],
    ["ACE_Track",10,0,0],
    ["Land_CanisterFuel_F",0,0,2],
    ["B_T_APC_Tracked_01_CRV_F",500,250,350],                           // CRV-6e Bobcat
    ["B_T_Truck_01_transport_F",100,0,100],                             // HEMTT Transport
    ["B_T_Truck_01_covered_F",100,0,100],                               // HEMTT Transport (Covered)
    ["B_T_Truck_01_flatbed_F",100,0,100],                               // HEMTT Transport (Flatbed)
    [(KPLIB_b_mobileRespawn select 1),200,0,100],                       // HEMTT Medevac
    ["B_T_Truck_01_Repair_F",325,0,75],                                 // HEMTT Repair
    ["B_T_Truck_01_fuel_F",125,0,275],                                  // HEMTT Fuel
    ["B_T_Truck_01_ammo_F",125,200,75],                                 // HEMTT Ammo
    [(KPLIB_b_mobileRespawn select 2),200,0,0],                         // Huron Medevac
    ["B_Slingload_01_Repair_F",275,0,0],                                // Huron Repair
    ["B_Slingload_01_Fuel_F",75,0,200],                                 // Huron Fuel
    ["B_Slingload_01_Ammo_F",75,200,0],                                 // Huron Ammo
    [(KPLIB_b_mobileRespawn select 3),200,0,100],                       // LCVP Mk5
    ["rksla3_lcvpmk5_viv_generic_grey",200,0,100]                       // LCVP Mk5 ViV
];

/*
    --- Squads ---
    Pre-made squads for the commander build menu.
    These shouldn't exceed 10 members.
*/

// Light infantry squad.
KPLIB_b_squadLight = [
    "B_T_Soldier_TL_F",
    "B_T_Soldier_F",
    "B_T_Soldier_F",
    "B_T_Soldier_LAT_F",
    "B_T_Soldier_GL_F",
    "B_T_Soldier_AR_F",
    "B_T_Soldier_AR_F",
    "B_T_soldier_M_F",
    "B_T_Medic_F",
    "B_T_Engineer_F"
];

// Heavy infantry squad.
KPLIB_b_squadInf = [
    "B_T_Soldier_TL_F",
    "B_T_Soldier_LAT_F",
    "B_T_Soldier_LAT_F",
    "B_T_Soldier_GL_F",
    "B_T_Soldier_AR_F",
    "B_T_Soldier_AR_F",
    "B_T_Soldier_AR_F",
    "B_T_soldier_M_F",
    "B_T_Medic_F",
    "B_T_Engineer_F"
];

// AT specialists squad.
KPLIB_b_squadAT = [
    "B_T_Soldier_TL_F",
    "B_T_Soldier_F",
    "B_T_Soldier_F",
    "B_T_Soldier_AT_F",
    "B_T_Soldier_AT_F",
    "B_T_Soldier_AT_F",
    "B_T_Medic_F",
    "B_T_Soldier_F"
];

// AA specialists squad.
KPLIB_b_squadAA = [
    "B_T_Soldier_TL_F",
    "B_T_Soldier_F",
    "B_T_Soldier_F",
    "B_T_Soldier_AA_F",
    "B_T_Soldier_AA_F",
    "B_T_Soldier_AA_F",
    "B_T_Medic_F",
    "B_T_Soldier_F"
];

// Force recon squad.
KPLIB_b_squadRecon = [
    "B_T_Recon_TL_F",
    "B_T_Recon_F",
    "B_T_Recon_F",
    "B_T_Recon_LAT_F",
    "B_T_Recon_M_F",
    "B_T_Recon_M_F",
    "B_T_Sniper_F",
    "B_T_Spotter_F",
    "B_T_Recon_Medic_F",
    "B_T_Recon_Exp_F"
];

// Paratroopers squad (The units of this squad will automatically get parachutes on build)
KPLIB_b_squadPara = [
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F",
    "B_T_Soldier_PG_F"
];

// Light infantry vehicle squad.
KPLIB_b_squadVeh = [
    "B_T_Soldier_TL_F",
    "B_T_Soldier_F",
    "B_T_Soldier_F"
];

/*
    --- Vehicles to unlock ---
    Classnames below have to be unlocked by capturing military bases.
*/
KPLIB_b_vehToUnlock = [
    "B_T_MBT_01_TUSK_F",                                                // M2A4 Slammer UP
    "B_T_MBT_01_arty_F",                                                // M4 Scorcher
    "B_T_MBT_01_mlrs_F",                                                // M5 Sandstorm MLRS
    "B_Heli_Attack_01_F",                                               // AH-99 Blackfoot
    "B_UAV_02_F",                                                       // MQ-4A Greyhawk
    "B_UAV_02_CAS_F",                                                   // MQ-4A Greyhawk
    "B_T_UAV_03_F",                                                     // MQ-12 Falcon
    "B_UAV_05_F",                                                       // UCAV Sentinel
    "B_Plane_CAS_01_F",                                                 // A-164 Wipeout (CAS)
    "B_Plane_Fighter_01_F",                                             // F/A-181 Black Wasp II
    "B_Plane_Fighter_01_Stealth_F",                                     // F/A-181 Black Wasp II (Stealth)
    "B_T_VTOL_01_armed_F"                                               // V-44 X Blackfish (Armed)
];
