-- -----------------------------------------------------------------
-- File: ACUI_MyBank.lua
--
-- Purpose: Functions for ACUI_MyBank WoW Window.
-- 
-- ChangeLog:
-- 3.1.0.0
-- - Bumped toc and started testing
-- 
-- 3.0.2.3
-- - Fixed OnLoad code which gave MoneyFrame.lua error.
-- 
-- 3.0.2.2
-- - Bumped version for release on Curse
--
-- 3.0.2.1
-- - Upgraded code to load, and be 3.0 compatible
-- - Fixed some refrences to code that Blizzard has removed
-- - Fixed error on opening bank, and with MoneyFrame
--
-- 3.0.2.0
-- - Bumped toc and started testing
--
-- 2.2.0.2
-- - Put Dressingroom code back into addon
--
-- 2.2.0.1
-- - Bumped toc and ready for testing..
-- - Fixed show only first bagslot from bank while at bank
--
-- 2.1.0.0
-- - Bumped toc and ready for testing..
-- 
-- 2.0.12.1
-- - Removed debug tag.
-- 
-- 2.0.12.1
-- - Fixed code that handled saving of items
-- - Fixed code that made links from saved info
-- - Fixed code that made gametooltips
-- - Fixed some TBC/WoW2.0 tooltip/item changes
-- - Updated and removed redundant old code
-- - Fixed some minor glitches in graphics display
-- 
-- 2.0.3.1
-- - minor bugfixes from romracer and honem
-- - minor updates
-- - bumped toc for 20003 and TBC
-- 
-- 2.0.1.3
-- - Fixed myAddons support
-- - Fixed slash-cmd error
-- 
-- 2.0.1.2
-- - turned off debug mode
-- 
-- 2.0.1.1
-- - fixed toc for 2.0.1
-- - fixed error on mouse-over on not yet bought bankslots
-- - fixed error in how addon scans gametooltip for information re madeby/soulbound
-- - converted addon to WOW2 syntax and code
-- - updated to correctly show the right amount of bagslots
-- - udpated to correctly work with max slots for every bagslot
-- 
-- 1.12.0.1
-- - fixed toc for 1.12
-- - fixed some bugs
-- - upped number of bagslots to 192
-- - intermediate release to bring live version up to 1.12.0
-- 
-- 1.10.0.1
-- - fixed toc for 1.11
-- - fixed some bugs
-- - added scaling
-- - intermediate release to bring live version up to 1.11.0
-- 
-- 1.9.0.4
-- - fixed keybinding issue.
-- - should really not be doing this at 5am :)
-- 
-- 1.9.0.3
-- - fixed mouse over on additional bags.. When adding more..
-- 
-- 1.9.0.2
-- - fixed debug mode on..
-- 
-- 1.9.0.1
-- - updated to fix 10900 compliance
-- - fixed loading of data between changing chars

-- 
-- Maintainer: Asys@Turalyon-EU
-- Original Author: Ramble 
-- 
-- Credits: 
--   Starven, for MyInventory
--   Kaitlin, for BankItems
--   Sarf, for the original concept of AllInOneInventory
-- -----------------------------------------------------------------
-----------------------
-- Saved Configuration
-----------------------
ACUI_MyBankProfile = {}
MYBANK_VERSION           =  "3.1.0.0";

local PlayerName = nil; -- Logged in player name
local bankPlayer     = nil; -- viewing player pointer
local bankPlayerName = nil; -- Viewing player name

------------------------
-- Saved Function Calls
------------------------
local BankFrame_Saved = nil;
local PurchaseSlot_Saved = nil;
-----------------------
-- Local Configuration
-----------------------
local ACUI_MyBank_Loaded = nil;
local AtBank = false;

MYBANK_MAX_ID              = 224; -- 8 * 28 slot bags, 28 Bankslots
MYBANK_COLUMNS_MIN         =   8; -- 7 Bags, so it has to be at least 8 wide :)	
MYBANK_COLUMNS_MAX         =  18; -- Same as MI
MYBANK_BASE_HEIGHT         = 153; -- Height of Borders + Title + Bottom
MYBANK_ROW_HEIGHT          =  40; -- One Row
MYBANK_BASE_WIDTH          =  12; -- Width of the borders
MYBANK_COL_WIDTH           =  39; -- One Column
MYBANK_FIRST_ITEM_OFFSET_X =   7; -- Leave room for the border
MYBANK_FIRST_ITEM_OFFSET_Y = -28 - 39; -- Leave room for the title.
MYBANK_ITEM_OFFSET_X       =  39; -- Each is 39 apart
MYBANK_ITEM_OFFSET_Y       = -39; -- Each is 39 apart

ACUI_MyBankDEBUG                = 0;
-- Not Saved between Sessions
ACUI_MyBankAllRealms				= 0;
-- Saved Between Sessions
ACUI_MyBankReplaceBank          = 1;
ACUI_MyBankColumns              = 8;
ACUI_MyBankFreeze					= 0;
ACUI_MyBankHighlightItems			= 1;
ACUI_MyBankHighlightBags			= 1;
ACUI_MyBankBagView              = 1;
ACUI_MyBankGraphics             = 1;
ACUI_MyBankBackground           = 1;
ACUI_MyBankShowPlayers          = 1;
ACUI_MyBankScale                = 1;

--InitializeProfile: Initializes a players profile {{{
--  If Player's profile is not found, it makes a new one from defaults
--  If Player's profile is found, it loads the values from ACUI_MyBankProfile
function ACUI_MyBank_InitializeProfile()
	if ( UnitName("player") ) then
		PlayerName = UnitName('player').."|"..ACUI_MyBank_Trim(GetCVar("realmName"));
		ACUI_MyBank_LoadSettings();

		ACUI_MyBank_DEBUG("ACUI_MyBank: Profile for "..PlayerName.." Initilized.");
		ACUI_MyBankFrame_PopulateFrame();
		-- TODO: why is this here?
		-- ACUI_MyBank_UpdateBagCost(ACUI_MyBankProfile[PlayerName].Bags);
	end
end

function ACUI_MyBank_LoadSettings()
	if ( ACUI_MyBankProfile[PlayerName] == nil ) then
		ACUI_MyBankProfile[PlayerName] = {};
		ACUI_MyBank_Print("Mybank:Creating new Profile for "..PlayerName);
	end
	ACUI_MyBankReplaceBank    = ACUI_MyBank_SavedOrDefault("ReplaceBank");
	ACUI_MyBankColumns        = ACUI_MyBank_SavedOrDefault("Columns");
	ACUI_MyBankFreeze         = ACUI_MyBank_SavedOrDefault("Freeze");
	ACUI_MyBankHighlightItems = ACUI_MyBank_SavedOrDefault("HighlightItems");
	ACUI_MyBankHighlightBags  = ACUI_MyBank_SavedOrDefault("HighlightBags");
	ACUI_MyBankBagView        = ACUI_MyBank_SavedOrDefault("BagView");
	ACUI_MyBankGraphics       = ACUI_MyBank_SavedOrDefault("Graphics");
	ACUI_MyBankBackground     = ACUI_MyBank_SavedOrDefault("Background");
	ACUI_MyBankShowPlayers    = ACUI_MyBank_SavedOrDefault("ShowPlayers");
	ACUI_MyBankScale          = ACUI_MyBank_SavedOrDefault("Scale");
	
	ACUI_MyBank_SetGraphics();
	ACUI_MyBank_SetReplaceBank();
	ACUI_MyBank_SetFreeze();
end
function ACUI_MyBank_SavedOrDefault(varname)
	if PlayerName == nil or varname == nil then
		ACUI_MyBank_DEBUG("ERR: nil value");
		return nil;
	end
	if ACUI_MyBankProfile[PlayerName][varname] == nil then -- Setting not set
		ACUI_MyBankProfile[PlayerName][varname] = getglobal("ACUI_MyBank"..varname); -- Load Default
	end
	return ACUI_MyBankProfile[PlayerName][varname];  -- Return Setting.
end
-- END  Initialization }}}
function ACUI_MyBank_GetPlayer(playerName)
	if ( not ACUI_MyBankProfile[playerName] ) then
		ACUI_MyBank_InitializeProfile();
	end
	bankPlayerName = playerName;
	UIDropDownMenu_SetSelectedValue(ACUI_MyBankDropDown, bankPlayerName);
	return ACUI_MyBankProfile[playerName];
