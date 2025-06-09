include("autorun/client/cl_betterinfo_icontext.lua")
include("autorun/client/cl_betterinfo_timetext.lua")

local PANEL = {}

function PANEL:Init()
    self.avatar_label = vgui.Create("IconWithText", self)
    self.avatar_label:SetImage("null")
    self.avatar_label:SetText("Player")

    self.role_colour = Color(0,255,0)

    self.icons = {}
end

function PANEL:SetPlayer(ply)
    if IsValid(ply) then
        self.avatar_label.icon:SetPlayer(ply, 32)
        local name = ply:Nick()
        if #name > 32 then
            name = string.sub(name, 1, 32) .. "…"
        end
        self.avatar_label:SetText(name)
        self.avatar_label.label:SetFont("DermaDefaultBold")
    end
end

function PANEL:PerformLayout(w, h)
    local padding = 10
    local x = padding
    local tallest = 0

    -- Layout avatar label
    self.avatar_label:SizeToContents()
    self.avatar_label:SetPos(x, 0)
    x = x + self.avatar_label:GetWide() + 8
    tallest = math.max(tallest, self.avatar_label:GetTall())

    -- Layout icons, removing invalid ones
    for i = #self.icons, 1, -1 do
        local icon = self.icons[i]
        if not IsValid(icon) then
            table.remove(self.icons, i)
            continue
        end

        icon:SizeToContents()
        icon:SetPos(x, 0)
        x = x + icon:GetWide() + 4
        tallest = math.max(tallest, icon:GetTall())
    end

    self:SetSize(x + padding, tallest)
end

local function FindNickFromIDX(last_id)
  local player = Entity(last_id)
  return player:Nick()
end

function PANEL:AddSearchResults(search_results_raw)
  if not self.search_results then
    -- Take non-optional information
    local player_role = search_results_raw["role"]
    self:UpdatePlayerRole(player_role)
    local death_time = search_results_raw["dtime"]
    self:AddTimeText(death_time)
    -- Show either the weapon that killed them or cause of death
    local cause_of_death = self:FindCauseOfDeath(search_results_raw["wep"], search_results_raw["dmg"])
    self:AddIconWithText(cause_of_death["icon"], cause_of_death["text"])
    -- Add all non-optional info
    -- DNA
    local remaining_dna = search_results_raw["stime"]
    if remaining_dna > 0 then
      local p = self:AddTimeText(remaining_dna)
      p:SetImage("icon16/error.png")
      p:SetCountdownMode(true)
    end
    -- Last Seen
    -- This is a table with idx in it with 0 signifying no-one
    local last_id = search_results_raw["lastid"]["idx"]
    if last_id ~= 0 then self:AddIconWithText("icon16/eye.png", FindNickFromIDX(last_id)) end

    -- Last Words
    local last_words = search_results_raw["words"]
    if words then self:AddIconWithText("icon16/keyboard.png", last_words) end
    
    -- Headshot
    local headshot = search_results_raw["head"]
    if headshot then self:AddIconWithText("icon16/cross.png", "Headshot") end

    -- Equipment
    self:CreateEquipmentIcons(search_results_raw["eq_armor"], search_results_raw["eq_disg"], search_results_raw["eq_radar"], search_results_raw["c4"])

    -- Kills
    local kills = search_results_raw["kills"]
    if kills then self:AddIconWithText("icon16/cross.png", #kills) end
  end
  --self.search_results = search_results_raw
end

function PANEL:CreateEquipmentIcons(armour, disguise, radar, c4)
  if not (armour or disguise or radar or (c4~= 0)) then return end

  local grid = vgui.Create("DGrid", self)
  grid:SetCols(2)
  grid:SetColWide(16)
  grid:SetRowHeight(16)

  if armour then
    local armour_icon = vgui.Create("DImage")
    armour_icon:SetImage("icon16/accept.png")
    armour_icon:SetSize(16,16)
    grid:AddItem(armour_icon)
  end
  if disguise then
    local disguise_icon = vgui.Create("DImage")
    disguise_icon:SetImage("icon16/accept.png")
    disguise_icon:SetSize(16,16)
    grid:AddItem(disguise_icon)
  end
  if radar then
    local radar_icon = vgui.Create("DImage")
    radar_icon:SetImage("icon16/accept.png")
    radar_icon:SetSize(16,16)
    grid:AddItem(radar_icon)
  end
  if c4 ~= 0 then
    local c4_icon = vgui.Create("DImage")
    c4_icon:SetImage("icon16/accept.png")
    c4_icon:SetSize(16,16)
    grid:AddItem(c4_icon)
  end
  table.insert(self.icons, grid)
  self:InvalidateLayout()
end


local function GetWeaponName(classname)
  local wep = weapons.GetStored(classname)
  if wep and wep.PrintName and wep.PrintName ~= "" then
    local translated = LANG.GetTranslation(wep.PrintName)
    if translated and translated ~= classname and not string.find(translated, "ERROR") then return translated
    else return wep.PrintName end
  end 
  return classname
end

function GetDamageType(damage)
    if bit.band(damage, DMG_CRUSH) ~= 0 then
        return "Crushed"
    elseif bit.band(damage, DMG_BULLET) ~= 0 then
        return "Shot"
    elseif bit.band(damage, DMG_FALL) ~= 0 then
        return "Fell"
    elseif bit.band(damage, DMG_BLAST) ~= 0 then
        return "Explosion"
    elseif bit.band(damage, DMG_CLUB) ~= 0 then
        return "Blunt Force"
    elseif bit.band(damage, DMG_DROWN) ~= 0 then
        return "Drowned"
    elseif bit.band(damage, DMG_SLASH) ~= 0 then
        return "Stabbed"
    elseif bit.band(damage, DMG_BURN) ~= 0 then
        return "Burned"
    elseif bit.band(damage, DMG_SONIC) ~= 0 then
        return "Telefragged"
    elseif bit.band(damage, DMG_VEHICLE) ~= 0 then
        return "Hit by Car"
    else
        return "Unknown"
    end
end

function PANEL:FindCauseOfDeath(weapon_used, fatal_damage)
    if weapon_used and weapon_used ~= "" and weapon_used ~= 0 then
        local name = GetWeaponName(weapon_used)
        return {
            icon = "icon16/gun.png",
            text = name
        }
    else
        return {
            icon = "icon16/heart.png",
            text = GetDamageType(fatal_damage)
        }
    end
end

function PANEL:UpdatePlayerRole(player_role)
  if player_role == 1 then self.role_colour = Color(255,0,0)
  elseif player_role == 2 then self.role_colour = Color(0,0,255)
  end
end

function PANEL:AddTimeText(time)
  local p = vgui.Create("TimeText", self)
  p:SetTime(time)
  table.insert(self.icons, p)
  self:InvalidateLayout()
  return p
end

function PANEL:AddIconWithText(mat, text)
    local p = vgui.Create("IconWithText", self)
    p:SetImage(mat)
    p:SetText(text)
    table.insert(self.icons, p)
    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(8, 0, w, h)
    draw.RoundedBoxEx(8, 0, 0, 8, h, self.role_colour, true, false, true, false)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
