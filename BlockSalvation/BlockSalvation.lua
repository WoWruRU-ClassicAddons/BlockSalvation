local BS_PlayerName = nil;
local BS_default = 0;

function BS_OnLoad()
    this:RegisterEvent("PLAYER_AURAS_CHANGED");
    this:RegisterEvent("VARIABLES_LOADED");
DEFAULT_CHAT_FRAME:AddMessage(BS_by_Badger, 1, 1, 0.5);
    SLASH_BS1 = "/BS";
    SlashCmdList["BS"] = function(msg)
		BS_SlashCommand(msg);
	end
end

function BS_Init()
    BS_PlayerName = UnitName("player")..PofR..GetCVar("realmName");

    if (BS_CONFIG == nil) then
	BS_CONFIG = {};
    end

    if (BS_CONFIG[BS_PlayerName] == nill) then
	BS_CONFIG[BS_PlayerName] = BS_default;
    end
end

function BS_OnEvent()

  if (event == "PLAYER_AURAS_CHANGED") then 
    BS_Kill();
  elseif (event == "VARIABLES_LOADED") then
    BS_Init();
  end

end

function BS_SlashCommand(msg)
    local BS_Status = BS_Off;
    if(msg == "on") then
      BS_on();
    elseif (msg == "off") then
      BS_off()
    else
      if ( DEFAULT_CHAT_FRAME ) then
	if (BS_CONFIG[BS_PlayerName] == 1) then
		BS_Status = BS_On;
	end
        DEFAULT_CHAT_FRAME:AddMessage(BS_by_Badger, 1, 1, 0.5);
        DEFAULT_CHAT_FRAME:AddMessage(Status_BS..BS_Status, 1, 1, 0.5);
        DEFAULT_CHAT_FRAME:AddMessage(BS_Use, 1, 1, 0.5);
      end
    end
end

function BS_on()
    BS_CONFIG[BS_PlayerName] = 1;
    if ( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage(BS_cancelled, 1, 1, 0.5);
    end
end

function BS_off()
    BS_CONFIG[BS_PlayerName] = 0;
    if ( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage(BS_l_cancelled, 1, 1, 0.5);
    end
end

function BS_Kill() 
    if (BS_CONFIG[BS_PlayerName] == 0) then
	return false;
    end

    local i = 0;
    while not (GetPlayerBuff(i,"HELPFUL") == -1) do
	local buffIndex, untilCancelled = GetPlayerBuff(i,"HELPFUL")
	local texture = GetPlayerBuffTexture(buffIndex);

	if ((string.find(texture,"Spell_Holy_SealOfSalvation")) or (string.find(texture,"Spell_Holy_GreaterBlessingofSalvation"))) then
	    CancelPlayerBuff(i);
	    DEFAULT_CHAT_FRAME:AddMessage(BS_Blocked, 1, 1, 0.5);
	    return true;
	end
    i = i + 1;
    end
end
