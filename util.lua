local util = {}

function util:HasPet()
  local player = GetPlayerEntity();
  return player ~= nil and player.PetTargetIndex ~= 0;
end

function util:PetEntity()
  local player = GetPlayerEntity();
  return (player ~= nil and GetEntity(player.PetTargetIndex)) or nil;
end

return util;
