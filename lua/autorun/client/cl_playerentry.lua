print("Included...")

PANEL = {}

function PANEL:Init(entry_height)
  self.entry_height = entry_height

  -- No clue who this is for right now
  self.avatar = vgui.Create("DImage", self)
  self.avatar:SetSize(entry_height, entry_height)
  self.avatar:SetMouseInputEnabled(false)

  self.nick = vgui.Create("DLabel", self)

  -- Here is where we will store our search info
  self.search_info = nil

  -- With no search info, there are no search icons!
  self.icons = {}
  return self
end

function PANEL:EntryWidth()
  return 32 + (#self.icons + 1) * self.entry_height
end

function PANEL:Draw(x, y)
  draw.RoundedBoxEx(5, x - self:EntryWidth() - 10, y, 10, self.entry_height, Color(0, 255, 0, 100), true, false, true, false)
  draw.RoundedBox(0, x - self:EntryWidth(), y, self:EntryWidth(), self.entry_height, Color(0, 0, 0, 100))
end

vgui.Register("AHUDPlayerEntry", PANEL, "Panel")
