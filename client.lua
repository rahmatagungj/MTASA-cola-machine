function gantiModel()
  txd = engineLoadTXD("cola.txd", 2647)
  engineImportTXD(txd, 2647)
   dff = engineLoadDFF("cola.dff", 2647)
  engineReplaceModel(dff, 2647)
end
addEventHandler("onResourceStart", resourceRoot, gantiModel)

local menggunakan_vending = 0
botol = createObject(2647,0,0,0) 
function cola ()
  local x, y, z = getElementPosition(source)
  local dis = getDistanceBetweenPoints3D(x,y,z, getElementPosition(localPlayer))
  local dis2 = getDistanceBetweenPoints3D(x,y,z, getElementPosition(localPlayer))
  if dis < 1.5 and dis2 > 0.5 and menggunakan_vending == 0 then
  -- ANTI CHEAT
  showCursor (false)   
  toggleAllControls(false,true,true)
  -- END ANTI CHEAT
  triggerServerEvent ( "ambilUang", localPlayer)
  menggunakan_vending = 1
  triggerServerEvent ( "animasiBeli", localPlayer)
  setTimer(function()
    local suaraMinum = playSound("sprunk.wav",false)
  end, 1100, 1)
  ambil = setTimer(function()
  exports.bone_attach:attachElementToBone(botol,localPlayer,11,0.01,0,0.06,0,280,0) 
  menggunakan_vending = 2
  triggerServerEvent ( "animasiAmbil", localPlayer)
  end, 2500, 1)
  setTimer(function()
    menggunakan_vending = 0
    setPedAnimation (localPlayer)
    setPedFrozen(localPlayer,false)
    toggleAllControls(true, true, true)
    exports.bone_attach:detachElementFromBone(botol) 
    moveObject(botol, 1 ,0 ,0 ,0) 
  end, 3500, 1)
end
end
addEvent("beliCola",true)
addEventHandler("beliCola",root,cola)
-- bindKey("E","down",cola)
