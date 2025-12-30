-- ----------------------------
-- SavedVariables init
-- ----------------------------
WarstormSpecManagerDB = WarstormSpecManagerDB or {}

local function WSSM_DB()
    local db = WarstormSpecManagerDB

    if type(db.comps) ~= "table" then db.comps = {} end
    if type(db.lastComp) ~= "string" then db.lastComp = "" end
    if type(db.autoRaidDuringBuild) ~= "boolean" then db.autoRaidDuringBuild = true end 

    -- Hardcoded for Warstorm server
    db.interval = 0.70
    db.commandChannel = "SAY"
    db.addPattern = ".warstormbot bot addclass %s"

    return db
end

local DB = WSSM_DB()

-- ----------------------------
-- Force-commit SavedVariables on logout
-- (prevents other copies/old keys from overwriting our saved comps)
-- ----------------------------
local WSSM_SVCommit = CreateFrame("Frame")
WSSM_SVCommit:RegisterEvent("PLAYER_LOGOUT")
WSSM_SVCommit:SetScript("OnEvent", function()
    -- Ensure the SavedVariables table exists and points to our current DB state
    WarstormSpecManagerDB = WarstormSpecManagerDB or {}

    -- Hard overwrite the fields we care about right before WoW writes SavedVariables
    WarstormSpecManagerDB.comps = DB.comps or {}
    WarstormSpecManagerDB.lastComp = DB.lastComp or ""
    WarstormSpecManagerDB.autoRaidDuringBuild = (DB.autoRaidDuringBuild ~= false)

    -- Remove legacy key from older versions / other copies
    WarstormSpecManagerDB.currentComp = nil
end)


-- Spec data per class (English class tokens)
local paladin_specs = {"prot pve","ret pve","holy pve","prot pvp","ret pvp","holy pvp"}
local warrior_specs = {"prot pve","arms pve","fury pve","prot pvp","arms pvp","fury pvp"}
local dk_specs      = {"blood pve","frost pve","unholy pve","da blood pve","blood pvp","frost pvp","unholy pvp"}
local shaman_specs  = {"resto pve","ele pve","enh pve","resto pvp","ele pvp","enh pvp"}
local hunter_specs  = {"bm pve","mm pve","surv pve","bm pvp","mm pvp","surv pvp"}
local druid_specs   = {"bear pve","resto pve","cat pve","balance pve","resto pvp","cat pvp","balance pvp"}
local rogue_specs   = {"as pve","combat pve","subtlety pve","as pvp","combat pvp","subtlety pvp"}
local priest_specs  = {"holy pve","disc pve","shadow pve","holy pvp","disc pvp","shadow pvp"}
local mage_specs    = {"arcane pve","frost pve","fire pve","frostfire pve","arcane pvp","frost pvp","fire pvp"}
local warlock_specs = {"affli pve","demo pve","destro pve","affli pvp","demo pvp","destro pvp"}

local CLASS_SPECS = {
    PALADIN = paladin_specs,
    WARRIOR = warrior_specs,
    DEATHKNIGHT = dk_specs,
    SHAMAN = shaman_specs,
    HUNTER = hunter_specs,
    DRUID = druid_specs,
    ROGUE = rogue_specs,
    PRIEST = priest_specs,
    MAGE = mage_specs,
    WARLOCK = warlock_specs,
}