end

function ACUI_MyBank_GetBag(bagIndex)
	local curBag
	if bagIndex == BANK_CONTAINER then
		curBag = bankPlayer["Bank"];
	else
		curBag = bankPlayer["Bag"..bagIndex];
	end
	return curBag;
end

function ACUI_MyBank_GetBagsTotalSlots()
	local slots = 28;
	if bankPlayer == nil then
		return slots;
	end 
	for bag = 5, 11 do
		local curBag = bankPlayer["Bag"..bag];
		if (curBag ~= nil) then
			if curBag["s"] ~=nil then
				slots = slots + curBag["s"];
			end
		end
	end
	return slots;
end

-- == Event Handling == 
-- OnLoad {{{
function ACUI_MyBankFrame_OnLoad()
	ACUI_MyBank_Register(); -- Slash Commands
	ACUI_MyBank_Print(MYBANK_LOADED);
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	this:RegisterEvent("BANKFRAME_OPENED");
	this:RegisterEvent("BANKFRAME_CLOSED");
	this:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	this:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED");
	this:RegisterEvent("PLAYER_MONEY");
	tinsert(UISpecialFrames, "ACUI_MyBankFrame"); -- Esc Closes ACUI_MyBank
end

function ACUI_MyBank_Register()
	SlashCmdList["MYBANKSLASHMAIN"] = ACUI_MyBank_ChatCommandHandler;
	SLASH_MYBANKSLASHMAIN1 = "/mybank";
	SLASH_MYBANKSLASHMAIN2 = "/mb";
end
-- End Load }}}
-- Confirm Dialog for buying bag slot {{{
function ACUI_MyBank_RegisterConfirm() 
	PurchaseSlot_Saved = PurchaseSlot;
	PurchaseSlot = ACUI_MyBank_PurchaseSlot;
	StaticPopupDialogs["PURCHASE_BANKBAG"] = {
		text = TEXT(MYBANK_PURCHASE_CONFIRM_S),
		button1 = TEXT(ACCEPT),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			PurchaseSlot_Saved();
		end,
		showAlert = 1,
		timeout = 0,
	};
end

function ACUI_MyBank_PurchaseSlot()
	if not StaticPopupDialogs["PURCHASE_BANKBAG"] then
		return;
	end
	local cost = GetBankSlotCost();
	if cost < 10000 then
		StaticPopupDialogs["PURCHASE_BANKBAG"]["text"] = format(MYBANK_PURCHASE_CONFIRM_S,(cost/100)); 
	else
		StaticPopupDialogs["PURCHASE_BANKBAG"]["text"] = format(MYBANK_PURCHASE_CONFIRM_G,(cost/10000)); 
	end
	StaticPopup_Show("PURCHASE_BANKBAG");
end
-- End buy bag slot config }}}
-- Register with MyAddons
function ACUI_MyBank_MyAddonsRegister()
	if (myAddOnsFrame) then
		myAddOnsList.ACUI_MyBank = {
			name = MYBANK_MYADDON_NAME,
			description = MYBANK_MYADDON_DESCRIPTION,
			version = MYBANK_VERSION,
			category = MYADDONS_CATEGORY_INVENTORY,
			frame = "ACUI_MyBankFrame",
			optionsframe = "ACUI_MyBankConfigFrame"
		};
	end
end

function ACUI_MyBankFrame_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		ACUI_MyBank_DEBUG("ACUI_MyBank: Variables_loaded event");
		ACUI_MyBank_Loaded = 1;
		ACUI_MyBank_MyAddonsRegister();
		--	ACUI_MyBank_InitializeProfile();
		if not BankBuyFrame then
			ACUI_MyBank_RegisterConfirm();
		end
	end
	if (not ACUI_MyBank_Loaded) then
		return;
	end
	
	if ( event == "UNIT_NAME_UPDATE" and arg1 == "player" and UnitName("player") ~= UNKNOWNOBJECT and bankPlayer == nil ) then
		ACUI_MyBank_DEBUG("ACUI_MyBank: UNIT_NAME_UPDATE event");
		PlayerName = UnitName("player").."|"..ACUI_MyBank_Trim(GetCVar("realmName"));
		bankPlayer = ACUI_MyBank_GetPlayer(PlayerName);
	elseif ( event == "PLAYER_ENTERING_WORLD") then
		ACUI_MyBank_DEBUG("ACUI_MyBank: PLAYER_ENTERING_WORLD event");
	  if (PlayerName == nil) then
	  	PlayerName = UnitName("player").."|"..ACUI_MyBank_Trim(GetCVar("realmName"));
	  	bankPlayer = ACUI_MyBank_GetPlayer(PlayerName);
	  end
		ACUI_MyBank_InitializeProfile();
		ACUI_MyBank_SaveMoney();
	elseif ( event == "BAG_UPDATE" ) then
		ACUI_MyBank_DEBUG("ACUI_MyBank: BAG_UPDATE event");
		if AtBank and arg1 >=5 and arg1 <=11 then
			ACUI_MyBankFrame_SaveItems();
		end
	elseif (event == "PLAYERBANKSLOTS_CHANGED" or event=="PLAYERBANKBAGSLOTS_CHANGED") then
		ACUI_MyBankFrame_SaveItems();
	elseif ( event == "ITEM_LOCK_CHANGED" or  event == "UPDATE_INVENTORY_ALERTS" ) then
		if ( AtBank ) then
			ACUI_MyBankFrame_PopulateFrame();
		end
	end
	if (event == "BANKFRAME_OPENED") then
		AtBank = true;
		SetPortraitTexture(ACUI_MyBankFramePortrait, "npc");
		ACUI_MyBankFrameAtBankText:Show();
		OpenBackpack(); -- Open Backpack at Bank
		bankPlayer = ACUI_MyBank_GetPlayer(PlayerName);
		ACUI_MyBankFrame_SaveItems();
		ACUI_MyBankFramePurchaseButton:Enable();
		if ACUI_MyBankReplaceBank == 1 then
			OpenACUI_MyBankFrame();
		end
	elseif (event == "BANKFRAME_CLOSED") then
		AtBank = false;
		ACUI_MyBankFramePortrait:SetTexture("Interface\\Addons\\ACUI_MyBank\\Skin\\MyBankPortait");
		ACUI_MyBankFrameAtBankText:Hide();
		ACUI_MyBankFramePurchaseButton:Disable();
		CloseBackpack(); -- Close Backpack when leaving
	 	if ACUI_MyBankReplaceBank == 1 then
			if ACUI_MyBankFreeze == 0 then
				CloseACUI_MyBankFrame();
			end
		end
		if StackSplitFrame:IsVisible() then
			StackSplitFrame:Hide();
		end
	elseif (event == "PLAYER_MONEY" ) then
		ACUI_MyBank_SaveMoney();
		return;
	end
