local PANEL = {}

function PANEL:Init()
    self:SetPaintBackground(false)
    self.icon = vgui.Create("DImage", self)
    self.icon:SetSize(16, 16)

    self.label = vgui.Create("DLabel", self)
    self.label:SetFont("DermaDefault")
    self.label:SetTextColor(color_white)
    self.label:SetContentAlignment(5)
    self.label:SetMouseInputEnabled(false)
end

function PANEL:SetImage(mat)
    self.icon:SetImage(mat or "icon16/star.png")
end

function PANEL:SetText(txt)
    self.label:SetText(txt or "")
    self.label:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    self.icon:SetPos((w - self.icon:GetWide()) / 2, 0)
    self.label:SetPos((w - self.label:GetWide()) / 2, self.icon:GetTall() + 2)
    self:SetWide(math.max(self.icon:GetWide(), self.label:GetWide()))
    self:SetTall(self.icon:GetTall() + 2 + self.label:GetTall())    
end

vgui.Register("IconWithText", PANEL, "DPanel")

