local PLUGIN = PLUGIN

function PLUGIN:PrePlayerLoadedCharacter(client, character, currentChar)
    if (IsValid(currentChar) and currentChar:GetFaction() != CHUMTOAD) then return end
    client:SetMaxHealth(100)
    client:SetViewOffset(Vector(0,0,64))
    client:SetViewOffsetDucked(Vector(0, 0, 32))
    client:ResetHull()
    client:SetWalkSpeed(ix.config.Get("walkSpeed"))
    client:SetRunSpeed(ix.config.Get("runSpeed"))
    client:SetJumpPower(200)
end


function PLUGIN:PlayerSpawn(client)
    if client:Team() == FACTION_CHUMTOAD then
        timer.Simple(0.1, function()
            client:SetJumpPower(200 * ix.config.Get("chumtoadJumpPower", 2))
            client:SetWalkSpeed(ix.config.Get("chumtoadMovementSpeed", 65))
            client:SetRunSpeed(ix.config.Get("chumtoadMovementSpeed", 65)*1.5)
            client:SetMaxHealth(ix.config.Get("chumtoadHealth", 25))
            client:SetHealth(ix.config.Get("chumtoadHealth", 25))
            client:StripWeapon("ix_keys")
        end)
    end
end