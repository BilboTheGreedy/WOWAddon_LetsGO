LG_SavedVars = {charName = "", enabled = true}; 

local MSG_PREFIX = "LetsGO"
local MSG_SAY = "LetsSAY"
local MSG_FOLLOW = "LetsFOLLOW"

RegisterAddonMessagePrefix(MSG_PREFIX)
RegisterAddonMessagePrefix(MSG_SAY)
RegisterAddonMessagePrefix(MSG_FOLLOW)

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", function(self, event, prefix, msg, channel, sender)
if LG_SavedVars.enabled then
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
			SendChatMessage("My  XP is currently at "..floor( (XP / XPMax)*100 ).."%.","GUILD")
			end
		end
	   end
	end)
	
local UIConfig = CreateFrame("Frame", "LetsGO_Frame", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(300, 240);
UIConfig:SetPoint("CENTER", UIParent, "CENTER");
LetsGO_Frame:Hide()
LetsGO_Frame:SetMovable(true)
LetsGO_Frame:EnableMouse(true)
LetsGO_Frame:RegisterForDrag("LeftButton")

UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
UIConfig.title:SetText("LetsGO Options");

-- EditBox

UIConfig.charEditBox = CreateFrame("EditBox", nil, UIConfig, "InputBoxTemplate");
UIConfig.charEditBox:SetPoint("CENTER", UIConfig, "TOP", 0, -50);
UIConfig.charEditBox:SetSize(140, 50);
UIConfig.charEditBox:ClearFocus(); 
UIConfig.charEditBox:SetText(LG_SavedVars.charName) 

--Buttons

UIConfig.mountBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.mountBtn:SetPoint("CENTER", UIConfig, "TOP", 60, -90);
UIConfig.mountBtn:SetSize(120, 40);
UIConfig.mountBtn:SetText("Mount");
UIConfig.mountBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.mountBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.mountBtn:SetScript("OnClick", function(self,event) 
print("mount")
	SendAddonMessage("LetsGO", "mount", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.dismountBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.dismountBtn:SetPoint("CENTER", UIConfig.mountBtn, "CENTER", -125, 0);
UIConfig.dismountBtn:SetSize(120, 40);
UIConfig.dismountBtn:SetText("Dismount");
UIConfig.dismountBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.dismountBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.dismountBtn:SetScript("OnClick", function(self,event) 
print("dismount")
	SendAddonMessage("LetsGO", "dismount", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.followBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.followBtn:SetPoint("CENTER", UIConfig.dismountBtn, "CENTER", 0, -50);
UIConfig.followBtn:SetSize(120, 40);
UIConfig.followBtn:SetText("Follow");
UIConfig.followBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.followBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.followBtn:SetScript("OnClick", function(self,event) 
print("follow")
	SendAddonMessage("LetsFOLLOW", UnitName("target"), "WHISPER", LG_SavedVars.charName)
end)

UIConfig.confirmsummonBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.confirmsummonBtn:SetPoint("CENTER", UIConfig.followBtn, "CENTER", 125, 0);
UIConfig.confirmsummonBtn:SetSize(120, 40);
UIConfig.confirmsummonBtn:SetText("Accept Summon");
UIConfig.confirmsummonBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.confirmsummonBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.confirmsummonBtn:SetScript("OnClick", function(self,event) 
print("Accept Summon")
	SendAddonMessage("LetsGO", "confirmsummon", "WHISPER", LG_SavedVars.charName)
end)

UIConfig.saveBtn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
UIConfig.saveBtn:SetPoint("CENTER", UIConfig.charEditBox, "Right", 25, 0);
UIConfig.saveBtn:SetSize(40, 20);
UIConfig.saveBtn:SetText("Save");
UIConfig.saveBtn:SetNormalFontObject("GameFontNormalLarge");
UIConfig.saveBtn:SetHighlightFontObject("GameFontHighlightLarge");
UIConfig.saveBtn:SetScript("OnClick", function(self,event,arg1) 
	print(UIConfig.charEditBox:GetText())
	LG_SavedVars.charName = UIConfig.charEditBox:GetText()
end)

-- Checkboxes

UIConfig.rxChkBtn = CreateFrame("CheckButton", nil, UIConfig, "UICheckbuttonTemplate");
UIConfig.rxChkBtn:SetPoint("TOPRIGHT", UIConfig.confirmsummonBtn, "BOTTOMLEFT", -90, -10);
UIConfig.rxChkBtn.text:SetText("Enable Receiving LetsGO");
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



SLASH_letsgo1 = '/letsgo';
local function handler(msg, editbox)
 local command = msg:match("^(%S*)%s*(.-)$");
     print(GetAddOnMetadata("LetsGo", "Title"), 'version ' .. GetAddOnMetadata("LetsGo", "Version"));
	LetsGO_Frame:Show()
	UIConfig.charEditBox:SetText(LG_SavedVars.charName) 
	UIConfig.rxChkBtn:SetChecked(LG_SavedVars.enabled);
 end
SlashCmdList["letsgo"] = handler;