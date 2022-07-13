; Authors
; -------
; Museus (Discord: Museus#7777)
; SpR3AD (Discord: SpR3AD#9314)
;
; This script was based off of TW3AutoSpam (https://gist.github.com/Gaztin/391afe70ceeb1c79005f21645cdc480d)

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force
#MaxHotkeysPerInterval 100

;;;;;;;;;;;;;;;;;;;;;;;;;
; CONFIGURATION SECTION ;
;;;;;;;;;;;;;;;;;;;;;;;;;

; Color to make overlay background, for Chromakey purposes (ex: ff00ff)
overlayWindowBackground := "ff00ff"

; Color to make overlay text (ex: 00ffff)
overlayFontColor := "00ffff"

; The key the user will hold to trigger script
spamKey := "f"

 ; The key the script will send to the game
confirmKey := "q"

;;;;;;;;;;;;;;;;;;;;;
; END CONFIGURATION ;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
; Main Program ;
;;;;;;;;;;;;;;;;

; Load or prompt spam key
if (!IsValidKey(spamKey))
    spamKey := PromptUserForKey("Enter your desired auto-spam key:`n(visit autohotkey.com/docs/KeyList.htm for valid keys)`n`n`nUnfortunately controller is not supported at this time`, so please use a keyboard key.")

; Prompt user for confirm key
if (!IsValidKey(confirmKey))
    confirmKey := PromptUserForKey("What keyboard key do you have Confirm bound to? (Default is Q)")

; Create Skipping window
Gui, skippingOverlay:destroy
Gui, skippingOverlay: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop +E0x20
Gui, skippingOverlay:Color, c%overlayWindowBackground%
Gui, skippingOverlay:Font, s16 q1 c%overlayFontColor%, %Font%
Gui, skippingOverlay:margin,, 0
Gui, skippingOverlay:Add,Text,vtext w100,
Gui, skippingOverlay:Show, y0 x0 NoActivate, DD_SkippingOverlay
WinSet, TransColor, c%overlayWindowBackground% 255

; Main loop
global textIsHidden := true
SetKeyDelay, 10, 10
Loop
{
    if WinActive("ahk_exe DeathsDoor.exe")
    {
        spamKeyIsDown := GetKeyState(spamKey, "P")
        if (spamKeyIsDown) {
            ShowSkippingOverlayText()

            Send {%confirmKey% down}{%confirmKey% up}
            KeyWait % confirmKey, "L"
        } else {
            HideSkippingOverlayText()
        }
    }
    else
    {
        HideSkippingOverlayText()
        Sleep, 100
    }
}

;;;;;;;;;;;;;;;;;;;;
; End Main Program ;
;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
; Helper Functions ;
;;;;;;;;;;;;;;;;;;;;

; User prompt Functions

IsValidKey(selectedKey)
{
    vKey := GetKeyVK(selectedKey)
    if vKey = 0
        return false

    return true
}

PromptUserForKey(promptMessage)
{
    validKey := false
    selectedKey := ""
    While !validKey
    {
        InputBox, selectedKey, Enter key, %promptMessage%
        if ErrorLevel
            Exit

        StringLower, selectedKey, selectedKey

        validKey := IsValidKey(selectedKey)
        if (!validKey)
            MsgBox % selectedKey . " is not a valid key."
    }

    return selectedKey
}


; Overlay Functions

; Set overlay text
ShowSkippingOverlayText(displayText:="Skipping...")
{
    if (textIsHidden)
    {
        GuiControl, skippingOverlay:, Text, %displayText%
        textIsHidden := false
    }
}

; Hide overlay text
HideSkippingOverlayText()
{
    if (!textIsHidden)
    {
        GuiControl, skippingOverlay:, Text,
        textIsHidden := true
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;
; End Helper Functions ;
;;;;;;;;;;;;;;;;;;;;;;;;