end

function ACUI_MyBank_HighlightBag(bagID, bagName, isItem)
	if ACUI_MyBankHighlightBags == 0 and isItem then 
		return;
	end
	if ACUI_MyBankHighlightItems == 0 and (not isItem) then
		return;
	end
	if isItem then
		if bagID > -1 then
			getglobal("ACUI_MyBankFrameBag"..bagID):LockHighlight();
		end
	end
	if(bankPlayer[bagName])then
		local i, found;
		for i=1, MYBANK_MAX_ID do
			local itemButton = getglobal("ACUI_MyBankFrameItem"..i);
			if not itemButton:IsVisible() then
				break;
			end
			if itemButton.bagIndex == bagID then
				found = true;
				itemButton:LockHighlight();
			else
				if found then
					break;
				end
			end
		end
	end
end

function ACUI_MyBank_GetCooldown(item)
	if item["d"] then
		local cooldownInfo = item["d"];
		local CoolDownRemaining;
		if cooldownInfo and cooldownInfo["d"] and cooldownInfo["s"] then
			CoolDownRemaining = cooldownInfo["d"] - (GetTime() - cooldownInfo["s"]);
		else
			CoolDownRemaining = 0;
		end
		if CoolDownRemaining <= 0 then
			item["d"] = nil;
		else
			return cooldownInfo;
		end
	end
	return nil;
end

function ACUI_MyBank_GetCooldownString(cooldownInfo)
	local CoolDownRemaining = cooldownInfo["d"] - (GetTime() - cooldownInfo["s"]);
	-- 60 secs in a min
	-- 3600 secs in an hour
	-- 86400 secs in a day
	local days, hours, minutes, seconds;
	days = math.floor(CoolDownRemaining / 86400);
	CoolDownRemaining = CoolDownRemaining - 86400 * days;
	hours = math.floor(CoolDownRemaining / 3600);
	CoolDownRemaining = CoolDownRemaining - 3600 * hours;
	minutes = math.floor(CoolDownRemaining / 60);
	seconds = math.floor(CoolDownRemaining - 60 * minutes);
	if days > 0 then
		return format(ITEM_COOLDOWN_TIME_DAYS_P1, days+1);
	elseif hours > 0 then
		return format(ITEM_COOLDOWN_TIME_HOURS_P1, hours+1);
	elseif minutes > 0 then
		return format(ITEM_COOLDOWN_TIME_MIN, minutes+1);
	else
		return format(ITEM_COOLDOWN_TIME_SEC, seconds);
	end
end

function ACUI_MyBank_MakeLink(item)
	if item and item["l"] then
		local name;
		_,_,_, name = strfind(item["l"],"|H(item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r");
		-- item_id, item_enchant, item_suffix = strmatch( i.h, "|Hitem:(%-?%d+):(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:(%-?%d+):%-?%d+" )
		item["name"] = name;
		item["l"] = nil;
	end
	
	if item and item["name"] then
		local myHyperlink;
		myHyperlink = item["itemlink"];

		if myHyperlink then
			GameTooltip:Hide();
			GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
			GameTooltip:SetHyperlink(myHyperlink);
			if item["sb"] then
				GameTooltipTextLeft2:SetText(ITEM_SOULBOUND);
			end
			if item["m"] then
				GameTooltip:AddLine(format(ITEM_CREATED_BY, item["m"]));
			end
			if item["d"] and not (item["d"] == 1 ) then
				local cooldownInfo = item["d"];
				if cooldownInfo and cooldownInfo["e"] and cooldownInfo["e"] > 0 and cooldownInfo["d"] > 0 then
					CoolDownString = ACUI_MyBank_GetCooldownString(cooldownInfo);
					GameTooltip:AddLine(CoolDownString, 1.0, 1.0, 1.0);
				end
			end
			GameTooltip:Show();
		end
	end
end

function ACUI_MyBankFrame_Button_OnEnter()
	--show tooltip
	local myLink, MadeBy, Soulbound, count;
	local bagName= strsub(this:GetName(), 17, 22);
	local curBag;
	local cooldownInfo;
	if AtBank then
		local hasCooldown, repairCost;
		GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
		if (this.isBag) then
			ACUI_MyBank_HighlightBag(this:GetID(), bagName);
			local inventoryID = BankButtonIDToInvSlotID(this:GetID(), 1);
			hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", inventoryID);
		else
			ACUI_MyBank_HighlightBag(this.bagIndex, bagName, 1);
			if this.bagIndex < 0 then
				-- local newIndex = BankFrameItem1:GetInventorySlot(); 
				local newIndex = ButtonInventorySlot(this);
				hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", newIndex);
			else
				hasCooldown, repairCost = GameTooltip:SetBagItem(this.bagIndex, this.itemIndex);
			end
		end

	else
		if LootLink_AutoInfoOff then
			LootLink_AutoInfoOff();
		end
		if (this.isBag) then
			ACUI_MyBank_MakeLink(bankPlayer[bagName]);
			ACUI_MyBank_HighlightBag(this:GetID(), bagName);
		else
			ACUI_MyBank_HighlightBag(this.bagIndex, bagName, 1);
			curBag = ACUI_MyBank_GetBag(this.bagIndex);
			if curBag and curBag[this.itemIndex] then
				ACUI_MyBank_MakeLink(curBag[this.itemIndex]);
			end

		end
		if LootLink_AutoInfoOn then
			LootLink_AutoInfoOn();
		end
	end
