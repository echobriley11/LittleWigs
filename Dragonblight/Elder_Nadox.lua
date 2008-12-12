﻿------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Elder Nadox"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ElderNadox",

	guardian = "Ahn'kahar Guardian",
	guardian_desc = "Warn for the hatching of an Ahn'kahar Guardian.",

	broodplague = "Brood Plague",
	broodplague_desc = "Warn for who has the Brood Plague debuff",
	broodplague_message = "Brood Plague: %s",

	broodplaguebar = "Brood Plague Bar",
	broodplaguebar_desc = "Show a bar for the duration of the Brood Plague debuff.",
} end)

L:RegisterTranslations("deDE", function() return {
	guardian = "Wächter der Ahn'kahar",
	guardian_desc = "Warnt vor dem Schlüpfen eines Wächter der Ahn'kahar.",

	broodplague = "Brutseuche",
	broodplague_desc = "Warnt wer den Brutseuche Debuff hat",
	broodplague_message = "Brutseuche: %s",

	broodplaguebar = "Brutseuche Bar",
	broodplaguebar_desc = "Zeigt eine Bar für die Dauer des Brutseuche Debuffs.",
} end)

L:RegisterTranslations("frFR", function() return {
	guardian = "Gardien ahn'kahar",
	guardian_desc = "Prévient lors de l'éclosion d'un gardien ahn'kahar.",

	broodplague = "Peste d'espèce",
	broodplague_desc = "Prévient quand un joueur subit les effets de la Peste d'espèce.",
	broodplague_message = "Peste d'espèce : %s",

	broodplaguebar = "Peste d'espèce - Barre",
	broodplaguebar_desc = "Affiche une barre indiquant la durée de la Peste d'espèce.",
} end)

L:RegisterTranslations("koKR", function() return {
	guardian = "안카하르 수호자",
	guardian_desc = "안카하르 수호자가 깨어나는 것을 알립니다.",

	broodplague = "혈족 역병",
	broodplague_desc = "혈족 역병 디버프에 걸린 플레이어를 알립니다.",
	broodplague_message = "혈족 역병: %s",

	broodplaguebar = "혈족 역병 바",
	broodplaguebar_desc = "혈족 역병 디버프가 지속되는 바를 표시합니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	guardian = "安卡哈守护者",
	guardian_desc = "当孵化安卡哈守护者时发出警报。",

	broodplague = "蜘蛛瘟疫",
	broodplague_desc = "当玩家中了蜘蛛瘟疫减益时发出警报。",
	broodplague_message = "蜘蛛瘟疫：%s！",

	broodplaguebar = "蜘蛛瘟疫计时条",
	broodplaguebar_desc = "当蜘蛛瘟疫减益持续时显示计时条。",
} end)

L:RegisterTranslations("zhTW", function() return {
	guardian = "安卡哈守護者",
	guardian_desc = "當孵化安卡哈守護者時發出警報。",

	broodplague = "孵育瘟疫",
	broodplague_desc = "當玩家中了孵育瘟疫減益時發出警報。",
	broodplague_message = "孵育瘟疫：%s！",

	broodplaguebar = "孵育瘟疫計時條",
	broodplaguebar_desc = "當孵育瘟疫減益持續時顯示計時條。",
} end)

L:RegisterTranslations("esES", function() return {
} end)

L:RegisterTranslations("ruRU", function() return {
	guardian = "Ан'кахарский страж",
	guardian_desc = "Предупреждать о насечке Ан'кахарских стражей.",

	broodplague = "Чумное поветрие",
	broodplague_desc = "Предупреждать на ком наложен дебафф - Чумное поветрие",
	broodplague_message = "Чумное поветрие: %s",

	broodplaguebar = "Полоса Чумного поветрия",
	broodplaguebar_desc = "Отображать полосу длительности дебаффа - Чумное поветрие.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partycontent = true
mod.otherMenu = "Dragonblight"
mod.zonename = BZ["Ahn'kahet: The Old Kingdom"]
mod.enabletrigger = boss
mod.guid = 29309
mod.toggleoptions = {"guardian",-1,"broodplague","broodplaguebar","bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:AddCombatListener("SPELL_AURA_APPLIED", "BroodPlague", 56130, 59467)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BroodPlagueRemoved", 56130, 59467)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.guardian then
		self:IfMessage(msg, "Important")
	end
end

function mod:BroodPlague(player, spellId, _, _, spellName)
	if self.db.profile.broodplague then
		self:IfMessage(L["broodplague_message"]:format(player), "Important", spellId)
	end
	if self.db.profile.broodplaguebar then
		self:Bar(L["broodplague_message"]:format(player), 30, spellId)
	end
end

function mod:BroodPlagueRemoved(player)
	if self.db.profile.broodplaguebar then
		self:TriggerEvent("BigWigs_StopBar", self, L["broodplague_message"]:format(player))
	end
end