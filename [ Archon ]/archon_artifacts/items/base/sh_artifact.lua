ITEM.name = "Artifact Base"
ITEM.description = "A placeholder artifact."
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl"
ITEM.category = "Artifacts"
ITEM.width = 1
ITEM.height = 1
ITEM.buffs = {}
-- example:
--[[ITEM.buffs = {
    {"attribute", "stm", 5},
    {"attribute", "str", 2},
    {"attribute", "end", 9},

    {"modifier", "healthRegen", {10, 5}},
    {"modifier", "healthBoost", 10},
    {"modifier", "movementSpeed", 10}
}]]

-- Inventory drawing
if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        if item:GetData("equip") then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end

    function ITEM:PopulateTooltip(tooltip)
        local buffs = self.buffs
        if buffs then
            local title = tooltip:AddRow("buffs")
            title:SetText("Effects")
            title:SetBackgroundColor(Color(0, 128, 255))
            title:SizeToContents()

            for _, buff in ipairs(buffs) do
                local buffType, buffID, buffAmount = unpack(buff)
                local text = self:GetBuffText(buffType, buffID, buffAmount)
                local row = tooltip:AddRow("buff_" .. buffID)
                row:SetText(text)
                row:SizeToContents()
            end
        end
    end

    function ITEM:GetBuffText(buffType, buffID, buffAmount)
        if buffType == "attribute" then
            return string.format("- Increases %s by %d", buffID, buffAmount)
        elseif buffType == "modifier" then
            if buffID == "healthRegen" then
                return string.format("- Restores %d health every %d seconds", buffAmount[1], buffAmount[2])
            elseif buffID == "healthBoost" then
                return string.format("- Increases maximum health by %d", buffAmount)
            elseif buffID == "movementSpeed" then
                return string.format("- Increases movement speed by %d", buffAmount)
            end
        end
        return ""
    end
end

function ITEM:AddArtifact(client)
    local character = client:GetCharacter()
    self:SetData("equip", true)
    self:ApplyBuffs(character)
    self:OnEquipped()
end

function ITEM:RemoveArtifact(client)
    local character = client:GetCharacter()
    self:SetData("equip", false)
    self:RemoveBuffs(character)
    self:OnUnequipped()
end

function ITEM:ApplyBuffs(character)
    if istable(self.buffs) then
        for _, buff in ipairs(self.buffs) do
            local buffType, buffID, buffAmount = unpack(buff)
            if buffType == "attribute" then
                character:AddBoost(self.uniqueID, buffID, buffAmount)
            elseif buffType == "modifier" then
                self:ApplyModifier(character:GetPlayer(), buffID, buffAmount)
            end
        end
    end
end

function ITEM:RemoveBuffs(character)
    if istable(self.buffs) then
        for _, buff in ipairs(self.buffs) do
            local buffType, buffID, buffAmount = unpack(buff)
            if buffType == "attribute" then
                character:RemoveBoost(self.uniqueID, buffID)
            elseif buffType == "modifier" then
                self:RemoveModifier(character:GetPlayer(), buffID, buffAmount)
            end
        end
    end
end

function ITEM:ApplyModifier(client, modifier, amount)
    if modifier == "healthRegen" then
        self:StartHealthRegen(client, amount)
    elseif modifier == "healthBoost" then
        client:SetMaxHealth(client:GetMaxHealth() + amount)
    elseif modifier == "movementSpeed" then
        client:SetWalkSpeed(client:GetWalkSpeed() + amount)
        client:SetRunSpeed(client:GetRunSpeed() + amount)
    end
end

function ITEM:RemoveModifier(client, modifier, amount)
    if modifier == "healthRegen" then
        self:StopHealthRegen(client)
    elseif modifier == "healthBoost" then
        client:SetMaxHealth(client:GetMaxHealth() - amount)
    elseif modifier == "movementSpeed" then
        client:SetWalkSpeed(client:GetWalkSpeed() - amount)
        client:SetRunSpeed(client:GetRunSpeed() - amount)
    end
end

function ITEM:StartHealthRegen(client, amount)
    local healthAmount, interval = amount[1], amount[2]
    local timerID = "HealthRegen_" .. client:SteamID()

    timer.Create(timerID, interval, 0, function()
        if IsValid(client) and client:Alive() then
            client:SetHealth(math.min(client:GetMaxHealth(), client:Health() + healthAmount))
        else
            timer.Remove(timerID)
        end
    end)
end

function ITEM:StopHealthRegen(client)
    local timerID = "HealthRegen_" .. client:SteamID()
    timer.Remove(timerID)
end

ITEM.functions.EquipUn = {
    name = "Unequip",
    tip = "equipTip",
    icon = "icon16/cross.png",
    OnRun = function(item)
        item:RemoveArtifact(item.player)
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
            hook.Run("CanPlayerUnequipItem", client, item) ~= false
    end
}

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(item)
        local client = item.player
        local char = client:GetCharacter()
        local items = char:GetInventory():GetItems()

        if item:HasEquippedArtifact(items) then
            client:NotifyLocalized("You can only equip one artifact at a time.")
            return false
        end

        item:AddArtifact(client)
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        return not IsValid(item.entity) and IsValid(client) and item:GetData("equip") ~= true and
            hook.Run("CanPlayerEquipItem", client, item) ~= false
    end
}

function ITEM:HasEquippedArtifact(items)
    for _, v in pairs(items) do
        if v.id ~= self.id and v.category == "Artifacts" and v:GetData("equip") then
            return true
        end
    end
    return false
end

function ITEM:CanTransfer(oldInventory, newInventory)
    return not (newInventory and self:GetData("equip"))
end

function ITEM:OnRemoved()
    if self.invID ~= 0 and self:GetData("equip") then
        self.player = self:GetOwner()
        self:RemoveArtifact(self.player)
        self.player = nil
    end
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end