end
function ACUI_MyBankFrame_Button_OnLeave()
	if this.isBag then
		local bagName= strsub(this:GetName(), 17, 22);
		local i, found;
		for i=1, MYBANK_MAX_ID do
			local itemButton = getglobal("ACUI_MyBankFrameItem"..i);
			if itemButton.bagIndex == this:GetID() then
				found = true;
				itemButton:UnlockHighlight();
			else
				if found then
					break;
				end
			end
		end
	else
		if this.bagIndex > -1 then
			getglobal("ACUI_MyBankFrameBag"..(this.bagIndex)):UnlockHighlight();
		end

	end
	GameTooltip:Hide();
end

function ACUI_MyBankFrame_UpdateCooldown(button)
	if (not button.bagIndex) or (not button.itemIndex) then
		return;
	end
  local cooldown = getglobal(button:GetName().."Cooldown");
  local start, duration, enable = GetContainerItemCooldown(button.bagIndex, button.itemIndex);
  CooldownFrame_SetTimer(cooldown, start, duration, enable);
  if ( duration > 0 and enable == 0 ) then
    SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4);
  end
end

function ACUI_MyBankFrame_OnHide()
	if AtBank then
		CloseBankFrame();
	end
	PlaySound("igBackPackClose");
end

function ACUI_MyBankFrame_OnShow()
	if AtBank then
		ACUI_MyBankFramePurchaseButton:Enable();
	else
		ACUI_MyBankFramePurchaseButton:Disable();
	end
	ACUI_MyBank_UpdateTotalMoney();
	ACUI_MyBankFrame_UpdateLookIfNeeded();
	PlaySound("igBackPackOpen");
end

function ACUI_MyBankFrameItemButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterForDrag("LeftButton");

	this.SplitStack = function(button, split)
		SplitContainerItem(button:GetParent():GetID(), button:GetID(), split);
	end
end

function ACUI_MyBankFrameItemButton_OnClick(button, ignoreShift)
	local myLink;
	local item = ACUI_MyBank_GetBag(this.bagIndex)[this.itemIndex];
	ACUI_MyBank_DEBUG("Entered OnClick");
	if (button == "LeftButton" ) then
		if (IsShiftKeyDown() and (not ignoreShift)) then
			if ChatFrameEditBox:IsVisible() then
				-- Insert Link
				myLink = item["itemlink"];
				if myLink then
					ChatFrameEditBox:Insert(myLink);
				end
			else
				if AtBank then
					--Shift key down, left mouse button
					local texture, itemCount, locked = GetContainerItemInfo(this.bagIndex, this.itemIndex);
					if ( not locked ) then
						this.SplitStack = function(button, split)
							SplitContainerItem(button.bagIndex, button.itemIndex, split);
						end
						OpenStackSplitFrame(this.count, this, "BOTTOMRIGHT", "TOPRIGHT");
					end
				end
			end
		elseif ( IsControlKeyDown() ) then -- Dressing room code..
			DressUpItemLink(GetContainerItemLink(this.bagIndex, this.itemIndex));
		else
  		-- no shift, left mouse button
			if AtBank==true then
				PickupContainerItem(this.bagIndex, this.itemIndex);
			end
		end
	elseif (button == "RightButton") then
		if AtBank==true then
			UseContainerItem(this.bagIndex, this.itemIndex);
		end
	end
end
			  
function ACUI_MyBankFrameItemButtonBag_OnShiftClick(button, ignoreShift) 
	local bankBag = getglobal("BankFrameBag"..(tonumber(strsub(this:GetName(), 20, 22))-4));
	local inventoryID = BankButtonIDToInvSlotID(bankBag:GetID(), 1);
	if ( ChatFrameEditBox:IsVisible() ) then
		local bagName = strsub(this:GetName(), 17, 22);
		local myLink;
		ACUI_MyBank_DEBUG("Clicked on "..bagName.." or "..this:GetName().." ...");
		myLink = bankPlayer[bagName]["itemlink"];
		if myLink then
			ChatFrameEditBox:Insert(myLink);
		end
	else
		 -- Shift key, no chat box
		if AtBank then
			PickupBagFromSlot(inventoryID);
			PlaySound("BAGMENUBUTTONPRESS");
		end
	end
end
function ACUI_MyBankFrameItemButtonBag_OnClick(button, ignoreShift) 
	ACUI_MyBank_DEBUG(this:GetName());	
	local bankBag = getglobal("BankFrameBag"..(tonumber(strsub(this:GetName(), 20, 22))-4));
	local inventoryID = BankButtonIDToInvSlotID(bankBag:GetID(), 1);
	ACUI_MyBank_DEBUG(bankBag:GetName().." "..inventoryID);	
		 -- No ShiftKey
	if AtBank then
		local hadItem = PutItemInBag(inventoryID);
		local id = this:GetID();
	end
end
-- == End Event Handling == 

function ACUI_MyBankFrame_SetColumns(col)
	if ( type(col) ~= "number" ) then
		col = tonumber(col);
	end
	if ( col == nil ) then
		ACUI_MyBank_DEBUG("Cols Error");
	else
		if ( ( col >= MYBANK_COLUMNS_MIN ) and ( col <= MYBANK_COLUMNS_MAX ) ) then
			ACUI_MyBankColumns = col;
			bankPlayer.Columns = ACUI_MyBankColumns;
			ACUI_MyBankFrame_UpdateLook(getglobal("ACUI_MyBankFrame"), ACUI_MyBank_GetBagsTotalSlots());
		end
	end
end

function ACUI_MyBankFrame_GetAppropriateHeight(rows)
	local height = MYBANK_BASE_HEIGHT + ( MYBANK_ROW_HEIGHT * (ACUI_MyBankBagView - 1 + rows ));
	if ACUI_MyBankShowPlayers == 0 and ACUI_MyBankGraphics == 0 then
		height = height - MYBANK_ROW_HEIGHT;
	end
	return height;
end

function ACUI_MyBankFrame_GetAppropriateWidth(cols)
	return MYBANK_BASE_WIDTH + ( MYBANK_COL_WIDTH * cols );
end

function ACUI_MyBankTitle_Update()
	local i, j, totalSlots, takenSlots = 0, 0, 0, 0;
	totalSlots = ACUI_MyBank_GetBagsTotalSlots();
	-- Need to calculate Free slots.
	if bankPlayer and bankPlayer["Bank"] then
		for i = 1, 28 do
			if bankPlayer["Bank"][i] then
				takenSlots = takenSlots + 1;
			end
		end
		for i = 5, 11 do
			if bankPlayer["Bag"..i] and bankPlayer["Bag"..i]["s"] then
				for j = 1, bankPlayer["Bag"..i]["s"] do
					if bankPlayer["Bag"..i][j] then
						takenSlots = takenSlots + 1;
					end
				end
			end
		end
	end

	if ( bankPlayerName ) then
		local playername = ACUI_MyBank_Split(bankPlayerName, "|");
		if ( ACUI_MyBankColumns >= 9 ) then
			ACUI_MyBankFrameName:SetText(format(MYBANK_FRAME_PLAYERANDREGION, playername[1], playername[2]));
		else
			ACUI_MyBankFrameName:SetText(format(MYBANK_FRAME_PLAYERONLY, playername[1]));
		end
		ACUI_MyBankFrameName:SetTextColor(1.0, 1.0, 1.0);
	end
	ACUI_MyBankFrameSlots:SetText(format(MYBANK_FRAME_SLOTS, (totalSlots-takenSlots), (totalSlots)));
