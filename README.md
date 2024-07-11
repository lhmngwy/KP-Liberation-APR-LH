# KP Liberation APR LH
This is my customised fork of Apricot_ale's fork of KP Liberation. My fork was created for my brother and I to play, the changes are mainly to improve co-op for low player counts.

[![license](https://img.shields.io/github/license/KillahPotatoes/KP-Liberation.svg)](https://github.com/KillahPotatoes/KP-Liberation/blob/master/LICENSE.md)

Apricot_ale's fork is a uniquely modified version of [KP Liberation](https://github.com/KillahPotatoes/KP-Liberation), incorporating several pull requests (PRs) that have already been submitted.

My customisations include:

- Updated vanilla presets, factions have access to all guns. Uniforms and vehicles are still faction restricted.
- Blufor vehicles and HC squads will be saved anywhere on the map.
- Added persistent player squads, disconnect and reconnect and you will still have your squad!
- Redeploy from anywhere, as long as there are no enemies nearby, and no captured hostiles in your squad.
- Alive AI squad members will now redeploy with the player. Unconscious AI squad members will die on redeploy, heal them first!
- Resource penalty when you respawn, to add risk when going without an AI squad:
    - Calculation: "30 of each resource / (number of alive AI in your squad at respawn time + number of AI built in your squad since you respawned + 1)".
    - This means that the penalty reduces the more AI squad members you build, as taking them with you is already a risk.
    - If there's less than 4 enemies nearby you can respawn without penalty.
- Added tents and landing craft as mobile respawn points (See recommended add-ons).

Integrated from others:

- Persistent vehicle cargo, fuel and damage, plus some other changes from https://github.com/moistbois/Moist-Liberation-APR
- Additional map ports by stutpip123: https://github.com/KillahPotatoes/KP-Liberation/pull/854
- pSiKO Ai Revive to enable AI medics to revive: https://steamcommunity.com/sharedfiles/filedetails/?id=2996342068
- Advanced Towing: https://steamcommunity.com/sharedfiles/filedetails/?id=639837898

- More changes to come...

### Required Add-ons
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)

### Recommended Add-ons
- [ACE](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057) with [ACE No Medical](https://steamcommunity.com/sharedfiles/filedetails/?id=3053169823)
- [LAMBS Danger.fsm](https://steamcommunity.com/sharedfiles/filedetails/?id=1858075458)
- [Tent Backpacks](https://steamcommunity.com/sharedfiles/filedetails/?id=2177826065)
- [RKSL Studios - LCVP Mk5 Landing Craft](https://steamcommunity.com/sharedfiles/filedetails/?id=1752496126)
