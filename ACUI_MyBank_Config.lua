-- -----------------------------------------------------------------
-- File: ACUI_MyBank_Config.lua
--
-- Purpose: Functions for ACUI_MyBank Config window and options.
-- 
-- Maintainer: Asys@Turalyon-EU
-- Original Author: Ramble 
-- 
-- Credits: 
--   Starven, for MyInventory
--   Kaitlin, for BankItems
--   Sarf, for the original concept of AllInOneInventory
-- -----------------------------------------------------------------

-- == Slash Handlers == 
-- ChatCommandHandler: Slash commands are in here
function ACUI_MyBank_ChatCommandHandler(msg)

	if ( ( not msg ) or ( strlen(msg) <= 0 ) ) then
		ACUI_MyBank_Print(MYBANK_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = ACUI_MyBank_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( (strfind(commandName, "show")) or (strfind(commandName, "toggle")) ) then
		ToggleACUI_MyBankFrame();
	elseif ( (strfind(commandName, "freeze")) or (strfind(commandName, "unfreeze")) ) then
		ACUI_MyBank_Toggle_Option("Freeze");
	elseif ( (strfind(commandName, "replacebank")) or (strfind(commandName, "replace"))) then
		ACUI_MyBank_Toggle_Option("ReplaceBank");
	elseif strfind(commandName, "highlightbags") then
		ACUI_MyBank_Toggle_Option("HighlightBags");
	elseif strfind(commandName, "highlightitems") then
		ACUI_MyBank_Toggle_Option("HighlightItems");
	elseif strfind(commandName, "graphic") then
		ACUI_MyBank_Toggle_Option("Graphics");
	elseif strfind(commandName, "back") then
		ACUI_MyBank_Toggle_Option("Background");
	elseif strfind(commandName, "player") then
		ACUI_MyBank_Toggle_Option("ShowPlayers");
	elseif (strfind(commandName, "scale")) then
		mbscale, params = ACUI_MyBank_Extract_NextParameter(params);
		mbscale = tonumber(mbscale);
		ACUI_MyBank_SetScale(mbscale);
	elseif ( (strfind(commandName, "cols")) or (strfind(commandName, "column")) ) then
		cols, params = ACUI_MyBank_Extract_NextParameter(params);
		cols = tonumber(cols);
		ACUI_MyBankFrame_SetColumns(cols);
	elseif ( (strfind(commandName, "reset")) or (strfind(commandName, "init")) ) then
		ACUI_MyBankProfile[UnitName("player")] = nil;
		ACUI_MyBank_InitializeProfile();
	elseif (strfind(commandName, "config")) then
		ACUI_MyBankConfigFrame:Show();
	else
		ACUI_MyBank_Print(MYBANK_CHAT_COMMAND_USAGE);
		return;
	end
end
-- Extract_NextParameter: Used for Slash command handler
function ACUI_MyBank_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end
-- == End Slash Handlers == 


--All Functions that deal directly with ACUI_MyBankConfig Frame items should go here
function ACUI_MyBankConfig_OnShow()
	ACUI_MyBankConfigReplaceCheck:SetChecked(ACUI_MyBankReplaceBank);
	ACUI_MyBankConfigFreezeCheck:SetChecked(ACUI_MyBankFreeze);
	ACUI_MyBankConfigColumns:SetText(ACUI_MyBankColumns);
	ACUI_MyBankConfigHighlightItemsCheck:SetChecked(ACUI_MyBankHighlightItems);
	ACUI_MyBankConfigHighlightBagsCheck:SetChecked(ACUI_MyBankHighlightBags);
	ACUI_MyBankConfigHighlightItemsCheck:SetChecked(ACUI_MyBankHighlightItems);
	ACUI_MyBankConfigGraphicsCheck:SetChecked(ACUI_MyBankGraphics);
	ACUI_MyBankConfigBackgroundCheck:SetChecked(ACUI_MyBankBackground);
end
function ACUI_MyBankConfig_OnHide()
	if ACUI_MyBankConfigReplaceCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("ReplaceBank", 1,1);
	else
		ACUI_MyBank_Toggle_Option("ReplaceBank", 0,1);
	end
	if ACUI_MyBankConfigFreezeCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("Freeze", 1,1);
	else
		ACUI_MyBank_Toggle_Option("Freeze", 0,1);
	end
	local cols =  tonumber(ACUI_MyBankConfigColumns:GetText());
	if cols and cols > 5 and cols < 19 then
		ACUI_MyBankFrame_SetColumns(cols);
	end
	if ACUI_MyBankConfigHighlightItemsCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("HighlightItems",1,1);
	else
		ACUI_MyBank_Toggle_Option("HighlightItems",0,1);
	end
	if ACUI_MyBankConfigHighlightBagsCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("HighlightBags",1,1);
	else
		ACUI_MyBank_Toggle_Option("HighlightBags",0,1);
	end
	if ACUI_MyBankConfigGraphicsCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("Graphics",1,1);
	else
		ACUI_MyBank_Toggle_Option("Graphics",0,1);
	end
	if ACUI_MyBankConfigBackgroundCheck:GetChecked() then
		ACUI_MyBank_Toggle_Option("Background",1,1);
	else
		ACUI_MyBank_Toggle_Option("Background",0,1);
	end
end


-- END ACUI_MyBankConfig Frame stuff


