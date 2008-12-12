------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Krik'thir the Gatewatcher"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local frenzyannounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Krik'thir",

	curse = "Curse of Fatigue",
	curse_desc = "Warn when someone has Curse of Fatigue.",
	curse_message = "Curse of Fatigue: %s",

	curseBar = "Curse of Fatigue Bar",
	curseBar_desc = "Display a bar for the duration of Curse of Fatigue.",

	frenzy = "Frenzy",
	frenzy_desc = "Warnings when Krik'thir goes into a frenzy.",
	frenzy_message = "Krik'thir is frenzied",
	frenzysoon_message = "Frenzy Soon",
} end)

L:RegisterTranslations("koKR", function() return {
	curse = "피로의 저주",
	curse_desc = "피로의 저주에 걸린 플레이어를 알립니다.",
	curse_message = "피로의 저주 - %s",
	
	curseBar = "피로의 저주 바",
	curseBar_desc = "피로의 저주가 지속되는 바를 표시합니다.",

	frenzy = "광기",
	frenzy_desc = "크릭시르의 광기에 대해 알립니다.",
	frenzy_message = "크릭시르 광기!",
	frenzysoon_message = "잠시 후 광기",
} end)

L:RegisterTranslations("deDE", function() return {
	curse = "Fluch der Erm\195\188dung",
	curse_desc = "Warnung wenn jemand von Fluch der Erm\195\188dung betroffen ist.",
	curse_message = "Fluch der Erm\195\188dung: %s",

	curseBar = "Fluch der Erm\195\188dung-Anzeige",
	curseBar_desc = "Eine Leiste f\195\188r die Dauer von Fluch der Erm\195\188dung anzeigen.",

	frenzy = "Raserei",
	frenzy_desc = "Warnungen wenn Krik'thir in Raserei verf\195\164llt.",
	frenzy_message = "Krik'thir ist in Raserei verfallen",
	frenzysoon_message = "Raserei bald",
} end)

L:RegisterTranslations("frFR", function() return {
	curse = "Malédiction de fatigue",
	curse_desc = "Prévient quand un joueur subit les effets de la Malédiction de fatigue.",
	curse_message = "Malédiction de fatigue - %s",

	curseBar = "Malédiction de fatigue - Barre",
	curseBar_desc = "Affiche une barre indiquant la durée de la Malédiction de fatigue.",

	frenzy = "Frénésie",
	frenzy_desc = "Prévient quand Krik'thir entre en frénésie.",
	frenzy_message = "Krik'thir est en frénésie",
	frenzysoon_message = "Frénésie imminente",
} end)

L:RegisterTranslations("zhCN", function() return {
	curse = "疲倦诅咒",
	curse_desc = "当玩家中了疲倦诅咒时发出警报。",
	curse_message = ">%s<：疲倦诅咒！",

	curseBar = "疲倦诅咒计时条",
	curseBar_desc = "当疲倦诅咒持续时显示计时条。",

	frenzy = "狂乱",
	frenzy_desc = "当看门者克里克希尔狂乱时发出警报。",
	frenzy_message = "看门者克里克希尔 - 狂乱！",
	frenzysoon_message = "即将 狂乱！",
} end)

L:RegisterTranslations("zhTW", function() return {
	curse = "疲倦詛咒",
	curse_desc = "當玩家中了疲倦詛咒時發出警報。",
	curse_message = ">%s<：疲倦詛咒！",

	curseBar = "疲倦詛咒計時條",
	curseBar_desc = "當疲倦詛咒持續時顯示計時條。",

	frenzy = "狂亂",
	frenzy_desc = "當『守門者』齊力克西爾狂亂時發出警報。",
	frenzy_message = "『守門者』齊力克西爾 - 狂亂！",
	frenzysoon_message = "即將 狂亂！",
} end)

L:RegisterTranslations("esES", function() return {
} end)

L:RegisterTranslations("ruRU", function() return {
	curse = "Проклятие усталости",
	curse_desc = "Предупреждать, когда на кого-нибудь накладывается проклятие усталости.",
	curse_message = "Проклятие усталости - %s",

	curseBar = "Полоса Проклятия усталости",
	curseBar_desc = "Отображать полосу продолжительности Проклятия усталости.",

	frenzy = "Бешенство",
	frenzy_desc = "Предупреждать о бешенстве Крик'тира.",
	frenzy_message = "Крик'тир взбесился",
	frenzysoon_message = "Скоро бешенство",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partycontent = true
mod.otherMenu = "Dragonblight"
mod.zonename = BZ["Azjol-Nerub"]
mod.enabletrigger = boss
mod.guid = 28684
mod.toggleoptions = {"curse", "curseBar", -1, "frenzy", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Curse", 52592, 59368)
	self:AddCombatListener("SPELL_AURA_APPLIED", "CurseRemoved", 52592, 59368)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frenzy", 28747)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	frenzyannounced = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Curse(player, spellId)
	if self.db.profile.curse then
		self:IfMessage(L["curse_message"]:format(player), "Attention", spellId)
	end
	if self.db.profile.curseBar then
		self:Bar(L["curse_message"]:format(player), 10, spellId)
	end
end

function mod:CurseRemoved(player)
	if self.db.profile.curseBar then
		self:TriggerEvent("BigWigs_StopBar", self, L["curse_message"]:format(player))
	end
end

function mod:Frenzy(_, spellId)
	if self.db.profile.frenzy then
		self:IfMessage(L["frenzy_message"], "Important", spellId)
	end
end

function mod:UNIT_HEALTH(arg1)
	if not self.db.profile.frenzy then return end
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 10 and health <= 15 and not frenzyannounced then
			frenzyannounced = true
			self:IfMessage(L["frenzysoon_message"], "Important", 28747)
		elseif health > 15 and frenzyannounced then
			frenzyannounced = nil
		end
	end
end