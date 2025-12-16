#NoEnv
#SingleInstance force
#Persistent
SetBatchLines, -1

; --- SETTINGS ---
FlashTime := 600
FontSize  := 160
TextColor := "FFFFFF"
BoxW := 420
BoxH := 260
; ---------------------

Gui, Lang:New, +AlwaysOnTop -Caption +ToolWindow +E0x20 +LastFound
Gui, Lang:Color, 010101
Gui, Lang:Font, s%FontSize% Bold, Segoe UI
Gui, Lang:Add, Text, vLangText w%BoxW% h%BoxH% Center +0x200 c%TextColor%
Gui, Lang:Show, Hide
WinSet, TransColor, 010101


; --- Keyboard layout switch detection ---
~Alt up::CheckLang()
~Ctrl up::CheckLang()
~#Space::CheckLang()
; ----------------------------------------

return



CheckLang()
{
    global FlashTime
    static last := 0
    static prevLang := ""

    if (A_TickCount - last < 100)
        return
    last := A_TickCount

    Sleep, 60

    Lang := GetActiveLang()

    if (Lang = prevLang)
        return
    prevLang := Lang

    GuiControl, Lang:, LangText, %Lang%
    Gui, Lang:Show, NoActivate Center
    SetTimer, HideLang, % -FlashTime
}


GetActiveLang()
{
    WinGet, hwnd, ID, A
    thread := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", 0)
    hkl := DllCall("GetKeyboardLayout", "UInt", thread, "Ptr")
    LangID := Format("{:04X}", hkl & 0xFFFF)

    if (LangID = "0409")
        return "EN"
    else if (LangID = "0419")
        return "RU"
    else if (LangID = "0422")
        return "UA"
    else
        return LangID
}

HideLang:
Gui, Lang:Hide
return

