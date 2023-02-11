--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local nodeMythos = nil;
bPulpMode = false;

function onInit()
	OptionsManager.registerCallback("PCLUCK", onUseLuckChanged);
	onUseLuckChanged();
	
	OptionsManager.registerCallback("PULP", onUsePulpChanged);
	onUsePulpChanged();
	
	local node = getDatabaseNode();
	
	DB.addHandler(DB.getPath(node, "sp"), "onUpdate", onSanityChanged);
	DB.addHandler(DB.getPath(node, "sessionsp"), "onUpdate", onSanityChanged);
	
	nodeMythos = ActorManager2.getSkill(node, Interface.getString("char_skill_cthulhu_mythos"));
	local nMSkill = DB.getChild(nodeMythos, "total");
	if nodeMythos and nMSkill then
		DB.addHandler(DB.getPath(nMSkill), "onUpdate", onMythosChanged);
		onMythosChanged();
	end
end

function onUseLuckChanged()
	local bLuckMode = OptionsManager.isOption("PCLUCK", "1");
	status_luckcurrent_label.setVisible(bLuckMode);
end

function onClose()
	local node = getDatabaseNode();
	
	DB.removeHandler(DB.getPath(node, "sp"), "onUpdate", onSanityChanged);
	DB.removeHandler(DB.getPath(node, "sessionsp"), "onUpdate", onSanityChanged);
	
	if nodeMythos then
		DB.removeHandler(DB.getPath(nodeMythos), "onUpdate", onMythosChanged);
	end
end

function onMythosChanged()
	local nMythos = DB.getValue(nodeMythos, "total", 0);
	maxsp.setValue (99 - nMythos);
end

function onSanityChanged()
	sp.updateState();
end

function onUsePulpChanged()
	bPulpMode = OptionsManager.isOption("PULP", "1");
	maxhp.onSourceUpdate();
end
