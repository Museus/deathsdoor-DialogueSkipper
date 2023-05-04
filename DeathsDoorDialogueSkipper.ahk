; Death's Door Dialogue Skipper v1.2.0
;
; Authors
; -------
; Museus (Discord: Museus#7777)
; SpR3AD (Discord: SpR3AD#9314)
;
; This script was based off of TW3AutoSpam (https://gist.github.com/Gaztin/391afe70ceeb1c79005f21645cdc480d)

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force
#MaxHotkeysPerInterval 100

SetBatchLines, -1
SetKeyDelay, -1, -1
SendMode Input

;;;;;;;;;;;;;;;;;;;;;;;;;
; CONFIGURATION SECTION ;
;;;;;;;;;;;;;;;;;;;;;;;;;

; Color to make overlay background, for Chromakey purposes (ex: ff00ff)
overlayWindowBackground := "ff00ff"

; Color to make overlay text (ex: 00ffff)
overlayFontColor := "00ffff"

; The key the user will hold to trigger script (using capital letters will result in you needing to press shift+key)
spamKey := ""

; The key the script will send to the game (using capital letters will result in sending shift+lowercase key)
confirmKey := ""

; How many times per second to send the down/up signal
spamCPS := 13

;;;;;;;;;;;;;;;;;;;;;
; END CONFIGURATION ;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
; Main Program ;
;;;;;;;;;;;;;;;;

; Load or prompt spam key
if (!IsValidKey(spamKey))
    spamKey := PromptUserForKey("Enter your desired auto-spam key:`n(visit autohotkey.com/docs/KeyList.htm for valid keys)`n(using capital letters will result in you needing to press shift+key) `n`nUnfortunately controller is not supported at this time`, so please use a keyboard key.")

; Prompt user for confirm key
if (!IsValidKey(confirmKey))
    confirmKey := PromptUserForKey("What keyboard key do you have Confirm bound to? `n(Default is q) `n(using capital letters will result in sending shift+lowercase key)")

; Calculate delay
; 10,000,000 µs / clicks per second = time per cycle in 
msSignalSent := 10000000 / spamCPS

; disable other hotkey functions
Hotkey, %spamKey%, disablefun
Hotkey, %spamKey%, Off


; Create Skipping window
Gui, skippingOverlay:destroy
Gui, skippingOverlay: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop +E0x20
Gui, skippingOverlay:Color, c%overlayWindowBackground%
Gui, skippingOverlay:Font, s16 q1 c%overlayFontColor%, %Font%
Gui, skippingOverlay:margin,, 0
Gui, skippingOverlay:Add,Text,vtext w250,
Gui, skippingOverlay:Show, y0 x0 NoActivate, DD_SkippingOverlay_v1.2.0
WinSet, TransColor, c%overlayWindowBackground% 255

; Main loop
global textIsHidden := true
t1 := t2 := 0
DllCall( "GetSystemTimePreciseAsFileTime", "Int64P",t1 )
status := 0
loop
{
	if WinActive("ahk_exe DeathsDoor.exe")
    {
		Hotkey, %spamKey%, On
		spamKeyIsDown := GetKeyState(spamKey, "P")
		if (spamKeyIsDown) {
			ShowSkippingOverlayText("Skipping... (v1.2.0)")
			DllCall( "GetSystemTimePreciseAsFileTime", "Int64P",t2 )
			if (Mod((t2-t1),(msSignalSent))<msSignalSent/2)
			{
				if (status=1)
				{	
					Send {%confirmKey% up}
					status := 0
				}
			}
			else
			{
				if (status=0)
				{
					Send {%confirmKey% down}
					status := 1
				}
			}
		}
		else
		{
			HideSkippingOverlayText()
			if (status=1)
			{	
				Send {%confirmKey% up}
				status := 0
			}
		}
	}
	else
    {
		Hotkey, %spamKey%, Off
        HideSkippingOverlayText()
		if (status=1)
		{	
			Send {%confirmKey% up}
			status := 0
		}
        Sleep, 100
    }
}

;;;;;;;;;;;;;;;;;;;;
; End Main Program ;
;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
; Helper Functions ;
;;;;;;;;;;;;;;;;;;;;

disablefun:
{}

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

