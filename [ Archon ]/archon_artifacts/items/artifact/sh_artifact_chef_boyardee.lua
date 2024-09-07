ITEM.name = "Can of Chef Boyardee"
ITEM.description = "An enchanted can of Chef Boyardee."
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.category = "Artifacts"
ITEM.width = 1
ITEM.height = 1
ITEM.buffs = {
    {"attribute", "stm", 5},
    {"attribute", "str", 2},
    {"attribute", "end", 9},

    {"modifier", "healthRegen", {10, 5}},
    {"modifier", "healthBoost", 10},
    {"modifier", "movementSpeed", 10}
}