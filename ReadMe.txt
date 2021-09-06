Description : 
This addon places all your bank bags in one frame and replaces the default bank windows.

Features: Saves settings per character.
* Displays total Bank slots (lower left corner)
* Shows Bag slots at the top, red bags to indicate not purchased
* Allows for purchasing of bags at Bank with a confirmation dialog telling you how much you're about to spend
* View Bank contents from anywhere once you've visited the bank once. Once you go to a bank it will switch to a live mode.
* Items with cooldowns will show cooldown timers even when not at bank (most of the time this seems to work)
* Mouseover effects so you can tell what items are in which bag and which bag an item is in (for all you guys who don't like all in one bag frames)
* Viewing other characters banks. (like BankItems and BankStatement)
* Simple configuration panel accessable through MyAddons or slash command.

Getting Started:

There are two basic ways to use ACUI MyBank. The easist would be to bind keys to open the ACUI MyBank Window and to open the ACUI MyBank config panel.  From the control panel, you can change almost all the options in ACUI MyBank. Options ommitted from the Config panel include lock and bagview, because these options are available on the ACUI MyBank window itself.

Usage: /mb [init|reset|show|toggle|replacebags|cols|column|freeze|unfreeze|scale]
Commands:
  show - toggles the ACUI_MyBank window
  replacebank - if it should replace the bank or not
	cols - how many columns there should be in each row.
	reset or init, will recreate your profile with default settings.
	freeze/unfreeze will lock/unlock the window for dragging.
	scale [0.5-2]   Scales the ACUI MyBank Window
	config - show config window
	

WARNING: Due to incompability between the Bank Buy procedure in this mod and CTmod's "BankViewFrame" it is not possible to buy new bankslots. To get around this just do the following:

To make purchasing bagslots work with CTmod, just delete these two files from the CT_MasterMod directory:
CT_BankViewFrame.lua
CT_BankViewFrame.xml