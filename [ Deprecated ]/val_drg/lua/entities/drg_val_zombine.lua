if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Zombine"
ENT.Category = "Val's Nextbots"
ENT.Models = {"models/zombie/zombie_soldier.mdl"}
ENT.CollisionBounds = Vector(15, 15, 65)
ENT.BloodColor = BLOOD_COLOR_GREEN
ENT.RagdollOnDeath = true

-- Stats --
ENT.SpawnHealth = 600
ENT.HealthRegen = 1
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
	--ENT.OnIdleSounds = {"npc/zombine/zombine_idle1.wav", "npc/zombine/zombine_idle2.wav", "npc/zombine/zombine_idle3.wav", "npc/zombine/zombine_idle4.wav"}
	--ENT.IdleSoundDelay = 16
	ENT.ClientIdleSounds = false
	ENT.OnDamageSounds = {"npc/zombine/zombine_pain1.wav", "npc/zombine/zombine_pain2.wav", "npc/zombine/zombine_pain3.wav", "npc/zombine/zombine_pain4.wav"}
	ENT.DamageSoundDelay = 2
	ENT.OnDeathSounds = {"npc/zombine/zombine_die1.wav", "npc/zombine/zombine_die2.wav"}

-- AI --
	ENT.Omniscient = false
	ENT.SpotDuration = 60
	ENT.RangeAttackRange = 0
	ENT.MeleeAttackRange = 60
	ENT.ReachEnemyRange = 50
	ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Locomotion --
ENT.Acceleration = 250
ENT.Deceleration = 250

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 0.8
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 35
ENT.RunSpeed = 160

-- Climbing --
	ENT.ClimbLedges = false
	ENT.ClimbLedgesMaxHeight = math.huge
	ENT.ClimbLedgesMinHeight = 0
	ENT.LedgeDetectionDistance = 20
	ENT.ClimbProps = false
	ENT.ClimbLadders = false
	ENT.ClimbLaddersUp = true
	ENT.LaddersUpDistance = 20
	ENT.ClimbLaddersUpMaxHeight = math.huge
	ENT.ClimbLaddersUpMinHeight = 0
	ENT.ClimbLaddersDown = false
	ENT.LaddersDownDistance = 20
	ENT.ClimbLaddersDownMaxHeight = math.huge
	ENT.ClimbLaddersDownMinHeight = 0
	ENT.ClimbSpeed = 60
	ENT.ClimbUpAnimation = ACT_CLIMB_UP
	ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
	ENT.ClimbAnimRate = 1
	ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
	ENT.EyeBone = "ValveBiped.Bip01_Head"
	ENT.EyeOffset = Vector(7.5, 0, 5)
	ENT.EyeAngle = Angle(0, 0, 0)
	ENT.SightFOV = 110
	ENT.SightRange = 1500
	ENT.MinLuminosity = 0
	ENT.MaxLuminosity = 1
	ENT.HearingCoefficient = 1

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
	  offset = Vector(5, 30, 20),
	  distance = 60
	},
	{eyepos = true}
}
ENT.PossessionBinds = {
    -- Passive
    [IN_SPEED] = {{
        coroutine = true,
        onkeydown = function(self)
            if self.RunSpeed >= 100 and self:GetCooldown("zombGear") <= 0 then
                self:EmitSound("npc/zombine/gear"..math.random(3)..".wav", 75, 100, math.random(0.6, 1.1))
                self:SetCooldown("zombGear", 0.38)
            end    
        end
    }},
    [IN_USE] = {{
        coroutine = false,
        onkeydown = function(self)
            for k,v in pairs(ents.FindInSphere(self:WorldSpaceCenter(),100)) do
                if string.find(v:GetClass(),"door") then v:Fire("open") end
            end
        end
    }},
    -- Combat
    [IN_ATTACK] = {{
      coroutine = true,
      onkeydown = function(self)
        self:EmitSound("Zombie.Attack")
        self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
      end
    }},
    [IN_ATTACK2] = {{
        coroutine = true,
        onkeydown = function(self)
          self:EmitSound("npc/zombine/zombine_readygrenade"..math.random(2)..".wav")
          self:ZombineGrenade()
          self:PlaySequenceAndMove("pullgrenade", 1, self.PossessionFaceForward)
        end
    }}
}

if SERVER then
	function ENT:ZombineGrenade()
        local nade = ents.Create("npc_grenade_frag")
        nade:SetPos(self:GetPos())
        nade:SetAngles(self:GetAngles())
        nade:Spawn()
        nade:SetOwner(self)
        nade:SetParent(self)
		nade:Fire("SetTimer", 4)
        nade:Fire("setparentattachment","grenade_attachment")
		timer.Simple(4, function()
			local boom1 = ents.Create("proj_drg_grenade")
			boom1:SetPos(self:GetPos())
			boom1:SetAngles(self:GetAngles())
			boom1:Spawn()
			boom1:Detonate()
		end)
    	self.IdleAnimation = "idle_grenade"
    	self.WalkAnimation = "walk_all_grenade"
    	self.RunAnimation = "run_all_grenade"
		timer.Simple(4.01, function()self:Suicide()end)
	end
  function ENT:CustomInitialize()
    self:SetBodygroup(1, 1)
  	self:SetDefaultRelationship(D_HT)
  end

  function ENT:CustomThink() end
  
  function ENT:OnAnimEvent()
    if self:IsAttacking() and self:GetCycle() > 0.3 then
      self:Attack({
        damage = 20,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound("Zombie.AttackHit")
        else self:EmitSound("Zombie.AttackMiss") end
      end)
    elseif math.random(2) == 1 then
      self:EmitSound("Zombie.FootstepLeft")
    else self:EmitSound("Zombie.FootstepRight") end
  end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)
  function ENT:OnMeleeAttack(enemy) 
    self:EmitSound("Zombie.Attack")
    self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
  end
  function ENT:OnRangeAttack(enqemy) end
  function ENT:OnChaseEnemy(enemy) 
	  if self.RunSpeed >= 100 and self:GetCooldown("zombGear") <= 0 then
		  self:EmitSound("npc/zombine/gear"..math.random(3)..".wav", 75, 100, math.random(0.7, 1.1))
		  self:SetCooldown("zombGear", 0.38)
	  end
  end
  function ENT:OnAvoidEnemy(enemy) end

  -- These hooks are called while the nextbot is patrolling (inside the coroutine)
  function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7))
  end 

  -- These hooks are called when the current enemy changes (outside the coroutine)
  function ENT:OnNewEnemy(enemy) 
	self:EmitSound("npc/zombine/zombine_alert"..math.random(7)..".wav", 75, 100, math.random(0.7, 1.1))
  end
  function ENT:OnEnemyChange(oldEnemy, newEnemy) end
  function ENT:OnLastEnemy(enemy) end

  -- Those hooks are called inside the coroutine
  function ENT:OnSpawn()
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Called outside the coroutine
  function ENT:OnTakeDamage(dmg, hitgroup)
    self:SpotEntity(dmg:GetAttacker())
  end
  function ENT:OnFatalDamage(dmg, hitgroup) end
  
  -- Called inside the coroutine
  function ENT:OnTookDamage(dmg, hitgroup) end
  function ENT:OnDeath(dmg, hitgroup) end
  function ENT:OnDowned(dmg, hitgroup) end

else

  function ENT:CustomInitialize() end
  function ENT:CustomThink() end
  function ENT:CustomDraw() end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)