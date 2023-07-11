#Persistent

; The submenu and all its items.
Menu, Submenu, add, SubmenuItem, TestLabel ; first add all items to the menu.
Menu, tray, add, The submenu, :Submenu ; then add the menu to the traz as a submenu

Menu, tray, add, MainMenuItem, VoidLabel ; add a menu item to the tray

return

VoidLabel:
return

TestLabel:
return