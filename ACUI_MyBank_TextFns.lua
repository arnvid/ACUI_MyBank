-- -----------------------------------------------------------------
-- File: ACUI_MyBank.lua
--
-- Purpose: Functions for ACUI_MyBank WoW Window.
-- 
-- Maintainer: Asys @ Turalyon-EU
-- Original Author: Ramble 
-- 
-- Credits: 
--   Starven, for MyInventory
--   Kaitlin, for BankItems
--   Sarf, for the original concept of AllInOneInventory
-- -----------------------------------------------------------------

function ACUI_MyBank_Trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

function ACUI_MyBank_Split(toCut, separator)
	if toCut == nil or separator == nil then 
		return nil
	end
	local splitted = {};
	local i = 0;
	local regEx = "([^" .. separator .. "]*)" .. separator .. "?";

	for item in string.gmatch(toCut .. separator, regEx) do
		i = i + 1;
		splitted[i] = ACUI_MyBank_Trim(item) or '';
	end
	splitted[i] = nil;
	return splitted;
end

function ACUI_MyBank_GetBankSlotCost(bags)
	if bags == 0 then
		return 1000;
	elseif bags == 1 then
		return 10000;
	elseif bags == 2 then
		return 100000;
	elseif bags == 3 then
		return 250000;
	elseif bags == 4 then
		return 500000;
	elseif bags == 5 then
		return 1000000;
	else
		return 0;
	end
end

-- Prints out text to a chat box.
function ACUI_MyBank_Print(msg,r,g,b,frame,id,unknown4th)
--	if ( Print ) then
--		Print(msg, r, g, b, frame, id, unknown4th);
--		return;
--	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end

	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 0.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			if type(msg) == 'string' then
				DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
			else
				for key, value in pairs(msg) do
					DEFAULT_CHAT_FRAME:AddMessage(value, r, g, b,id,unknown4th);
				end
			end
		end
	end
end

function ACUI_MyBank_DEBUG(msg)
	-- If Debug is not set, just skip it.
	if ( not ACUI_MyBankDEBUG or ACUI_MyBankDEBUG == 0 ) then
		return;
	end
	msg = "*** DEBUG(ACUI_MyBank): "..msg;
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1.0, 1.0, 0.0);
	end
end

