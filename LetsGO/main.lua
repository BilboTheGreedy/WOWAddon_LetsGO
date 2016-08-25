LG_SavedVars = {
charName = "Enter Character Name", 
enabled = true,
authorizedNames = {'Name'}
}; 


local MSG_PREFIX = "LetsGO"
local MSG_SAY = "LetsSAY"
local MSG_FOLLOW = "LetsFOLLOW"

RegisterAddonMessagePrefix(MSG_PREFIX)
RegisterAddonMessagePrefix(MSG_SAY)
RegisterAddonMessagePrefix(MSG_FOLLOW)

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", function(self, event, prefix, msg, channel, sender)
-- Outside of commands-scope, for checking if other player got LetsGO Enabled.
	if prefix == MSG_PREFIX and msg == "LetsGO:true" and channel == "WHISPER" then 
		print(string.format("LetsGO: [%s] got \124cff00ff00\124hEnabled Receiving\124h\124r set", sender))
	end
	if prefix == MSG_PREFIX and msg == "LetsGO:false" and channel == "WHISPER" then 
		print(string.format("LetsGO: [%s] got \124cffff0000\124hDisabled Receiving\124h\124r set", sender))
	end
	if prefix == MSG_PREFIX and msg == "CheckEnabled" and channel == "WHISPER" then 
		SendAddonMessage(MSG_PREFIX, "LetsGO:" .. tostring(LG_SavedVars.enabled), "WHISPER", LG_SavedVars.charName)
	end

-- Inside of commands-scope, if player got LetsGO Enabled
 for _,v in pairs(LG_SavedVars.authorizedNames) do
  if v == sender and LG_SavedVars.enabled and LG_SavedVars.enabled then
	-- print(string.format("LetsGO: [%s] got \124cff00ff00\124hAuthorized\124h\124r set", sender))
	if prefix == MSG_PREFIX and msg == "dismount" and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		Dismount();
		end
	if prefix == MSG_PREFIX and msg == "mount" and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		C_MountJournal.SummonByID(0)
		end
	if prefix == MSG_PREFIX and msg == "confirmsummon" and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		ConfirmSummon();
		StaticPopup1:Hide();
		end
	if prefix == MSG_PREFIX and msg == "acceptresurrect" and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		AcceptResurrect();
		end
	if prefix == MSG_PREFIX and msg == "repopme" and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		RepopMe();
		end
	if prefix == MSG_PREFIX and msg == "acceptrade" and channel == "WHISPER" then 
		AcceptTrade();
		end
	if prefix == MSG_SAY and channel == "WHISPER" then 
		SendChatMessage(msg, "SAY")
		end
	if prefix == MSG_FOLLOW and channel == "WHISPER" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
		FollowUnit(msg)
		end
	if prefix == MSG_PREFIX and msg == "xp" then 
		print(string.format("[%s] [%s]: %s %s", channel, sender, prefix, msg))
			if (UnitLevel("player")) ~= 110 then
			XP = UnitXP("player")
			XPMax = UnitXPMax("player")
			SendChatMessage("My Level XP is at "..floor( (XP / XPMax)*100 ).."%.","WHISPER", nil, sender)
			end
			end
		    break
		  end
		end
	end)
	
local UIConfig = CreateFrame("Frame", "LetsGO_Frame", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(300, 290);
UIConfig:SetPoint("CENTER", UIParent, "CENTER");
LetsGO_Frame:Hide()
LetsGO_Frame:SetMovable(true)
LetsGO_Frame:EnableMouse(true)
LetsGO_Frame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end)
LetsGO_Frame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)
LetsGO_Frame:SetScript("OnHide", function(self)
  if ( self.isMoving ) then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)

UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
UIConfig.title:SetText("LetsGO Options");

-- EditBox

