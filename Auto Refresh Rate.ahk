#Persistent
#SingleInstance, Force
#NoEnv
global menuVisible := false
global oBattery :=""
global Plug :=""
global defEnable :=""
global Startup:=""
global showMsg :=""
global PrevStatus:="Unknown"
global QResPath := A_WorkingDir
SetTimer, CheckBattery, 1000

filePath := A_WorkingDir . "\setting.ini"
if (!fileExist(filePath))
{
    IniWrite, 144, setting.ini, settings, Plugged
    IniWrite, 60, setting.ini, settings, onBattery
    IniWrite, 1, setting.ini, settings, isEnable
    IniWrite, 1, setting.ini, settings, Startup
    IniWrite, 1, setting.ini, settings, Notify
} 

;MsgBox, check %kiemtra%
;Menu, Tray, Click, 1
;Menu, Tray, Add, Show GUI, ShowGui
Menu,Tray, Tip, Auto Refresh Rate
IniRead, Enab , setting.ini, settings, isEnable
En := Enab + 0
defEnable := En
changeIcon(defEnable)
;Menu, Tray, icon, img/display_default.ico
Menu, Tray, Add, Enable, showclicked
Menu, Tray, Default, Enable
Menu, Tray, Add, Notify, Notify
Menu, Tray, Add
Menu, Tray, Add, Options, ShowOptions
Menu, Tray, Icon, Options, img/settings.ico
Menu, Tray, Add
Menu, Help, Add, About, About
Menu, Help, Icon, About, img/about.ico
Menu, Tray, Add, Help, :Help
Menu, Tray, Icon, Help, img/help.ico

Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Icon, Exit, img/exit.ico

Menu, Tray, NoStandard

Menu, Tray, Click, 1
if(defEnable = 1)
{
    Menu, tray, Check, Enable
    ;Menu, Tray, Icon, Enable, img/checked.ico
}

IniRead, msg, setting.ini, settings, Notify 
numbermsg := msg + 0
showMsg := numbermsg 
if(showMsg=1)
{
    menu, tray, Check, Notify
}
; DblClickTime := DllCall("GetDoubleClickTime", "UInt")
; ;MsgBox, DblClickTime = %DblClickTime% ms
; if(DblClickTime < 500)
; {
; }
; else 
; {
;     Menu:
;         Menu()
;     return 
; }
; if (menuVisible)
; {
;     ; Đóng cửa sổ menu nếu nó đã mở
;     WinClose, AutoHotkey Menu
;     menuVisible := false ; Cập nhật trạng thái của cửa sổ menu
; }
; else
; {
;     ; Mở cửa sổ menu nếu nó chưa mở
;     Menu()

;     menuVisible := true ; Cập nhật trạng thái của cửa sổ menu
; }

CheckBattery:
    if(defEnable = 0)
    {
        Exit
    }
    batteryCharging()
return
;OnDoubleClick:
;window()

readFile(){
    Iniread, batt,setting.ini, settings, onBattery
    numberBat := batt + 0
    oBattery:= numberBat
    IniRead, plg , setting.ini, settings, Plugged
    numberplg := plg + 0
    Plug := numberplg
    IniRead, Enab , setting.ini, settings, isEnable
    numberEn := Enab+ 0
    defEnable := numberEn 
    IniRead, start, setting.ini, settings, Startup 
    numberstar := start+ 0
    Startup := start 
    IniRead, msg, setting.ini, settings, Notify 
    numbermsg := msg + 0
    showMsg := numbermsg 

}

