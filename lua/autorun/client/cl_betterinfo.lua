include("autorun/client/cl_betterinfo_row.lua")
print("Running...")
local PANEL = {}

function PANEL:Init()
    self:SetSize(300, ScrH() - 100)
    self:SetPos(ScrW() - 320, 50)
    self:SetPaintBackground(false)

    self.rows = {}

    for i = 1, 24 do
        local row = vgui.Create("BetterInfoRow", self)
        row:SetPlayer(LocalPlayer()) -- Replace with player.GetAll() later
        table.insert(self.rows, row)
    end
end

vgui.Register("BetterInfoPanel", PANEL, "DPanel")

timer.Simple(1, function()
  --Kill older versions if need be
  if IsValid(BetterInfoPanel) then
    BetterInfoPanel:Remove()
  end

  BetterInfoPanel = vgui.Create("BetterInfoPanel")
end)
