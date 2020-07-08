local mgr = AshitaCore:GetResourceManager();

return {
  carbuncle = {
    { action = mgr:GetAbilityByName('assault', 0),         target = '<me>', ranks = 1 },
    { action = mgr:GetAbilityByName('retreat', 0),         target = '<me>', ranks = 1 },
    { action = mgr:GetAbilityByName('release', 0),         target = '<me>', ranks = 1 },
    { action = mgr:GetAbilityByName('poison nails', 0),    target = '<t>', ranks = 1 },
    { action = mgr:GetAbilityByName('meteorite', 0),       target = '<t>', ranks = 1 },
    { action = mgr:GetAbilityByName('healing ruby', 0),    target = '<stpc>', ranks = 2 },
    { action = mgr:GetAbilityByName('shining ruby', 0),    target = '<stpc>', ranks = 1 },
    { action = mgr:GetAbilityByName('glittering ruby', 0), target = '<stpc>', ranks = 1 },
  },
  -- titan = {
  --   { action = mgr:GetAbilityByName('', 0),         target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0),         target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0),         target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0),    target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0),       target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0),    target = '<me>', ranks = 2 },
  --   { action = mgr:GetAbilityByName('', 0),    target = '<me>', ranks = 1 },
  --   { action = mgr:GetAbilityByName('', 0), target = '<me>', ranks = 1 },
  -- },
};