ShowOptions(){
    ; Tạo màn hình cài đặt
    Gui, Destroy
    Gui, +LastFound +AlwaysOnTop
    Gui, +Border
    Gui, Margin, 0, 0
    Gui, Color, White
    Gui, Font, s22, Arial
    Gui, Add, Text, Center w500 h550, Choose Options
    Gui, Font, s20, Arial
    Gui, Add, Text,x40 y60, On Battery:
    Gui, Add, Edit,x120 y100 w80 voBattery, %oBattery%
    Gui, Add, Text,x40 h10 y140, Plugged in:
    Gui, Add, Edit, x120 y180 w80 vPlug, %Plug%
    Gui, Show
    if(defEnable = 1)
    {
        Gui, Add, Checkbox,x70 y250 w150 h20 vdefEnable Checked, Enable
    }
    else{
        Gui,Add, Checkbox,x70 y250 w150 h20 vdefEnable , Enable
    }
    if(Startup = 1)
    {
        Gui,Add, Checkbox, h100 vStartup Checked, Startup
    }
    else {

        Gui, Add, Checkbox, h100 vStartup , Startup
    }
    if(showMsg = 1)
    {
        Gui, Add, Checkbox, vshowMsg Checked, Notify
    }
    else {
        Gui, Add, Checkbox, vshowMsg, Notify
    }
    ;Gui, Add, Button,x10 y200, Cancel
    Gui, Add, Button, x250 y480 w100 gCancelButton, Cancel
    Gui, Add, Button,x380 y480 w100, Save
    Gui, Show, Center w500 h550, Setting

}

ButtonSave(){
    Gui, Submit ; Lấy giá trị từ các điều khiển
    plg := Plug
    batt := oBattery
    enab := defEnable
    start := Startup
    noti := showMsg
    IniWrite, %plg%, setting.ini, settings, Plugged
    IniWrite, %batt%, setting.ini, settings, onBattery
    IniWrite, %enab%, setting.ini, settings, isEnable
    IniWrite, %start%, setting.ini, settings, Startup 
    IniWrite, %noti%, setting.ini, settings, Notify 
    ;MsgBox,SUSSCESS`nOnBattery:%batt%`nPlugged in: %plg%`nEnable: %defEnable%`nStartup: %Startup%`nNotify: %noti%`n, , , , 400, 200
}

Menu()
{
showclicked:
    if tray_clicks > 0 ; SetTimer already started, so we log the keypress instead.
    {
        tray_clicks += 1
        return
    }
    ; Otherwise, this is the first press of a new series. Set count to 1 and start
    ; the timer:
    tray_clicks = 1
    SetTimer, tray_clicks_check, 400 ; Wait for more presses within a 400 millisecond window.
return
tray_clicks_check:
    SetTimer, tray_clicks_check, off
    if tray_clicks = 1 ; The key was pressed once.
    {

        ;menu, tray, UnCheck, Enable
        IniRead, Enab , setting.ini, settings, isEnable
        numberEn := Enab + 0
        defEnable := numberEn 

        ;MsgBox, kiem tra gia tri click:%defEnable%
        if(defEnable=1)
        {
            menu, tray, UnCheck, Enable
            ;Menu, Tray, Icon, Enable, img/checked.ico
            IniWrite, 0, setting.ini, settings, isEnable
            ;MsgBox, tat;
            defEnable :=0
        }
        else {
            menu, tray, Check, Enable
            IniWrite, 1, setting.ini, settings, isEnable
            ; MsgBox, bat
            defEnable :=1
        }
        changeIcon(defEnable)
    }
    else if tray_clicks = 2 ; The key was pressed twice.
    {
        readFile()
        ShowOptions()
        ;MsgBox, Two clicks detected. ; Open a different folder.
    }
    else if tray_clicks > 2
    {
        ;MsgBox, Three or more clicks detected.
    }
    ; Regardless of which action above was triggered, reset the count to
    ; prepare for the next series of presses:
    tray_clicks = 0
return
ShowOptions:
    readFile()
    ShowOptions()
return
About:
    Run, https://github.com/ngtuonghy/AutoRefreshRate
Return
Help:

Return
Notify:
    trayNotify()
Return
ButtonSave:
    status := GetBatteryStatus()
    ButtonSave()
    changeIcon(defEnable)
    if(status = "AC")
    {
        ;MsgBox, this is ac %Plug%
        Run, %QResPath%\QRes.exe /r:%Plug%, , Hide

    }
    else if(status = "Battery")
    {
        ;MsgBox, this is batt %oBattery%
        Run, %QResPath%\QRes.exe /r:%oBattery%, , Hide
    }
    AutoStartup(Startup)
    if(defEnable = 0)
    {
        Exit
    }
return
CancelButton:
GuiClose:
    Gui, Destroy ; Đóng màn hình cài đặt
return
ExitApp:
    FileDelete, ranBefore.txt
    ;MsgBox, Bạn đã chọn mục "Exit" trong menu Tray!
ExitApp 
}