end

function ACUI_MyBank_UpdateTotalMoney()
	local totalMoney = 0;
	for key, value in pairs(ACUI_MyBankProfile) do
		local thisRealmPlayers = ACUI_MyBank_Split(key, "|")[2];
		if ACUI_MyBankAllRealms == 1 or thisRealmPlayers == ACUI_MyBank_Trim(GetCVar("realmName")) then
			if ( ACUI_MyBankProfile[key].money ) then
				totalMoney = totalMoney + ACUI_MyBankProfile[key].money;
			end
		end
	end
	if ACUI_MyBankColumns < 8 then
		totalMoney = math.floor(totalMoney / 10000) * 10000;
	end
	MoneyFrame_SetType(ACUI_MyBank_MoneyFrameTotal,"STATIC");
	MoneyFrame_Update("ACUI_MyBank_MoneyFrameTotal", totalMoney);
end

function ACUI_MyBank_UpdateBagCost(bags) 
	if not bags then
		bags=0;
	end
	if bags < 7 then
		local cost = ACUI_MyBank_GetBankSlotCost(bags);
		MoneyFrame_SetType(ACUI_MyBankFrameDetailMoneyFrame,"STATIC");
		MoneyFrame_Update("ACUI_MyBankFrameDetailMoneyFrame", cost);
		if ( bankPlayer and bankPlayer["money"] and bankPlayer["money"] >= cost ) then
			SetMoneyFrameColor("ACUI_MyBankFrameDetailMoneyFrame", 1.0, 1.0, 1.0);
		else
			SetMoneyFrameColor("ACUI_MyBankFrameDetailMoneyFrame", 1.0, 0.1, 0.1)
		end
		ACUI_MyBankFramePurchaseInfo:Show();
	else
		ACUI_MyBankFramePurchaseInfo:Hide();
	end
end

function ACUI_MyBankFrame_UpdateLookIfNeeded()
	local slots = ACUI_MyBank_GetBagsTotalSlots();
	if ( ( not ACUI_MyBankFrame.size ) or ( slots ~= ACUI_MyBankFrame.size ) ) then
		ACUI_MyBankFrame_UpdateLook(getglobal("ACUI_MyBankFrame"), slots);
	end
end

function ACUI_MyBankFrame_UpdateLook(frame, frameSize)
	frame.size = frameSize;
	local name = frame:GetName();
	local columns = ACUI_MyBankColumns;
	
	local rows = ceil(frame.size / columns);
	local height = ACUI_MyBankFrame_GetAppropriateHeight(rows);
	frame:SetHeight(height);
	
	local width = ACUI_MyBankFrame_GetAppropriateWidth(columns);
	frame:SetWidth(width);
	
	ACUI_MyBankTitle_Update();	
	if ACUI_MyBankShowPlayers ==1 then
		ACUI_MyBankDropDown:Show();
		ACUI_MyBank_AllRealms_Check:Show();
		--MYINVENTORY_BASE_HEIGHT = MYINVENTORY_BASE_HEIGHT - MYINVENTORY_ITEM_OFFSET_Y;
	else
		ACUI_MyBankDropDown:Hide();
		ACUI_MyBank_AllRealms_Check:Hide();
	end
	for j=5,11 do
		local bagButton=getglobal("ACUI_MyBankFrameBag"..j);
		bagButton:ClearAllPoints();
		if j == 5 then
			bagButton:SetPoint("TOPLEFT", "ACUI_MyBankBagButtonsBar", "TOPLEFT", 0, 0);
		else
			bagButton:SetPoint("TOPLEFT", "ACUI_MyBankFrameBag"..(j-1), "TOPLEFT", MYBANK_ITEM_OFFSET_X, 0);
		end
		bagButton:Show();
	end
	local First_Y;
		First_Y = MYBANK_FIRST_ITEM_OFFSET_Y;
	if ACUI_MyBankBagView == 1 then
		First_Y = MYBANK_FIRST_ITEM_OFFSET_Y + MYBANK_ITEM_OFFSET_Y;
		ACUI_MyBankBagButtonsBar:Show();
	else
		First_Y = MYBANK_FIRST_ITEM_OFFSET_Y;
		ACUI_MyBankBagButtonsBar:Hide();
	end
	if (ACUI_MyBankShowPlayers == 0 and ACUI_MyBankGraphics == 0 ) then
		ACUI_MyBank_DEBUG("move up");
		First_Y = First_Y - MYBANK_ITEM_OFFSET_Y;
		ACUI_MyBankBagButtonsBar:ClearAllPoints();
		ACUI_MyBankBagButtonsBar:SetPoint("TOP", "ACUI_MyBankFrame", "TOP", 0, -28);
	else
		ACUI_MyBankBagButtonsBar:ClearAllPoints();
		ACUI_MyBankBagButtonsBar:SetPoint("TOP", "ACUI_MyBankFrame", "TOP", 0, -28-39);
		
	end
	for j=1, frame.size, 1 do
		local itemButton = getglobal(name.."Item"..j);
		ACUI_MyBank_DEBUG("Name "..name.."Item"..j);	
		-- Set first button
		itemButton:ClearAllPoints();
		if ( j == 1 ) then
			itemButton:SetPoint("TOPLEFT", name, "TOPLEFT", MYBANK_FIRST_ITEM_OFFSET_X, First_Y);
		else
			if ( mod((j-1), columns) == 0 ) then
				itemButton:SetPoint("TOPLEFT", name.."Item"..(j - columns), "TOPLEFT", 0, MYBANK_ITEM_OFFSET_Y);  
			else
				itemButton:SetPoint("TOPLEFT", name.."Item"..(j - 1), "TOPLEFT", MYBANK_ITEM_OFFSET_X, 0);  
			end
		end
		
		itemButton.readable = readable;
		itemButton:Show();
	end
	local button = nil;
	for i = frame.size+1, MYBANK_MAX_ID do
		button = getglobal("ACUI_MyBankFrameItem"..i);
		if ( button ) then
			button:Hide();
		end
	end
	ACUI_MyBankFrame_PopulateFrame();
end


function ACUI_MyBank_GetTooltipData()
	local soulbound = nil;
	local madeBy = nil;
	local field;
	local left, right;

	for index = 1, ACUI_MyBankHiddenTooltip:NumLines() do
		field = getglobal("ACUI_MyBankHiddenTooltipTextLeft"..index);
		if( field and field:IsVisible() ) then
			left = field:GetText();
		else
			left = "";
		end
		field = getglobal("ACUI_MyBankHiddenTooltipTextRight"..index);
		if( field and field:IsVisible() ) then
			right = field:GetText();
		else
			right = "";
		end
		if ( string.find(left, ITEM_SOULBOUND) ) then
			soulbound = 1;
		end
		local iStart, iEnd, val1 = string.find(left, "<Made by (.+)>");
		if (val1) then
			madeBy = val1;
		end
	end
	return soulbound, madeBy;
