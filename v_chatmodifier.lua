local PLUGIN = PLUGIN
PLUGIN.name = "Chat Prefix & Suffix"
PLUGIN.author = "Val"
PLUGIN.description = "Allows players to set a custom prefix and suffix for their chat messages. /chatmodifier [prefix] [suffix] to set, /chatmodifier \"\" \"\" to disable."
PLUGIN.chatTypes = {"ic", "w", "y", "dispatch"}
PLUGIN.invalidModifiers = {"", "nil", "false"} -- Effectively disables the modifier if the prefix or suffix is one of these values. Can be used to blacklist certain prefixes or suffixes if needed.

ix.lang.AddTable("english", {
    cmdChatModifier = "Set a custom prefix and suffix for your messages. /ChatModifier \"\" \"\" to disable.",
    cmdChatModifierEnabled = "You have set your chat modifier.",
    cmdChatModifierExample = "%s This is an example message. %s",
    cmdChatModifierDisabled = "You have disabled the chat modifier."
})

ix.command.Add("ChatModifier", {
    description = "@cmdChatModifier",
    arguments = { ix.type.string, ix.type.string },
    OnRun = function(self, client, prefix, suffix)
        if prefix and suffix and not table.HasValue(PLUGIN.invalidModifiers, prefix) and not table.HasValue(PLUGIN.invalidModifiers, suffix) then
            client:SetVar("chatModifier", {prefix = prefix, suffix = suffix})
            client:NotifyLocalized("cmdChatModifierEnabled")
            client:NotifyLocalized("cmdChatModifierExample", prefix, suffix)
        else
            client:SetVar("chatModifier", nil)
            client:NotifyLocalized("cmdChatModifierDisabled")
        end
    end
})

function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
    if table.HasValue(self.chatTypes, chatType) then
        local modifier = speaker:GetVar("chatModifier", false)
        if modifier and not table.HasValue(self.invalidModifiers, modifier.prefix) and not table.HasValue(self.invalidModifiers, modifier.suffix) then
            return string.format("%s %s %s", modifier.prefix, text, modifier.suffix)
        end
    end
end
