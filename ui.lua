require 'common';
require 'd3d8';
local textures = require 'textures';
local util = require 'util';
local actions = require 'actions';

local FRAME_PADDING_W = 2;
local FRAME_PADDING_H = 2;
local ITEM_SPACING_W = 4;
local ITEM_SPACING_H = 4;

local DRAG_W = 15;
local BUTTON_W = 54;
local BUTTON_H = BUTTON_W;
local keys = { '`', '1', '2', '3' , '4', '5', '6', '7', '8', '9', '0', '-', '=' };

local FRAME_FLAGS = bit.bor(
  ImGuiWindowFlags_NoTitleBar,
  ImGuiWindowFlags_NoResize,
  ImGuiWindowFlags_NoScrollbar,
  ImGuiWindowFlags_NoScrollWithMouse,
  ImGuiWindowFlags_ShowBorders,
  ImGuiWindowFlags_NoFocusOnAppearing,
  ImGuiWindowFlags_AlwaysAutoResize
);

local ui = {};
local X, Y, W, H;

function ui:MainBar(ctrlDown, altDown, shiftDown, winDown, key)
  local buttons;
  if (winDown) then
    buttons = textures:SpiritButtons();
  else
    buttons = textures:Buttons();
  end
  local BUTTONS = #buttons;

  imgui.PushStyleVar(ImGuiStyleVar_FramePadding, FRAME_PADDING_W, FRAME_PADDING_H);
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ITEM_SPACING_W, ITEM_SPACING_H);
  imgui.Begin('smnbar', true, FRAME_FLAGS);
  imgui.Indent(DRAG_W);
  -- imgui.BeginChild('buttonbar', nil, nil, true, ImGuiWindowFlags_AlwaysAutoResize);
  for i = 1, BUTTONS do
    if (i > 1) then imgui.SameLine(); end
    if (imgui.ImageButton(buttons[i].ptr, BUTTON_W, BUTTON_H) and buttons[i].action) then
      buttons[i].action();
    end
  end
  -- imgui.EndChild();
  imgui.Unindent(DRAG_W);
  X, Y = imgui.GetWindowPos();
  W, H = imgui.GetWindowSize();

  imgui.End();
  imgui.PopStyleVar(2);
end

function ui:PetBar(ctrlDown, altDown, shiftDown, winDown, key)
  if (not util:HasPet()) then return end;
  if (winDown) then return end;

  local buttons = textures:PetButtons();

  imgui.PushStyleVar(ImGuiStyleVar_FramePadding, FRAME_PADDING_H, FRAME_PADDING_H);
  imgui.SetNextWindowPos(X + DRAG_W + FRAME_PADDING_W * 2, Y + H, ImGuiSetCond_Always);
  imgui.Begin('petbar', true, bit.bor(FRAME_FLAGS, ImGuiWindowFlags_NoMove));
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ITEM_SPACING_W, ITEM_SPACING_H);
  local bx, by = imgui.GetCursorScreenPos();
  for i, button in ipairs(buttons or {}) do
    if (i > 1) then
      imgui.SameLine();
      imgui.SetCursorScreenPos(bx, by);
    end
    if (not ctrlDown and not altDown and not shiftDown and not winDown and i == key) then
      imgui.PushStyleColor(ImGuiCol_Button, 1, 1, 1, 0.5);
    end
    if (imgui.ImageButton(button.ptr, BUTTON_W * 0.75, BUTTON_H * 0.75)) then
      button.action();
    end
    if (not ctrlDown and not altDown and not shiftDown and not winDown and i == key) then
      imgui.PopStyleColor();
    end
    if (imgui.IsItemHovered()) then
      imgui.BeginTooltip();
      imgui.PushTextWrapPos(imgui.GetFontSize() * 25);
      imgui.TextColored(1.0, 1.0, 0.4, 1.0, button.ability.Name[2]);
      imgui.Separator();
      imgui.TextColored(1.0, 0.6, 0.4, 1.0, button.ability.Description[2]);
      imgui.PopTextWrapPos();
      imgui.EndTooltip();
    end
    imgui.SameLine();
    bx, by = imgui.GetCursorScreenPos();
    imgui.SetCursorScreenPos(bx - 20, by);
    local text = keys[i];
    -- local tw, th = imgui.CalcTextSize(text);  -- not implemented :(
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, 0, 3.8);
    imgui.PushStyleColor(ImGuiCol_ChildWindowBg, 0, 0, 0, 0);
    -- draw a clear frame to shift contents down...  setting y pos causes parent to grow strangely
    imgui.BeginChild('shortcut' .. i .. 'offset', 12, 30, false, bit.bor(ImGuiWindowFlags_AlwaysUseWindowPadding, ImGuiWindowFlags_NoInputs));
      imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, 2.5, 2);
      imgui.PushStyleVar(ImGuiStyleVar_ChildWindowRounding, 3);
      imgui.PushStyleColor(ImGuiCol_ChildWindowBg, 0.0, 0.0, 0.0, 0.65);
      imgui.BeginChild('shortcut' .. i, 12, 16, false, bit.bor(ImGuiWindowFlags_AlwaysUseWindowPadding, ImGuiWindowFlags_NoInputs));
        imgui.TextColored(1.0, 1.0, 0.4, 1.0, text);
      imgui.EndChild();
      imgui.PopStyleColor();
      imgui.PopStyleVar();
      imgui.PopStyleVar();
    imgui.EndChild();
    imgui.PopStyleColor();
    imgui.PopStyleVar();
  end
  imgui.PopStyleVar();
  imgui.End();
  imgui.PopStyleVar();
