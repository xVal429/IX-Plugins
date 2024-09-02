local PLUGIN = PLUGIN

PLUGIN.name = "Archon Factions - Chumtoad"
PLUGIN.author = "Val"
PLUGIN.description = "An entire plugin dedicated to one creature: The Chumtoad."

ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")


-- CHUMTOAD
    ix.config.Add("chumtoadMovementSpeed", 65, "The base rate (in Hammer Units Per Second) that Chumtoads can move." , nil, {
        data = {min = 1, max = 200},
        category = "Factions"})
    ix.config.Add("chumtoadJumpPower", 2, "The multiplier that is applied to the base player jump power (default 200). If set to 2, the Chumtoads jump power will be 400.", nil, {
        data = {min = 1, max = 10},
        category = "Factions"})
    ix.config.Add("chumtoadHealth", 25, "The amount of health that Chumtoads spawn with.", nil, {
        data = {min = 1, max = 100},
        category = "Factions"})

    ix.option.Add("chumtoadEffects", ix.type.bool, true, {
        category = "Accessibility",
        description = "Enables the Chumtoad color modification and overlay effects while in first person."})