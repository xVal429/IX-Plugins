local PLUGIN = PLUGIN
PLUGIN.name = "Door Kicking"
PLUGIN.author = "Val"
PLUGIN.description = "A command to kick down a door, which checks to see if you're the proper faction or your strength is enough."

ix.command.Add("doorkick", {
	description = "Attempt to kick a door open.",
	OnRun = function(self, client, ply)
		if client:Team() == FACTION_OTA or client:Team() == FACTION_MPF or client:Team() == FACTION_VORTIGAUNT then
			local see = client:GetEyeTraceNoCursor()
			if see.Entity:GetClass() =="prop_door_rotating" then
				if client:Team() == FACTION_MPF then -- beginning of MPF injection
					local inject = Sound("npc/metropolice/vo/inject.wav")
					local function doorOpen()
						client:ForceSequence("kickdoorbaton")
						timer.Simple(1.1, function()
							see.Entity:Fire("Unlock")
							see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
							see.Entity:Fire("Open")
							client:Notify("You successfully kicked the door open!")
						end)
					end
					client:EmitSound(inject)
					timer.Simple(SoundDuration(inject), doorOpen) -- end of MPF injection
				elseif client:Team() == FACTION_OTA then -- beginning of OTA injection
						client:ForceSequence("range_fistse_noga_1")
						timer.Simple(0.4, function()
							see.Entity:Fire("Unlock")
							see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
							see.Entity:Fire("Open")
							client:Notify("You successfully kicked the door open!")
						end) -- end of OTA injection
				else
					see.Entity:Fire("Unlock")
					see.Entity:Fire("Open")
					client:Notify("You successfully kicked the door open!")
					see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
				end
			else
				client:Notify("This is not a valid door!")
			end
		else
			if client:Team() != FACTION_OTA or client:Team() != FACTION_MPF or client:Team() != FACTION_VORTIGAUNT then -- non mpf/ota/vort time :)
				local att = client:GetCharacter():GetAttribute("str")
				if(att >= 50) then
					local see = client:GetEyeTraceNoCursor()
					local chance = math.random(0, 10)
					if see.Entity:GetClass() =="prop_door_rotating" then
						if (chance >= 7) then
							see.Entity:Fire("Unlock")
							see.Entity:Fire("Open")
							client:Notify("You successfully kicked the door open.")
							see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
						elseif (chance < 7) then
							client:Notify("You fail to kick the door open.")
						end
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