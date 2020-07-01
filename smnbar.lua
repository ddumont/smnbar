_addon.author   = 'siete';
_addon.name     = 'smnbar';
_addon.version  = '0.1';

require 'common';

local BUTTONS = 10;
local DRAG_W = 10;
local BUTTON_W = 64;
local BUTTON_H = BUTTON_W;
local BUTTONBAR_W = (BUTTON_W + ImGuiStyleVar_ChildWindowRounding * 2) * BUTTONS;
local BUTTONBAR_H = BUTTON_H + ImGuiStyleVar_ChildWindowRounding * 2;
local FRAME_W = DRAG_W + BUTTONBAR_W + ImGuiStyleVar_ChildWindowRounding * 2;
local FRAME_H = BUTTONBAR_H + ImGuiStyleVar_ChildWindowRounding * 2;

local FRAME_FLAGS = bit.bor(
  ImGuiWindowFlags_NoTitleBar,
  ImGuiWindowFlags_NoScrollbar,
  ImGuiWindowFlags_NoScrollWithMouse,
  ImGuiWindowFlags_ShowBorders,
  ImGuiWindowFlags_NoFocusOnAppearing
);

ashita.register_event('render', function()
  imgui.SetNextWindowSize(FRAME_W, FRAME_H, ImGuiSetCond_Always);
  -- imgui.SetNextWindowSizeConstraints(BUTTON_H, BUTTON_W, FLT_MAX, FLT_MAX);
  if (not imgui.Begin('smnbar', true, FRAME_FLAGS)) then return imgui.End() end
  imgui.Indent(DRAG_W);
  imgui.BeginChild('draghandle', nil, BUTTONBAR_H, true);
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, 1);
  for i = 1, BUTTONS do
    if (i > 1) then imgui.SameLine(); end
    if (imgui.ImageButton(nil, BUTTON_W, BUTTON_H)) then

    end
  end
  imgui.PopStyleVar();
  imgui.EndChild();
  imgui.Unindent(DRAG_W);
  imgui.End();
end);
