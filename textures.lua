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

function textures:load()
  for i = 1, #buttons do
    local texture = buttons[i];
    texture.texture = load_texture(texture.name);
    texture.ptr = texture.texture:Get();
  end
end

function textures:unload()
  for i = 1, #buttons do
    local texture = buttons[i];
    if (texture.texture) then
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
    end
  end
end

function textures:buttons()
  return buttons;
end

return textures;
