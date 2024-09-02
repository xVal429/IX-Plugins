FACTION.name = "Chumtoad"
FACTION.description = "A small, amphibious creature native to the home world of Xen."
FACTION.color = Color(64, 224, 208)
FACTION.isDefault = false
FACTION.models = {"models/vj_hlr/hl1/chumtoad.mdl"}

function FACTION:OnSpawn(client)
	local character = client:GetCharacter()
	local inventory = character:GetInventory()
    timer.Simple(.1, function()
        local hull = Vector(19.46, 18.01, 13.65) -- obtain with easy entity inspector
        client:SetHull(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
        client:SetHullDuck(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
        
        -- Calculate view offsets based on hull dimensions with a higher vertical offset
        local verticalOffset = 2
        local viewOffset = Vector(0, 0, hull.z / 2 + verticalOffset)
        local viewOffsetDucked = Vector(0, 0, hull.z / 2 + verticalOffset)
        local currentViewOffset = Vector(0, hull.z / 2 + verticalOffset, 0)
        
        client:SetViewOffset(viewOffset)
        client:SetViewOffsetDucked(viewOffsetDucked)
        client:SetCurrentViewOffset(currentViewOffset)

		inventory:SetSize(3, 2)
    end)
end

FACTION_CHUMTOAD = FACTION.index