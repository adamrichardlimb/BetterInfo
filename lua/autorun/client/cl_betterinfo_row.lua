print("Included BetterInfoRow")

local PANEL = {}

function PANEL:Init()
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(32, 32)

    self.name = vgui.Create("DLabel", self)
    self.name:SetFont("DermaDefaultBold")
    self.name:SetText("Player")
    self.name:SetTextColor(color_white)
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
    self.avatar:SetPos(10, (h - self.avatar:GetTall()) / 2)
    self.name:SetPos(50, (h - self.name:GetTall()) / 2)
end

function PANEL:Paint(w, h)
    print("Paint coolest")
    surface.SetDrawColor(40, 40, 40, 200)
    surface.DrawRect(8, 0, w, h)
    draw.RoundedBoxEx(8, 0, 0, 8, h, Color(0, 255, 0, 255), true, false, true, false)
end

vgui.Register("BetterInfoRow", PANEL, "DPanel")
