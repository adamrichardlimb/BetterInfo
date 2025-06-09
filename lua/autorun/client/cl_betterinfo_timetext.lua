local PANEL = {}

local time_text_counter = 0

function PANEL:Init()
    self:SetPaintBackground(false)
    self.time = 0
    self.countdown = false

    self.icon = vgui.Create("DImage", self)
    self.icon:SetSize(16, 16)
    self.icon:SetImage("icon16/clock.png")

    self.label = vgui.Create("DLabel", self)
    self.label:SetFont("DermaDefault")
    self.label:SetTextColor(color_white)
    self.label:SetContentAlignment(5)
    self.label:SetMouseInputEnabled(false)

    time_text_counter = time_text_counter + 1
    self.timer_id = "TimeText_Update_" .. time_text_counter

    timer.Create(self.timer_id, 1, 0, function()
        if not IsValid(self) then
            timer.Remove(self.timer_id)
            return
        end

        if self.countdown then
            self.time = self.time - 1
            if self.time <= 0 then
                self:Remove()
                return
            end
        else
            self.time = self.time + 1
        end

        self:UpdateTimeText()
    end)
end


function PANEL:SetImage(path)
    self.icon:SetImage(path or "icon16/clock.png")
end

function PANEL:SetCountdownMode(enabled)
    self.countdown = enabled
end

function PANEL:SetTime(t)
    self.time = t or 0
    self:UpdateTimeText()
end

function PANEL:UpdateTimeText()
    self.label:SetText(os.date("!%M:%S", math.max(0, self.time)))
    self.label:SizeToContents()
    self:InvalidateLayout()
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
