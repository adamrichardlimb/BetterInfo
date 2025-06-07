print("Included")

local PANEL = {}

function PANEL:Init()
    self:SetTall(32)
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 4)

    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(28, 28)
    self.avatar:SetPos(2, 2)

    self.name = vgui.Create("DLabel", self)
    self.name:SetPos(36, 6)
    self.name:SetFont("DermaDefaultBold")
    self.name:SetText("Player")
    self.name:SizeToContents()
end

function PANEL:SetPlayer(ply)
    if IsValid(ply) then
        self.avatar:SetPlayer(ply, 32)
        self.name:SetText(ply:Nick())
        self.name:SizeToContents()
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
