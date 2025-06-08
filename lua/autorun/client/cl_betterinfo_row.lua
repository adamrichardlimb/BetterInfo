print("Included BetterInfoRow")

local PANEL = {}

function PANEL:Init()
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(32, 32)

    self.name = vgui.Create("DLabel", self)
    self.name:SetFont("DermaDefaultBold")
    self.name:SetText("Player")
    self.name:SetTextColor(color_white)

    if math.random() < 0.5 then
        self.debug_extra = vgui.Create("DLabel", self)
        self.debug_extra:SetText("Debug")
        self.debug_extra:SetTextColor(Color(200, 200, 200))
        self.debug_extra:SizeToContents()
    end
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

    -- Debug label (if present)
    if IsValid(self.debug_extra) then
        self.debug_extra:SizeToContents()
        self.debug_extra:SetPos(x, (h - self.debug_extra:GetTall()) / 2)
        x = x + self.debug_extra:GetWide() + 6
    end

    -- Total width is x, use for SizeToContents()
    self:SetWide(x + padding)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(8, 0, w, h)
    draw.RoundedBoxEx(8, 0, 0, 8, h, Color(0, 255, 0, 255), true, false, true, false)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
