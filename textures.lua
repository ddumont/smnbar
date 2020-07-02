local textures = {};

local buttons = {
  { name = 'carb',  texture = nil },
  { name = 'titan',  texture = nil },
  { name = 'levi',  texture = nil },
  { name = 'garuda',  texture = nil },
  { name = 'ifrit',  texture = nil },
  { name = 'shiva',  texture = nil },
  { name = 'ramuh',  texture = nil },
  { name = 'fenrir',  texture = nil },
  { name = 'diabolos',  texture = nil },
  { name = 'cait',  texture = nil },
  { name = 'atomos',  texture = nil },
  { name = 'siren',  texture = nil },
};

local ctrl_buttons = {
  { name = 'light',  texture = nil },
  { name = 'earth',  texture = nil },
  { name = 'water',  texture = nil },
  { name = 'wind',  texture = nil },
  { name = 'fire',  texture = nil },
  { name = 'ice',  texture = nil },
  { name = 'thunder',  texture = nil },
  { name = 'dark',  texture = nil },
};

local function load_texture(name)
  local path = string.format('%s/64/%s.png', _addon.path, name);

  local res, texture = ashita.d3dx.CreateTextureFromFileA(path);
  if (res ~= 0) then
    -- Get the error information..
    local _, err = ashita.d3dx.GetErrorStringA(res);
    print(string.format('[Error] Failed to load background texture for slot: %s - Error: (%08X) %s', name, res, err));
    return nil;
  end
  return texture;
end

function textures:Load()
  for i = 1, #buttons do
    local texture = buttons[i];
    texture.texture = load_texture(texture.name);
    texture.ptr = texture.texture:Get();
  end
  for i = 1, #ctrl_buttons do
    local texture = ctrl_buttons[i];
    texture.texture = load_texture(texture.name);
    texture.ptr = texture.texture:Get();
  end
end

function textures:Unload()
  for i = 1, #buttons do
    local texture = buttons[i];
    if (texture.texture) then
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
    end
  end
  for i = 1, #ctrl_buttons do
    local texture = ctrl_buttons[i];
    if (texture.texture) then
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
    end
  end
end

function textures:Buttons()
  return buttons;
end

function textures:CtrlButtons()
  return ctrl_buttons;
end

return textures;
