------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Prince Keleseth"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Keleseth",

	tomb = "Frost Tomb",
	tomb_desc = "Warn for who is in the Frost Tomb.",
	tomb_message = "Frost Tomb: %s",

	tombBar = "Frost Tomb Bar",
	tombBar_desc = "Display a bar for the duration of the Frost Tomb.",
} end )

L:RegisterTranslations("koKR", function() return {
	tomb = "서리 무덤",
	tomb_desc = "서리 무덤의 대상자를 알립니다.",
	tomb_message = "서리 무덤: %s",
	
	tombBar = "서리 무덤 바",
	tombBar_desc = "서리 무덤이 지속되는 바를 표시합니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	tomb = "Tombeau de givre",
	tomb_desc = "Prévient quand un joueur subit les effets du Tombeau de givre.",
	tomb_message = "Tombeau de givre : %s",

	tombBar = "Tombeau de givre - Barre",
	tombBar_desc = "Affiche une barre indiquant la durée du Tombeau de givre.",
} end )

L:RegisterTranslations("zhTW", function() return {
	tomb = "冰霜之墓",
	tomb_desc = "當玩家中了冰霜之墓時發出警報。",
	tomb_message = ">%s<：冰霜之墓！",

	tombBar = "冰霜之墓計時條",
	tombBar_desc = "當冰霜之墓持續時顯示計時條。",
} end )

L:RegisterTranslations("deDE", function() return {
	tomb = "Frostgrab",
	tomb_desc = "Warnt wer im Frostgrab gefangen ist.",
	tomb_message = "Frostgrab: %s",

	tombBar = "Frostgrab-Anzeige",
	tombBar_desc = "Eine Leiste \195\188ber die Dauer von Frostgrab anzeigen.",
} end )

L:RegisterTranslations("zhCN", function() return {
	tomb = "冰霜之墓",
	tomb_desc = "当玩家中了冰霜之墓时发出警报。",
	tomb_message = ">%s<：冰霜之墓！",

	tombBar = "冰霜之墓计时条",
	tombBar_desc = "当冰霜之墓持续时显示计时条。",
} end )

L:RegisterTranslations("ruRU", function() return {
	tomb = "Ледяная могила",
	tomb_desc = "Предупреждать, когда кто-нибудь попадает в ледяную могилу.",
	tomb_message = "В ледяной могиле: %s",

	tombBar = "Полоса Ледяной могилы",
	tombBar_desc = "Отображение полосы продолжительности Ледяной могилы.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Howling Fjord"
mod.zonename = BZ["Utgarde Keep"]
mod.enabletrigger = boss 
mod.guid = 23953
mod.toggleoptions = {"tomb", "tombBar", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tomb", 48400)
	self:AddCombatListener("SPELL_AURA_REMOVED", "TombRemoved", 48400)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Tomb(player, spellId)
	if self.db.profile.tomb then
		self:IfMessage(L["tomb_message"]:format(player), "Urgent", spellId)
	end
	if self.db.profile.tombBar then
		self:Bar(L["tomb_message"]:format(player), 20, spellId)
	end
end

function mod:TombRemoved(player)
	if self.db.profile.tombBar then
		self:TriggerEvent("BigWigs_StopBar", self, L["tomb_message"]:format(player))
	end
end