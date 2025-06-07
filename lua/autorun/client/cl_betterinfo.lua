include("autorun/client/cl_betterinfo_row.lua")
print("Running lol")

local PANEL = {}

function PANEL:Init()
    local max_players = 24
    local padding = 20
    local spacing = 6
    local screen_height = ScrH()
    local usable_height = screen_height - 2 * padding - (max_players - 1) * spacing
    local row_height = math.floor(usable_height / max_players)
    local minimum_row_height = 32
    local allow_scroll = row_height < minimum_row_height
    row_height = math.max(row_height, minimum_row_height)

    self:SetSize(300, screen_height)
    self:SetPos(ScrW() - 320, 0)
    self:SetPaintBackground(false)

    local container = allow_scroll and vgui.Create("DScrollPanel", self) or self
    container:Dock(RIGHT)
    container:DockMargin(0, padding, 0, padding)

    self.rows = {}

    for i = 1, max_players do
        local row = vgui.Create("BetterInfoRow", container)
        row:SetTall(row_height)
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, spacing)
        row:SetPlayer(LocalPlayer()) -- Replace with actual players
        table.insert(self.rows, row)
    end
end

vgui.Register("BetterInfoPanel", PANEL, "DPanel")

timer.Simple(1, function()
    if IsValid(BetterInfoPanel) then
        BetterInfoPanel:Remove()
    end

    BetterInfoPanel = vgui.Create("BetterInfoPanel")
end)