end
function ACUI_MyBankFrame_SaveBagInfo(currPlayer, bagIndex, bagName)
	if bagName=="Bank" then
		return 28;
	end
	local bagNum_Slots = GetContainerNumSlots(bagIndex);
	local bagNum_ID    = BankButtonIDToInvSlotID(bagIndex, 1);
	local itemLink     = GetInventoryItemLink("player", bagNum_ID);
	local texture      = GetInventoryItemTexture("player", bagNum_ID);
	local hasCooldown, repairCost = ACUI_MyBankHiddenTooltip:SetInventoryItem("player", bagNum_ID);
	local soulbound, madeBy = ACUI_MyBank_GetTooltipData();
	if (itemLink) then
		currPlayer[bagName]= {};
		ACUI_MyBank_SaveItemData(currPlayer[bagName], itemLink, strsub(texture,17), bagNum_Slots, _ , soulbound, madeBy, _); 
		return bagNum_Slots;
	else
		currPlayer[bagName] = nil;
		return 0;
	end
end
function ACUI_MyBankSaveBagItem(currPlayer, bagNewIndex, itemIndex, bagName)
	local itemLink = GetContainerItemLink(bagNewIndex, itemIndex);
	local texture, itemCount = GetContainerItemInfo(bagNewIndex, itemIndex);
	local hasCooldown, repairCost;
	if bagNewIndex == BANK_CONTAINER then
		local newIndex = 39 + itemIndex; 
		hasCooldown, repairCost = ACUI_MyBankHiddenTooltip:SetInventoryItem("player", newIndex);
	else
		hasCooldown, repairCost = ACUI_MyBankHiddenTooltip:SetBagItem(bagNewIndex, itemIndex);
	end
	local start, duration, enable = GetContainerItemCooldown(bagNewIndex, itemIndex);
	local soulbound, madeBy = ACUI_MyBank_GetTooltipData();
	local cooldown;
	if hasCooldown and enable > 0 then
		cooldown = {
			["s"] = start,
			["d"] = duration,
			["e"] = enable
		};
	end
	if (itemLink) then
		currPlayer[bagName][itemIndex] = {};
		ACUI_MyBank_SaveItemData(currPlayer[bagName][itemIndex], itemLink, strsub(texture,17), _, itemCount, soulbound, madeBy, cooldown); 
	else
		currPlayer[bagName][itemIndex] = nil;
	end
end

function ACUI_MyBank_SaveItemData(MBItem, itemLink, texture, Slots, Count, soulbound, madeBy, Cooldown)
	local myColor, name, rarity, myEnchant;
  local myColor, myId, myEnchant = strmatch( itemLink, "|c(%x+)|Hitem:(%-?%d+):(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:(%-?%d+):%-?%d+" );
  local name, _, rarity = GetItemInfo( itemLink );
 
	if (name == nil) then
		ACUI_MyBank_DEBUG("ACUI_MyBank: No name found for "..itemLink..".");
	end

	MBItem["name"] = name;
	MBItem["i"] = texture;
	MBItem["s"] = Slots;
	MBItem["c"] = Count;
	MBItem["q"] = rarity;
	MBItem["itemlink"] = itemLink;
	MBItem["color"] = myColor;
	MBItem["id"] = myId;
	MBItem["enchant"] = myEnchant;
	MBItem["sb"] = soulbound;
	MBItem["m"] = madeBy;
	MBItem["d"] = Cooldown;
	ACUI_MyBank_DEBUG("ACUI_MyBank: ACUI_MyBank_SaveItemData for "..name..", "..myId..", "..itemLink.." saved.");
end

function ACUI_MyBank_SaveMoney()
	if ( PlayerName ) then
		if ( ACUI_MyBankProfile[PlayerName] ) then
			ACUI_MyBankProfile[PlayerName]["money"] = GetMoney();
		end
		if ( ACUI_MyBank_MoneyFrame:IsVisible() ) then
			MoneyFrame_SetType(ACUI_MyBank_MoneyFrame,"STATIC");
			MoneyFrame_Update("ACUI_MyBank_MoneyFrame", bankPlayer.money);
			ACUI_MyBank_UpdateTotalMoney();
		end
	end
end

function ACUI_MyBankFrame_SaveItems()
	local currPlayer=ACUI_MyBankProfile[PlayerName];
	if currPlayer == nil then
		return;
	end
	if not AtBank then
		return;
	end
	ACUI_MyBank_DEBUG("SaveItems");
	-- rewrite above...
	currPlayer.Bags, _ = GetNumBankSlots();
	local bagName, bagMaxIndex, bagNewIndex;
	for bagNum = 0, currPlayer.Bags do
		if bagNum == 0 then -- Is it the bank?
			bagName = "Bank";
			bagNewIndex = BANK_CONTAINER;
		else	-- It's in a bag slot
			bagName = "Bag"..(4+bagNum);
			bagNewIndex = (4+bagNum);
		end
		if (not currPlayer[bagName]) then
			ACUI_MyBank_DEBUG("Clearing "..bagName);
			currPlayer[bagName] = {} ;
		end
		-- rewrite above
		bagMaxIndex = ACUI_MyBankFrame_SaveBagInfo(currPlayer, bagNewIndex, bagName);
		for itemIndex = 1, bagMaxIndex do
			ACUI_MyBankSaveBagItem(currPlayer, bagNewIndex, itemIndex, bagName);
		end
	end
	for bagNum = 5+currPlayer.Bags, 11 do
		currPlayer["Bag"..bagNum] = nil;
	end

	ACUI_MyBank_SaveMoney();
	ACUI_MyBankFrame_PopulateFrame();
end


