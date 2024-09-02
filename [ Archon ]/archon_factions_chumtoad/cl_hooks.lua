local chumtoadOverlay = ix.util.GetMaterial("effects/tp_eyefx/tpeye2")

function PLUGIN:RenderScreenspaceEffects()
    local faction = LocalPlayer():Team()
    local isThirdPerson = ConVarExists("simple_thirdperson_enabled") and GetConVar("simple_thirdperson_enabled"):GetBool()

    if faction == FACTION_CHUMTOAD and not isThirdPerson and ix.option.Get("chumtoadEffects", true) then
        local chumtoadColoring = {
            ["$pp_colour_addr"] = 0.02,
            ["$pp_colour_addg"] = 0,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = 0.01,
            ["$pp_colour_contrast"] = 3.5,
            ["$pp_colour_colour"] = 0.6,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0,
        }
        DrawColorModify(chumtoadColoring)

        chumtoadOverlay:SetFloat("$alpha", 0.3)
        chumtoadOverlay:SetInt("$ignorez", 1)
        render.SetMaterial(chumtoadOverlay)
        render.DrawScreenQuad()

        local dlight = DynamicLight(LocalPlayer():EntIndex())
        if dlight then
            dlight.pos = LocalPlayer():GetPos() + Vector(0, 0, 50) -- light goes above the player a bit
            dlight.r = 100
            dlight.g = 0
            dlight.b = 0
            dlight.brightness = 1
            dlight.Decay = 1000
            dlight.Size = 256
            dlight.DieTime = CurTime() + 0.1
        end
    else
        local default = {
            ["$pp_colour_addr"] = 0,
            ["$pp_colour_addg"] = 0,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = 0,
            ["$pp_colour_contrast"] = 1,
            ["$pp_colour_colour"] = 1,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0
        }
        DrawColorModify(default)
    end
end