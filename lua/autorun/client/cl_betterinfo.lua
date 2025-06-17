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
    self:SetPos(ScrW() - self:GetWide(), ScrH() - self:GetTall())
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

    for i = 1, 0 do
        local fake_ply = {
            Nick = function() return "TestPlayer" .. i end,
            IsValid = function() return true end,
            SteamID64 = function() return "000000000000000" .. i end,
            __fake = true -- mark as fake if needed
        }

        local row = vgui.Create("BetterInfoRow", self.scroll)
        row:SetPlayer(fake_ply)
        self.rows[fake_ply] = row
    end
end

function PANEL:PerformLayout(w, h)
    local y = 0
    local canvas = self.scroll:GetCanvas()
    local canvas_width = canvas:GetWide()

    local players = {}

    for ply in pairs(self.rows) do
        if IsValid(ply) then
            table.insert(players, ply)
        end
    end

    table.sort(players, function(a, b)
      local ga = ScoreGroup(a)
      local gb = ScoreGroup(b)

      if ga ~= gb then
          return ga < gb
      end

      -- fallback: alphabetical within group
      return a:Nick():lower() < b:Nick():lower()
    end)

    for _, ply in ipairs(players) do
      local row = self.rows[ply]
      if IsValid(row) then
          row:SizeToContents()
          local rw, rh = row:GetSize()
          local target_x = canvas_width - rw
          local target_y = y

          local current_x, current_y = row:GetPos()

          if math.abs(current_y - target_y) > 1 or math.abs(current_x - target_x) > 1 then
              local start_x, start_y = current_x, current_y
              local start_time = CurTime()
              local duration = 0.05

              row.Think = function(panel)
                  local elapsed = CurTime() - start_time
                  local t = math.min(elapsed / duration, 1)

                  local new_x = start_x + (target_x - start_x) * t
                  local new_y = start_y + (target_y - start_y) * t
                  panel:SetPos(new_x, new_y)

                  if t >= 1 then
                      panel:SetPos(target_x, target_y)
                      panel.Think = nil
                  end
              end
     
          else
              row:SetPos(target_x, target_y)
          end

          y = y + rh
      end
    end
end


function PANEL:GetRowForPlayer(ply)
  return self.rows[ply]
end

function PANEL:ToggleSlide()
    self.slideState = self.slideState or "out"
    local targetX
    local duration = 0.3
    local startTime = CurTime()
    local startX = self.x
    local endX

    if self.slideState == "out" then
        -- Slide in to current position
        endX = ScrW() - self:GetWide()
        self.slideState = "in"
        self:SetVisible(true)
    else
        -- Slide out off-screen
        endX = ScrW()
        self.slideState = "out"
    end

    self.Think = function(panel)
        local t = (CurTime() - startTime) / duration
        t = math.Clamp(t, 0, 1)
        local x = Lerp(t, startX, endX)
        panel:SetPos(x, panel.y)

        if t >= 1 then
            panel.Think = nil
            if self.slideState == "out" then
                self:SetVisible(false)
            end
        end
    end
end

function PANEL:UpdateRows()
    local changed = false

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) then continue end

        local row = self.rows[ply]

        -- Create row if missing and not a spectator
        if not row then
            local player_group = ScoreGroup(ply)

            if player_group == GROUP_SPEC then continue end
            row = vgui.Create("BetterInfoRow", self.scroll)
            row:SetPlayer(ply)
            self.rows[ply] = row
            row._last_group = ScoreGroup(ply)
            changed = true
        else
            -- Check if group has changed
            local current_group = ScoreGroup(ply)
            if row._last_group ~= current_group then
                row._last_group = current_group
                changed = true
            end
        end
    end

    -- Remove invalid/disconnected players
    for ply, row in pairs(self.rows) do
        if not IsValid(ply) then
            row:Remove()
            self.rows[ply] = nil
            changed = true
        end
    end

    if changed then
        self:InvalidateLayout()
    end
end


vgui.Register("BetterInfoPanel", PANEL, "DPanel")

timer.Simple(1, function()
    if IsValid(BetterInfoPanel) then
        BetterInfoPanel:Remove()
    end

    BetterInfoPanel = vgui.Create("BetterInfoPanel")
    timer.Create("BetterInfoPanelUpdater", 0.3, 0, function()
      if IsValid(BetterInfoPanel) then
          BetterInfoPanel:UpdateRows()
      end
    end)

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

hook.Add("PlayerButtonDown", "ToggleBetterInfoPanel", function(ply, button)
    if button == KEY_F6 and IsValid(BetterInfoPanel) then
        BetterInfoPanel:ToggleSlide()
    end
end)