function ACUI_MyBankFrame_PopulateFrame()
	local texture, itemButton, itemCount;
	local bagName, bagMaxIndex, bagNewIndex;
	local buttonIndex = 1;
	local BlankTexture;
	local maxBags;
	if not bankPlayer then 
		return;
	end
	if bankPlayer.Bags then
		maxBags = bankPlayer.Bags;
	else
		maxBags = 0;
	end
	ACUI_MyBank_UpdateBagCost(maxBags);
	_, BlankTexture = GetInventorySlotInfo("Bag0Slot");
	for bagNum = 0, maxBags do
		if bagNum == 0 then -- Is it the bank?
			bagName = "Bank";
			bagNewIndex = BANK_CONTAINER;
			bagMaxIndex = 28;
		else
			bagName = "Bag"..(4+bagNum);
			bagNewIndex = (4+bagNum);
			local bagButton = getglobal("ACUI_MyBankFrameBag"..(bagNewIndex));
			SetItemButtonNormalTextureVertexColor(bagButton, 1.0,1.0,1.0);
			SetItemButtonTextureVertexColor(bagButton, 1.0,1.0,1.0);
			if bankPlayer[bagName] and bankPlayer[bagName]["s"] then
				bagMaxIndex = bankPlayer[bagName]["s"];
				SetItemButtonTexture(bagButton, "Interface\\Icons\\"..bankPlayer[bagName]["i"]);
			else
				bagMaxIndex = 0;
				SetItemButtonTexture(bagButton, BlankTexture);
			end
		end
		for itemIndex = 1,bagMaxIndex do
			itemButton = getglobal("ACUI_MyBankFrameItem"..buttonIndex);
			buttonIndex = buttonIndex + 1;
			if(bankPlayer and bankPlayer[bagName] and bankPlayer[bagName][itemIndex]) then
				texture = "Interface\\Icons\\"..bankPlayer[bagName][itemIndex]["i"];
				itemCount = bankPlayer[bagName][itemIndex]["c"];	
			else
				texture = nil;
				itemCount = 0;
			end
			if(itemButton) then
				local locked;
				if AtBank then
					texture, itemCount, locked, _, _ = GetContainerItemInfo(bagNewIndex, itemIndex);
					ACUI_MyBankFrame_UpdateCooldown(itemButton);
				else
					locked = nil;
				end
				if bankPlayer[bagName] and bankPlayer[bagName][itemIndex] and bankPlayer[bagName][itemIndex]["d"] then
					local cooldown = getglobal(itemButton:GetName().."Cooldown");
					local cooldownInfo = bankPlayer[bagName][itemIndex]["d"];
					if cooldownInfo and cooldownInfo["e"] then
						local start, duration, enable = cooldownInfo["s"], cooldownInfo["d"], cooldownInfo["e"];
						if duration > 0 then
							CooldownFrame_SetTimer(cooldown, start, duration, enable);
						else
							cooldown:Hide();
						end
					else
						cooldown:Hide();
					end
				end
				SetItemButtonTexture(itemButton, texture);
				SetItemButtonCount(itemButton, itemCount);
				SetItemButtonDesaturated(itemButton, locked, 0.5, 0.5, 0.5);
				itemButton.bagIndex = bagNewIndex;
				itemButton.itemIndex= itemIndex;
			end
		end
	end
	for bagNum = 5+maxBags, 11 do
		local bagButton = getglobal("ACUI_MyBankFrameBag"..(bagNum));
		SetItemButtonNormalTextureVertexColor(bagButton, 1.0,0.1,0.1);
		SetItemButtonTextureVertexColor(bagButton, 1.0,0.1,0.1);
		SetItemButtonTexture(bagButton, BlankTexture);
	end
	if ( bankPlayer and  bankPlayer["money"] ) then
		MoneyFrame_SetType(ACUI_MyBank_MoneyFrame,"STATIC");
		MoneyFrame_Update("ACUI_MyBank_MoneyFrame", bankPlayer["money"]);
		ACUI_MyBank_MoneyFrame:Show();
	else
		ACUI_MyBank_MoneyFrame:Hide();
	end
	ACUI_MyBank_UpdateTotalMoney();
	ACUI_MyBankFrame_UpdateLookIfNeeded();
end
-- == Viewing other peoples banks ==
function ACUI_MyBank_UserDropDown_GetValue()
	if ( bankPlayerName ) then
		return bankPlayerName;
	else
		return (UnitName("player").."|"..ACUI_MyBank_Trim(GetCVar("realmName")));
	end
end
function ACUI_MyBank_UserDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, ACUI_MyBank_UserDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(this, ACUI_MyBank_UserDropDown_GetValue());
	ACUI_MyBankDropDown.tooltip = "You are viewing this player's bank contents.";
	UIDropDownMenu_SetWidth(ACUI_MyBankDropDown, 140, 0);
	-- OptionsFrame_EnableDropDown(ACUI_MyBankDropDown);
end

function ACUI_MyBank_UserDropDown_OnClick()
	if ( not bankPlayer ) then
		return;
	end
	if AtBank then
		CloseBankFrame();
		OpenACUI_MyBankFrame();
	end
	-- UIDropDownMenu_SetSelectedValue(ACUI_MyBankDropDown, this.value);
	if ( this.value ) then
		bankPlayer = ACUI_MyBank_GetPlayer(this.value);
	end
	ACUI_MyBankFrame_PopulateFrame();
end

function ACUI_MyBank_UserDropDown_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(ACUI_MyBankDropDown);
	local info;
	for key, value in pairs(ACUI_MyBankProfile) do
		local thisRealmPlayers = ACUI_MyBank_Split(key, "|")[2];
		if ( table.getn(ACUI_MyBankProfile[key]) > 0 or ACUI_MyBankProfile[key].money ) then
			if (ACUI_MyBankAllRealms == 1 or thisRealmPlayers == ACUI_MyBank_Trim(GetCVar("realmName")) ) then
				info = {};
				info.text = ACUI_MyBank_Split(key,"|")[1].." of "..ACUI_MyBank_Split(key,"|")[2];
				info.value = key;
				info.func = ACUI_MyBank_UserDropDown_OnClick;
				if ( selectedValue == info.value ) then
					info.checked = 1;
				else
					info.checked = nil;
				end
				UIDropDownMenu_AddButton(info);
			end
		end
	end
end

function ACUI_MyBank_ShowAllRealms_Check_OnClick()
		if ( ACUI_MyBankAllRealms == 0 ) then
			ACUI_MyBankAllRealms = 1;
		else
			ACUI_MyBankAllRealms = 0;
		end
		ACUI_MyBank_UpdateTotalMoney();
end

function ACUI_MyBank_ShowAllRealms_Check_OnShow()
	local allrealms;
	if ( ACUI_MyBankAllRealms == 1 ) then
		allrealms = 1;
	else
		allrealms = nil;
	end
	BlizzardOptionsPanel_CheckButton_Enable(ACUI_MyBank_AllRealms_Check, false);
	ACUI_MyBank_AllRealms_Check:SetChecked(allrealms);
	ACUI_MyBank_AllRealms_Check.tooltipText = "Check to show all saved characters, regardless of realm.";
end


-- === Toggle Functions ===
-- All toggling of options
function ToggleACUI_MyBankFrame()
	if ( ACUI_MyBankFrame:IsVisible() ) then
		CloseACUI_MyBankFrame();
	else
		OpenACUI_MyBankFrame();
	end
end
function CloseACUI_MyBankFrame()
	if AtBank then
		CloseBankFrame();
	end
	if ( ACUI_MyBankFrame:IsVisible() ) then
		HideUIPanel(ACUI_MyBankFrame);
	end
end
function OpenACUI_MyBankFrame()
	ACUI_MyBankFrame_UpdateLookIfNeeded();
	ShowUIPanel(ACUI_MyBankFrame, 1);
end

