# KP Liberation APR LH
This is my customised fork of Apricot_ale's fork of KP Liberation. It was created for my brother and I to play. The changes improve co-op for low player counts, as well as creating a more dynamic battlefield.

[![license](https://img.shields.io/github/license/KillahPotatoes/KP-Liberation.svg)](https://github.com/KillahPotatoes/KP-Liberation/blob/master/LICENSE.md)

Apricot_ale's fork is a uniquely modified version of [KP Liberation](https://github.com/KillahPotatoes/KP-Liberation), incorporating several pull requests (PRs) that have already been submitted.

My customisations include:

- Updated vanilla presets, factions have access to all guns. Uniforms and vehicles are still faction restricted.
- Enemies will be more spread out around a sector with less predictability.
- The enemy now knows how to use ground troop transports to drop off reinforcements.
- The enemy has the ability to call in reinforcements when attacking your sectors.
- Added persistent player squads, disconnect and reconnect and you will still have your squad!
- Blufor vehicles, captured vehicles and HC squads will be saved anywhere on the map.
- Enemy and civilian vehicles must be taken to a FOB at least once to count as captured.
- AI squad members will now redeploy with the player. Unconscious AI squad members will die on redeploy, heal them first!
- All players on the commander actions whitelist will have access to Zeus (Missionframework/KPLIB_whitelists.sqf).
- Zeus will be regained automatically on respawn.
- Enemy units and structures are hidden from Zeus to prevent it from being used for scouting.
- Resource penalty of up to 40 of each resource when you respawn:
    - The penalty reduces the more AI squad members you build, as taking them with you is already a risk.
    - Respawning while your squad is still alive cancels out the reduction, wait to be revived instead. This also prevents using respawns as fast travel for free.
    - If there's less than 4 enemies nearby you can respawn without penalty.
- Added tents and landing craft as mobile respawn points (See recommended add-ons).
- Civilians will spawn in player sectors.
- Improved civilian waypoints, they will move around the general area and between buildings. They will also go indoors at night or during rain.

Integrated from others:

- pSiKO Ai Revive to enable AI medics to revive: https://steamcommunity.com/sharedfiles/filedetails/?id=2996342068
- VcomAI 3.4.1, only using a subset of features: https://github.com/genesis92x/VcomAI-3.0/tree/3.4.1---Dev-Build/
    - AI will use artillery (If you have lambs installed, that will be used for this instead).
    - AI in combat or stealth mode will steal vehicles, mount static weapons or replace dead gunners.
    - AI will plant mines.
- AI Driving Control: https://forums.bohemia.net/forums/topic/223430-ai-driving-control/
- Advanced Towing: https://steamcommunity.com/sharedfiles/filedetails/?id=639837898
- Soldier Tracker for better map icons: https://github.com/auQuiksilver/Soldier-Tracker
- Arma 3 Performance Extension: https://github.com/Battlekeeper/Arma3PerformanceExtension
- Air, Animals, and soap from TPW Mods for better ambience: https://steamcommunity.com/sharedfiles/filedetails/?id=2586787720
- Persistent vehicle cargo, fuel and damage, plus some other changes from https://github.com/moistbois/Moist-Liberation-APR
- Additional map ports by stutpip123: https://github.com/KillahPotatoes/KP-Liberation/pull/854

- More changes to come...

### Required Add-ons
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)

### Recommended Add-ons
- [ACE](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) with [ACE No Medical](https://steamcommunity.com/sharedfiles/filedetails/?id=3053169823)
- [LAMBS Danger.fsm](https://steamcommunity.com/sharedfiles/filedetails/?id=1858075458)
- [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631)
- [Tent Backpacks](https://steamcommunity.com/sharedfiles/filedetails/?id=2177826065)
- [RKSL Studios - LCVP Mk5 Landing Craft](https://steamcommunity.com/sharedfiles/filedetails/?id=1752496126)