local SPEC_EXEC = {
    WARRIOR = {
        ["prot pve"] = function()
            SendChatMessage("talents spec prot pve", "WHISPER", nil, UnitName("target"))
    end,
        ["arms pve"] = function()
            SendChatMessage("talents spec arms pve", "WHISPER", nil, UnitName("target"))
    end,
        ["fury pve"] = function()
            SendChatMessage("talents spec fury pve", "WHISPER", nil, UnitName("target"))
    end,
        ["prot pvp"] = function()
            SendChatMessage("talents spec prot pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["arms pvp"] = function()
            SendChatMessage("talents spec arms pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["fury pvp"] = function()
            SendChatMessage("talents spec fury pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    PALADIN = {
        ["prot pve"] = function()
            SendChatMessage("talents spec prot pve", "WHISPER", nil, UnitName("target"))
    end,
        ["holy pve"] = function()
            SendChatMessage("talents spec holy pve", "WHISPER", nil, UnitName("target"))
    end,
        ["ret pve"] = function()
            SendChatMessage("talents spec ret pve", "WHISPER", nil, UnitName("target"))
    end,
        ["prot pvp"] = function()
            SendChatMessage("talents spec prot pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["holy pvp"] = function()
            SendChatMessage("talents spec holy pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["ret pvp"] = function()
            SendChatMessage("talents spec ret pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    DEATHKNIGHT = {
        ["blood pve"] = function()
            SendChatMessage("talents spec blood pve", "WHISPER", nil, UnitName("target"))
    end,
        ["frost pve"] = function()
            SendChatMessage("talents spec frost pve", "WHISPER", nil, UnitName("target"))
    end,
        ["unholy pve"] = function()
            SendChatMessage("talents spec unholy pve", "WHISPER", nil, UnitName("target"))
    end,
        ["da blood pve"] = function()
            SendChatMessage("talents spec double aura blood pve", "WHISPER", nil, UnitName("target"))
    end,
        ["blood pvp"] = function()
            SendChatMessage("talents spec blood pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["frost pvp"] = function()
            SendChatMessage("talents spec frost pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["unholy pvp"] = function()
            SendChatMessage("talents spec unholy pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    SHAMAN = {
        ["resto pve"] = function()
            SendChatMessage("talents spec resto pve", "WHISPER", nil, UnitName("target"))
    end,
        ["ele pve"] = function()
            SendChatMessage("talents spec ele pve", "WHISPER", nil, UnitName("target"))
    end,
        ["enh pve"] = function()
            SendChatMessage("talents spec enh pve", "WHISPER", nil, UnitName("target"))
    end,
        ["resto pvp"] = function()
            SendChatMessage("talents spec resto pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["ele pvp"] = function()
            SendChatMessage("talents spec ele pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["enh pvp"] = function()
            SendChatMessage("talents spec enh pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    HUNTER = {
        ["bm pve"] = function()
            SendChatMessage("talents spec bm pve", "WHISPER", nil, UnitName("target"))
    end,
        ["mm pve"] = function()
            SendChatMessage("talents spec mm pve", "WHISPER", nil, UnitName("target"))
    end,
        ["surv pve"] = function()
            SendChatMessage("talents spec surv pve", "WHISPER", nil, UnitName("target"))
    end,
        ["bm pvp"] = function()
            SendChatMessage("talents spec bm pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["mm pvp"] = function()
            SendChatMessage("talents spec mm pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["surv pvp"] = function()
            SendChatMessage("talents spec surv pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    DRUID = {
        ["bear pve"] = function()
            SendChatMessage("talents spec bear pve", "WHISPER", nil, UnitName("target"))
    end,
        ["resto pve"] = function()
            SendChatMessage("talents spec resto pve", "WHISPER", nil, UnitName("target"))
    end,
        ["cat pve"] = function()
            SendChatMessage("talents spec cat pve", "WHISPER", nil, UnitName("target"))
    end,
        ["balance pve"] = function()
            SendChatMessage("talents spec balance pve", "WHISPER", nil, UnitName("target"))
    end,
        ["resto pvp"] = function()
            SendChatMessage("talents spec resto pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["cat pvp"] = function()
            SendChatMessage("talents spec cat pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["balance pvp"] = function()
            SendChatMessage("talents spec balance pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    ROGUE = {
        ["subtlety pve"] = function()
            SendChatMessage("talents spec subtlety pve", "WHISPER", nil, UnitName("target"))
    end,
        ["combat pve"] = function()
            SendChatMessage("talents spec combat pve", "WHISPER", nil, UnitName("target"))
    end,
        ["as pve"] = function()
            SendChatMessage("talents spec as pve", "WHISPER", nil, UnitName("target"))
    end,
        ["subtlety pvp"] = function()
            SendChatMessage("talents spec subtlety pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["combat pvp"] = function()
            SendChatMessage("talents spec combat pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["as pvp"] = function()
            SendChatMessage("talents spec as pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    PRIEST = {
        ["holy pve"] = function()
            SendChatMessage("talents spec holy pve", "WHISPER", nil, UnitName("target"))
    end,
        ["disc pve"] = function()
            SendChatMessage("talents spec disc pve", "WHISPER", nil, UnitName("target"))
    end,
        ["shadow pve"] = function()
            SendChatMessage("talents spec shadow pve", "WHISPER", nil, UnitName("target"))
    end,
        ["holy pvp"] = function()
            SendChatMessage("talents spec holy pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["disc pvp"] = function()
            SendChatMessage("talents spec disc pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["shadow pvp"] = function()
            SendChatMessage("talents spec shadow pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    MAGE = {
        ["frost pve"] = function()
            SendChatMessage("talents spec frost pve", "WHISPER", nil, UnitName("target"))
    end,
        ["fire pve"] = function()
            SendChatMessage("talents spec fire pve", "WHISPER", nil, UnitName("target"))
    end,
        ["arcane pve"] = function()
            SendChatMessage("talents spec arcane pve", "WHISPER", nil, UnitName("target"))
    end,
        ["frostfire pve"] = function()
            SendChatMessage("talents spec frostfire pve", "WHISPER", nil, UnitName("target"))
    end,
        ["frost pvp"] = function()
            SendChatMessage("talents spec frost pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["fire pvp"] = function()
            SendChatMessage("talents spec fire pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["arcane pvp"] = function()
            SendChatMessage("talents spec arcane pvp", "WHISPER", nil, UnitName("target"))
    end,
    },

    WARLOCK = {
        ["affli pve"] = function()
            SendChatMessage("talents spec affli pve", "WHISPER", nil, UnitName("target"))
    end,
        ["demo pve"] = function()
            SendChatMessage("talents spec demo pve", "WHISPER", nil, UnitName("target"))
    end,
        ["destro pve"] = function()
            SendChatMessage("talents spec destro pve", "WHISPER", nil, UnitName("target"))
    end,
        ["affli pvp"] = function()
            SendChatMessage("talents spec affli pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["demo pvp"] = function()
            SendChatMessage("talents spec demo pvp", "WHISPER", nil, UnitName("target"))
    end,
        ["destro pvp"] = function()
            SendChatMessage("talents spec destro pvp", "WHISPER", nil, UnitName("target"))
    end,
    },
}


-- ================================
-- Main frame
-- ================================
local frame = CreateFrame("Frame", "WarstormSpecManagerFrame", UIParent)

frame:SetSize(420, 170)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Simple backdrop (3.3.5 style)
frame:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile     = true,
    tileSize = 32,
    edgeSize = 32,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
})
frame:SetBackdropColor(0, 0, 0, 1)

-- Title text
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("WarstormSpecManager v2.0")

-- Status / helper text
local statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
statusText:SetPoint("TOP", 0, -32)
statusText:SetText("Target a player to see spec buttons.")

-- Container for buttons
frame.buttons = {}

-- ================================
-- Button creation / update
-- ================================
local function ClearButtons()
    for _, btn in ipairs(frame.buttons) do
        btn:Hide()
    end
end

local function UpdateButtonsForClass(classToken)
    ClearButtons()

    local specs = CLASS_SPECS[classToken]
    if not specs then
        statusText:SetText("No spec data for this class.")
        return
    end

    local num = #specs
    if num == 0 then
        statusText:SetText("No specs configured.")
        return
    end

    statusText:SetText("Target: "..(classToken or "Unknown"))

    -- Layout: 2 rows for spec buttons
    local rows = 2
    local cols = math.ceil(num / rows)

    local btnWidth  = 100
    local btnHeight = 24
    local spacing   = 5

    -- Center the grid under the status text
    local totalWidth = cols * btnWidth + (cols - 1) * spacing
    local startX = -totalWidth / 2 + btnWidth / 2
    local startY = -50

    -- =========================
    -- SPEC BUTTONS
    -- =========================
    for i, specName in ipairs(specs) do
    local row = math.floor((i - 1) / cols)
    local col = (i - 1) % cols

    local btn = frame.buttons[i]
    if not btn then
        btn = CreateFrame("Button", "WarstormSpecButton"..i, frame, "UIPanelButtonTemplate")
        frame.buttons[i] = btn
    end

    btn:SetSize(btnWidth, btnHeight)
    btn:SetText(specName)
    btn:ClearAllPoints()
    btn:SetPoint("TOP", frame, "TOP",
        startX + col * (btnWidth + spacing),
        startY - row * (btnHeight + spacing)
    )

    -- *** THIS IS THE IMPORTANT PART ***
    btn:SetScript("OnClick", function(self)
        local classTable = SPEC_EXEC[classToken]
        local fn = classTable and classTable[specName]

        if fn then
            fn()  -- run your custom execution
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Warstorm]|r No execution defined for "..(classToken or "?").." - "..specName)
        end
    end)

    btn:Show()
end


    -- Hide leftovers from previous target
    for i = num + 1, #frame.buttons do
        frame.buttons[i]:Hide()
    end


    -- =========================
    -- THIRD ROW BUTTONS
    -- =========================
    local thirdRowY = startY - (2 * (btnHeight + spacing))

    -- AUTOGEAR
    if not frame.autogearButton then
        frame.autogearButton = CreateFrame("Button", "WarstormAutoGearButton", frame, "UIPanelButtonTemplate")
        frame.autogearButton:SetText("Autogear")
        frame.autogearButton:SetSize(100, 24)
        frame.autogearButton:SetScript("OnClick", function()
            SendChatMessage("autogear", "PARTY", nil, nil)
        end)
    end

    frame.autogearButton:ClearAllPoints()
    frame.autogearButton:SetPoint("TOP", frame, "TOP", -60, thirdRowY)
    frame.autogearButton:Show()


    -- CLOSE
    if not frame.closeButton then
        frame.closeButton = CreateFrame("Button", "WarstormCloseButton", frame, "UIPanelButtonTemplate")
        frame.closeButton:SetText("Close")
        frame.closeButton:SetSize(100, 24)
        frame.closeButton:SetScript("OnClick", function()
        frame:Hide()
        WSSM_IsOpen = false

        -- ALSO close Bot Comp window if it exists
        if frame.botPanel and frame.botPanel:IsShown() then
        frame.botPanel:Hide()
        end
end)
    end

    frame.closeButton:ClearAllPoints()
    frame.closeButton:SetPoint("TOP", frame, "TOP", 60, thirdRowY)
    frame.closeButton:Show()
end

local function ShowUtilityRowOnly()
    -- Show the main frame even without target
    frame:Show()

    -- Optional: update title/label if you have one
    if frame.titleText then
        frame.titleText:SetText("Warstorm Spec Manager")
    end
    if frame.targetNameText then
        frame.targetNameText:SetText("No target")
    end

    -- Hide spec buttons
    if frame.specButtons then
        for _, b in ipairs(frame.specButtons) do
            b:Hide()
        end
    end

    -- Hide class label if you have one
    if frame.classLabel then
        frame.classLabel:SetText("")
    end

    -- Ensure utility buttons exist and are shown (Autogear / Bots / Close)
    local thirdRowY = -120  -- adjust if your addon uses a different Y

    if frame.autogearButton then
        frame.autogearButton:ClearAllPoints()
        frame.autogearButton:SetPoint("TOP", frame, "TOP", -110, thirdRowY)
        frame.autogearButton:Show()
    end

    if type(WSSM_HookThirdRowButtons) == "function" then
    WSSM_HookThirdRowButtons()
    end

    if frame.botsButton then
        frame.botsButton:ClearAllPoints()
        frame.botsButton:SetPoint("TOP", frame, "TOP", 0, thirdRowY)
        frame.botsButton:Show()
    end

    if frame.closeButton then
        frame.closeButton:ClearAllPoints()
        frame.closeButton:SetPoint("TOP", frame, "TOP", 110, thirdRowY)
        frame.closeButton:Show()
    end
end

-- ================================
-- Target handling
-- ================================
local function RefreshForTarget()
    -- Do nothing if the addon window is not open
    if not WSSM_IsOpen or not frame:IsShown() then
        return
    end

    if UnitExists("target") and UnitIsPlayer("target") then
        local _, classToken = UnitClass("target")
        if classToken and CLASS_SPECS[classToken] then
            statusText:SetText(UnitName("target"))
            UpdateButtonsForClass(classToken)
        else
            statusText:SetText("No spec data for this target's class.")
            ClearButtons()
        end
    else
        statusText:SetText("Target a player to see spec buttons.")
        ClearButtons()
    end
end

-- ================================
-- Events
-- ================================
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Hide by default; only open via slash command
        frame:Hide()
        WSSM_IsOpen = false
        return
    elseif event == "PLAYER_TARGET_CHANGED" then
        RefreshForTarget()
    end
end)

-- =========================================================
-- WarstormSpecManager - Bot Party/Comp Manager (Warstorm server)
-- Uses: .warstormbot bot addclass <class>  (SAY)
-- =========================================================
-- ----------------------------
-- Class mapping (server tokens)
-- ----------------------------
local WSSM_CLASS_ORDER = {
    "WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST",
    "SHAMAN","MAGE","WARLOCK","DRUID","DEATHKNIGHT"
}

local WSSM_CLASS_LABEL = {
    WARRIOR="Warrior", PALADIN="Paladin", HUNTER="Hunter", ROGUE="Rogue", PRIEST="Priest",
    SHAMAN="Shaman", MAGE="Mage", WARLOCK="Warlock", DRUID="Druid", DEATHKNIGHT="DK"
}

local WSSM_CLASS_CMD = {
    WARRIOR="warrior", PALADIN="paladin", HUNTER="hunter", ROGUE="rogue", PRIEST="priest",
    SHAMAN="shaman", MAGE="mage", WARLOCK="warlock", DRUID="druid", DEATHKNIGHT="dk"
}

-- ----------------------------
-- Send queue (interval)
-- ----------------------------
local WSSM_SendQueue = {}
local WSSM_Sending = false
local WSSM_Elapsed = 0

-- True only while the addon is actively building a group/raid
local WSSM_BUILD_ACTIVE = false

local function WSSM_Queue(msg)
    if not msg or msg == "" then return end
    table.insert(WSSM_SendQueue, msg)
    WSSM_Sending = true
end

local function WSSM_ClearQueue()
    wipe(WSSM_SendQueue)
    WSSM_Sending = false
    WSSM_BUILD_ACTIVE = false
end

local WSSM_Ticker = CreateFrame("Frame")
WSSM_Ticker:SetScript("OnUpdate", function(self, elapsed)
    if not WSSM_Sending then return end
    if #WSSM_SendQueue == 0 then
    WSSM_Sending = false
    WSSM_BUILD_ACTIVE = false
    return
end

    local interval = tonumber(DB.interval) or 0.40
    if interval < 0.10 then interval = 0.10 end

    WSSM_Elapsed = WSSM_Elapsed + elapsed
    if WSSM_Elapsed < interval then return end
    WSSM_Elapsed = 0

    local msg = table.remove(WSSM_SendQueue, 1)
    SendChatMessage(msg, DB.commandChannel or "SAY")
end)

local function WSSM_QueueAddClass(classToken, count)
    count = tonumber(count) or 0
    if count <= 0 then return end

    local cmd = WSSM_CLASS_CMD[classToken]
    if not cmd then return end

    local pattern = DB.addPattern or ""
    if not string.find(pattern, "%%s") then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[Warstorm]|r addPattern must include %s (example: .warstormbot bot addclass %s)")
        return
    end

    for i=1, count do
        WSSM_Queue(string.format(pattern, cmd))
    end
end

local function WSSM_QueueComp(comp)
    if type(comp) ~= "table" then return end

    local total = 0
    for _, classToken in ipairs(WSSM_CLASS_ORDER) do
        total = total + (tonumber(comp[classToken]) or 0)
    end

    if total <= 0 then return end

    WSSM_BUILD_ACTIVE = true

    for _, classToken in ipairs(WSSM_CLASS_ORDER) do
        WSSM_QueueAddClass(classToken, comp[classToken] or 0)
    end
end


-- =========================================================
-- UI Panel (simple, anchored to your existing frame)
-- =========================================================
local function Trim(s)
    s = s or ""
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    return s
end

local function WSSM_GetCompNames()
    local t = {}
    for name,_ in pairs(DB.comps) do table.insert(t, name) end
    table.sort(t)
    return t
end

local function WSSM_FixInputBoxLook(editBox, height)
    if not editBox then return end

    -- Standard height for clean borders
    if height then
        local w = editBox:GetWidth()
        editBox:SetSize(w, height)
    end

    -- Text padding
    editBox:SetTextInsets(6, 6, 0, 0)

    -- Force template pieces to align (prevents "disconnected" look)
    if editBox.Left and editBox.Middle and editBox.Right then
        editBox.Left:ClearAllPoints()
        editBox.Left:SetPoint("LEFT", editBox, "LEFT", -5, 0)

        editBox.Right:ClearAllPoints()
        editBox.Right:SetPoint("RIGHT", editBox, "RIGHT", 0, 0)

        editBox.Middle:ClearAllPoints()
        editBox.Middle:SetPoint("LEFT", editBox.Left, "RIGHT", 0, 0)
        editBox.Middle:SetPoint("RIGHT", editBox.Right, "LEFT", 0, 0)
    end
end

-- ----------------------------
-- Premade comps (built-in)
-- Click in dropdown to load. Optionally Save to store as your own.
-- ----------------------------
-- ----------------------------
-- Raid-specific presets (built-in)
-- Totals are exactly 10 or 25.
-- These are class-count templates (roles/specs handled later via your spec buttons).
-- ----------------------------

local WSSM_RAID_PRESETS = {
    ["Naxxramas 10"] = {
        WARRIOR=0, PALADIN=2, HUNTER=1, ROGUE=1, PRIEST=1,
        SHAMAN=1, MAGE=1, WARLOCK=1, DRUID=1, DEATHKNIGHT=0,
    },
    ["Ulduar 10"] = {
        WARRIOR=0, PALADIN=2, HUNTER=1, ROGUE=0, PRIEST=1,
        SHAMAN=1, MAGE=1, WARLOCK=1, DRUID=1, DEATHKNIGHT=1,
    },
    ["Trial of the Crusader 10"] = {
        WARRIOR=0, PALADIN=2, HUNTER=1, ROGUE=0, PRIEST=1,
        SHAMAN=1, MAGE=1, WARLOCK=1, DRUID=1, DEATHKNIGHT=1,
    },
    ["Icecrown Citadel 10"] = {
        WARRIOR=0, PALADIN=2, HUNTER=1, ROGUE=0, PRIEST=1,
        SHAMAN=1, MAGE=1, WARLOCK=1, DRUID=1, DEATHKNIGHT=1,
    },

    ["Naxxramas 25"] = {
        WARRIOR=1, PALADIN=3, HUNTER=2, ROGUE=1, PRIEST=3,
        SHAMAN=3, MAGE=2, WARLOCK=3, DRUID=3, DEATHKNIGHT=3,
    },
    ["Ulduar 25"] = {
        WARRIOR=1, PALADIN=3, HUNTER=2, ROGUE=1, PRIEST=3,
        SHAMAN=3, MAGE=2, WARLOCK=3, DRUID=3, DEATHKNIGHT=3,
    },
    ["Trial of the Crusader 25"] = {
        WARRIOR=0, PALADIN=3, HUNTER=2, ROGUE=1, PRIEST=3,
        SHAMAN=3, MAGE=2, WARLOCK=3, DRUID=3, DEATHKNIGHT=4,
    },
    ["Icecrown Citadel 25"] = {
        WARRIOR=0, PALADIN=3, HUNTER=2, ROGUE=0, PRIEST=3,
        SHAMAN=3, MAGE=2, WARLOCK=4, DRUID=3, DEATHKNIGHT=4,
    },
}

local function WSSM_CreateBotPanel(parentFrame)
    if parentFrame.botPanel then return end

    local p = CreateFrame("Frame", "WarstormSpecManagerBotPanel", UIParent)
    parentFrame.botPanel = p

    p:SetSize(420, 410)
    p:SetPoint("LEFT", parentFrame, "RIGHT", 10, 0)
    p:SetMovable(true)
    p:EnableMouse(true)
    p:RegisterForDrag("LeftButton")
    p:SetScript("OnDragStart", p.StartMoving)
    p:SetScript("OnDragStop", p.StopMovingOrSizing)

    p:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile     = true,
        tileSize = 32,
        edgeSize = 32,
        insets   = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    p:SetBackdropColor(0, 0, 0, 1)

    local title = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Warstorm Bot Comp")

    -- Comp name
    local nameLbl = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameLbl:SetPoint("TOPLEFT", p, "TOPLEFT", 16, -42)
    nameLbl:SetText("Comp name:")

    local nameBox = CreateFrame("EditBox", nil, p, "InputBoxTemplate")
    nameBox:SetSize(180, 20)
    nameBox:ClearAllPoints()
    nameBox:SetPoint("TOPLEFT", p, "TOPLEFT", 90, -46)
    nameBox:SetAutoFocus(false)
    nameBox:SetText(DB.lastComp or "")
    nameBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    WSSM_FixInputBoxLook(nameBox, 20)
    p.nameBox = nameBox

    -- Dropdown
    local drop = CreateFrame("Frame", "WarstormSpecManagerCompDrop", p, "UIDropDownMenuTemplate")
    drop:ClearAllPoints()
    drop:SetPoint("TOPRIGHT", p, "TOPRIGHT", -14, -38)
    UIDropDownMenu_SetWidth(drop, 120)
    p.drop = drop
    frame.botPanel.drop = drop


    -- Count boxes
    p.countBoxes = {}

    local startY = -86
    local rowH = 20

    for i, classToken in ipairs(WSSM_CLASS_ORDER) do
        local y = startY - (i-1)*rowH

        local lbl = p:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lbl:SetPoint("TOPLEFT", p, "TOPLEFT", 16, y)
        lbl:SetText(WSSM_CLASS_LABEL[classToken] or classToken)

        local box = CreateFrame("EditBox", nil, p, "InputBoxTemplate")
        box:SetSize(26, 20)
        box:ClearAllPoints()
        box:SetPoint("TOPRIGHT", p, "TOPRIGHT", -40, y)
        box:SetAutoFocus(false)
        box:SetNumeric(true)
        box:SetMaxLetters(2) -- keep compact but allow 10+
        box:SetJustifyH("CENTER")
        box:SetText("0")
        box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        WSSM_FixInputBoxLook(box, 20)

        p.countBoxes[classToken] = box
    end

    local function ReadCompFromUI()
        local comp = {}
        for _, classToken in ipairs(WSSM_CLASS_ORDER) do
            local box = p.countBoxes[classToken]
            comp[classToken] = tonumber(box and box:GetText() or "0") or 0
        end
        return comp
    end

    local function LoadCompToUI(name, comp)
        if type(comp) ~= "table" then return end
        p.nameBox:SetText(name or "")
        for _, classToken in ipairs(WSSM_CLASS_ORDER) do
            local box = p.countBoxes[classToken]
            if box then
                box:SetText(tostring(tonumber(comp[classToken]) or 0))
            end
        end
        UIDropDownMenu_SetText(p.drop, name or "Saved comps")
        UIDropDownMenu_SetSelectedValue(p.drop, name)
    end

    local function GetPresetNames(suffix)
        local t = {}
        for name,_ in pairs(WSSM_RAID_PRESETS) do
            if string.find(name, suffix) then table.insert(t, name) end
        end
        table.sort(t)
        return t
    end

    UIDropDownMenu_Initialize(drop, function()
        local function AddTitle(txt)
            local info = UIDropDownMenu_CreateInfo()
            info.text = txt
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info)
        end

        local function AddEntry(name, comp, markSaved)
            local info = UIDropDownMenu_CreateInfo()
            info.text = name
            info.value = name
            info.func = function()
                LoadCompToUI(name, comp)
                if markSaved then DB.lastComp = name end
            end
            UIDropDownMenu_AddButton(info)
        end

        AddTitle("Raid presets (10)")
        for _, name in ipairs(GetPresetNames(" 10")) do
            AddEntry(name, WSSM_RAID_PRESETS[name], false)
        end

        AddTitle("Raid presets (25)")
        for _, name in ipairs(GetPresetNames(" 25")) do
            AddEntry(name, WSSM_RAID_PRESETS[name], false)
        end

        AddTitle("Saved comps")
        for _, compName in ipairs(WSSM_GetCompNames()) do
            local comp = DB.comps[compName]
            if type(comp) == "table" then
                AddEntry(compName, comp, true)
            end
        end
    end)

    -- Status line
    local status = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    status:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 16, 16)
    status:SetText("Queue: 0")
    p:SetScript("OnUpdate", function()
        status:SetText("Queue: "..tostring(#WSSM_SendQueue))
    end)

    -- Buttons (centered)
    local stopBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
    stopBtn:SetSize(90, 22)
    stopBtn:SetPoint("BOTTOM", p, "BOTTOM", -110, 54)
    stopBtn:SetText("Stop")
    stopBtn:SetScript("OnClick", function()
        WSSM_ClearQueue()
        DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00[Warstorm]|r Queue cleared.")
    end)

    local saveBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
    saveBtn:SetSize(90, 22)
    saveBtn:SetPoint("BOTTOM", p, "BOTTOM", 0, 54)
    saveBtn:SetText("Save")
    saveBtn:SetScript("OnClick", function()
        local name = Trim(p.nameBox:GetText())
        if name == "" then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[Warstorm]|r Enter a comp name first.")
            return
        end
        DB.comps[name] = ReadCompFromUI()
        DB.lastComp = name
        UIDropDownMenu_Initialize(p.drop, p.drop.initialize)
        UIDropDownMenu_SetText(p.drop, name)
        local c = 0
        for _ in pairs(DB.comps) do c = c + 1 end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Warstorm]|r Saved comp: "..name.." (total saved: "..c..")")
    end)

-- ================================
-- 3.3.5 compatibility helpers (GLOBAL)
-- ================================
    function WSSM_IsInRaid()
        if type(IsInRaid) == "function" then
            return IsInRaid()
        end
        if type(GetNumRaidMembers) == "function" then
            return GetNumRaidMembers() > 0
        end
        return UnitInRaid and (UnitInRaid("player") ~= nil) or false
    end

    function WSSM_IsLeader()
        if type(UnitIsGroupLeader) == "function" then
            return UnitIsGroupLeader("player")
        end
        if type(IsPartyLeader) == "function" then
            return IsPartyLeader()
        end
        return false
    end

        local buildBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
        buildBtn:SetSize(90, 22)
        buildBtn:SetPoint("BOTTOM", p, "BOTTOM", 110, 54)
        buildBtn:SetText("Build")
        buildBtn:SetScript("OnClick", function()
            -- Ensure raid on 3.3.5
            if not WSSM_IsInRaid() and GetNumPartyMembers() > 0 then
                if WSSM_IsLeader() then
                    ConvertToRaid()
                end
            end
        
            local comp = ReadCompFromUI()
            WSSM_QueueComp(comp)
        
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Warstorm]|r Bot add commands queued.")
end)


    local delBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
    delBtn:SetSize(90, 22)
    delBtn:SetPoint("BOTTOM", p, "BOTTOM", -110, 28)
    delBtn:SetText("Delete")
    delBtn:SetScript("OnClick", function()
        local name = Trim(p.nameBox:GetText())
        if name == "" then name = DB.lastComp or "" end
        if name ~= "" and DB.comps[name] then
            DB.comps[name] = nil
            if DB.lastComp == name then DB.lastComp = "" end
            UIDropDownMenu_Initialize(p.drop, p.drop.initialize)
            UIDropDownMenu_SetText(p.drop, "Saved comps")
            DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00[Warstorm]|r Deleted comp: "..name)
        end
    end)

    local loadBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
    loadBtn:SetSize(90, 22)
    loadBtn:SetPoint("BOTTOM", p, "BOTTOM", 0, 28)
    loadBtn:SetText("Load")
    loadBtn:SetScript("OnClick", function()
        local name = Trim(p.nameBox:GetText())
        if name == "" then name = DB.lastComp or "" end
        if name ~= "" and type(DB.comps[name]) == "table" then
            LoadCompToUI(name, DB.comps[name])
            DB.lastComp = name
        end
    end)

    local clearBtn = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
    clearBtn:SetSize(90, 22)
    clearBtn:SetPoint("BOTTOM", p, "BOTTOM", 110, 28)
    clearBtn:SetText("Clear")
    clearBtn:SetScript("OnClick", function()
        for _, classToken in ipairs(WSSM_CLASS_ORDER) do
            local box = p.countBoxes[classToken]
            if box then box:SetText("0") end
        end
    end)

    p:Hide()
end


local function WSSM_ToggleBotPanel()
    if not frame then return end

    WSSM_CreateBotPanel(frame)

    -- If we're about to show it, rebuild the dropdown from SavedVariables
    if not frame.botPanel:IsShown() then
        if frame.botPanel.drop and frame.botPanel.drop.initialize then
            UIDropDownMenu_Initialize(frame.botPanel.drop, frame.botPanel.drop.initialize)

            -- Optional: show last used comp name in the dropdown text
            if DB and DB.lastComp and DB.lastComp ~= "" then
                UIDropDownMenu_SetText(frame.botPanel.drop, DB.lastComp)
            else
                UIDropDownMenu_SetText(frame.botPanel.drop, "Saved comps")
            end
        end

        frame.botPanel:Show()
    else
        frame.botPanel:Hide()
    end
end


-- =========================================================
-- Add a "Bots" button on your main frame (next to Autogear/Close)
-- =========================================================
local function WSSM_HookThirdRowButtons()
    if not frame then return end
    if frame.botsButton then return end

    -- Create the button now; positioning is handled by UpdateButtonsForClass() each refresh.
    frame.botsButton = CreateFrame("Button", "WarstormBotsButton", frame, "UIPanelButtonTemplate")
    frame.botsButton:SetText("Bots")
    frame.botsButton:SetSize(100, 24)
    frame.botsButton:SetScript("OnClick", function()
        WSSM_ToggleBotPanel()
    end)
end

WSSM_HookThirdRowButtons()

-- Monkey-patch: after your UpdateButtonsForClass lays out Autogear/Close, we place Bots in the middle.
-- This does NOT change your spec logic.
local _orig_UpdateButtonsForClass = UpdateButtonsForClass
UpdateButtonsForClass = function(classToken)
    _orig_UpdateButtonsForClass(classToken)

    if frame and frame.botsButton and frame.autogearButton and frame.closeButton then
        -- Find the Y position used by the existing buttons (use autogear as reference)
        local _, _, _, _, y = frame.autogearButton:GetPoint(1)

        frame.autogearButton:ClearAllPoints()
        frame.autogearButton:SetPoint("TOP", frame, "TOP", -110, y)

        frame.botsButton:ClearAllPoints()
        frame.botsButton:SetPoint("TOP", frame, "TOP", 0, y)
        frame.botsButton:Show()

        frame.closeButton:ClearAllPoints()
        frame.closeButton:SetPoint("TOP", frame, "TOP", 110, y)
    end
end

-- ================================
-- Auto-convert party to raid when first member joins
-- ================================
local WSSM_AutoRaid = CreateFrame("Frame")
WSSM_AutoRaid:RegisterEvent("PARTY_MEMBERS_CHANGED")
WSSM_AutoRaid:SetScript("OnEvent", function()
    -- Only auto-convert while we are actively building bots
    -- (prevents questing/invites from forcing raid)
    -- Only auto-convert while we are actively building via the addon
    if not WSSM_BUILD_ACTIVE then
        return
    end

    -- Optional: allow user toggle (default ON)
    if WarstormSpecManagerDB and WarstormSpecManagerDB.autoRaidDuringBuild == false then
        return
    end


    if not WSSM_IsInRaid() and GetNumPartyMembers() > 0 then
        if WSSM_IsLeader() then
            ConvertToRaid()
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Warstorm]|r Party converted to raid.")
        end
    end
end)



-- ================================
-- Slash commands to toggle frame
-- ================================
SLASH_WARSTORMSPECMANAGER1 = "/wssm"

SlashCmdList["WARSTORMSPECMANAGER"] = function()
    if frame:IsShown() then
        -- Close main
        frame:Hide()
        WSSM_IsOpen = false

        -- Close bot window too (same as clicking Close)
        if frame.botPanel and frame.botPanel:IsShown() then
            frame.botPanel:Hide()
        end
    else
        -- Open main
        frame:Show()
        WSSM_IsOpen = true
        RefreshForTarget()

        -- Emulate clicking the Bots button
        if frame.botsButton and frame.botsButton.Click then
            frame.botsButton:Click()
        else
            -- Fallback if button doesn't exist for some reason
            if type(WSSM_ToggleBotPanel) == "function" then
                WSSM_ToggleBotPanel()
            end
        end
    end
end
