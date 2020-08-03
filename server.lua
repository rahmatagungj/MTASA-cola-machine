jumlahCola = 1
mysql = exports.mysql

mysql:query ( "CREATE TABLE IF NOT EXISTS VendingCola ( ID INT AUTO_INCREMENT KEY,x INT,y INT,z INT,rotation INT,dimension INT,interior INT)"  ); 
addCommandHandler("addvending", function(thePlayer, commandName, id)
    local rank = exports.integration
    if rank:isPlayerTrialAdmin(thePlayer) then
        local dim = getElementDimension(thePlayer)
        local int = getElementInterior(thePlayer)
        local _, _, rot = getElementRotation(thePlayer)
        local objectPosition = thePlayer.matrix.position + thePlayer.matrix.forward * 1.5
        local x, y, z = objectPosition:getX(), objectPosition:getY(), objectPosition:getZ()
        local adminUsername = getElementData(thePlayer, "account:username")
        local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
        local minus = 1.46
        local spawnMesin = createObject(1209, x, y, z-minus, 0, 0, rot-180)
        local query = mysql:query_free("INSERT INTO VendingCola (x,y,z,rotation,dimension,interior) VALUES ('"..x.."','"..y.."',' "..z.."',' "..rot.."',' "..dim.."',' "..int.."')")
        if query then
          query = mysql:query("SELECT ID FROM VendingCola ORDER BY ID DESC LIMIT 1")
            if query then
                while true do
                    local row = mysql:fetch_assoc(query)
                    if not row then break end
                    exports.global:sendMessageToAdmins("[VENDING]: "..adminTitle.." "..getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has create new vending machin #"..row["ID"]..".")
                    outputChatBox("vending machine created with ID #"..row["ID"].."!", thePlayer, 0, 255, 0)
                end
            end
        end
    end
end)

addEvent("ambilUang",true)
			addEventHandler("ambilUang",root,function ()
			exports.global:takeMoney(client,15)
      -- exports.global:giveItem(source, 1, 1)
end)

addEvent("jauhDariMesin",true)
			addEventHandler("jauhDariMesin",root,function ()
        outputChatBox("Kamu terlalu jauh dari mesin.", source, 255, 194, 14)
end)

addEvent("hausDitambahkan",true)
			addEventHandler("hausDitambahkan",root,function ()
        outputChatBox("Berhasil meminum dan karakter tidak haus.", source, 255, 194, 14)
end)

addEvent("animasiBeli",true)
			addEventHandler("animasiBeli",root,function ()
        exports.global:applyAnimation(source,"vending", "vend_use",-1,false,false,false)
end)

addEvent("animasiAmbil",true)
			addEventHandler("animasiAmbil",root,function ()
        exports.global:applyAnimation(source,"vending", "vend_use",-1,false,false,false)
        exports.global:giveItem(source, 9, 1)
end)

function elementClicked( theButton, theState, thePlayer )
  if theButton == "right" and theState == "down" then
    if source and isElement( source ) and getElementType( source ) == "object" and getElementModel ( source ) == 1209 then 
    triggerClientEvent( thePlayer,'beliCola',source,x,y,z ) 
    else
      -- outputChatBox("BUKAN VENDING", thePlayer, 0, 255, 0)
    end
  end
end
addEventHandler( "onElementClicked", root, elementClicked ) 

function muatMesin()
  local query = mysql:query("SELECT  * FROM VendingCola")
  if query then
      while true do
      local row = mysql:fetch_assoc(query)
      if not row then break end
      local x = tonumber(row["x"])
      local y = tonumber(row["y"])
      local z = tonumber(row["z"])
      local rot = tonumber(row["rotation"]) 
      local dim = tonumber(row["dimension"])
      local int = tonumber(row["interior"])
      local minus = 1.46
      local spawnMesin = createObject(1209, x, y, z-minus, 0, 0, rot)
      setElementDimension(spawnMesin, dim)
      setElementInterior(spawnMesin, int)
  end
end
end
addEventHandler("onResourceStart", resourceRoot, muatMesin)


addCommandHandler("showvending",function (thePlayer,commandName)
  local rank = exports.integration
  if (rank:isPlayerTrialAdmin(thePlayer)) then
                local sqlshow = mysql:query ( "SELECT ID FROM VendingCola")
                 if (sqlshow) then
            local continue = true
            while continue do
               local row = mysql:fetch_assoc(sqlshow)
                if not row then break end

            outputChatBox("All vending Mashin in the server IDS #" .. row["ID"] .. "!", thePlayer, 0, 255, 0)
          end
      end
    end
end)


addCommandHandler("delvending",function (thePlayer,_,id)
    local rank = exports.integration
      if (rank:isPlayerTrialAdmin(thePlayer)) then
  local adminUsername = getElementData(thePlayer, "account:username")
  local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
        local id = tonumber(id)
	if id then
        		local query = mysql:query_free("DELETE FROM VendingCola WHERE ID='" .. id .. "'")
		if query then
      			  exports.global:sendMessageToAdmins("[VENDING]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has removed the vending machin #".. id ..".")
		end
		return query
    	end
			outputChatBox("SYNTAX: /delvending [ID]", thePlayer, 255, 194, 14)
    end
end)


addCommandHandler("delallvending",function (thePlayer,commandName)
    local rank = exports.integration
    if (rank:isPlayerLeadScripter(thePlayer)) then
  local adminUsername = getElementData(thePlayer, "account:username")
  local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
                local delAllvend = mysql:query ( "DELETE FROM VendingCola WHERE ID")
                 if (delAllvend) then
            local continue = true
            while continue do
               local row = mysql:fetch_assoc(delAllvend)
                  exports.global:sendMessageToAdmins("[VENDING]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has removed all the vending machins #")
                  executeCommandHandler ( "restartres coding", thePlayer )
                if not row then break end
          end
      end
    end
end)

function restartResCommand (thePlayer)  
      local rank = exports.integration
      if (rank:isPlayerTrialAdmin(thePlayer)) then
        restartResource(getThisResource())
    end
  end
addCommandHandler ("addvending",restartResCommand)
addCommandHandler ("delvending",restartResCommand)

function restartResCommandDev (thePlayer)  
      local rank = exports.integration
      if (rank:isPlayerLeadScripter(thePlayer)) then
        restartResource(getThisResource())
    end
  end
addCommandHandler ("delallvending",restartResCommandDev)

