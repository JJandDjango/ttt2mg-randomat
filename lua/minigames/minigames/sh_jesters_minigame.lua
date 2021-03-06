if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_jesters_base_traitor = {
    checkbox = true,
    desc = "(Def. 1)"
  },

  ttt2_minigames_jesters_base_detective = {
    checkbox = true,
    desc = "(Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Jesters!"
    },
    desc = {
      English = "One traitor, One Detective. Everyone else is a jester. Detective is stronger."
    }
  }
else
  ttt2_minigames_jesters_base_traitor = CreateConVar("ttt2_minigames_jesters_base_traitor", "1", {FCVAR_ARCHIVE}, "Force the sole traitor to be a base traitor")
  ttt2_minigames_jesters_base_detective = CreateConVar("ttt2_minigames_jesters_base_detective", "1", {FCVAR_ARCHIVE}, "Force the sole traitor to be a base detective")
end

if SERVER then
  function DetectiveCheck()
    local d = 0
    for _, ply in ipairs(player.GetAll()) do
      if d == 1 then return true end
      if ply:Alive() and ply:GetBaseRole() == ROLE_DETECTIVE then
        d = 1
      end
    end
    if d > 0 then
      return true
    else
      return false
    end
  end

  function MINIGAME:IsSelectable()
    return DetectiveCheck()
  end

  function MINIGAME:OnActivation()
    if not DetectiveCheck() then
      print("[TTT2][MINIGAMES][sh_jesters_minigame] Error: No Valid Detective!")
      return false
    end
    local tx = 0
    local dx = 0
    for _, ply in ipairs(player.GetAll()) do
      if (ply:HasTeam(TEAM_TRAITOR) and tx == 0) or (ply:GetBaseRole() == ROLE_DETECTIVE and dx == 0) then
        if ply:GetBaseRole() ~= ROLE_DETECTIVE then
          if ply:GetSubRole() ~= ROLE_TRAITOR and ttt2_minigames_jesters_base_traitor:GetBool() then ply:SetRole(ROLE_TRAITOR) end
          tx = 1
        else
          if ply:GetSubRole() ~= ROLE_DETECTIVE and ttt2_minigames_jesters_base_detective:GetBool() then ply:SetRole(ROLE_DETECTIVE) end
          dx = 1
          ply:SetHealth(200)
          ply:SetMaxHealth(200)
        end
      else
        ply:SetRole(ROLE_JESTER)
        for k, wep in ipairs(ply:GetWeapons()) do
          if wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2 then
            ply:StripWeapon(wep:GetClass())
          end
        end
      end
    end
    SendFullStateUpdate()
  end

  function MINIGAME:OnDeactivation()

  end
end
