local actions = require 'actions';
local util = require 'util';
local mgr = AshitaCore:GetResourceManager();
local textures = {};

local buttons = require 'buttons';
local spirit_buttons = require 'spirit_buttons';
local ja_buttons = require 'ja_buttons';

local pet_buttons = nil; -- updated on pet change

local function load_texture(name, size)
  local path = string.format('%s/' .. size .. '/%s.png', _addon.path, name):gsub("[%?']", '_');

  local res, texture = ashita.d3dx.CreateTextureFromFileA(path);
  if (res ~= 0) then
    -- Get the error information..
    local _, err = ashita.d3dx.GetErrorStringA(res);
    print(string.format('[Error] Failed to load background texture for slot: %s - Error: (%08X) %s', path, res, err));
    return nil;
  end
  return texture;
end

function textures:Load()
  for _, textures in ipairs({ buttons, spirit_buttons, ja_buttons }) do
    for _, texture in ipairs(textures) do
      if (textures == ja_buttons) then
        texture.texture = load_texture(texture.command, 48);
        local action, ability = actions:GetJaAction(texture.command, texture.target);
        texture.action = action;
        texture.ability = ability;
      else
        texture.texture = load_texture(texture.name, 64);
        texture.action = actions:Get(texture.name);
      end
      if (texture.texture) then
        texture.ptr = texture.texture:Get();
      end

      for _, command in ipairs(texture.commands or {}) do
        if (command.command) then
          command.texture = load_texture(command.command, 48);
          if (command.texture ~= nil) then
            command.ptr = command.texture:Get();
          end
        end
      end
    end
  end
end

function textures:Unload()
  for _, textures in ipairs({ buttons, spirit_buttons, ja_buttons }) do
    for _, texture in ipairs(textures) do
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
      texture.action = nil;

      for _, command in ipairs(texture.commands or {}) do
        if (command.texture ~= nil) then
          command.texture:Release();
          command.texture = nil;
        end
        command.ptr = nil;
        command.action = nil;
      end
    end
  end
end

function textures:Buttons()
  return buttons;
end

function textures:SpiritButtons()
  return spirit_buttons;
end

function textures:JaButtons()
  return ja_buttons;
end

function textures:PetButtons()
  local pet, lastpet = util:PetName();
  if (not util:HasPet() or pet == nil) then
    pet_buttons = nil;
    return pet_buttons;
  end
  if (pet == lastpet) then return pet_buttons end -- use the table we generated last time to save time

  -- assemble new table of actions for the current pet and save it off for next render
  pet_buttons = {};
  local commands = nil;
  local spirit = pet:lower():match('(.+)spirit');
  if (spirit) then
    pet = spirit .. ' spirit' -- there's no space in the ashita name
  end

  for _, button in ipairs(spirit == nil and buttons or spirit_buttons) do
    if (button.name == pet:lower()) then
      commands = button.commands;
      break;
    end
  end
  if (commands == nil) then
    for _, button in ipairs(spirit_buttons) do
      if (button.name == pet:lower()) then
        commands = button.commands;
        break;
      end
    end
  end

  commands = commands or {};
  for i, command in ipairs(commands) do
    local action, ability = actions:GetPetAction(command.command, command.ranks, command.target);
    if (action ~= nil) then
      command.action = action;
      command.ability = ability;
      table.insert(pet_buttons, command);
    end
  end
end

return textures;
