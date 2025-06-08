print("Included BetterInfoRow")

local PANEL = {}

function PANEL:Init()
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(32, 32)

    self.name = vgui.Create("DLabel", self)
    self.name:SetFont("DermaDefaultBold")
    self.name:SetText("Player")
    self.name:SetTextColor(color_white)

    self.icons = {}
    local icon_count = math.random(0, 4)
    for i = 1, icon_count do
        local icon = vgui.Create("DImage", self)
        icon:SetSize(16, 16)
        icon:SetImage("icon16/star.png")-- Replace with your icon path
        table.insert(self.icons, icon)
        --icon:SetTooltip("Hello, world!")
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

    for _, icon in ipairs(self.icons) do
        icon:SetPos(x, (h - icon:GetTall()) / 2)
        x = x + icon:GetWide() + 4
    end

    -- Total width is x, use for SizeToContents()
    self:SetWide(x + padding)
    self:SizeToChildren(true, true)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(8, 0, w, h)
    draw.RoundedBoxEx(8, 0, 0, 8, h, Color(0, 255, 0, 255), true, false, true, false)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
