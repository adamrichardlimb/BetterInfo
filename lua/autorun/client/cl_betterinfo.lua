include("autorun/client/cl_betterinfo_row.lua")

local PANEL = {}

function PANEL:Init()
    local max_players = 24
    local padding = 20
    local spacing = 6
    local screen_height = ScrH()
    local usable_height = screen_height - 2 * padding - (max_players - 1) * spacing
    local row_height = math.max(math.floor(usable_height / max_players), 32)

    self:SetSize(300, screen_height)
    self:SetPos(ScrW() - self:GetWide(), 0)
    self:SetPaintBackground(false)

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(0, padding, 0, padding)

    self.rows = {}

    for _, ply in player.Iterator() do
        local row = vgui.Create("BetterInfoRow", self.scroll)
        row:SetPlayer(ply)-- replace later
        self.rows[ply] = row
    end
end

function PANEL:PerformLayout(w, h)
    local spacing = 6
    local padding = 20
    local y = padding
    local canvas = self.scroll:GetCanvas()
    local canvas_width = canvas:GetWide()

    for _, row in pairs(self.rows) do
        row:SizeToContents()
        local rw, rh = row:GetSize()
        row:SetPos(canvas_width - rw, y)
        y = y + rh + spacing
    end
end

function PANEL:GetRowForPlayer(ply)
  return self.rows[ply]
end

vgui.Register("BetterInfoPanel", PANEL, "DPanel")

timer.Simple(1, function()
    if IsValid(BetterInfoPanel) then
        BetterInfoPanel:Remove()
    end

    BetterInfoPanel = vgui.Create("BetterInfoPanel")
end)

hook.Add("TTTBodySearchPopulate", "read_tables", function(proc, raw)
  if IsValid(BetterInfoPanel) then
    local dead_player = raw["owner"]
    --Check if we have a row
    local player_row = BetterInfoPanel:GetRowForPlayer(dead_player)
    if not IsValid(player_row) then return end
    player_row:AddSearchResults(raw)
    PrintTable(raw)
  end
end)
