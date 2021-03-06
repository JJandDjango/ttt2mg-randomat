if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_grave_health = {
    slider = true,
    min = 1,
    max = 100,
    desc = "(Def. 30)"
  },

  ttt2_minigames_grave_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "(Def. 3)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "RISE FROM YOUR GRAVE!"
    },
    desc = {
      English = "The dead will return as Infected!"
    }
  }
else
  ttt2_minigames_grave_health = CreateConVar("ttt2_minigames_grave_health", "30", {FCVAR_ARCHIVE}, "Health of Infected respawned")
  ttt2_minigames_grave_delay = CreateConVar("ttt2_minigames_grave_delay", "3", {FCVAR_ARCHIVE}, "Respawn delay for minigame")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("PostPlayerDeath", "GraveMinigame", function(ply)
      if ply.RisenForRound == true then return end

      ply:Revive(
        ttt2_minigames_grave_delay:GetInt(),
        function()
          ply:SetRole(ROLE_INFECTED)
          ply:SetHealth(ttt2_minigames_grave_health:GetInt())
          ply:SetMaxHealth(ttt2_minigames_grave_health:GetInt())
          ply.RisenForRound = true
          SendFullStateUpdate()
        end,
        nil,
        true,
        false
      )
      ply:SendRevivalReason("RISE FROM YOUR GRAVE!")
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "GraveMinigame")
  end
end
