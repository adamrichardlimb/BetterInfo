-- cl_playerentries.lua
include("autorun/client/cl_playerentry.lua")
local ENTRIES = {}

local vertical_spacing = 6
local vertical_padding = 20

local max_players = 24
local max_height = 64
local available_height = ScrH() - (2 * vertical_padding) - ((max_players - 1) * vertical_spacing)
local entry_height = math.min(math.floor(available_height / max_players), max_height)
entry_height = math.max(entry_height, 24)

local function InitialiseEntries()
  print("Initialising...")
  
  for i = 1, 24 do
    --vgui.Create("AHUDPlayerEntry")
  end
end

hook.Add("HUDPaint", "BetterInfo", function()
  local x = ScrW()
  local y = vertical_padding

  print("Creating...")
  local entry = vgui.Create("AHUDPlayerEntry");
  entry:SetPos(x, y)

  for _, entry in ipairs(ENTRIES) do
    entry:Draw(x, y)
    y = y + PANEL.entry_height + vertical_spacing
  end
end)

InitialiseEntries()
