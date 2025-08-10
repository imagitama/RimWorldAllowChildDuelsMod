using HarmonyLib;
using RimWorld;
using Verse;
using RimWorldAllowChildDuelsMod;

[StaticConstructorOnStartup]
public static class AllowChildDuels_DefEdit
{
    static AllowChildDuels_DefEdit()
    {
        var harmony = new Harmony("rimworld.allowchildduels");
        harmony.PatchAll();

        var duelBehavior = DefDatabase<RitualBehaviorDef>.GetNamedSilentFail("GladiatorDuel");
        if (duelBehavior != null && duelBehavior.roles != null)
        {
            foreach (var role in duelBehavior.roles)
            {
                if (role.id != null && role.id.StartsWith("duelist"))
                {
                    role.allowChild = true;
                    Logger.LogMessage($"Patched role {role.id} to allow children");
                }
            }
        }
        else
        {
            Logger.LogMessage("Could not find GladiatorDuel behavior or roles");
        }
    }
}
