local addonName = ...
AutoOptionDB = AutoOptionDB or {}

--Options helpers
local layoutIndex = 0
local function GetLayoutIndex()
	layoutIndex = layoutIndex + 1
	return layoutIndex
end

local function UpdateOptions()
	if AutoOptionDB.autoLootOn then
		C_CVar.SetCVar("autoLootDefault", 1)
	else
		C_CVar.SetCVar("autoLootDefault", 0)
	end

	if AutoOptionDB.actionTargetingOn then
		--C_CVar.SetCVar("softTargetEnemy", 3)
		Settings.SetValue("PROXY_ACTION_TARGETING", true)
	else
		--C_CVar.SetCVar("softTargetEnemy", 0)
		Settings.SetValue("PROXY_ACTION_TARGETING", false)
	end

	local layoutInfo = C_EditMode.GetLayouts()
	local numLayoutPresets = 2
	for index, layout in ipairs(layoutInfo.layouts) do
		if layout.layoutName == AutoOptionDB["layout"] then
			C_EditMode.SetActiveLayout(index + numLayoutPresets)
		end
	end

	if AutoOptionDB.showActionBar2 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", false)
	end
	if AutoOptionDB.showActionBar3 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", false)
	end
	if AutoOptionDB.showActionBar4 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", false)
	end
	if AutoOptionDB.showActionBar5 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", false)
	end
	if AutoOptionDB.showActionBar6 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_6", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_6", false)
	end
	if AutoOptionDB.showActionBar7 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_7", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_7", false)
	end
	if AutoOptionDB.showActionBar8 then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_8", true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_8", false)
	end
end

local function OnSettingsLoaded(self, event, ...)

	UpdateOptions()

	-- Options Panel
	local optionsPanel = CreateFrame("Frame", nil, nil, "VerticalLayoutFrame")
	optionsPanel.spacing = 4
	optionsPanel.name = "Auto Options"
	local category, layout = Settings.RegisterCanvasLayoutCategory(optionsPanel, "Auto Options");
	category.ID = "Auto Options";
	Settings.RegisterAddOnCategory(category);

	local function makeCheckButton(text)
		local checkButton = CreateFrame("CheckButton", addonName.."CheckBox", optionsPanel, "SettingsCheckBoxTemplate")
		checkButton.text = checkButton:CreateFontString(addonName.."CheckBoxText", "ARTWORK", "GameFontNormal")
		checkButton.text:SetText(text)
		checkButton.text:SetPoint("LEFT", checkButton, "RIGHT", 4, 0)
		checkButton:SetSize(21,20)

		return checkButton
	end

	local settingsInfo = {
	{ option = "autoLootOn", detail = "Auto Loot Enabled" },
	{ option = "actionTargetingOn", detail = "Action Targeting Enabled" },
	{ option = "showActionBar2", detail = "Show Action Bar 2" },
	{ option = "showActionBar3", detail = "Show Action Bar 3" },
	{ option = "showActionBar4", detail = "Show Action Bar 4" },
	{ option = "showActionBar5", detail = "Show Action Bar 5" },
	{ option = "showActionBar6", detail = "Show Action Bar 6" },
	{ option = "showActionBar7", detail = "Show Action Bar 7" },
	{ option = "showActionBar8", detail = "Show Action Bar 8" },
	}

	local header = CreateFrame("Frame", nil, optionsPanel)
	header:SetSize(150, 50)
	local title = header:CreateFontString("ARTWORK", nil, "GameFontHighlightHuge")
	title:SetPoint("TOP")
	title:SetText("Auto Options")
	local divider = header:CreateTexture(nil, "ARTWORK")
	divider:SetAtlas("Options_HorizontalDivider", true)
	divider:SetPoint("BOTTOMLEFT", -50)
	header.layoutIndex = GetLayoutIndex()
	header.bottomPadding = 10

	local footer = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormal")
	footer:SetPoint("LEFT")
	footer:SetText("Set options here to have them apply to all characters on login or /reload")
	footer.layoutIndex = GetLayoutIndex()

	for _, keyInfo in ipairs(settingsInfo) do
		
		local checkButton = makeCheckButton(keyInfo.detail)
		checkButton.layoutIndex = GetLayoutIndex()
		checkButton:SetHitRectInsets(0,-checkButton.text:GetWidth(), 0, 0)
		checkButton.HoverBackground = nil
		checkButton:SetChecked(AutoOptionDB[keyInfo.option])
		checkButton:SetScript("OnClick", function()
			AutoOptionDB[keyInfo.option] = not AutoOptionDB[keyInfo.option]
		checkButton:SetChecked(AutoOptionDB[keyInfo.option])
		UpdateOptions()
		end)
	end

	local layoutString = optionsPanel:CreateFontString("ARTWORK", nil, "GameFontNormal")
	layoutString:SetPoint("LEFT")
	layoutString:SetText("Edit Mode Layout - Set blank to not override layout")
	layoutString.layoutIndex = GetLayoutIndex()
	layoutString.topPadding = 5

	local dropdownLayout = CreateFrame("Frame", "dropdownLayout", optionsPanel, "UIDropDownMenuTemplate")
	dropdownLayout.layoutIndex = GetLayoutIndex()
	UIDropDownMenu_SetText(dropdownLayout, AutoOptionDB["layout"])
	
	local function DropDownOnClick(self, arg1)
		AutoOptionDB["layout"] = arg1
		UpdateOptions()
		UIDropDownMenu_SetText(dropdownLayout, AutoOptionDB["layout"])
	end

	-- Populate the dropdown menu with all existing layouts
	function DropDownMenu(frame, level, menuList)
		local layouts = {};
		tinsert(layouts, " ")
		local layoutInfo = C_EditMode.GetLayouts()
		for index, layout in ipairs(layoutInfo.layouts) do
			tinsert(layouts, layout.layoutName)
		end

		local info = UIDropDownMenu_CreateInfo()
		info.func = DropDownOnClick
		for i, name in ipairs(layouts) do
			info.text, info.arg1 = name, name
			UIDropDownMenu_AddButton(info)
		end
	end
	UIDropDownMenu_Initialize(dropdownLayout, DropDownMenu)

	optionsPanel:Layout()

end

local CVarCheckFrame = CreateFrame("Frame")
CVarCheckFrame:RegisterEvent("SETTINGS_LOADED")
CVarCheckFrame:SetScript("OnEvent", OnSettingsLoaded)



