/*
    File: allowedExtension.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-05-11
    Last Update: 2020-05-11
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        List of classnames which will be always added to the allowed gear list.
        This is used to add let's name it "generic classnames".

        E.g. if you've an available weapon "myMod_weap_M16" and an available grip "myMod_acc_coolGrip"
        some mods transform this combination to a weapon "myMod_weap_M16_coolGrip".
        That classname is used internally and wouldn't be listed in the arsenal and can cause issues to be
        detected as not allowed weapon, even if the weapon and the grip is whitelisted.
        So add this "generic classname" here afterwards to avoid this.

        The classnames of blacklisted items on a player are logged in the server rpt for a later lookup.
*/

// Extension list of allowed arsenal gear
KPLIB_arsenalAllowedExtension = [
    "ACE_PreloadedMissileDummy_CUP",
    "ACE_PreloadedMissileDummy_Igla_CUP",
    "ACE_PreloadedMissileDummy_M72A6_CUP",
    "ACE_PreloadedMissileDummy_NLAW_CUP",
    "ACE_PreloadedMissileDummy_RPG18_CUP",
    "ACE_PreloadedMissileDummy_Stinger_CUP",
    "ACE_PreloadedMissileDummy_Strela_2_CUP",
    "ACE_ReserveParachute",
    //ACE Start
    "ACE_adenosine",
    "ACE_salineIV",
    "ACE_salineIV_250",
    "ACE_salineIV_500",
    "acex_intelitems_notepad",
    "ACE_Fortify",
    "ACE_CableTie",
    "ToolKit",
    "ACE_EarPlugs",
    "ACE_wirecutter",
    "ACE_MapTools",
    "ACE_fieldDressing",
    "ACE_bloodIV",
    "ACE_bloodIV_250",
    "ACE_bloodIV_500",
    "ACE_bodyBag",
    "ACE_epinephrine",
    "ACE_morphine",
    "ACE_personalAidKit",
    "ACE_Sandbag_empty",
    "ACE_tourniquet",
    "ACE_SpareBarrel",
    "ACE_EntrenchingTool",
    "ACE_rope12", 
    "ACE_rope15",
    "ACE_rope18",
    "ACE_rope27",
    "ACE_rope36",
    "ACE_elasticBandage",
    "ACE_packingBandage",
    "ACE_quikclot",
    "ItemMap",
    "ItemCompass",
    "ACE_splint",
    "ACE_Banana",
    "ACE_Canteen_Half",
    "ACE_Canteen_Empty",
    "ACE_Canteen",
    "ACE_Sunflower_Seeds",
    "ACE_surgicalKit",
    "ACE_artilleryTable",                                           // Artillery Rangetable
    "ACE_RangeCard",                                                // Range Card
    "ACE_RangeTable_82mm",                                          // 82 mm Rangetable
    "ACE_LIB_FireCord",
    "ACE_PlottingBoard",
    "ACE_WaterBottle",
    "ACE_WaterBottle_Half",
    "ACE_WaterBottle_Empty"
    
    //ACE End
];