function ACUI_MyBank_Toggle_Option(option, value, quiet)
	if value == nil then
		if getglobal("ACUI_MyBank"..option) == 1 then
			value = 0;
		else
			value = 1;
		end
	end
	setglobal("ACUI_MyBank"..option, value);
	ACUI_MyBankProfile[PlayerName][option] = value;
	if not quiet then
		local chat_message;
		local globalName = "MYBANK_CHAT_"..string.upper(option);
		if value == 0 then
			globalName = globalName.."OFF";
		else
			globalName = globalName.."ON";
		end
		chat_message = getglobal(globalName);
		if ( chat_message ) then
			ACUI_MyBank_Print(chat_message);
		else
			ACUI_MyBank_DEBUG("ERROR: No global "..globalName);
		end
	end
	if option == "ReplaceBank" then
		ACUI_MyBank_SetReplaceBank();
	elseif option == "ShowPlayers" or option == "BagView" then
		ACUI_MyBankFrame_UpdateLook(getglobal("ACUI_MyBankFrame"),ACUI_MyBank_GetBagsTotalSlots());
	elseif option == "Graphics" or option == "Background" then
		ACUI_MyBank_SetGraphics();
		ACUI_MyBankFrame_UpdateLook(getglobal("ACUI_MyBankFrame"),ACUI_MyBank_GetBagsTotalSlots());
	elseif option == "Freeze" then
		ACUI_MyBank_SetFreeze();
	end
end
function ACUI_MyBank_SetGraphics()
	local pScale = tonumber(ACUI_MyBankFrame:GetParent():GetScale());
	local scale = ACUI_MyBankScale;
	if ( pScale == nil ) then
		pScale = tonumber(GetCVar("uiscale"));
		if not pScale then
			pScale = 1;
			ACUI_MyBank_DEBUG("Scale Error")
		end
	end
	if ACUI_MyBankGraphics == 1 then
		ACUI_MyBankFrame:SetBackdropColor(0,0,0,0);
		ACUI_MyBankFrame:SetBackdropBorderColor(0,0,0,0);
		
		ACUI_MyBankFramePortrait:Show();
		ACUI_MyBankFrameTextureTopLeft:Show();
		ACUI_MyBankFrameTextureTopCenter:Show();
		ACUI_MyBankFrameTextureTopRight:Show();
		ACUI_MyBankFrameTextureLeft:Show();
		ACUI_MyBankFrameTextureCenter:Show();
		ACUI_MyBankFrameTextureRight:Show();
		ACUI_MyBankFrameTextureBottomLeft:Show();
		ACUI_MyBankFrameTextureBottomCenter:Show();
		ACUI_MyBankFrameTextureBottomRight:Show();
		ACUI_MyBankFrameName:ClearAllPoints();
		ACUI_MyBankFrameName:SetPoint("TOPLEFT", "ACUI_MyBankFrame", "TOPLEFT", 70, -8);
		ACUI_MyBankFrameCloseButton:ClearAllPoints();
		ACUI_MyBankFrameCloseButton:SetPoint("TOPRIGHT", "ACUI_MyBankFrame", "TOPRIGHT", 10, 0);
		ACUI_MyBankFrame:SetScale(pScale * tonumber(scale));
	else
		if ACUI_MyBankBackground==1 then
			ACUI_MyBankFrame:SetBackdropColor(0,0,0,1.0);
			ACUI_MyBankFrame:SetBackdropBorderColor(1,1,1,1.0);
		else
			ACUI_MyBankFrame:SetBackdropColor(0,0,0,0);
			ACUI_MyBankFrame:SetBackdropBorderColor(1,1,1,0);
		end
		
		ACUI_MyBankFramePortrait:Hide();
		ACUI_MyBankFrameTextureTopLeft:Hide();
		ACUI_MyBankFrameTextureTopCenter:Hide();
		ACUI_MyBankFrameTextureTopRight:Hide();
		ACUI_MyBankFrameTextureLeft:Hide();
		ACUI_MyBankFrameTextureCenter:Hide();
		ACUI_MyBankFrameTextureRight:Hide();
		ACUI_MyBankFrameTextureBottomLeft:Hide();
		ACUI_MyBankFrameTextureBottomCenter:Hide();
		ACUI_MyBankFrameTextureBottomRight:Hide();
		ACUI_MyBankFrameName:ClearAllPoints();
		ACUI_MyBankFrameName:SetPoint("TOPLEFT", "ACUI_MyBankFrame", "TOPLEFT", 5, -6);
		ACUI_MyBankFrameCloseButton:ClearAllPoints();
		ACUI_MyBankFrameCloseButton:SetPoint("TOPRIGHT", "ACUI_MyBankFrame", "TOPRIGHT", 2, 2);
		ACUI_MyBankFrame:SetScale(pScale * tonumber(scale));
	end
end
function ACUI_MyBank_SetFreeze()
	if ACUI_MyBankFreeze == 1 then
		MBFreezeNormalTexture:SetTexture("Interface\\AddOns\\ACUI_MyBank\\Skin\\LockButton-Locked-Up");
	else
		MBFreezeNormalTexture:SetTexture("Interface\\AddOns\\ACUI_MyBank\\Skin\\LockButton-Unlocked-Up");
	end
end

-- SetReplaceBank: Sets if ACUI_MyBank replaces the official Bank frame
-- Unhooks the Official blizzard frome from the opened and closed events
function ACUI_MyBank_SetReplaceBank()
	if BankFrame_Saved == nil then
		BankFrame_Saved = getglobal("BankFrame");
	end
	if ( ACUI_MyBankReplaceBank == 0 ) then
		BankFrame_Saved:RegisterEvent("BANKFRAME_OPENED");
		BankFrame_Saved:RegisterEvent("BANKFRAME_CLOSED");
		setglobal("BankFrame", BankFrame_Saved);
		BankFrame_Saved = nil;
	else
		if BankFrame_Saved:IsVisible() then
			BankFrame_Saved:Hide();
		end
		BankFrame_Saved:UnregisterEvent("BANKFRAME_OPENED");
		BankFrame_Saved:UnregisterEvent("BANKFRAME_CLOSED");
		setglobal("BankFrame", ACUI_MyBankFrameAtBankText);
	end
end
-- == End Toggle Functions ==

function ACUI_MyBank_SetScale(scale) -- {{{
	if ( type(scale) ~= "number" ) then
		scale = tonumber(scale);
	end
	if ( scale == nil ) then
		ACUI_MyBank_DEBUG("Scale Error")
	else
		if ( ( scale >= 0.5 ) and ( scale <= 2 ) ) then
			local pScale = tonumber(ACUI_MyBankFrame:GetParent():GetScale());
			if ( pScale == nil ) then
				pScale = tonumber(GetCVar("uiscale"));
				if not pScale then
					pScale = 1;
					ACUI_MyBank_DEBUG("Scale Error")
				end
			end
			ACUI_MyBankFrame:SetScale(pScale * tonumber(scale));
			ACUI_MyBankScale = scale;
			bankPlayer.Scale = ACUI_MyBankScale;
		end
	end
end 

--		ACUI_MyBankColumns = col;
--		bankPlayer.Columns = ACUI_MyBankColumns;