local util = {}

local lastPet = nil;

function util:HasPet()
  local player = GetPlayerEntity();
  return player ~= nil and player.PetTargetIndex ~= 0;
end

function util:PetEntity()
  local player = GetPlayerEntity();
  return (player ~= nil and GetEntity(player.PetTargetIndex)) or nil;
end

function util:PetName()
  local pet = self:PetEntity();
  local name = nil;
  if (pet ~= nil) then
    name = pet.Name;
  end

  local last = lastPet;
  lastPet = name;
  return name, last;
end

return util;
