print("Included BetterInfoRow")

local PANEL = {}
local skip_keys = {nick=true, dmg=true}

function PANEL:Init()
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(32, 32)
    self.role_colour = Color(0,255,0)
    self.name = vgui.Create("DLabel", self)
    self.name:SetFont("DermaDefaultBold")
    self.name:SetText("Player")
    self.name:SetTextColor(color_white)

    self.icons = {} 
end

function PANEL:SetPlayer(ply)
    if IsValid(ply) then
        self.avatar:SetPlayer(ply, 32)
        local name = ply:Nick()
        if #name > 32 then
            name = string.sub(name, 1, 32) .. "…"
        end
        self.name:SetText(name)
        self.name:SizeToContents()
    end
end

function PANEL:PerformLayout(w, h)
    local padding = 10
    local x = padding

    -- Avatar on the left
    self.avatar:SetPos(x, (h - self.avatar:GetTall()) / 2)
    x = x + self.avatar:GetWide() + 6

    -- Name next
    self.name:SizeToContents()
    self.name:SetPos(x, (h - self.name:GetTall()) / 2)
    x = x + self.name:GetWide() + 6

    for _, icon in ipairs(self.icons) do
        icon:SetPos(x, (h - icon:GetTall()) / 2)
        x = x + icon:GetWide() + 4
    end

    -- Total width is x, use for SizeToContents()
    self:SetWide(x + padding)
    self:SizeToChildren(true, true)
end

function PANEL:AddSearchResults(search_results)
  if not self.search_results then
    for title, entry in pairs(search_results) do
      if not skip_keys[title] then
          -- Change role colour
          if title == "role" then
            local upper = string.upper(entry["text"])
            if string.find(upper, "TRAITOR") then self.role_colour = Color(255, 0, 0)
            elseif string.find(upper, "DETECTIVE") then self.role_colour = Color(0,0,255)
            end
          else self:AddIcon(entry["img"])
          end
      end
    end
    self.search_results = search_results
  end
end

function PANEL:AddIcon(mat)
    local icon = vgui.Create("DImage", self)
    icon:SetSize(16, 16)
    icon:SetImage(mat or "icon16/star.png") -- fallback icon
    table.insert(self.icons, icon)
    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(8, 0, w, h)
    draw.RoundedBoxEx(8, 0, 0, 8, h, self.role_colour, true, false, true, false)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
