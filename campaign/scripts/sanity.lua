local nCurrentSan = 0;

function onInit()
	initSessionStartSAN();
	updateState();
	registerMenuItem(Interface.getString("char_menu_reset_san"), "equals", 7);
end

function resetSessionSanity()
	-- get Session start SAN
	local node = window.getDatabaseNode();
	local startSAN = DB.getChild(node, "sessionsp");
	startSAN.setValue(getValue());
	updateState();
end

function initSessionStartSAN()
	-- get Session start SAN
	local node = window.getDatabaseNode();
	local startSAN = DB.getChild(node, "sessionsp");
	if not startSAN then
		startSAN = DB.createChild(node, "sessionsp", "number");
		startSAN.setValue(getValue());
	else
		local nStartSAN = startSAN.getValue();
		if not nStartSAN or nStartSAN == 0 then
			nStartSAN = getValue();
			startSAN.setValue(nStartSAN);
		end
	end
end

function updateState()
	-- get Session start SAN
	local node = window.getDatabaseNode();
	-- Zarestia changed
	local nStartSAN = DB.getValue(node, "sessionsp", 0);
	local nSP = DB.getValue(node, "sp", 0);
	
	if nCurrentSan - nSP >= 5 then
		rollRealization()
	end
	nCurrentSan = nSP;
	
	local nPercentage = math.ceil((nSP * 100) / nStartSAN);
	if nPercentage <= 80 then
		ChatManager.Message(Interface.getString("message_indefiniate_insanity"), true, ActorManager.resolveActor(node));
		window.indef_insanity.setValue(1);
	end
	
	setTooltipText(nStartSAN.." -> ".. nSP .. " ("..nPercentage.."%)");
end

function rollRealization()
	-- Zarestia changed
	local nTotal = DB.getValue(window.getDatabaseNode(), "abilities.intelligence", 0)
	local sAbility = Interface.getString("char_label_realization");
	
	local sRollType = "ability"
	
	local rActor = ActorManager.resolveActor(window.getDatabaseNode());
	local sDesc = sRollType.." "..sAbility.." "..Interface.getString("message_check").." (" .. nTotal .. "%)";
	local rRoll = { sType = "ability", sDesc = sDesc, aDice = { "d100" }, nMod = 0 };
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function onMenuSelection(selection)
	if selection == 7 then
		resetSessionSanity();
	end
end

function action(draginfo)
	local nTotal = getValue();
	local sAbility = self.getName();
	
	if rolltype and rolltype[1] then
		sAbility = Interface.getString(rolltype[1]);
	end
	local sRollType = Interface.getString("ability_roll");
	if rolltypeprefix and rolltypeprefix[1] then
		sRollType = Interface.getString(rolltypeprefix[1]);
	end
	
	local rActor = ActorManager.resolveActor(window.getDatabaseNode());
	local sDesc = sRollType.." "..sAbility.." "..Interface.getString("message_check").." (" .. nTotal .. "%)";
	local rRoll = { sType = "ability", sDesc = sDesc, aDice = { "d100" }, nMod = 0 };
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function onDoubleClick(x, y)
	action();
	return true;
end

function onDragStart(button, x, y, draginfo)
	action(draginfo);
	return true;
end
