local PANEL = {}

function PANEL:Init()
    self:SetPaintBackground(false)
    self.time = 0

    self.icon = vgui.Create("DImage", self)
    self.icon:SetSize(16, 16)
    self.icon:SetImage(mat or "icon16/clock.png")
    self.label = vgui.Create("DLabel", self)
    self.label:SetFont("DermaDefault")
    self.label:SetTextColor(color_white)
    self.label:SetContentAlignment(5)
    self.label:SetMouseInputEnabled(false)

    self.timer_id = "TimeText_Update_" .. tostring(self)

    timer.Create(self.timer_id, 1, 0, function()
        if not IsValid(self) then
            timer.Remove(self.timer_id)
            return
        end
        self.time = self.time + 1
        self:UpdateTimeText()
    end)
end

function PANEL:UpdateTimeText()
    self.label:SetText(os.date("!%M:%S", self.time)) -- MM:SS format
    self.label:SizeToContents()
    self:InvalidateLayout()
end

function PANEL:SetTime(t)
    self.time = t or 0
    self:UpdateTimeText()
end

function PANEL:PerformLayout(w, h)
    self.icon:SetPos((w - self.icon:GetWide()) / 2, 0)
    self.label:SetPos((w - self.label:GetWide()) / 2, self.icon:GetTall() + 2)
    self:SetWide(math.max(self.icon:GetWide(), self.label:GetWide()))
    self:SetTall(self.icon:GetTall() + 2 + self.label:GetTall())    
end

function PANEL:OnRemove()
    timer.Remove(self.timer_id)
end

vgui.Register("TimeText", PANEL, "DPanel")

