--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local nodeDodge = nil;
bShieldsOn = false;

function onInit()
	OptionsManager.registerCallback("SHLD", onUseShieldsChanged);
	onUseShieldsChanged();
	
	local node = getDatabaseNode();
	
	CharManager.updateAbilityDependantSkills(node)
	
	local sVersion = DB.getValue(node, "version", "0");
	if sVersion == "0" then
		DB.createChild(node, "version", "string");
		DB.setValue(node, "version", "string", "7");
	end
	
	onSTRChanged();
	DB.addHandler(DB.getPath(node, "abilities.strength"), "onUpdate", onSTRChanged);
	onCONChanged();
	DB.addHandler(DB.getPath(node, "abilities.constitution"), "onUpdate", onCONChanged);
	onSIZChanged();
	DB.addHandler(DB.getPath(node, "abilities.size"), "onUpdate", onSIZChanged);
	onDEXChanged();
	DB.addHandler(DB.getPath(node, "abilities.dexterity"), "onUpdate", onDEXChanged);
	onAPPChanged();
	DB.addHandler(DB.getPath(node, "abilities.appearance"), "onUpdate", onAPPChanged);
	onINTChanged();
	DB.addHandler(DB.getPath(node, "abilities.intelligence"), "onUpdate", onINTChanged);
	onPOWChanged();
	DB.addHandler(DB.getPath(node, "abilities.power"), "onUpdate", onPOWChanged);
	onEDUChanged();
	DB.addHandler(DB.getPath(node, "abilities.education"), "onUpdate", onEDUChanged);
	
	DB.addHandler(DB.getPath(node, "age"), "onUpdate", onAgeChanged);
	onAgeChanged();
	
	nodeLangOwn = ActorManager2.getSkill(node, Interface.getString("char_lang_own_skill"));
	nodeDodge = ActorManager2.getSkill(node, Interface.getString("char_skill_dodge"));
	if nodeDodge and DB.getChild(nodeDodge, "total") then
		DB.addHandler(DB.getPath(DB.getChild(nodeDodge, "total")), "onUpdate", onDodgeChanged);
		onDodgeChanged();
	end
	
	ActorManager2.calcMove(node);
end

function onClose()
	local node = getDatabaseNode();
	
	DB.removeHandler(DB.getPath(node, "abilities.dexterity"), "onUpdate", onDEXChanged);
	DB.removeHandler(DB.getPath(node, "abilities.intelligence"), "onUpdate", onINTChanged);
	DB.removeHandler(DB.getPath(node, "abilities.education"), "onUpdate", onEDUChanged);
	DB.removeHandler(DB.getPath(node, "abilities.strength"), "onUpdate", onSTRChanged);
	DB.removeHandler(DB.getPath(node, "abilities.size"), "onUpdate", onSIZChanged);
	DB.removeHandler(DB.getPath(node, "abilities.constitution"), "onUpdate", onCONChanged);
	DB.removeHandler(DB.getPath(node, "abilities.appearance"), "onUpdate", onAPPChanged);
	DB.removeHandler(DB.getPath(node, "abilities.power"), "onUpdate", onPOWChanged);
	DB.removeHandler(DB.getPath(node, "age"), "onUpdate", onAgeChanged);
	
	if nodeDodge then
		DB.removeHandler(DB.getPath(DB.getChild(nodeDodge, "total")), "onUpdate", onDodgeChanged);
	end
end

function onINTChanged()
	local node = getDatabaseNode();
	local nIntelligence = DB.getValue(node, "abilities.intelligence", 0);
	DB.setValue(node, "skillpoints.personalinterest", "number", nIntelligence*2);
	CharManager.updateSkillBase(node, "INT", nIntelligence);
	CharManager.updateSkillPoints(node);
	ActorManager2.updateOccupationSkills(node);
end

function onDEXChanged()
	local node = getDatabaseNode();
	local nDexterity = DB.getValue(node, "abilities.dexterity", 0);
	CharManager.updateSkillBase(node, "DEX", nDexterity);
	ActorManager2.updateOccupationSkills(node);
	ActorManager2.calcMove(node);
end

function onEDUChanged()
	local node = getDatabaseNode();
	local nEducation = DB.getValue(node, "abilities.education", 10);
	
	CharManager.updateSkillBase(node, "EDU", nEducation);
	
	ActorManager2.updateOccupationSkills(node);
end

function onBuildChanged()
	local nodeActor = getDatabaseNode();
	local nBuild, sDBDesc, aDBDice = ActorManager2.getBuild(nodeActor);
	
	DB.setValue(nodeActor, "derived.dbdesc", "string", sDBDesc);
	DB.setValue(nodeActor, "derived.damagedice", "dice", aDBDice);
	DB.setValue(nodeActor, "derived.build", "number", nBuild);
	
	ActorManager2.calcMove(nodeActor);
end

function onSTRChanged()
	local nodeActor = getDatabaseNode();
	local nStrength = DB.getValue(nodeActor, "abilities.strength", 10);
	
	CharManager.updateSkillBase(nodeActor, "STR", nStrength);
	
	onBuildChanged();
end

function onAPPChanged()
	local nodeActor = getDatabaseNode();
	local nSize = DB.getValue(nodeActor, "abilities.appearance", 10);
	
	CharManager.updateSkillBase(nodeActor, "APP", nSize);
end

function onCONChanged()
	local nodeActor = getDatabaseNode();
	local nSize = DB.getValue(nodeActor, "abilities.constitution", 10);
	
	CharManager.updateSkillBase(nodeActor, "CON", nSize);
end

function onSIZChanged()
	local nodeActor = getDatabaseNode();
	local nSize = DB.getValue(nodeActor, "abilities.size", 10);
	
	CharManager.updateSkillBase(nodeActor, "STR", nSize);
	
	onBuildChanged();
end

function onAgeChanged()
	ActorManager2.calcMove(getDatabaseNode());
end

function onPOWChanged()
	local nodeActor = getDatabaseNode();
	local nPower = DB.getValue(nodeActor, "abilities.power", 10);

	local nSP = DB.getValue(nodeActor, "sp", 0);
	-- Zarestia maxsp has no DB value ...
	local nMaxSP = parentcontrol.window.overview.subwindow.maxsp.getValue();

	if nSP == 0 then
		local san = nPower;
		if san > nMaxSP then
			san = nMaxSP;
		end
		DB.setValue(nodeActor, "sp", "number", san);
	end
	CharManager.updateSkillBase(nodeActor, "POW", nPower);
	
end

function onDodgeChanged()
	local nDodge = DB.getValue(nodeDodge, "total", 0);
	dodge.setValue(nDodge);
end

function onAgeChanged()
	local node = getDatabaseNode();
	local sAge = DB.getValue(node, "age", 0);
	local nAge = tonumber(sAge);
	
	ActorManager2.calcMove(node);
	local nMove = DB.getValue(node, "derived.move", 0);
	
	movedisplay.update();
end

function onUseShieldsChanged()
	bShieldsOn = OptionsManager.isOption("SHLD", "1");
	actions.subwindow.onInit();
end
