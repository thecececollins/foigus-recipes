#!/bin/bash

#Wipe out the Woodwing ZXP folder, if it exists
woodwingZXPFolder="/Applications/Adobe InCopy CC 2015/WoodWing ZXP"                                        

if [ -d "${woodwingZXPFolder}" ]
then
        rm -rf "${woodwingZXPFolder}"                                                                                                               
fi

#Wipe out PluginConfig.txt, if it exists
pluginConfigLocation="/Applications/Adobe InCopy CC 2015/PluginConfig.txt"                                        

if [ -f "${pluginConfigLocation}" ]
then
        rm -rf "${pluginConfigLocation}"                                                                                                               
fi

#Wipe out stickyNotesExtension, if it exists
stickyNotesExtension="/Library/Application Support/Adobe/CEP/extensions/Sticky Notes"                                        

if [ -d "${stickyNotesExtension}" ]
then
        rm -rf "${stickyNotesExtension}"                                                                                                               
fi

#List of receipt names to forget
receiptsToForget=( ElementLabel InCopy InCopyOverset PluginConfig SCCoreContent SCCoreDataLink SCCoreDataLinkUI SCCoreInCopy SCCoreInCopyOverset SCCoreInCopyUI SCCoreStickyNotes SCCoreStickyNotesUI SCCoreTemplate SCEntAccessUI SCEntEditioning SCEntEditioningUI SCEnterprise SCEnterpriseUI SCEntFields SCEntFieldsUI SCEntScripting SCEntWidgets SCProFramesInCopy SCProFramesInCopyUI SCProInCopyUI SCProPanel SmartImage SmartImageUI SmartJump SmartJumpInCopyUI style WoodWing woodwingui WoodWingWidgets WoodWingZXP WWActivate WWSettings )

#Forget the single outlier receipt
if pkgutil --pkg-info com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg > /dev/null 2>&1
then
	pkgutil --forget com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg
else
	echo Receipt to remove com.WoodWing.smartconnectioncs5vxyzbuild.Uninstaller.pkg NOT FOUND
fi

#Forget the receipts in the receiptsToForget array
#Since Woodwing uses version names in the package receipts, need to use a regex to remove all receipts with a particular name
for receiptName in "${receiptsToForget[@]}"
do
	if pkgutil --pkgs=com\\.WoodWing\\.smartConnectionForAdobeCc2015V[\\d]+\\."${receiptName}"\\.pkg > /dev/null 2>&1
	then
		pkgutil --pkgs=com\\.WoodWing\\.smartConnectionForAdobeCc2015V[\\d]+\\."${receiptName}"\\.pkg | tr '\n' '\0' | xargs -n 1 -0 pkgutil --forget 
	else
		echo Receipt to remove com.WoodWing.smartConnectionForAdobeCc2015V\*version\*."${receiptName}".pkg NOT FOUND
	fi
done