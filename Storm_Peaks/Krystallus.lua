-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Krystallus", "Halls of Stone")
if not mod then return end
mod.partycontent = true
mod.otherMenu = "The Storm Peaks"
mod:RegisterEnableMob(27977)
mod.toggleOptions = {
	50810, -- Shatter
	"bosskill",
}

-------------------------------------------------------------------------------
--  Localization

local L = LibStub("AceLocale-3.0"):NewLocale("Little Wigs: ", "enUS", true)
if L then
	--@do-not-package@
	L["shatterBar_message"] = "~Shatter"
	L["shatter_warn"] = "Ground Slam - Shatter in ~8 sec"
	--@end-do-not-package@
	--@localization(locale="enUS", namespace="Storm_Peaks/Krystallus", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = LibStub("AceLocale-3.0"):GetLocale("Little Wigs: ")
mod.locale = L

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Slam", 50833)
	self:Log("SPELL_CAST_START", "Shatter", 50810, 61546)
	self:Death("Win", 27977)
end

----------------------------------
-------------------------------------------------------------------------------
--  Event Handlers

function mod:Slam(_, spellId, _, _, spellName)
	self:Message(50810, L["shatter_warn"], "Urgent", spellId)
	self:Bar(50810, L["shatterBar_message"], 8, spellId)
end

function mod:Shatter(_, spellId, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, L["shatterBar_message"])
	self:Message(50810, spellName, "Urgent", spellId)
end
