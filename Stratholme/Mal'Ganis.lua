﻿-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Mal'Ganis", "The Culling of Stratholme")
if not mod then return end
mod.partyContent = true
mod.otherMenu = "Caverns of Time"
mod:RegisterEnableMob(26533)
mod.toggleOptions = {
	52721, -- Sleep
	52723, -- Vampiric Touch
	"bosskill",
}

-------------------------------------------------------------------------------
--  Locals

local sleepDuration = 8

-------------------------------------------------------------------------------
--  Localization

local L = LibStub("AceLocale-3.0"):NewLocale("Little Wigs: Mal'Ganis", "enUS", true)
if L then
	--@do-not-package@
	L["vampTouch_message"] = "Mal'Ganis gains Vampiric Touch"
	L["defeat_trigger"] = "Your journey has just begun, young prince. Gather your forces, and meet me in the arctic land of Northrend. It is there we shall settle the score between us. It is there that your true destiny will unfold."
	--@end-do-not-package@
	--@localization(locale="enUS", namespace="Stratholme/Mal_Ganis", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = LibStub("AceLocale-3.0"):GetLocale("Little Wigs: Mal'Ganis")
mod.locale = L

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Sleep", 52721, 58849)
	self:Log("SPELL_AURA_REMOVED", "SleepRemove", 52721, 58849)	
	self:Log("SPELL_AURA_APPLIED", "VampTouch", 52723)
	self:Log("SPELL_AURA_REMOVED", "VampTouchRemove", 52723)

	self:Yell("Win", L["defeat_trigger"])
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Sleep(player, spellId, _, _, spellName)
	self:Message(52721, spellName..": "..player, "Important", spellId)
	if spellId == 52721 then sleepDuration = 10 end
	self:Bar(52721, player..": "..spellName, sleepDuration, spellId)
end

function mod:SleepRemove(player, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, player..": "..spellName)
end

function mod:VampTouch(target, spellId, _, _, spellName, _, _, _, dGuid)
	if tonumber(dGuid:sub(-12, -7), 16) ~= 26533 then return end
	self:Message(52723, L["vampTouch_message"], "Important", spellId)
	self:Bar(52723, spellName, 30, spellId)
end

function mod:VampTouchRemove(_, _, _, _, spellName, _, _, _, dGuid)
	if tonumber(dGuid:sub(-12, -7), 16) ~= 26533 then return end
	self:SendMessage("BigWigs_StopBar", self, spellName)
end