end

function ui:JaBar(ctrlDown, altDown, shiftDown, winDown, key)
  if (not winDown) then return end;

  local buttons = textures:JaButtons();

  imgui.PushStyleVar(ImGuiStyleVar_FramePadding, FRAME_PADDING_H, FRAME_PADDING_H);
  imgui.SetNextWindowPos(X + DRAG_W + FRAME_PADDING_W * 2, Y + H, ImGuiSetCond_Always);
  imgui.Begin('jabar', true, bit.bor(FRAME_FLAGS, ImGuiWindowFlags_NoMove));
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ITEM_SPACING_W, ITEM_SPACING_H);
  local bx, by = imgui.GetCursorScreenPos();
  for i, button in ipairs(buttons or {}) do
    if (i > 1) then
      imgui.SameLine();
      imgui.SetCursorScreenPos(bx, by);
    end
    if (not ctrlDown and not altDown and not shiftDown and winDown and i == key) then
      imgui.PushStyleColor(ImGuiCol_Button, 1, 1, 1, 0.5);
    end
    if (imgui.ImageButton(button.ptr, BUTTON_W * 0.75, BUTTON_H * 0.75)) then
      button.action();
    end
    if (not ctrlDown and not altDown and not shiftDown and winDown and i == key) then
      imgui.PopStyleColor();
    end
    if (imgui.IsItemHovered()) then
      imgui.BeginTooltip();
      imgui.PushTextWrapPos(imgui.GetFontSize() * 25);
      imgui.TextColored(1.0, 1.0, 0.4, 1.0, button.ability.Name[2]);
      imgui.Separator();
      imgui.TextColored(1.0, 0.6, 0.4, 1.0, button.ability.Description[2]);
      imgui.PopTextWrapPos();
      imgui.EndTooltip();
    end
    imgui.SameLine();
    bx, by = imgui.GetCursorScreenPos();
    imgui.SetCursorScreenPos(bx - 20, by);
    local text = keys[i];
    -- local tw, th = imgui.CalcTextSize(text);  -- not implemented :(
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, 0, 3.8);
    imgui.PushStyleColor(ImGuiCol_ChildWindowBg, 0, 0, 0, 0);
    -- draw a clear frame to shift contents down...  setting y pos causes parent to grow strangely
    imgui.BeginChild('shortcut' .. i .. 'offset', 12, 30, false, bit.bor(ImGuiWindowFlags_AlwaysUseWindowPadding, ImGuiWindowFlags_NoInputs));
      imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, 2.5, 2);
      imgui.PushStyleVar(ImGuiStyleVar_ChildWindowRounding, 3);
      imgui.PushStyleColor(ImGuiCol_ChildWindowBg, 0.0, 0.0, 0.0, 0.65);
      imgui.BeginChild('shortcut' .. i, 12, 16, false, bit.bor(ImGuiWindowFlags_AlwaysUseWindowPadding, ImGuiWindowFlags_NoInputs));
        imgui.TextColored(1.0, 1.0, 0.4, 1.0, text);
      imgui.EndChild();
      imgui.PopStyleColor();
      imgui.PopStyleVar();
      imgui.PopStyleVar();
    imgui.EndChild();
    imgui.PopStyleColor();
    imgui.PopStyleVar();
  end
  imgui.PopStyleVar();
  imgui.End();
  imgui.PopStyleVar();
end

function ui:Load()
  textures:Load();
end
function ui:Unload()
  textures:Unload();
end

return ui;
