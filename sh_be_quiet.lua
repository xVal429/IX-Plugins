local PLUGIN = PLUGIN

PLUGIN.name = "Be Quiet!"
PLUGIN.author = "Val"
PLUGIN.description = "Adds a command to toggle a character's pain sounds."

if SERVER then
    local oldPlayerHurt = GM.PlayerHurt

    function GM:PlayerHurt(client, attacker, health, damage)
        if client:GetCharacter():GetData("painSounds", true) then
            oldPlayerHurt(self, client, attacker, health, damage)
        end
    end

    ix.command.Add("TogglePainSounds", {
        description = "Toggles your character's pain sounds.",
        OnRun = function(self, client)
            local character = client:GetCharacter()
            local painSounds = character:GetData("painSounds", true)

            character:SetData("painSounds", not painSounds)

            local message = painSounds and "Pain sounds have been disabled." or "Pain sounds have been enabled."
            client:Notify(message)
        end
    })
end