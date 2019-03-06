-- Version : English - Ramble
-- FR Translation by : Rincevent 
BINDING_HEADER_MYBANKHEADER	= "My Bank";
BINDING_HEADER_MYBANKCONFIGHEADER	= "My Bank Config";
BINDING_NAME_MYBANKICON		= "My Bank Frame Toggle";
BINDING_NAME_MYBANKCONFIG		= "My Bank Config Frame Toggle";

if (GetLocale() == "frFR") then
	-- é: C3 A9  - \195\169
	-- ê: C3 AA  - \195\170
	-- à: C3 A0  - \195\160
	-- î: C3 AE  - \195\174
	-- è: C3 A8  - \195\168
	-- ë: C3 AB  - \195\171
	-- ô: C3 B4  - \195\180
	-- û: C3 BB  - \195\187
	-- â: C3 A2  - \195\162
	-- ç: C3 A7  - \185\167
	--
	-- ': E2 80 99  - \226\128\153
	MYBANK_MYADDON_NAME = "ACUI MyBank";
	MYBANK_MYADDON_DESCRIPTION = "Une fen\195\170tre de banque simple et compacte";

	MYBANK_CHAT_COMMAND_USAGE = {
		[1]="Usage: /mb [init|reset|show|toggle|replacebags|cols|column|freeze|unfreeze|scale]",
		[2]="Commands:",
		[3]="show - affiche la fen\195\170tre ACUI MyBank",
		[4]="replacebank - Remplacer la banque normale",
		[5]="cols - Nombre de colonnes par ligne.",
		[6]="reset or init, Recr\195\169er votre profil avec les param\195\168tres par d\195\169faut.",
		[7]="freeze/unfreeze Bloquer/d\195\169bloquer le d\195\169placement de la fen\195\170tre ACUI MyBank.",
		[8]="scale - lost in translation ;)",
	};


	MYBANK_CHAT_PROFILE_CREATED = "ACUI MyBank: Nouveau profil cr\195\169e pour %s"; 
	MYBANK_CHAT_OLDVERSION = "Ancienne Version detect\195\169e. Effacement des anciens profils";

	MYBANK_CHAT_COLUMNS_FORMAT = "ACUI MyBank Nombre de colonnes mis \195\160 %d";
	MYBANK_CHAT_FREEZEON = "ACUI MyBank position fixe";
	MYBANK_CHAT_FREEZEOFF = "ACUI MyBank position libre";
	MYBANK_CHAT_REPLACEBANKON = "ACUI MyBank remplace la banque";
	MYBANK_CHAT_REPLACEBANKOFF = "ACUI MyBank ne remplace pas la banque";

	MYBANK_PURCHASE_CONFIRM_S = "Etes vous s\195\187r de vouloir acheter un emplacement de sac pour %d argent?";
	MYBANK_PURCHASE_CONFIRM_G = "Etes vous s\195\187r de vouloir acheter un emplacement de sac pour %d or?";

	MYBANK_ATBANK = "A la Banque";

	MYBANK_CONFIG_REPLACE = "Remplacer la banque";
	MYBANK_CONFIG_FREEZE = "Bloquer la fen\195\170tre ACUI MyBank en place";
	MYBANK_CONFIG_HIGHLIGHTITEMS = "Surligner les objets du sac";
	MYBANK_CONFIG_HIGHLIGHTBAGS = "Surligner le sac des objets";
	MYBANK_CONFIG_HIGHLIGHTCOLOR = "Couleur surlignage";

	MYBANK_FROZEN_ERROR = "ACUI MyBank est bloqu\195\169e et ne peux pas \195\170tre d\195\169plac\195\169e...";

	MYBANK_LOADED = "ACUI MyBank charg\195\169e.";

	MYBANK_CHAT_HIGHLIGHTBAGSON = "ACUI MyBank surlignera le sac des objets";
	MYBANK_CHAT_HIGHLIGHTBAGSOFF = "ACUI MyBank ne surlignera pas le sac des objets";
	MYBANK_CHAT_HIGHLIGHTITEMSON = "ACUI MyBank surlignera les objets du sac";
	MYBANK_CHAT_HIGHLIGHTITEMSOFF = "ACUI MyBank ne surlignera pas les objets du sac";

	MYBANK_FRAME_PLAYERANDREGION = "Banque de %s de %s";
	MYBANK_FRAME_PLAYERONLY = "Banque de %s";
	MYBANK_FRAME_SLOTS = "%d/%d emplacements";
	MYBANK_FRAME_ALLREALMS = "Tous les Royaumes";
	MYBANK_FRAME_SELECTPLAYER = "Afficher la banque de :";
	MYBANK_FRAME_TOTAL = "(t)";
	MYBANK_FRAME_BUY = "Acheter";