UIConfig.charEditBox = CreateFrame("EditBox", nil, UIConfig, "InputBoxTemplate");
UIConfig.charEditBox:SetPoint("RIGHT", UIConfig, "TOP", 10, -50);
UIConfig.charEditBox:SetSize(140, 40);
UIConfig.charEditBox:ClearFocus(); 
UIConfig.charEditBox:SetAutoFocus(false)
UIConfig.charEditBox:SetText(LG_SavedVars.charName) 

UIConfig.authorizedNamesEditBox = CreateFrame("EditBox", nil, UIConfig, "InputBoxTemplate");
UIConfig.authorizedNamesEditBox:SetPoint("CENTER", UIConfig.charEditBox, "BOTTOM", 0, -10);
UIConfig.authorizedNamesEditBox:SetSize(140, 40);
UIConfig.authorizedNamesEditBox:ClearFocus(); 
UIConfig.authorizedNamesEditBox:SetAutoFocus(false)
UIConfig.authorizedNamesEditBox:SetText(LG_SavedVars.charName)

--Buttons

UIConfig.mountBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.mountBtn:SetPoint("CENTER", UIConfig, "TOP", 60, -145);
UIConfig.mountBtn:SetSize(120, 30);
UIConfig.mountBtn:SetText("Mount");
UIConfig.mountBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.mountBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.mountBtn:SetScript("OnClick", function(self,event) 
print("mount")
	SendAddonMessage("LetsGO", "mount", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.dismountBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.dismountBtn:SetPoint("CENTER", UIConfig.mountBtn, "CENTER", -125, 0);
UIConfig.dismountBtn:SetSize(120, 30);
UIConfig.dismountBtn:SetText("Dismount");
UIConfig.dismountBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.dismountBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.dismountBtn:SetScript("OnClick", function(self,event) 
print("dismount")
	SendAddonMessage("LetsGO", "dismount", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.followBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.followBtn:SetPoint("CENTER", UIConfig.dismountBtn, "CENTER", 0, -35);
UIConfig.followBtn:SetSize(120, 30);
UIConfig.followBtn:SetText("Follow");
UIConfig.followBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.followBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.followBtn:SetScript("OnClick", function(self,event) 
print("follow")
	SendAddonMessage("LetsFOLLOW", UnitName("target"), "WHISPER", LG_SavedVars.charName)
end)

UIConfig.confirmsummonBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.confirmsummonBtn:SetPoint("CENTER", UIConfig.followBtn, "CENTER", 125, 0);
UIConfig.confirmsummonBtn:SetSize(120, 30);
UIConfig.confirmsummonBtn:SetText("Accept Summon");
UIConfig.confirmsummonBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.confirmsummonBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.confirmsummonBtn:SetScript("OnClick", function(self,event) 
print("Accept Summon")
	SendAddonMessage("LetsGO", "confirmsummon", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.acceptresurrectBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.acceptresurrectBtn:SetPoint("CENTER", UIConfig.confirmsummonBtn, "CENTER", -125, -35);
UIConfig.acceptresurrectBtn:SetSize(120, 30);
UIConfig.acceptresurrectBtn:SetText("Accept Resurrect");
UIConfig.acceptresurrectBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.acceptresurrectBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.acceptresurrectBtn:SetScript("OnClick", function(self,event) 
print("Accept Resurrect")
	SendAddonMessage("LetsGO", "acceptresurrect", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.repopmeBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.repopmeBtn:SetPoint("CENTER", UIConfig.acceptresurrectBtn, "CENTER", 125, 0);
UIConfig.repopmeBtn:SetSize(120, 30);
UIConfig.repopmeBtn:SetText("Release Spirit");
UIConfig.repopmeBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.repopmeBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.repopmeBtn:SetScript("OnClick", function(self,event) 
print("Release Spirit")
	SendAddonMessage("LetsGO", "repopme", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.expBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.expBtn:SetPoint("CENTER", UIConfig.repopmeBtn, "CENTER", 0, -35);
UIConfig.expBtn:SetSize(120, 30);
UIConfig.expBtn:SetText("Level Experiance");
UIConfig.expBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.expBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.expBtn:SetScript("OnClick", function(self,event) 
print("Level Experiance")
	SendAddonMessage("LetsGO", "xp", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.saveBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.saveBtn:SetPoint("CENTER", UIConfig.charEditBox, "Right", 25, 0);
UIConfig.saveBtn:SetSize(50, 30);
UIConfig.saveBtn:SetText("Save");
UIConfig.saveBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.saveBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.saveBtn:SetScript("OnClick", function(self,event) 
	print(string.format("LetsGO:Sending Commands to: \124cFFF56900\124h[%s]\124h\124r", UIConfig.charEditBox:GetText()))
	LG_SavedVars.charName = UIConfig.charEditBox:GetText()
	SendAddonMessage("LetsGO", "CheckEnabled", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.authBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.authBtn:SetPoint("CENTER", UIConfig.authorizedNamesEditBox, "Right", 25, 0);
UIConfig.authBtn:SetSize(50, 30);
UIConfig.authBtn:SetText("Auth");
UIConfig.authBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.authBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.authBtn:SetScript("OnClick", function(self,event) 
	print(string.format("LetsGO:Authorized: \124cff00ff00\124h[%s]\124h\124r", UIConfig.authorizedNamesEditBox:GetText()))
	table.insert(LG_SavedVars.authorizedNames, UIConfig.authorizedNamesEditBox:GetText())
end)

UIConfig.rmauthBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.rmauthBtn:SetPoint("CENTER", UIConfig.authBtn, "Right", 34, 0);
UIConfig.rmauthBtn:SetSize(60, 30);
UIConfig.rmauthBtn:SetText("Remove");
UIConfig.rmauthBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.rmauthBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.rmauthBtn:SetScript("OnClick", function(self,event) 
	for _,v in pairs(LG_SavedVars.authorizedNames) do
	  if v == UIConfig.authorizedNamesEditBox:GetText() then
		print(string.format("LetsGO:Unauthorized: \124cffff0000\124h[%s]\124h\124r", UIConfig.authorizedNamesEditBox:GetText()))
		table.remove(LG_SavedVars.authorizedNames, _)
		break
	  end
	end
end)

-- Text

-- Checkboxes

UIConfig.rxChkBtn = CreateFrame("CheckButton", nil, UIConfig, "UICheckbuttonTemplate");
UIConfig.rxChkBtn:SetPoint("CENTER", UIConfig.authorizedNamesEditBox, "BOTTOMLEFT", 10, -10);
UIConfig.rxChkBtn.text:SetText("Enable Receiving");
UIConfig.rxChkBtn:SetChecked(LG_SavedVars.enabled);
UIConfig.rxChkBtn:SetScript("OnClick", function(self,event,arg1) 
  if self:GetChecked() then
    DEFAULT_CHAT_FRAME:AddMessage("LetsGO: \124cff00ff00\124hListening\124h\124r");
	LG_SavedVars.enabled = true
  else
    DEFAULT_CHAT_FRAME:AddMessage("LetsGO: \124cffff0000\124hNot Listening\124h\124r");
	LG_SavedVars.enabled = false
  end
end)

SLASH_lg1 = '/lg';
local function handler(msg, editbox)
 local command = msg:match("^(%S*)%s*(.-)$");
     print(GetAddOnMetadata("LetsGo", "Title"), 'version ' .. GetAddOnMetadata("LetsGo", "Version"));
	LetsGO_Frame:Show()
	UIConfig.charEditBox:SetText(LG_SavedVars.charName) 
	UIConfig.authorizedNamesEditBox:SetText(LG_SavedVars.charName) 
	UIConfig.rxChkBtn:SetChecked(LG_SavedVars.enabled);
 end
SlashCmdList["lg"] = handler;