local PLUGIN = PLUGIN
PLUGIN.name = "Door Kicking"
PLUGIN.author = "Val"
PLUGIN.description = "A command to kick down a door, which checks to see if you're the proper faction or your strength is enough."

ix.command.Add("doorkick", {
	description = "Attempt to kick a door.",
	OnRun = function(self, client, ply)
		if client:Team() == FACTION_OTA or client:Team() == FACTION_MPF or client:Team() == FACTION_VORTIGAUNT then
			local see = client:GetEyeTraceNoCursor()
			if see.Entity:GetClass() =="prop_door_rotating" then
				see.Entity:Fire("Unlock")
				see.Entity:Fire("Open")
				client:Notify("You successfully kicked the door open!")
				see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
			else
				client:Notify("This is not a valid door!")
			end
		else
			if client:Team() != FACTION_OTA or client:Team() != FACTION_MPF or client:Team() != FACTION_VORTIGAUNT then
				local att = client:GetCharacter():GetAttribute("str")
				if(att >= 30) then
					local see = client:GetEyeTraceNoCursor()
					if see.Entity:GetClass() =="prop_door_rotating" then
						see.Entity:Fire("Unlock")
						see.Entity:Fire("Open")
						client:Notify("You successfully kicked the door open!")
						see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
					else
						client:Notify("This is not a valid door!")
					end
				else
					client:Notify("You're too weak to kick down this door!")
				end
			end
		end
	end
})