else
	MYBANK_MYADDON_NAME	= "ACUI MyBank";
	MYBANK_MYADDON_DESCRIPTION = "A simple, compact bank frame window.";

	MYBANK_CHAT_COMMAND_USAGE		= {
		[1]="Usage: /mb [init|reset|show|toggle|replacebags|cols|column|freeze|unfreeze|scale]",
		[2]="Commands:",
		[3]="show - toggles the ACUI MyBank window",
		[4]="replacebank - if it should replace the bank or not",
		[5]="cols - how many columns there should be in each row.",
		[6]="reset or init, will recreate your profile with default settings.",
		[7]="freeze/unfreeze will lock/unlock the window for dragging.",
		[8]="scale - scales the addon."
	};

	MYBANK_CHAT_PROFILE_CREATED   = "ACUI MyBank: New profile for %s was created";
	MYBANK_CHAT_OLDVERSION        = "Old Version detected. Clearing old profiles.";
	
	MYBANK_CHAT_COLUMNS_FORMAT			 = "ACUI MyBank number of columns set to %d.";
	MYBANK_CHAT_FREEZEON              = "ACUI MyBank frozen.";
	MYBANK_CHAT_FREEZEOFF             = "ACUI MyBank unfrozen.";
	MYBANK_CHAT_REPLACEBANKON         = "ACUI MyBank replacing bank.";
	MYBANK_CHAT_REPLACEBANKOFF        = "ACUI MyBank not replacing bank.";
	MYBANK_CHAT_HIGHLIGHTBAGSON		 = "ACUI MyBank will highlight item's bag.";
	MYBANK_CHAT_HIGHLIGHTBAGSOFF		 = "ACUI MyBank not highlighting item's bag.";
	MYBANK_CHAT_HIGHLIGHTITEMSON		 = "ACUI MyBank will highlight bag's items.";
	MYBANK_CHAT_HIGHLIGHTITEMSOFF		 = "ACUI MyBank not highlighting bag's items.";

	MYBANK_PURCHASE_CONFIRM_S = "Are you sure you wish to purchase a bag slot for %d silver?";
	MYBANK_PURCHASE_CONFIRM_G = "Are you sure you wish to purchase a bag slot for %d gold?";
	
	MYBANK_ATBANK = "At Bank";
	
	MYBANK_CONFIG_REPLACE = "Replace Bank";
	MYBANK_CONFIG_FREEZE  = "Freeze ACUI MyBank";
	MYBANK_CONFIG_HIGHLIGHTITEMS = "Highlight Bag's Items";
	MYBANK_CONFIG_HIGHLIGHTBAGS = "Highlight Item's Bag";
	MYBANK_CONFIG_HIGHLIGHTCOLOR = "Highlight Color";
	
	MYBANK_FROZEN_ERROR = "ACUI MyBank is frozen and can not move...";
	
	MYBANK_LOADED = "ACUI MyBank AddOn loaded.";
	
	MYBANK_FRAME_PLAYERANDREGION = "%s of %s's Bank";
	MYBANK_FRAME_PLAYERONLY      = "%s's Bank";
	MYBANK_FRAME_SLOTS           = "%d/%d Slots.";
	MYBANK_FRAME_ALLREALMS       = "All Realms";
	MYBANK_FRAME_SELECTPLAYER    = "Select Player's Bank to Show";
	MYBANK_FRAME_TOTAL           = "(t)";
	MYBANK_FRAME_BUY             = "Buy";
end

ACUIMYBANK_HELP = {};
ACUIMYBANK_HELP[1] = "ACUI MyBank\n\nA simple, compact bank frame window.\n\n";
ACUIMYBANK_HELP[2] = "Usage: /mb\n\nCommands:\n show - toggles the ACUI MyBank window\n replacebank - if it should replace the bank or not\n cols - how many columns there should be in each row.\n reset or init, will recreate your profile with default settings.\n freeze/unfreeze will lock/unlock the window for dragging.\n scale - scales the addon.\n";