batteryCharging(){
    global PrevStatus
    ;QResPath := A_WorkingDir
    ;MsgBox, %QResPath%
    SystemStatus := GetBatteryStatus()
    if (PrevStatus = "Unknown") ; Kiểm tra trạng thái trước đó
    {
        PrevStatus := SystemStatus ; Lưu trạng thái hiện tại vào biến trạng thái trước đó
        ;MsgBox, sethientia %PrevStatus%
        return ; Thoát khỏi hàm
    }
    ;MsgBox, %PrevStatus%

    ; Kiểm tra trạng thái sạc và thực hiện hành động tương ứng
    if (SystemStatus = "AC" && PrevStatus = "Battery")
    {
        ShowMessage("Plugging the charger into a power source!.")
        IniRead, plg , setting.ini, settings, Plugged
        Plug := plg + 0
        Run, %QResPath%\QRes.exe /r:%Plug%, , Hide
        ;Run, %QResPath%\QRes.exe /r:60, , Hide
        ;TrayTip,,chao %plg%!.,
        ;PrevStatus:="AC"
    }
    else if (SystemStatus = "Battery" && PrevStatus = "AC")
    {
        IniRead, batt, setting.ini, settings, onBattery
        oBattery := batt + 0
        ShowMessage("Unplugged from the charger to a power source!")
        Run, %QResPath%\QRes.exe /r:%oBattery%, , Hide
        ;PrevStatus:="Battery"
    }
    PrevStatus := SystemStatus
}

GetBatteryStatus()
{
    ; Sử dụng WMI để lấy trạng thái sạc
    battery := ComObjGet("Winmgmts:").ExecQuery("SELECT BatteryStatus FROM Win32_Battery")
    for each in battery
    {
        if (each.BatteryStatus = 2 || each.BatteryStatus = 6 || each.BatteryStatus = 9)
            return "AC" ; Đang cắm sạc vào nguồn điện
        else
            return "Battery" ; Đang chạy bằng pin
    }
}

AutoStartup(check){
    scriptPath := A_ScriptFullPath
    startupFolder := A_Startup
    shortcutPath := startupFolder . "\Auto Display Refresh.lnk"

    if (check = 1){
        FileDelete,%shortcutPath%
        CreateShortcut(scriptPath, shortcutPath)
        ;MsgBox, Have set up a program to boot with the system.
    }
    else if(check = 0) {
        FileDelete,%shortcutPath%
        ;MsgBox, delete thanh cong
    }
}

CreateShortcut(targetPath, shortcutPath)
{
    shell := ComObjCreate("WScript.Shell")
    shortcut := shell.CreateShortcut(shortcutPath)
    shortcut.TargetPath := targetPath
    shortcut.WorkingDirectory := A_WorkingDir
    shortcut.Save()
}

ShowMessage(message)
{
    IniRead, plg , setting.ini, settings, Plugged
    numberplg := plg + 0
    Plug := numberplg
    status := GetBatteryStatus()
    IniRead, msg, setting.ini, settings, Notify 
    showMsg := msg + 0
    if (showMsg)
    {
        ;MsgBox, PLUG %Plug%
        ;MsgBox, BATT %oBattery%
        if(status = "AC")
        {
            TrayTip,Change refresh rate: %Plug% ,% message, 1,, 
        }
        else if(status = "Battery")
        {
            TrayTip,Change refresh rate: %oBattery% ,% message, 1,, 
        }
    }
return
}

changeIcon(defEnable){
    ;IniRead, Enab , setting.ini, settings, isEnable
    ;defEnable := Enab + 0
    ;MsgBox, gia tri trong change icon %defEnable%
    if(defEnable = 1)
    {
        Menu, Tray, icon, img/display_default.ico
    }
    else if(defEnable = 0)
    {
        Menu, Tray, icon, img/display_off.ico
    }

}
trayNotify(){

    IniRead, msg, setting.ini, settings, Notify 
    numbermsg := msg + 0
    showMsg := numbermsg 
    if(showMsg=1)
    {
        menu, tray, UnCheck, Notify
        ;Menu, Tray, Icon, Enable, img/checked.ico
        IniWrite, 0, setting.ini, settings, Notify
        ;MsgBox, tat;

    }
    else {
        menu, tray, Check, Notify
        IniWrite, 1, setting.ini, settings, Notify
        ; MsgBox, bat

    }
}