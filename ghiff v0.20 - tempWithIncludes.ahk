; Welcome to GRID Hotkey Interface v0.20.  I made this in an attempt to redesign hotkeys for Finale so
; that they are intuitive, visual, quicker, ergonomic.  Using AutoHotKey Script, it creates a simple visual
; interface, activated by any hotkey of your choosing (default is TAB) to perform basic tool switching
; as well as complicated tasks.  The GRID is a way some games use to organize hotkeys so they mimic
; visual menus and fit completely under the left hand.  Each Menu consists of 15 buttons: 3 rows of 5.
; Row one corresponds to "qwerty" Row two corresponds to "asdfg"  Row three corresponds to "zxcvb"
; This is the GRID.  Menus are changed by pressing 1-9 (1 always come up as default).  This allows for a
; possible 135 shortcuts to be programmed.  Each requiring no more than 3 key sequences to activate.
; The visual nature of the program requires little to no memory to learn while you naturally absorb the
; hotkeys into your mind.  By redistributing the workload of the actions more towards your left-hand,
; the right must move far less.  In doing so, one can come closer to greater efficiency and enjoyment.

; Make sure you have the latest version of AHK from http://ahkscript.org/download/
; The old site (autohotkey.com) is not maintained and doesn't have the latest version.

; How fast AHK does Send commands, basically.

; strsplit(var,"|") to delimit a thing like button101:some text|sometext() if that is how I'd set it up

IfNotExist, settings.ini
    gosub, createSettingsINIFile

SetDefaultMouseSpeed, 0

IniRead, topPageMargin, settings.ini, margins, Top
IniRead, leftPageMargin, settings.ini, margins, Left
IniRead, rightPageMargin, settings.ini, margins, Right
IniRead, bottomPageMargin, settings.ini, margins, Bottom
IniRead, optimalKeyDelay, settings.ini, pace, keyDelay
IniRead, pageScalingPercent, settings.ini, scalings, pagePercent
IniRead, systemScalingPercent, settings.ini, scalings, systemPercent
IniRead, staffHeight, settings.ini, scalings, staffHeight
IniRead, partPageWidth, settings.ini, pagesizes, ppageWidth
IniRead, partPageHeight, settings.ini, pagesizes, ppageHeight
IniRead, scorePageWidth, settings.ini, pagesizes, spageWidth
IniRead, scorePageHeight, settings.ini, pagesizes, spageHeight
IniRead, partTopFirstPageMarginExtension, settings.ini, additionaloffset, partp1offset
IniRead, scoreTopFirstPageMarginExtension, settings.ini, additionaloffset, scorep1offset
IniRead, partPage2OnPageMarginExtension, settings.ini, additionaloffset, partp2onoffset
IniRead, scorePage2OnPageMarginExtension, settings.ini, additionaloffset, scorep2onoffset


; Page Margins
global topPageMargin
global leftPageMargin
global rightPageMargin
global bottomPageMargin

; Page sizes
global partPageWidth
global partPageHeight
global scorePageWidth
global scorePageHeight

; should these be in settings?
global partTopFirstPageMarginExtension
global scoreTopFirstPageMarginExtension
global partPage2OnPageMarginExtension
global scorePage2OnPageMarginExtension

; How fast the mouse moves on macros that use the mouse in MOVEMENT
global optimalKeyDelay
SetKeyDelay, %optimalKeyDelay%
global clickspeed:=2


; Scaling for Parts
global pageScalingPercent
global systemScalingPercent
global staffHeight

global partOrScore

; Makes sure that CAPS doesn't get stuck on
SetCapsLockState, AlwaysOff

; This creates the menus/tabs that each contain 15 buttons.
Gui, Add, Tab2,x-4 y-3 w520 h330 vTabGroup  AltSubmit, Menu 1|Menu 2|Menu 3|Menu 4|Menu 5|Menu 6|Menu 7|Menu 8|Menu 9|Settings

; includes my customized macros for AHK... Things that let me write code better (better check/uncheck checkboxes)
changesSaved()
{
	SplashTextOn, 400,80, , The Changes Saved.  Script restarting...
	Sleep, 1500
	SplashTextOff
	Reload
}

Current_Tab()
{
	GuiControlGet,Current_Tab,,TabGroup
	return Current_Tab
}

ultimatum(functionToPerform)
{
	MsgBox,5,Error,Couldn't find the right things.`nPress Retry or Cancel to reload the script
	IfMsgBox Retry
		%functionToPerform%(dummy1,dummy2,dummy3)
	Else
		IfMsgBox Cancel
		{
			Reload
			Sleep 1000 
			MsgBox, Sorry.  Couldn't reload the script.
			return
		}
}

; activate Finale
goToFinale()
{
	Gui, Cancel
	WinActivate, Finale 
	WinWaitActive, Finale
	Send {esc}
}

waitForCursorToGoFromHourGlassToArrow()
{	
	timeOutCounter:=0
	while ((A_cursor != "Wait") && (timeOutCounter < 1000))
	{
		sleep 10
		timeOutCounter++
	}
	while ((A_cursor = "Wait") && (timeOutCounter < 1000))
	{
		sleep 10
		timeOutCounter++
	}
}

waitForCursorToBePointerForABit()
{
	timeOutCounter:=0
	Loop
	{
		if ((A_Cursor ="Arrow") && (timeOutCounter < 200))
			Continue
		Else
			Break
	}
}

; My custom Toggle Checkbox function...
customToggle(classNN, winTitle)
{
	ControlGet, isOrIsntChecked, Checked,, %classNN%, %winTitle%
	if (isOrIsntChecked = 0){
		Control Check,, %classNN%
	} else {
		Control Uncheck,, %classNN%
	}
}

; My custom Check / Uncheck function...
easyCheck(buttonsNumbersToCheck, winTitle)
{
	Loop, 3
	{
		for k, v in buttonsNumbersToCheck
		{
			Control, Check,, Button%v%, %winTitle%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}
}

easyUncheck(buttonsNumbersToUncheck, winTitle)
{
	Loop, 3
	{
		for k, v in buttonsNumbersToUncheck
		{
			Control, Uncheck,, Button%v%, %winTitle%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}	
}


easyReplaceText(editNumber, replacementText, winTitle)
{
	loop,3
	{
		loop, % editNumber.MaxIndex()
		{
			gg := % editNumber[a_index]
			ControlSetText, Edit%gg%, % replacementText[a_index], %winTitle%
			; MsgBox, Edit%editNumber%
		}
		if ErrorLevel
			{
				if a_index = 3
					ultimatum(A_ThisFunc)
				sleep 333
				Continue
			}
			Else
				Break
		break
	}
}

easyChoose(comboBoxNumber, whichOption, winTitle)
{
	loop, % comboBoxNumber.MaxIndex()
	{
		gg := % comboBoxNumber[a_index]
		Control, Choose,% whichOption[a_index],ComboBox%gg%, %winTitle%
	}
}

easyChooseString(comboBoxNumber, string, winTitle)
{
	loop, % comboBoxNumber.MaxIndex()
	{
		gg:= % comboBoxNumber[a_index]
		Control, ChooseString, % string[a_index], ComboBox%gg%, %winTitle%
	}
}


positionMeasureNumber(buttonNumber,myComboBox1,myComboBox2,HDistanceFromStaff,VDistanceFromStaff)
{
	ControlClick, Button%buttonNumber%, Measure Number,,,, NA
	WinWaitActive, Position Measure Number
	Control, Choose, %myComboBox1%, ComboBox1, Position Measure Number
	Control, Choose, %myComboBox2%, ComboBox2, Position Measure Number
	easyReplaceText([1,2], [HDistanceFromStaff,VDistanceFromStaff], "Position Measure Number")
	ControlClick, Button1, Position Measure Number,,,, NA
	WinWaitActive, Measure Number
}

;figure out a more efficient way
nothingSelected()
{
	WinMenuSelectItem, Finale,,Tools,Resize
	sleep 100
	WinMenuSelectItem, Finale,,Tools,Selection Tool
	sleep 100
}


killExtraInPrepper()
{
	IfWinExist, Finale, There must be at least 2 systems
	{
		WinActivate, Finale, There must be at least 2 systems
		Send {Enter}
		sleep 100
		IfWinExist, Space Systems Evenly
			WinClose, Space Systems Evenly
	}
}

applyToAllParts()
{
	WinWaitActive, Edit
	Send, !c
	WinWaitActive, Select Parts/Score
	Send, !a
	ControlFocus, SysListView321,Select Parts/Score
	Sleep, 100
	Send, {PgUp}
	Sleep, 100
	Send, {Space}
	Sleep, 100
	Send, {Enter}
	WinWaitActive, Edit
	send, !c
	WinWaitActive, Select Parts/Score
	Send, !n{Enter}
	WinWaitActive, Edit
}


forceMyPrefs()
{
	tryIt := runJWLuaScript("force-my-prefs.lua", "Force Joseph's Part/Score Preferences")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		updatePartsTemplate()
	}	
}


updatePartsTemplate()
{
	switchToInches()
	; if ((scoreOrPart = "part") Or (scoreOrPart = "allParts"))
	; {
	goToPageFormatForParts()
	pageFormatFor:="Page Format for Parts"
	Control, ChooseString, Inches, ComboBox2, %pageFormatFor%
	easyCheck([2,11],pageFormatFor)
	easyUncheck([6,9],pageFormatFor)
	easyReplaceText([2,3,4,5,6,7,8,9,10,11,15,16,17,18,23],[partPageWidth,partPageHeight,pageScalingPercent,staffHeight,systemScalingPercent,0,0,0,0,0,topPageMargin+partPage2OnPageMarginExtension,leftPageMargin,rightPageMargin,bottomPageMargin,topPageMargin+partTopFirstPageMarginExtension],pageFormatFor)
	; }
	Send, {Enter}
}
	
prepper(scoreOrPart,firstSysIndention,additionalOffsetForLeftScorePageMargin,additionalBottom)
{
	switchToInches()

	if (scoreOrPart = "score")
	{
		goToPageFormatForScore()
		pageFormatFor:="Page Format for Score"
		Control, ChooseString, Inches, ComboBox2, %pageFormatFor%
		easyCheck([2,6,11],pageFormatFor)
		easyUncheck([9],pageFormatFor)
		easyReplaceText([2,3,15,16,17,18,23,12,13,14],[scorePageWidth,scorePageHeight,topPageMargin+scorePage2OnPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,bottomPageMargin,partTopFirstPageMarginExtension+topPageMargin,0,firstSysIndention,0],pageFormatFor)
	}
	;fix page size, just in case
	goToPageSize()
	Send !a

	if (scoreOrPart = "part") {
		easyReplaceText([2,3], [partPageWidth, partPageHeight], "Page Size")
		Send, {Enter}
	}
	if (scoreOrPart = "score") {
		easyReplaceText([2,3], [scorePageWidth, scorePageHeight], "Page Size")
		Send, {Enter}
	}


	WinWaitActive, Finale
	goToEditSystemMargins()
	if (scoreOrPart = "score")
	{
		easyCheck([5,6,7,8,9], "Edit System Margins")
		easyReplaceText([1,2,3,4,5,6,7], [0,firstSysIndention,0,0,0,1,1], "Edit System Margins")
		ControlClick, Button1, Edit System Margins,,,, NA
	}
	if ((scoreOrPart = "part") Or (scoreOrPart = "allParts"))
	{
		Send !a
		easyCheck([5,6,7,8,9], "Edit System Margins")
		easyReplaceText([1,2,3,4,5,6], [0,0,0,0,0,1], "Edit System Margins")
		if (scoreOrPart = "allParts")
			applyToAllParts()
		if (scoreOrPart = "part")
			ControlClick, Button1, Edit System Margins,,,, NA
	}
	waitForCursorToGoFromHourGlassToArrow()


	;set page margins
	goToEditPageMargins()
	Send !a
	easyCheck([5,6,7,8,9], "Edit Page Margins")

	; establish .5 inch page margins for the entire document
	if (scoreOrPart = "part")
	{
		easyReplaceText([1,2,3,4], [topPageMargin+partTopFirstPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")
		ControlClick, Button1, Edit Page Margins,,,, NA
	}
	if (scoreOrPart = "allParts")
	{
		easyReplaceText([1,2,3,4], [topPageMargin+partTopFirstPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")
		applyToAllParts()
	}
	if (scoreOrPart = "score")
	{
		easyReplaceText([1,2,3,4],[topPageMargin+scoreTopFirstPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")
		ControlClick, Button1, Edit Page Margins,,,, NA
	}

	waitForCursorToGoFromHourGlassToArrow()

	Loop
	{
		InputBox, numFromInputBox,Systems per Page,How many systems should go on page 1?
		if ErrorLevel
			Break
		Else
		{
			;WinActivate, Finale
			WinWaitActive, Finale
			goToSpaceSystemsEvenly()
			if (scoreOrPart = "allParts")
				Control, ChooseString,All Parts,ComboBox1,Space Systems Evenly
			Send !p!c
			page2TopSystem:=numFromInputBox+1
			page2SecondToTopSystem:=numFromInputBox+2
			easyReplaceText([5], [numFromInputBox], "Space Systems Evenly")
			ControlClick, Button1, Space Systems Evenly,,,, NA
			waitForCursorToGoFromHourGlassToArrow()
			if (scoreOrPart = "allParts")
			{
				goToSpaceSystemsEvenly()
				Control, ChooseString,Current Part or Score,ComboBox1,Space Systems Evenly
				Send, {Enter}
			}
			waitForCursorToGoFromHourGlassToArrow()
			killExtraInPrepper()
			WinWaitActive, Finale
			Continue
		}
	}
	

	; fix page margins for rest of document
	goToEditPageMargins()
	easyCheck([5,6,7,8,9], "Edit Page Margins")
	; sleep 100
	Send !g{tab 2}2
	; sleep 100
	if (scoreOrPart = "part")
		{
			easyReplaceText([1,2,3,4],[topPageMargin+partPage2OnPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")	
			ControlClick, Button1, Edit Page Margins,,,, NA
		}
		if (scoreOrPart = "allParts")
		{
			easyReplaceText([1,2,3,4],[topPageMargin+partPage2OnPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")		
			applyToAllParts()
		}
	if (scoreOrPart = "score")
	{
		easyReplaceText([1,2,3,4],[topPageMargin+scorePage2OnPageMarginExtension,leftPageMargin+additionalOffsetForLeftScorePageMargin,rightPageMargin,additionalBottom+bottomPageMargin], "Edit Page Margins")
		ControlClick, Button1, Edit Page Margins,,,, NA
	}
	waitForCursorToGoFromHourGlassToArrow()


	goToEditSystemMargins()
	easyCheck([5,6,7,8,9], "Edit System Margins")
	; sleep 100
	easyReplaceText([1,2,3,4,5,6,7], [0,0,0,0,0,page2TopSystem,page2TopSystem], "Edit System Margins")
	if ((scoreOrPart = "score") or (scoreOrPart = "part"))
		ControlClick, Button1, Edit System Margins,,,, NA
	if (scoreOrPart = "allParts")
		applyToAllParts()
	waitForCursorToGoFromHourGlassToArrow()
	easyUncheck([15],"Edit Page Margins")
	easyReplaceText([1,2,3,4,5,6], [0,0,0,0,0,page2SecondToTopSystem], "Edit System Margins")
	if ((scoreOrPart = "score") or (scoreOrPart = "part"))
		ControlClick, Button1, Edit System Margins,,,, NA
	if (scoreOrPart = "allParts")
		applyToAllParts()
	waitForCursorToGoFromHourGlassToArrow()

	Loop
	{
		InputBox, num2FromInputBox,Systems per Page,How many systems should go on page 2+?
		if ErrorLevel
			Break
		Else
		{
			WinActivate, Finale
			WinWaitActive, Finale
			goToSpaceSystemsEvenly()
			if (scoreOrPart = "allParts")
				Control, ChooseString,All Parts,ComboBox1,Space Systems Evenly
			Send !n
			; sleep 100
			easyReplaceText([5], [num2FromInputBox], "Space Systems Evenly")
			ControlClick, Button1, Space Systems Evenly,,,, NA
			waitForCursorToGoFromHourGlassToArrow()
			if (scoreOrPart = "allParts")
			{
				goToSpaceSystemsEvenly()
				Control, ChooseString,Current Part or Score,ComboBox1,Space Systems Evenly
				Send, {Enter}
			}
			killExtraInPrepper()
			Continue
		}
	}
}

; SciSetText("( ﾟ∀ﾟ)ｱﾊﾊ八八ﾉヽﾉヽﾉヽﾉ ＼ / ＼/ ＼", "Scintilla1", "Scratch Pad ahk_exe AutoHotkey.exe")

; GeekDude wrote this in like 10 minutes one night for fun... 
SciSetText(Text, Control, WinTitle)
{
	Static MEM_COMMIT := 0x1000, PAGE_READWRITE := 0x04, MEM_RELEASE := 0x8000
	Static SCI_SETTEXT := 2181
	WinGet, PID, PID, %WinTitle%
	
	hProcess := DllCall("OpenProcess", "UInt", 0x438 ; PROCESS-OPERATION|READ|WRITE|QUERY_INFORMATION
	, "Int", False ; inherit = false
	, "ptr", PID
	, "UPtr")
	
	Length := StrPutVar(Text, Buffer, "UTF-8")
	
	pBuffer := DllCall("VirtualAllocEx", "ptr", hProcess, "ptr", 0
	, "UInt", Length, "UInt", MEM_COMMIT, "UInt", PAGE_READWRITE, "UPtr")
	
	DllCall("WriteProcessMemory", "ptr", hProcess
	, "ptr", pBuffer, "ptr", &Buffer, "UInt", Length, "UPtr", 0)
	
	SendMessage, SCI_SETTEXT, 0, pBuffer, %Control%, %WinTitle%
	
	DllCall("VirtualFreeEx", "ptr", hProcess, "ptr", pBuffer, "ptr", 0, "UInt", MEM_RELEASE)
}

StrPutVar(string, ByRef var, encoding)
{
    ; Ensure capacity.
    VarSetCapacity( var, StrPut(string, encoding)
        ; StrPut returns char count, but VarSetCapacity needs bytes.
        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )
    ; Copy or convert the string.
    return StrPut(string, &var, encoding)
}

; includes all of the functions for each Finale Macro.
; This function is a list of instructions for what to do when a button on the grid is pressed.
; Once a button is pressed, it basically takes away the interface and makes Finale the active window.

; helper functions

goToDocumentOptions()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Document,Document Options...
	WinWaitActive, Document Options,,1
	if ErrorLevel
		goToDocumentOptions()
}

goToResizePage()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Page Layout,Resize Pages (Page Reduction)...
	if ErrorLevel
	{
		activatePageLayoutTool()
		sleep 100
		goToResizePage()
	}
	WinWaitActive, Resize Page
	if ErrorLevel
		goToResizePage()
}

changeTimeSigInDocOptions(sequence,font, type, size, top, bottom,topEditNumber,bottomEditNumber)
{
	WinWaitActive, Finale
	goToDocumentOptions()
	i := 0
	while (i < 90) and !(WinActive("Document Options - Fonts"))
	{
		Send ^{tab}
		i++
		sleep, 5
	}
	ifWinActive, Document Options - Fonts
	{
		ControlFocus, ComboBox3
		Send %sequence%
		send !n
		WinWaitActive, Font
		easyUncheck([1,2,3,4,5], "Font")
		easyReplaceText([1,2,3],[font, type, size],"Font")
		ControlClick, Button6, Font,,,, NA
	}
	else
	MsgBox, Couldn't find time signatures

	i := 0
	while (i < 90) and !(WinActive("Document Options - Time Signatures"))
	{
		Send ^{tab}
		i++
		sleep, 5
	}
	ifWinActive, Document Options - Time Signatures
	{
		; Send +{tab}e
		easyReplaceText([topEditNumber,bottomEditNumber], [top,bottom], "Document Options - Time Signatures")
	}
	else
	{
		MsgBox, Couldn't find time signatures
	}
	Send {enter}
	WinWaitActive, Finale
}

createNewExpression(verticalBaselineAdjustment, verticalEntryAdjustment, aboveOrBelow9or10, styleButton)
{
	WinWaitActive, Finale
	switchToEVPUs()
	activateExpressionTool()
	KeyWait, LButton, D
	KeyWait, LButton, U
	Click
	WinWaitActive, Expression Selection
	ControlFocus, ListBox1
	Send se!c
	WinWaitActive, Expression Designer
	Send ^+{tab}
	sleep, 100
	easyUncheck([1], "Expression Designer")
	sleep, 100
	Control, Choose, 1, ComboBox2, Expression Designer 
	Control, Choose, %aboveOrBelow9or10%, ComboBox3, Expression Designer
	Send !b%verticalBaselineAdjustment%
	Send !f%verticalEntryAdjustment%
	sleep, 100
	Send ^{tab}
	easyUncheck([4], "Expression Designer")
	Control, ChooseString, Times New Roman, ComboBox1, Expression Designer
	Control, ChooseString, 14, ComboBox2, Expression Designer
	sleep, 100
	ControlClick, %styleButton%, Expression Designer,,,, NA
	ControlFocus, FinDisp2
	While !(WinActive("Expression Selection") || GetKeyState("Tab","P"))
		sleep, 20
	IfWinActive, Expression Designer
	{
		sleep, 50
		Send, {BackSpace}
		sleep, 50
		ControlClick, Button18, Expression Designer,,,, NA
		sleep, 50
		WinWaitActive, Expression Selection
		Send, +a
		Send, {Enter}

	}
	Else
	{
		Send, +a
		Send, {Enter}
	}
}

goToGlobalStaffAttributes()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Plug-ins,Scoring and Arranging,Global Staff Attributes...
	WinWaitActive, Global Staff Attributes,,.6
	if ErrorLevel
		goToGlobalStaffAttributes()
}

goToFitMeasures()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Fit Measures...
	WinWaitActive, Fit Measures
}

switchToEVPUs()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Measurement Units,EVPUs
}

switchToInches()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Measurement Units,Inches
}

switchToSpaces()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Measurement Units,Spaces
}

goToMoveCopyLayers()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Move/Copy Layers...
	WinWaitActive, Move/Copy Layers
}

goToChangeNoteDurations()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Change,Note Durations...
	WinWaitActive, Change Note Durations
}

goToChangeNoteHeads()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Change,Noteheads...
	WinWaitActive, Change Noteheads
}

goToEditFilter()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Edit Filter...
	WinWaitActive, Edit Filter
}

ToggleFilter()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Use Filter
}

goToPageFormatForParts()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Document, Page Format, Parts...
	WinWaitActive, Page Format for Parts
}

goToPageFormatForScore()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Document, Page Format, Score...
	WinWaitActive, Page Format for Score
}

goToEditMeasureNumberRegions()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Measure,Edit Measure Number Regions...
	if ErrorLevel
	{
		activateMeasureTool()
		sleep 200
		goToEditMeasureNumberRegions()
	}
	WinWaitActive, Measure Number
}

goToPrint()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,File,Print...
	WinWaitActive, Print
	if ErrorLevel
		goToPrint()
}

goToManageParts()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Document,Manage Parts...
	WinWaitActive, Manage Parts,, .3
	if ErrorLevel
		goToManageParts()
}


goToEditSystemMargins()
{
	WinWaitActive, Finale,,.3
	IfWinExist, Edit System Margins
	{
		WinActivate, Edit System Margins
		WinWaitActive, Edit System Margins
		if ErrorLevel
			goToEditSystemMargins()
	}
	Else
	{
		activatePageLayoutTool()
		sleep 250
		WinMenuSelectItem,Finale,,Page Layout,Systems,Edit Margins...
		sleep 250
		WinActivate, Edit System Margins
		WinWaitActive, Edit System Margins
		if ErrorLevel
			goToEditSystemMargins()
	}
}

goToEditPageMargins()
{
	WinWaitActive, Finale,,.3
	IfWinExist, Edit Page Margins
	{
		WinActivate, Edit Page Margins
		WinWaitActive, Edit Page Margins
	}
	Else
	{
		activatePageLayoutTool()
		sleep 250
		WinMenuSelectItem,Finale,,Page Layout,Page Margins,Edit Page Margins...
		sleep 250
		WinActivate, Edit Page Margins
		WinWaitActive, Edit Page Margins
	}
}

goToPageSize()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Page Layout,Page Size...
	If ErrorLevel
	{
		activatePageLayoutTool()
		goToPageSize()		
	}
	WinWaitActive, Page Size
}

goToSpaceSystemsEvenly()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Page Layout,Space Systems Evenly...
	if ErrorLevel
	{
		activatePageLayoutTool()
		goToSpaceSystemsEvenly()
	}
	WinWaitActive, Space Systems Evenly
}

goToTextSearchAndReplace()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Text Search and Replace...
	WinWaitActive, Text Search and Replace
}

goToResizeStaffSystem()
{
	activatePageLayoutTool()
	sleep 100
	WinMenuSelectItem,Finale,,Page Layout,Resize Staff Systems (System Reduction)...
	WinWaitActive, Resize Staff System
}

goToTransposition()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Transpose...
	WinWaitActive, Transposition
}

goToRetranscribe()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,MIDI/Audio,Retranscribe
}

goToScoreManager()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Window,ScoreManager
	WinWaitActive, ScoreManager
}

goToVerticalCollisionRemover()
{
	switchToEVPUs()
	sleep 100
	WinMenuSelectItem, Finale,,Plug-ins,Scoring And Arranging,Vertical Collision Remover...
	WinWaitActive, Vertical Collision Remover
}

makeSureThereIsSomethingInScoreInsert() ;fix me using ControlGetText
{
	goToScoreManager()
	Control,TabLeft,,SysTabControl321
	Clipboard = 
	ControlFocus, Edit8, ScoreManager
	Send ^a^c
	sleep 100
	ClipWait, .1
	if ErrorLevel
	{
		Send Score
		sleep 50
		WinClose, ScoreManager
	}
	sleep 50
	WinClose, ScoreManager
}

print(pageSize)
{
	goToPrint()
	Send, !c
	Sleep, 50
	Send, !s
	WinWaitActive, Print Setup
	Sleep, 50

	;printer definitions
	Control, ChooseString, PrimoPDF, ComboBox1, Print Setup
	if ErrorLevel = 0
	{
		Control, ChooseString, %pageSize%, ComboBox2, Print Setup
		Send, {Enter}
		WinWaitActive, Print
		Send, {Enter}
		WinWaitActive, PrimoPDF
		Send, +{Tab 2}{Down 4}{Tab 2}{Enter}
	}
	Else
	{
		Control, ChooseString, CutePDF Writer
		if ErrorLevel = 0
		{
			Control, ChooseString, %pageSize%, ComboBox2, Print Setup
			Send, {Enter}
			WinWaitActive, Print
			Send, {Enter}
		}
		Else
		{
			Control, ChooseString, PDFCreator, ComboBox1, Print Setup
			Control, ChooseString, %pageSize%, ComboBox2, Print Setup
			Send, {Enter}
			WinWaitActive, Print
			Send, {Enter}
		}
	}
	
}

askAndAddInserts(partOrScore,currentInsert,font,typeFace,size,page,horizontal,vertical,positionFrom,pageNumber,hDistance,vDistance)
{
	WinWaitActive, Finale
	Click 4
	sleep 100
	WinMenuSelectItem,Finale,,Text,Inserts,%currentInsert%
	sleep 100
	If (currentInsert = "Page Number")
	{
		Send {Home}-{space}{right}{space}-
	}
	If (currentInsert = "Total Pages")
	{
		Send {Home}Total{space}Pages{space}{space}={space}{space}
	}
	If ((currentInsert = "Subtitle") AND (partOrScore = "Score"))
	{
		Send +{Enter}Estimated Time ={Space}
		WinMenuSelectItem,Finale,,Text,Inserts,Performance Time
	}
	sleep 100
	Send ^a^'
	WinMenuSelectItem,Finale,,Text,Font...
	WinWaitActive, Font

	easyUncheck([1,2,3,4,5], "Font")
	if (partOrScore = "hidden")
	{
		easyCheck([4],"Font")
		easyCheck([1],"Font")
	}

	If ((partOrScore = "score") Or (partOrScore = "titlePage"))
	{
		easyCheck([1],"Font")
	}
	easyReplaceText([1,2,3],[font,typeFace,size],"Font")
	sleep 200
	Send {enter}
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Text,Frame Attributes...
	WinWaitActive, Frame Attributes
	easyChoose([1,3,4,5],[page,horizontal,vertical,positionFrom], "Frame Attributes")
	easyCheck([8],"Frame Attributes")
	easyUncheck([10],"Frame Attributes")
	easyReplaceText([1,4,5],[pageNumber,hDistance,vDistance],"Frame Attributes")
	sleep 100
	send {enter}
	WinWaitActive, Finale
}


; BELOW ARE THE FUNCTIONS THEMSELVES FOR EACH INDIVIDUAL MACRO THAT ACTUALLY DO SOMETHING
; ---------------------------------------------------------------------------------------------------------------

printLetter()
{
	print("Letter")
}

printTabloid()
{
	print("11 x 17")
}

printConcert()
{
	print("9x12")
}

activateExpressionTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Expression
}

activateSecondaryBeamBreak()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,, Tools, Advanced Tools, Special Tools, Secondary Beam Break
}

activateSpeedyNoteEntry()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Speedy Entry
}

activateSelectionTool()
{
	WinWaitActive, Finale
	Send, {Esc}
	WinMenuSelectItem,Finale,,Tools,Selection Tool
}

activateClefTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Clef
}

activateTimeSignatureTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Time Signature
}

activateTextTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Text
}

activateMeasureTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Measure
}

activateArticulationTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Articulation
}

activateSlur()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Smart Shape,Slur
}

activateDecrescendo()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Smart Shape,Decrescendo
}

activateCrescendo()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Smart Shape,Crescendo
}

showHideGrid()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,View,Grid/Guide,Show Grid
}

activateSimpleEntry()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Simple Entry,Repitch
}

toggleConcertPitch()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Document,Display in Concert Pitch
}

openCanonicUtilities()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Plug-ins,Scoring And Arranging,Canonic Utilities...
	WinWaitActive, Canonic Utilities
}

activatePageLayoutTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Page Layout
	sleep, 100
}

activateStaffTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Staff
}

switchToDefaultSpelling()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Enharmonic Spelling,Use Default Spelling
}

switchToUseSpellingTables()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Enharmonic Spelling,Use Spelling Tables
}

switchtoFavorFlats()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Enharmonic Spelling,Favor Flats
}

switchToFavorSharps()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Enharmonic Spelling,Favor Sharps
}

createMultimeasureRests()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Edit,Multimeasure Rests,Create for Parts/Score...
	WinWaitActive, Select Parts/Score,,.3
	if ErrorLevel
		createMultimeasureRests()
	Send, !a{Enter}

}

activateChordTool()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Tools,Chord
}

switchToLayer1()
{
	goToMoveCopyLayers()
	Send 7{Enter}
}

switchToLayer2()
{
	goToMoveCopyLayers()
	Send 6{Enter}
}

doubleNoteLengths()
{
	goToChangeNoteDurations()
	Control, ChooseString, 200`%, ComboBox1, Change Note Durations
	ControlClick, Button1, Change Note Durations,,,, NA
}

halveNoteLengths()
{
	goToChangeNoteDurations()
	Control, ChooseString, 50`%, ComboBox1, Change Note Durations
	ControlClick, Button1, Change Note Durations,,,, NA
}

pasteDynamicsOnly()
{
	goToEditFilter()
	ControlClick, Button3, Edit Filter,,,, NA
	easyCheck([12, 14], Edit Filter)
	ControlClick, Button1, Edit Filter,,,, NA
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Paste
	sleep 100
	ToggleFilter()
}

makeBigTimeSignatures()
{
	tryIt := runJWLuaScript("time-sigs-score-big.lua", "Time Signatures - Score - Make Big")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		addInfoToPartsOld()
	} Else
	{
		goToGlobalStaffAttributes()
	}
}

makeBigTimeSignaturesOld()
{
	changeTimeSigInDocOptions("ntt","EngraverTime","Regular",40,0,"-290e",7,9)
	goToGlobalStaffAttributes()
}

makeNormalTimeSignatures()
{
	tryIt := runJWLuaScript("time-sigs-score-normal.lua", "Time Signatures - Score - Normal")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		makeNormalTimeSignaturesOld()
	}
}

makeNormalTimeSignaturesOld()
{
	changeTimeSigInDocOptions("ntt","Maestro","Regular",24,0,0,7,9)
	goToGlobalStaffAttributes()
	easyCheck([22], "Global Staff Attributes")
	easyCheck([22], "Global Staff Attributes")
	ControlClick, Button1, Global Staff Attributes,,,, NA
}

makeBigTimeSignaturesInParts()
{
	changeTimeSigInDocOptions("nttt","EngraverTextT","Regular",28,"-17e","-58e",8,10)
}

makeNormalTimeSignaturesInParts()
{
	changeTimeSigInDocOptions("nttt","Maestro","Regular",24,0,0,8,10)
}

showHideRestsInEmptyMeasures()
{
	goToGlobalStaffAttributes()
	customToggle("Button8", "Global Staff Attributes")
	ControlClick, Button1, Global Staff Attributes,,,, NA
}

makeHollywoodMeasureNumbers()
{
	switchToEVPUs()
	goToEditMeasureNumberRegions()
	Send !d!d!d!d!d!a ;deletes up to 5 existing entries and then adds a new one
	Control,TabLeft,,SysTabControl321
	easyUncheck([8,11,12,14,24], "Measure Number")
	easyCheck([9,10,17,23], "Measure Number")
	
	ControlClick, Button21, Measure,,,, NA
	WinWaitActive, Font
	easyUncheck([1,2,3,4,5], "Font")
	easyReplaceText([1,2,3], ["Times New Roman","Bold",22], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number

	positionMeasureNumber(22,3,3,0,-270)

	;change linked parts settings
	Control,TabRight,,SysTabControl321
	sleep 50
	easyUncheck([7],"Measure Number")
	easyCheck([8,10,17,24],"Measure Number")
	easyUncheck([11,12,14,18,20,23],"Measure Number")
	positionMeasureNumber(22,3,3,0,-175)
	positionMeasureNumber(26,3,3,0,-175)
	
	;add hidden Regions
	Send !a
	sleep 50
	easyUncheck([8,9,10,17,24],"Measure Number")
	Control,TabLeft,,SysTabControl321
	sleep 50
	easyUncheck([8,9,10], "Measure Number")
	Send !t
	WinWaitActive, Font
	easyCheck([4], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number
	ControlClick, Button1, Measure Number,,,, NA
	; actually hide all hidden ones by default
	nothingSelected()
	goToGlobalStaffAttributes()
	easyUncheck([22], "Global Staff Attributes")
	ControlClick, Button1, Global Staff Attributes,,,, NA
}

makeConventionalMeasureNumbers()
{
	switchToEVPUs()
	goToEditMeasureNumberRegions()
	Send !d!d!d!d!d!a ;deletes up to 5 existing entries and then adds a new one
	Control,TabLeft,,SysTabControl321
	easyCheck([8,11,14,24,23], "Measure Number")
	easyUncheck([9,10,12,17,18,20], "Measure Number")
	Send !f
	WinWaitActive, Font
	easyReplaceText([1,2,3], ["Times New Roman","Italic",11], "Font")
	easyCheck([1], "Font")
	easyUncheck([2,3,4,5], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number
	Send !p
	WinWaitActive, Position Measure Number
	Send !a{up 2}
	easyReplaceText([1,2], [6,50], "Position Measure Number")
	ControlClick, Button1, Position Measure Number,,,, NA
	WinWaitActive, Measure Number
	positionMeasureNumber(26,3,3,0,-175)
	ControlClick, Button1, Measure Number,,,, NA
	WinWaitActive, Finale
	Send {esc}
}

showHideMeasureNumbers()
{
	goToGlobalStaffAttributes()
	customToggle("Button16", "Global Staff Attributes")
	ControlFocus, Button1
	Send {enter}
}

showMeasureNumbers()
{
	goToGlobalStaffAttributes()
	easyCheck([16],"Global Staff Attributes")
	ControlFocus, Button1
	Send {enter}
}

addHiddenTextAboveTheStaff()
{
	createNewExpression(-26, 36, 9, "Button6")
}

addBoldTextAboveTheStaff()
{
	createNewExpression(-26, 36, 9, "KOBmpBtn1")
}

addItalicTextBelowTheStaff()
{
	createNewExpression(26, -65, 10, "KOBmpBtn2")
}

addTempoMarking()
{
	switchToEVPUs()
	activateExpressionTool()
	KeyWait, LButton, D
	KeyWait, LButton, U
	Click
	WinWaitActive, Expression Selection
	ControlFocus, ListBox1
	Send st!c
	WinWaitActive, Expression Designer
	Send ^{tab}
	sleep, 100
	Send !m
	Sleep, 100
	Send ^{tab}
	sleep, 50
	easyUncheck([1], "Expression Designer")
	sleep, 50
	Control, Choose, 1, ComboBox2, Expression Designer 
	Control, Choose, 9, ComboBox3, Expression Designer
	easyReplaceText([2],[-26], "Expression Designer")
	Send ^{tab}
	sleep, 100
	Control, Choose, 2, ComboBox1, Expression Designer
	sleep, 20
	send q^a
	easyUncheck([4], "Expression Designer")
	sleep, 50
	easyCheck([5], "Expression Designer")
	Control, ChooseString, EngraverTextT, ComboBox1, Expression Designer
	Control, ChooseString, 12, ComboBox2, Expression Designer
	Send {Right}
	Control, ChooseString, Times New Roman, ComboBox1, Expression Designer
	Control, ChooseString, 14, ComboBox2, Expression Designer
	sleep, 50
	ControlClick, KOBmpBtn1, Expression Designer,,,, NA
	send {Space}={Space}^{Left 8}
	ControlClick, KOBmpBtn1, Expression Designer,,,, NA
	Control, ChooseString, Times New Roman, ComboBox1, Expression Designer
	Control, ChooseString, 14, ComboBox2, Expression Designer
	sleep, 20
	While !(WinActive("Expression Selection") || GetKeyState("Tab","P"))
		sleep, 20
	IfWinActive, Expression Designer
	{
		Send {BackSpace}^{right 20}
		KeyWait, Tab, D
		Send {BackSpace}
		sleep, 100
		ControlClick, OK, Expression Designer,,,, NA
		WinWaitActive, Expression Selection
		Send {Enter}

	}
	Else
		Send {Enter}
}

makeMultimeasureRests()
{
	switchToEVPUs()
	activateSelectionTool()

	; change doc options
	goToDocumentOptions()
	i := 0
	while (i < 90) and !(WinActive("Document Options - Fonts"))
	{
		Send ^{tab}
		i++
		sleep, 10
	}
	WinWaitActive, Document Options - Fonts
	ControlFocus, ComboBox3
	Send nm
	send !n
	WinWaitActive, Font
	easyUncheck([1,2,3,4,5], "Font")
	easyReplaceText([1,2,3],["MaestroTimes","Regular",24],"Font")
	ControlClick, Button6, Font,,,, NA

	WinWaitActive, Document Options - Fonts
	i := 0
	while (i < 90) and !(WinActive("Document Options - Multimeasure Rests"))
	{
		Send ^{tab}
		i++
		sleep, 6
	}
	WinWaitActive, Document Options - Multimeasure Rests
	Send +{tab}e
	easyCheck([6],"Document Options - Multimeasure Rests")
	easyUncheck([5],"Document Options - Multimeasure Rests")
	easyReplaceText([4,5],[0,6], "Document Options - Multimeasure Rests")

	Send {enter}
	WinWaitActive, Finale

	; actually makes them
	Send ^a
	createMultimeasureRests()
	sleep 100
	goToEditMeasureNumberRegions()
	easyCheck([24], "Measure Number")
	easyUncheck([23], "Measure Number")
	send {enter}
}

prepPart()
{
	goToResizePage()
	Send 100!a
	easyCheck([1,6], "Resize Page")
	Send {enter}
	prepper("part",0,0,0)
}

prepScore()
{
	prepper("score",.6,0.4,0.25) 
}

dropSystemMargins()
{
	goToEditSystemMargins()
	Send !a
	easyCheck([5,8,9], "Edit System Margins")
	easyUnCheck([6,7], "Edit System Margins")
	easyReplaceText([1,4,5,6], [0,0,0,1], "Edit System Margins")
	ControlClick, Button1, Edit System Margins,,,, NA
	WinActivate, Finale
	WinWaitActive, Finale
	Send {Esc}
	activateStaffTool()
}

addInfoToParts()
{
	tryIt := runJWLuaScript("parts_add-title-page-and-all-inserts.lua", "Parts - Add Inserts and Title Page")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		addInfoToPartsOld()
	}
}

addInfoToPartsOld()
{
	;delete existing inserts and blank pages
	activatePageLayoutTool()
	WinMenuSelectItem, Finale,,Page Layout, Delete Blank Pages...
	WinWaitActive, Delete Blank Pages
	easyCheck([6],"Delete Blank Pages")
	easyReplaceText([3],[1],"Delete Blank Pages")
	Send, {Enter}

	switchToInches()
	activateTextTool()
	makeSureThereIsSomethingInScoreInsert()
	MsgBox, The script will continue when you hit OK and click in a blank area.
	KeyWait, LButton, D
	KeyWait, LButton, U
	Send, ^a
	Sleep, 50
	Send, {Delete}
	askAndAddInserts("part","Part/Score Name","Times New Roman","Bold",18,1,1,1,2,1,leftPageMargin,-topPageMargin)
	askAndAddInserts("part","Copyright Text","Times New Roman","Bold",18,1,3,1,2,1,-rightPageMargin,-topPageMargin)
	askAndAddInserts("part","Title","Times New Roman","Bold",26,1,2,1,2,1,0,-0.5-topPageMargin)
	askAndAddInserts("part","Subtitle","Times New Roman","Italic",11,1,2,1,2,1,0,-0.9-topPageMargin)
	askAndAddInserts("part","Composer","Times New Roman","Bold",12,1,3,1,2,1,-rightPageMargin,-1.3-topPageMargin)
	askAndAddInserts("part","Part/Score Name","Times New Roman","Bold",14,3,1,1,2,2,leftPageMargin,-topPageMargin)
	askAndAddInserts("part","Page Number","Times New Roman","Bold",14,3,2,1,2,2,0,-topPageMargin)
	askAndAddInserts("part","Title","Times New Roman","Bold",14,3,3,1,2,2,-rightPageMargin,-topPageMargin)

	askAndAddInserts("hidden","Total Pages","Times New Roman","Regular",18,1,2,1,2,1,-1,-0.05)

	setTitlePageLayout()
}

addInfoToScore()
{
	tryIt := runJWLuaScript("score_add-all-inserts.lua", "Score - Add Inserts")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		addInfoToScoreOld()
	}
}

addInfoToScoreOld()
{
	switchToInches()
	activateTextTool()
	makeSureThereIsSomethingInScoreInsert()
	MsgBox, The script will continue when you hit OK and click in a blank area.
	KeyWait, LButton, D
	KeyWait, LButton, U
	Send, ^a
	Sleep, 50
	Send, {Delete}
	askAndAddInserts("score","Part/Score Name","Times New Roman","Bold",18,1,1,1,2,1,leftPageMargin,-topPageMargin)
	askAndAddInserts("score","Copyright Text","Times New Roman","Bold",18,1,3,1,2,1,-rightPageMargin,-topPageMargin)
	askAndAddInserts("score","Title","Times New Roman","Bold",26,1,2,1,2,1,0,-topPageMargin)
	askAndAddInserts("score","Subtitle","Times New Roman","Bold Italic",14,1,2,1,2,1,0,-.45-topPageMargin)
	askAndAddInserts("score","Composer","Times New Roman","Bold",12,1,3,1,2,1,-rightPageMargin,-.6-topPageMargin)
	askAndAddInserts("score","Part/Score Name","Times New Roman","Bold",14,3,1,1,2,2,leftPageMargin,-topPageMargin-.2)
	askAndAddInserts("score","Page Number","Times New Roman","Bold",14,3,2,1,2,2,0,-topPageMargin-.2)
	askAndAddInserts("score","Title","Times New Roman","Bold",14,3,3,1,2,2,-rightPageMargin,-topPageMargin-.2)

	askAndAddInserts("hidden","Total Pages","Times New Roman","Regular",18,1,2,1,2,1,-1,-0.05)
}

grabRestOfMeasures()
{
	WinWaitActive, Finale
	Send +{End}+{PgDn}
}

insertPageBreak()
{
	nothingSelected()
	activatePageLayoutTool()
	sleep 100
	MouseClick, Right
	WinWait,ahk_class #32768
	MouseClick, Left,10,80,,,,R
	MouseClick, Left,0,18,,,,R]
	MouseMove,-10,-98,,R
	Send {Esc}
}

resizePageSystemStaffAllParts()
{
	switchToEVPUs()
	goToResizePage()
	easyCheck([1,6], "Resize Page")
	Send !a
	Control, Choose, 3, ComboBox1, Resize Page
	easyReplaceText([1,4], [pageScalingPercent,1], "Resize Page")
	Send {Enter}
	WinWaitActive, Finale

	;resize system and staff
	goToResizeStaffSystem()
	Control, Choose, 1, ComboBox1, Resize Staff System
	Control, Choose, 3, ComboBox2, Resize Staff System
	easyReplaceText([1,2,3,4,5], [staffHeightEVPU,systemScalingPercent,1,1,1], "Resize Staff System")
	easyCheck([2,3,7], "Resize Staff System")
	Send {enter}
}

changeToXShapedNoteheads()
{
	tryIt := runJWLuaScript("x-shaped-noteheads-change.lua", "X-Shaped Noteheads - Change")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		changeToXShapedNoteheadsOld()
	}	
}

changeToXShapedNoteheadsOld()
{
	goToChangeNoteHeads()
	Send !n{tab}{Alt Down}{Numpad0}{Numpad1}{Numpad9}{Numpad2}{Alt Up}
	Send {Enter}
	WinWaitActive, Finale
}

addOctave()
{
	goToTransposition()
	Send !u!c!p1
	Control, ChooseString, Perfect Unison, ComboBox2, Transposition
	easyCheck([8], "Transposition")
	Send {Enter}
	WinWaitActive, Finale
	goToTransposition()
	Send !p-1
	easyUncheck([8], "Transposition")
	Send {Enter}
}

retranscribeToFavorFlats()
{
	switchToFavorFlats()
	goToRetranscribe()
}

retranscribeToFavorSharps()
{
	switchToFavorSharps()
	goToRetranscribe()
}

singleOutVoice()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Plug-ins,TG Tools,Process Extracted Parts...
	WinWaitActive, Process Extracted Parts
	Send +{Tab 2}
	While !(WinActive("Finale") || GetKeyState("Enter","P"))
		sleep, 20
	sleep 50
	IfWinActive, Finale
		goto, ending
	Send !c
	ending:
}

checkJWCautionaryAccidentals()
{
	activateSelectionTool()
	WinMenuSelectItem, Finale,,Plug-ins,JW Accidentals...
	If ErrorLevel
	{
		WinMenuSelectItem, Finale,,Plug-ins,JWTools,JW Accidentals...
		If ErrorLevel
		{
			MsgBox, Couldn't find the menu item "JW Accidentals."  Place it directly in Plug-ins or a folder called "JWTools"
			Goto, JWAccidentalEnding
		}

	}
	WinWaitActive, JW Accidentals
	WinActivate, Finale
	Send ^a
	WinActivate, JW Accidentals
	;fix
	ControlClick, Button3, JW Accidentals,,,, NA
	; waitForCursorToGoFromHourGlassToArrow()
	; WinWaitNotActive, JW Accidentals,,2
	; if ErrorLevel
	; {
	; 	SplashTextOn, 400,80, , Added cautionary accidentals...
	; 	Sleep, 1500
	; 	SplashTextOff
	; }
	; Else
	; {
	; 	Send, {Enter}
	; 	SplashTextOn, 400,80, , No cautionary accidentals were needed...
	; 	Sleep, 1500
	; 	SplashTextOff
	; }
	
	; IfWinExist, JW Accidentals
	; WinClose, JW Accidentals
	; ControlClick, Button4, JW Accidentals,,,, NA
	; nothingSelected()
	; IfWinExist, JW Accidentals
	; 	WinClose, JW Accidentals

	JWAccidentalEnding:
}

checkTiesAccidentalsDurations()
{
	activateSelectionTool()
	Send ^a
	sleep 100
	WinMenuSelectItem, Finale,,Utilities,Check Notation,Check Ties
	sleep 500
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Utilities,Check Notation,Check Accidentals
	sleep 500
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Plug-ins,Note`, Beam`, and Rest Editing,Check Region for Durations...
	WinWaitActive, Check Region for Durations
	Send {Enter}
}

fixScoreSpacingBeta()
{
	MsgBox, go have a coffee...
	goToVerticalCollisionRemover()
	easyCheck([1],"Vertical Collision Remover")
	;my configs
	easyCheck([3,4],"Vertical Collision Remover")
	easyUncheck([5,6,7],"Vertical Collision Remover")
	easyReplaceText([3,4,5,6],[0,0,0,0],"Vertical Collision Remover")
	sleep 50
	; edit "More" tab
	Control,TabRight,,SysTabControl321	
	Sleep, 50
	easyCheck([6,5,4,1],"Vertical Collision Remover")
	sleep 50
	Send {Enter}
	;running
	waitForCursorToGoFromHourGlassToArrow()
	WinWaitActive, Finale
	;space systems evenly

	;;;;;;;;;;
	goToVerticalCollisionRemover()
	easyCheck([1],"Vertical Collision Remover")
	;my configs
	easyCheck([3,4],"Vertical Collision Remover")
	easyUncheck([5,6,7],"Vertical Collision Remover")
	easyReplaceText([3,4,5,6],[20,0,90,70],"Vertical Collision Remover")
	sleep 50
	; edit "More" tab
	Control,TabRight,,SysTabControl321	
	Sleep, 50
	easyCheck([6,5,4,3],"Vertical Collision Remover")
	sleep 50
	Send {Enter}
	;running
	waitForCursorToGoFromHourGlassToArrow()
	WinWaitActive, Finale
	;space systems evenly
	goToSpaceSystemsEvenly()
	easyCheck([7,12],"Space Systems Evenly")
	Send, {Enter}
}

setTitlePageLayout()
{
	activatePageLayoutTool()
	WinMenuSelectItem, Finale,,Page Layout, Insert Blank Pages...
	WinWaitActive, Insert Blank Pages
	easyCheck([5], "Insert Blank Pages")
	Control, ChooseString, Current Part or Score, ComboBox1, Insert Blank Pages
	easyReplaceText([1,2],[1,1], "Insert Blank Pages")
	Send, {Enter}
	WinWaitActive, Finale
	goToPageSize()
	WinWaitActive, Finale

	switchToInches()
	activateTextTool()
	makeSureThereIsSomethingInScoreInsert()
	MsgBox, The script will continue when you hit OK and click in a blank area.
	KeyWait, LButton, D
	KeyWait, LButton, U
	askAndAddInserts("titlePage","Part/Score Name","Times New Roman","Bold",18,1,1,1,2,1,leftPageMargin,-topPageMargin)
	askAndAddInserts("titlePage","Copyright Text","Times New Roman","Bold",18,1,3,1,2,1,-rightPageMargin,-topPageMargin)
	askAndAddInserts("titlePage","Title","Times New Roman","Bold",32,1,2,1,2,1,0,-1.5-topPageMargin)
	askAndAddInserts("titlePage","Subtitle","Times New Roman","Bold Italic",14,1,2,1,2,1,0,-2-topPageMargin)
	askAndAddInserts("titlePage","Composer","Times New Roman","Bold",12,1,2,1,2,1,0,-3.0-topPageMargin)
	Send, {Esc}
}

addTitlePage()
{
	activatePageLayoutTool()
	WinMenuSelectItem, Finale,,Page Layout, Insert Blank Pages...
	WinWaitActive, Insert Blank Pages
	easyCheck([5], "Insert Blank Pages")
	Control, ChooseString, Current Part or Score, ComboBox1, Insert Blank Pages
	easyReplaceText([1,2],[1,1], "Insert Blank Pages")
	Send, {Enter}
}

transpose()
{
	tryIt := runJWLuaScript("transpose.lua", "Quick Transpose")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		transposeOld()
	}
}

transposeOld()
{
	WinWaitActive, Finale
	InputBox,upOrDown,Easy Transpose,Am I going Up ("u") or Down ("d")?`n`n("pu" and "pd" is preserve up or preserve down),,230,180
	If ErrorLevel
		Goto, endTranspose
	InputBox,transposeString,Easy Transpose,How should the selected transpose?`n`nJust a number means a diatonic transposition.`n`nExamples of chromatic transposition:`n- maj6 is a Major 6th`n- min4 is a minor 4th`n- aug4 is an Augmented 4th`n- dim5 is a Diminished 5th`n- p5 is a Perfect Fifth,,290,270
	If ErrorLevel
		Goto, endTranspose

	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Transpose...
	if ErrorLevel
		MsgBox, You need to select something first.
	WinWaitActive, Transposition

	If (upOrDown = "u")
	{
		easyCheck([4],"Transposition")
		easyUncheck([8],"Transposition")
	}
	Else If (upOrDown = "pu")
	{
		easyCheck([4],"Transposition")
		easyCheck([8],"Transposition")
	}
	Else If (upOrDown = "d")
	{
		easyCheck([5],"Transposition")
		easyUncheck([8],"Transposition")
	}
	Else If (upOrDown = "pd")
	{
		easyCheck([5],"Transposition")
		easyCheck([8],"Transposition")
	}
	Else
		{
			WinClose, Transposition
			MsgBox, Not valid...
			Goto, endTranspose
		}

	StringLen, myStrLength, transposeString
	If (myStrLength = 1)
		{
			easyCheck([6],"Transposition")
			sleep 50
			if (transposeString = 2)
			    Control, ChooseString, Second, ComboBox1, Transposition
			else if (transposeString = 3)
			    Control, ChooseString, Third, ComboBox1, Transposition
			else if (transposeString = 4)
			    Control, ChooseString, Fourth, ComboBox1, Transposition
			else if (transposeString = 5)
			    Control, ChooseString, Fifth, ComboBox1, Transposition
			else if (transposeString = 6)
			    Control, ChooseString, Sixth, ComboBox1, Transposition
			else if (transposeString = 7)
			    Control, ChooseString, Seventh, ComboBox1, Transposition
			Else
			{
				MsgBox, Sorry, not a valid transposition.
				Goto, endTranspose
			}
		}
		Else
		{
			easyCheck([7],"Transposition")
			sleep 50
			if (transposeString = "aug1")
			    Control, ChooseString, Augmented Unison, ComboBox2, Transposition
			else if (transposeString = "dim2")
			    Control, ChooseString, Diminished Second, ComboBox2, Transposition
			else if (transposeString = "min2")
			    Control, ChooseString, Minor Second, ComboBox2, Transposition
			else if (transposeString = "maj2")
			    Control, ChooseString, Major Second, ComboBox2, Transposition
			else if (transposeString = "aug2")
			    Control, ChooseString, Augmented Second, ComboBox2, Transposition
			else if (transposeString = "dim3")
			    Control, ChooseString, Diminished Third, ComboBox2, Transposition
			else if (transposeString = "min3")
			    Control, ChooseString, Minor Third, ComboBox2, Transposition
			else if (transposeString = "maj3")
			    Control, ChooseString, Major Third, ComboBox2, Transposition
			else if (transposeString = "aug3")
			    Control, ChooseString, Augmented Third, ComboBox2, Transposition
			else if (transposeString = "dim4")
			    Control, ChooseString, Diminished Fourth, ComboBox2, Transposition
			else if (transposeString = "p4")
			    Control, ChooseString, Perfect Fourth, ComboBox2, Transposition
			else if (transposeString = "aug4")
			    Control, ChooseString, Augmented Fourth, ComboBox2, Transposition
			else if (transposeString = "dim5")
			    Control, ChooseString, Diminished Fifth, ComboBox2, Transposition
			else if (transposeString = "p5")
			    Control, ChooseString, Perfect Fifth, ComboBox2, Transposition
			else if (transposeString = "aug5")
			    Control, ChooseString, Augmented Fifth, ComboBox2, Transposition
			else if (transposeString = "dim6")
			    Control, ChooseString, Diminished Sixth, ComboBox2, Transposition
			else if (transposeString = "min6")
			    Control, ChooseString, Minor Sixth, ComboBox2, Transposition
			else if (transposeString = "maj6")
			    Control, ChooseString, Major Sixth, ComboBox2, Transposition
			else if (transposeString = "aug6")
			    Control, ChooseString, Augmented Sixth, ComboBox2, Transposition
			else if (transposeString = "dim7")
			    Control, ChooseString, Diminished Seventh, ComboBox2, Transposition
			else if (transposeString = "min7")
			    Control, ChooseString, Minor Seventh, ComboBox2, Transposition
			else if (transposeString = "maj7")
			    Control, ChooseString, Major Seventh, ComboBox2, Transposition
			else if (transposeString = "aug7")
				Control, ChooseString, Augmented Seventh, ComboBox2, Transposition
			else if (transposeString = "dim8")
			    Control, ChooseString, Diminished Octave, ComboBox2, Transposition
			Else
			{
				MsgBox, Sorry, not a valid transposition.
				Goto, endTranspose
			}
		}
		Send, {Enter}
	endTranspose:
}

runJWLuaScript(filename, pluginName)
{
	WinWaitActive, Finale,,.3
	if ErrorLevel
	{
		WinActivate, Finale
		WinWaitActive, Finale
	}
	WinMenuSelectItem, Finale,, Plug-ins, JW Lua, %filename%
	If ErrorLevel
	{
		WinMenuSelectItem, Finale,, Plug-ins, JW Lua, %pluginName%
		if ErrorLevel
		{
			WinMenuSelectItem, Finale,,Plug-ins,JW Lua,JW Lua...
			If ErrorLevel
				return 1
			WinWaitActive, JW Lua
			Control,TabRight,,SysTabControl321
			Control,TabRight,,SysTabControl321
			Control,TabRight,,SysTabControl321
			Control,TabRight,,SysTabControl321

			FileRead, luaText, includes\luaFunctions\%filename%
			if ErrorLevel
			{
				return 2
				MsgBox, Invalid Lua Script Location... (misspelling?)
				Exit
			}

			SciSetText(luaText, "Scintilla1", "JW Lua")
			ControlClick, Button25, JW Lua,,,, NA
			WinClose, JW Lua
			WinWaitActive, Save JW Lua Script?
			Send, !n

		}
	}
	
	WinWaitActive, Finale

	JWLuaErrorEnding:
	return 0
}

staffNamesRename()
{
	tryIt := runJWLuaScript("staff-names_rename.lua", "Staff Names - Rename")
	if (tryIt == 1)
	{
		MsgBox, The eqvuivilant macro doesn't exist outside of the lua one you obviously don't have.
	}
}

makeAllUpperCase()
{
	tryIt := runJWLuaScript("staff-names_make-all-uppercase.lua", "Staff Names - Make all uppercase")
	if (tryIt == 1)
	{
		MsgBox, Because you're not using JW Lua and my JW Lua scripts, this is going to take a lot longer...
		makeAllUpperCaseOld()
	}

}

makeAllUpperCaseOld()
{
	goToTextSearchAndReplace()
	sleep 300
	WinWaitActive, Text Search and Replace,All Open Documents,.5
	if ErrorLevel
	{
		ControlClick, Button6, Text Search and Replace,,,, NA
	}
	sleep 100
	easyUnCheck([22,1,3,18,19,20],"Text Search and Replace")
	easyUncheck([8,9,10,11,12,13,14,15,16,17],"Text Search and Replace")
	easyCheck([12],"Text Search and Replace")
	lowerCaseLetters:=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	upperCaseLetters:=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
	loop, % lowerCaseLetters.MaxIndex()
		{
			eachLowerCaseLetter:=lowerCaseLetters[A_Index]
			eachUpperCaseLetter:=upperCaseLetters[A_index]
			easyReplaceText([1,2],[eachLowerCaseLetter,eachUpperCaseLetter], "Text Search and Replace")
			ControlClick, Button5, Text Search and Replace,,,, NA
			WinWaitActive, Finale, OK
			Send, {Enter}
			WinWaitActive, Text Search and Replace,
		}
	WinClose, Text Search and Replace
}

increaseMeasureWidth()
{
	tryIt := runJWLuaScript("measure-width_increase.lua", "Measure Width - Increase")
	if (tryIt == 1)
	{
		MsgBox, You don't have JW Lua and/or my scripts so unfortunately, so this will revert to the old AHK macro.
		increaseMeasureWidthOld()
	}		
}

increaseMeasureWidthOld()
{
	switchToEVPUs()
	activateSelectionTool()
	Sleep, 50
	Send, {Enter}
	WinWaitActive, Measure Attributes
	easyReplaceText([5],["500p"],"Measure Attributes")
	Send, {Enter}
}

makeGroup()
{
	activateStaffTool()
	Sleep, 100
	WinMenuSelectItem, Finale,,Staff,Group and Bracket,Add...,
	WinWaitActive, Group Attributes
	Send, !a
}

deleteGroup()
{
	activateStaffTool()
	Sleep, 100
	Send, +{End}
	WinMenuSelectItem, Finale,,Staff,Group and Bracket,Remove
	Send, {Esc}
}

forceTimeSignaturesToAppear()
{
	goToGlobalStaffAttributes()
	easyUncheck([22],"Global Staff Attributes")
	Sleep, 50
	easyUncheck([22],"Global Staff Attributes")
	Sleep, 50
	easyCheck([22],"Global Staff Attributes")
	Sleep, 50
	Send, {Enter}
	sleep 100
	IfWinExist, Global Staff Attributes
		WinClose, Global Staff Attributes
	WinWaitActive, Finale
}

fit4MeasuresOnAllParts()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Utilities,Fit Measures...
	WinWaitActive, Fit Measures
	easyCheck([1,7],"Fit Measures")
	easyReplaceText([1],[4],"Fit Measures")
	Control, ChooseString, All Parts, ComboBox1, Fit Measures
	Send, {Enter}
	waitForCursorToGoFromHourGlassToArrow()
	WinWaitActive, Finale
	goToSpaceSystemsEvenly()
	Control, ChooseString,Current Part or Score,ComboBox1,Space Systems Evenly
	Send, {Enter}
	waitForCursorToGoFromHourGlassToArrow()
	WinWaitActive, Finale
}

deleteScoreSystemDividers()
{
	goToScoreSystemDivider()
	Send, !r
	WinWaitActive, Delete dividers?
	Send, !y
	WinWaitActive, Score System Divider
	WinWaitNotActive, Score System Divider
	Send, {Enter}
	Sleep, 100
	IfWinActive, Score System Divider
		Send, {Enter}									
}

makePartScore()
{
	Global
	Gui makePartScoreGUI: Add, Checkbox, Checked x16 y17 vButton11, update sizing template
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton1, show measure numbers
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton2, show rests in empty measures
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton3, make/show big time Sigs in parts
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton4, make instrument names uppercase
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton5, add info to parts
	; Gui makePartScoreGUI: Add, Checkbox, Checked vButton6, add title page template
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton7, renew parts
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton8, make multimeasure rests
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton9, fit four measures per system
	Gui makePartScoreGUI: Add, Checkbox, Checked vButton10, prep default look
	Gui makePartScoreGUI: Add, Button, gGoMakePartScore x10 y230 w60 h30, &Go
	Gui makePartScoreGUI: Add, Button, gCancelMakePartScore x140 y230 w60 h30, &Cancel
	Gui makePartScoreGUI: Add, Button, gAll x80 y225 w50 h20, &All
	Gui makePartScoreGUI: Add, Button, gNone x80 y245 w50 h20, &None
	Gui makePartScoreGUI: Show,h270 w210, Which Macros?
	Return 

	All:
	easyCheck([1,2,3,4,5,7,8,9,10,11],"Which Macros?")
	Return

	None:
	easyUncheck([1,2,3,4,5,7,8,9,10,11],"Which Macros?")
	Return

	GoMakePartScore: 
	Gui, Submit
	WinWaitActive, Finale

	; halter
	Gui stopAnyTime: +AlwaysOnTop
	Gui stopAnyTime: Add, Button, gHaltMakePartScore w79 h85, End
	GUI stopAnyTime: Show, h100 w100, End
	WinSet, Transparent, 200, End


	WinActivate, Finale
	if (Button11 = 1)
	{
		forceMyPrefs()
		deleteScoreSystemDividers()
	}
	if (Button1 = 1)
		showMeasureNumbers()
	if (Button2 = 1)
		showHideRestsInEmptyMeasures()
	if (Button3 = 1)
	{
		makeBigTimeSignaturesInParts()
		forceTimeSignaturesToAppear()
	}

	if (Button4 = 1)
		makeAllUpperCase()
	if (Button5 = 1)
		addInfoToParts()
	; if (Button6 = 1)
	; 	setTitlePageLayout()
	if (Button7 = 1)
	{
		goToManageParts()
		SplashTextOn, 400,80,,Re-Generate Parts here for best results.`nScript will continue will you click OK.
		Sleep, 1500
		SplashTextOff
	}
	if (Button8 = 1)
		makeMultimeasureRests()
	if (Button9 = 1)
		fit4MeasuresOnAllParts()
	if (Button10 = 1)
	{
		WinWaitActive, Finale
		WinMenuSelectItem, Finale,,Document,Edit Part,Last Viewed Part
		prepper("allParts",0,0,0)
	}


	Goto, CancelMakePartScore
	Return

	CancelMakePartScore:
	Gui makePartScoreGUI: Destroy
	Gui stopAnyTime: Destroy
	Return
	HaltMakePartScore:
	Gui makePartScoreGUI: Destroy
	Gui stopAnyTime: Destroy
	Reload
	Return
}

explodeWithJW()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Plug-ins,JW Staff Polyphony...
	If ErrorLevel
	{
		WinMenuSelectItem, Finale,,Plug-ins,JWTools,JW Staff Polyphony...
		If ErrorLevel
		{
			MsgBox, Couldn't find the menu item "JW Staff Polyphony."  Place it directly in Plug-ins or a folder called "JWTools"
			Goto, JWExplodeEnding
		}

	}
	WinWaitActive, JW Staff Polyphony
	Send, {Left 2}{Up}{Left 2}{Up}{Left 2}{Up}{Left 2}{Down}{Right}{Down 2}
	Sleep, 100
	easyCheck([1,4],"JW Staff Polyphony")
	Control, Choose, 1, ComboBox1, JW Staff Polyphony
	Control, Choose, 1, ComboBox2, JW Staff Polyphony
	Control, Choose, 1, ComboBox3, JW Staff Polyphony
	Send, {Enter}
	Sleep, 50
	While WinActive("Overwrite Existing Music?")
		sleep, 20
	WinClose, JW Staff Polyphony
	JWExplodeEnding:
}

explodeWithTG()
{
	WinMenuSelectItem, Finale,,TGTools,Parts,Smart NNOOOOONOExplosion of multi-part staves...
	If ErrorLevel
	{
		explodeWithJW()
		Return
	}
	WinWaitActive, Smart Explosion
	Send, {Enter}
	WinWaitActive, Finale

	Loop
	{
		IfWinExist,,Collapse when inactive
		{
			Sleep, 20
			Continue
		}
		Break
	}
	
	MsgBox, we're there
	activateArticulationTool()
	activateSelectionTool()

}

implodeToTopStaffOfSelection()
{
	WinWaitActive, Finale
	WinMenuSelectItem, Finale,,Utilities,Implode Music...
	WinWaitActive, Implode Music
	easyCheck([6],"Implode Music")
	Send, {Enter}
}

spaceSystemsEvenlyWithoutChanging()
{
	goToSpaceSystemsEvenly()
	Control, ChooseString, Cuurent Part or Score, ComboBox1, Expression Designer
	easyReplaceText([4],[30],"Space Systems Evenly")
	easyCheck([7,12], "Space Systems Evenly")
	Send, {Enter}
	activateStaffTool()
}

;make a transparent gui that says you can use these keys ed or rf  then shift for finer gradiations
adjustMMR()
{
	switchToSpaces()
	SetTimer, check, 50
	MsgBox,4096,MMR Width, Here are a list of hotkeys for this macro:`nPress "e" to make the MMR wider.`nPress "d" to make the MMR narrower.`nHolding down Shift makes much smaller changes.`n`n`nDeactivate this by clicking OK or hitting CAPS.

	Check:
	If WinExist("MMR Width") 
	{
		WinSet, Transparent, 200, MMR Width
		WinGetPos, Xpos, Ypos,,,MMR Width
		WinMove, MMR Width,,Xpos,Ypos-200
		SetTimer, check, Off
		WinActivate, Finale
	}
	Return
}

changeMMRWidth(amount)
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Edit,Multimeasure Rests,Edit...
	WinWaitActive, Multimeasure Rest,,.3
	If ErrorLevel
	{
		MsgBox, You have to select a Multimeasure Rest first.
		WinActivate, Finale
		Return
	}
	ControlGetText,currentMeasureWidth,Edit7,Multimeasure Rest
	newAmount := amount+currentMeasureWidth
	ControlSetText, Edit7, %newAmount%,Multimeasure Rest
	Send, {Enter}
	Return
}

;anything else that needs to be done at the end of the score? save as part score put in page breaks
scoreFinisher()
{
	checkTiesAccidentalsDurations()
	insertScoreSystemDividers()
}

goToScoreSystemDivider()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Plug-ins, Scoring and Arranging, Score System Divider...
	WinWaitActive, Score System Divider
}

insertScoreSystemDividers()
{
	goToScoreSystemDivider()
	easyCheck([2,6,9],"Score System Divider")
	Send, {Enter}
}

finishingTouchesAndChecksOnScore()
{
	checkTiesAccidentalsDurations()
	While, WinExist("Check Region for Durations")
			sleep 50
	checkJWCautionaryAccidentals()
	insertScoreSystemDividers()
	IfWinExist, JW Accidentals
		WinClose, JW Accidentals
}

printDraftOnLetter()
{
	CoordMode, Mouse, Screen
	MouseGetPos, currentX, currentY
	CoordMode, Mouse, Relative
	goToPrint()
	Send, !c!a
	easyCheck([20,21],"Print")
	Send, !s
	WinWaitActive, Print Setup
	Control, ChooseString, HP LaserJet 5200 UPD PCL 6, ComboBox1, Print Setup
	Send, !p
	WinWaitNotActive, Print Setup
	WinActivate, Finale
	WinWaitActive, HP LaserJet 5200 UPD PCL 6 Document Properties,,.3
	if ErrorLevel
		winactivate, HP LaserJet 5200 UPD PCL 6 Document Properties
	Sleep, 100
	MouseClick,left,120,211,,%clickSpeed%
	sleep 100
	Send, {Enter}
	WinWaitNotActive, HP LaserJet 5200 UPD PCL 6 Document Properties
	WinActivate, Finale
	WinWaitActive, Print Setup,,.3
	if ErrorLevel
		WinActivate, Print Setup
	Send, {Enter}
	WinWaitActive, Print
	Send, {Enter}


	CoordMode, Mouse, Screen
	MouseMove, currentX, currentY
	CoordMode, Mouse, Relative

}

goToSpaceSystems()
{
	WinWaitActive, Finale
	WinMenuSelectItem,Finale,,Plug-ins, Scoring and Arranging, Space Systems...
	if ErrorLevel
	{
		MsgBox, Couldn't find the plug-in "Space Systems" in Scoring and Arranging.
		Reload
	}
	WinWaitActive, Space Systems
}

spaceSystemsWithAdditionalGaps()
{
	goToSpaceSystems()
	easyCheck([3],"Space Systems")
	easyUncheck([9,10],"Space Systems")
	easyReplaceText([3,4],[0,0],"Space Systems")
	easyChooseString([1,2,4],["Current Part or Score","Center","Space with additional gaps"],"Space Systems")
	Send, {Enter}
	While, WinExist("Space Systems")
		WinClose, Space Systems
	WinWaitActive, Finale
}

flipAccidentalsEnharmonically()
{
	tryIt := runJWLuaScript("flip-accidentals-enharmonically.lua", "Flip Accidentals Enharmonically")
	if (tryIt == 1)
	{
		MsgBox, You don't have JW Lua and/or my scripts so unfortunately, this won't work and there is no AHK alternative...
	}	
}

; This part creates each button for each menu/tab.

global defaultTextButtonSize:="w100 h90"
global defaultPictureButtonSize:=""
Gui, Tab, 1
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transpose
Gui, Add, Picture, x106 y37 %defaultPictureButtonSize% gButton102, icons\expressionTool.png
Gui, Add, Picture, x206 y37 %defaultPictureButtonSize% gButton103 , icons\speedyNoteEntry.png
Gui, Add, Picture, x306 y37 %defaultPictureButtonSize% gButton104 , icons\selectionTool.png
Gui, Add, Picture, x406 y37 %defaultPictureButtonSize% gButton105 , icons\timeSignatureTool.png
Gui, Add, Picture, x6 y127 %defaultPictureButtonSize% gButton106 , icons\articulationTool.png
Gui, Add, Picture, x106 y127 %defaultPictureButtonSize% gButton107 , icons\slur.png
Gui, Add, Picture, x206 y127 %defaultPictureButtonSize% gButton108 , icons\decrescendo.png
Gui, Add, Picture, x306 y127 %defaultPictureButtonSize% gButton109 , icons\staffTool.png
Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton110 , Show / Hide Grid
Gui, Add, Picture, x6 y217 %defaultPictureButtonSize% gButton111 , icons\cleffTool.png
Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton112 , Toggle Concert Pitch
Gui, Add, Picture, x206 y217 %defaultPictureButtonSize% gButton113 , icons\crescendo.png
Gui, Add, Picture, x306 y217 %defaultPictureButtonSize% gButton114 , icons\chordTool.png
Gui, Add, Picture, x406 y217 %defaultPictureButtonSize% gButton115 , icons\pageLayoutTool.png

Gui, Tab, 2
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton201, Favor Flats
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton202, Favor Sharps
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton203 , Default Spelling
Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton204 , Use Spelling Tables
Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton205 , Hidden Text Above the Staff
Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton206 , Change Selected To Flats
Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton207 , Change Selected To Sharps
Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton208 , Note Lengths Doubled
Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton209 , Note Lengths Halved
Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton210 , Bold Text Above the Staff
Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton211 , Change selected to Layer 1
Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton212 , Change selected to Layer 2
Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton213 , Pastes to Selected the Dynamics of Copied Material
Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton214 , Add Tempo Marking
Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton215 , Italic Text Below the Staff

Gui, Tab, 3
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton301 , -Score-`nAdd Info to Score
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton302 , -Score-`nPrep Score
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton303 , Put finishing touches and checks on score
Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton304 , -Score-`nGlobal Staff Attributes
Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton305 , -Score-`nShow/Hide rests in empty measures (selected staves)
Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton306 , -Score-`nLA-type Measure Numbers
Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton307 , -Score-`nConventional Measure Numbers
Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton308 , -Score Only-`nShow/Hide Measure Numbers (selected staves)
Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton309 , Print 11 x 17
; Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton310 , oooooooooooo
Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton311 , -Score-`nMake Big Time Signatures
Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton312 , -Score-`nMake Regular Time Signatures
Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton313 , Flip Accidentals Enharmonically
; Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton314 , oooooooooooo
; Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton315 , oooooooooooo

Gui, Tab, 4 
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton401 , -Parts-`nMake Part Score
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton402 , -Parts-`nPrep Part
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton403 , -Parts-`nAdd Title Page
Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton404 ,-Parts-`nDrop System Margins
Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton405 , Space systems with additional gaps
; Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton406 , oooooooooooo
; Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton407 , oooooooooooo
; Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton408 , oooooooooooo
Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton409 , Print 8.5 x 11
Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton410 , Print 9 x 12
Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton411 , -Parts-`nMake Big Time Signatures
Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton412 , -Parts-`nMake Regular Time Signatures
Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton413 , Adjust MultiMeasure Rest Width
; Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton414 , oooooooooooo
; Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton415 , oooooooooooo

Gui, Tab, 5 
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton501 , Change Selected to X-Shaped Noteheads
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton502 , Add Octave
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton503 , -Score Only-`nCanonic Utilities
Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton504 , Single Out Voice
Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton505 , Vertical Collision Remover
; Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton506 , oooooooooooo
Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton507 , Increase Measure Width
Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton508 , Explode selected downward (must have TGTool full or JW Staff Polyphony)
Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton509 , Implode selected to the Top Staff of Selection
Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton510 , Fix Score Beta
Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton511 , Make Group
Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton512 , Delete Group
; Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton513 , oooooooooooo
; Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton514 , oooooooooooo
; Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton515 , oooooooooooo

Gui, Tab, 6 
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton601 , Resize Page, System, and Staff in all parts
Gui, Add, Button, x106 y37 %defaultTextButtonSize% gButton602 , Make Instruments Uppercase
Gui, Add, Button, x206 y37 %defaultTextButtonSize% gButton603 , Add Info to Parts
Gui, Add, Button, x306 y37 %defaultTextButtonSize% gButton604 , Set Title Page Layout
; Gui, Add, Button, x406 y37 %defaultTextButtonSize% gButton605 , oooooooooooo
; Gui, Add, Button, x6 y127 %defaultTextButtonSize% gButton606 , oooooooooooo
; Gui, Add, Button, x106 y127 %defaultTextButtonSize% gButton607 , oooooooooooo
; ; Gui, Add, Button, x206 y127 %defaultTextButtonSize% gButton608 , oooooooooooo
; ; Gui, Add, Button, x306 y127 %defaultTextButtonSize% gButton609 , oooooooooooo
; Gui, Add, Button, x406 y127 %defaultTextButtonSize% gButton610 , oooooooooooo
; Gui, Add, Button, x6 y217 %defaultTextButtonSize% gButton611 , oooooooooooo
; Gui, Add, Button, x106 y217 %defaultTextButtonSize% gButton612 , oooooooooooo
; ; Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton613 , oooooooooooo
; Gui, Add, Button, x306 y217 %defaultTextButtonSize% gButton614 , oooooooooooo
Gui, Add, Button, x406 y217 %defaultTextButtonSize% gButton615 , Print 8.5x11 draft on 5200 for proofing

;------------------------SETTINGS------------------------

Gui, Tab, 10
Gui, Add, Text,, Margins (in Inches)
Gui, Add, Text,, Top
Gui, Add, Text,, Left
Gui, Add, Text,, Right
Gui, Add, Text,, Bottom
Gui, Add, Text,, 
Gui, Add, Text,, Speed of automation (fast to slow)
Gui, Add, Slider, vKeyDelay Range10-100, %optimalKeyDelay%


Gui, Add, Edit, x50 y50 vtopPmargin w30 r1,%topPageMargin%
Gui, Add, Edit, vleftPmargin w30 r1,%leftPageMargin%
Gui, Add, Edit, vrightPmargin w30 r1,%rightPageMargin%
Gui, Add, Edit, vbottomPmargin w30 r1,%bottomPageMargin%
Gui, Add, Text, x85 y54,in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.

Gui, Add, Text,x110 y28, Staff Scalings for Parts
Gui, Add, Text,, Page Scaling
Gui, Add, Text,, System Scaling
Gui, Add, Text,, Staff Height

Gui, Add, Edit, x190 y50 vpageScaling w30 r1,%pageScalingPercent%
Gui, Add, Edit, vsystemScaling w30 r1,%systemScalingPercent%
Gui, Add, Edit, vstaffHeight w30 r1,%staffHeight%

Gui, Add, Text,x225 y54, `%
Gui, Add, Text,, `%
; Gui, Add, Text,,

Gui, Add, Text,x250 y28, Page Sizes
Gui, Add, Text,, Part Width
Gui, Add, Text,, Part Height
Gui, Add, Text,, Score Width
Gui, Add, Text,, Score Height

Gui, Add, Edit, x325 y50 vppw w30 r1,%partPageWidth%
Gui, Add, Edit, vpph w30 r1,%partPageHeight%
Gui, Add, Edit, vspw w30 r1,%scorePageWidth%
Gui, Add, Edit, vsph w30 r1,%scorePageHeight%

Gui, Add, Text, x360 y54, in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.

Gui, Add, Text,x390 y28, Additional Top Offsets
Gui, Add, Text,, Part Page 1
Gui, Add, Text,, Part Page 2+
Gui, Add, Text,, Score Page 1
Gui, Add, Text,, Score Page 2+

Gui, Add, Edit, x470 y50 vpartp1offset w30 r1,%partTopFirstPageMarginExtension%
Gui, Add, Edit, vpartp2onoffset w30 r1,%scoreTopFirstPageMarginExtension%
Gui, Add, Edit, vscorep1offset w30 r1,%partPage2OnPageMarginExtension%
Gui, Add, Edit, vscorep2onoffset w30 r1,%scorePage2OnPageMarginExtension%

Gui, Add, Text, x502 y54, in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.
Gui, Add, Text,, in.

; Gui, Add, DropDownList, vdropdownlist Choose%dropdownlist%, 1|2|3|4|5
; Gui, Add, Checkbox, vcheckbox Checked%checkbox%, checkbox
; Gui, Add, Radio, vradio1 Checked%radio1%, radio1
; Gui, Add, Radio, vradio2 Checked%radio2%, radio2
; Gui, Add, Text,, Current tab is : %test%
Gui, Add, Button, x55 y280 gSave, Save
Gui, Add, Button, x400 y280 gRestoreDefaults, Restore Defaults

; these add additional functionality, feel free to comment this out
; faster alt-tabbing between only Finale and Transcribe!
#If (WinActive("Finale") or WinActive("Finale Hotkey Interface") or WinActive("Transcribe!"))
{
	`::
	IfWinActive, Finale
	{	
		IfWinExist, Transcribe!
			WinActivate, Transcribe!
	}
	Else
	IfWinActive, Transcribe!
	{
		IfWinExist, Finale
			WinActivate, Finale
	}
	return
}
#If

; better navigation in scroll view
#If (WinActive("Finale"))
; long distance
F4::^PgDn
F1::^PgUp

; 1-measure at a time
F3::Send, !u{Up}{Enter}
F2::Send, !u{Down}{Enter}
#If

; align/move dynamics
#If (WinActive("Finale"))
F5::!NumpadSub
F6::!NumpadAdd
#If


; changing and adding settings

Save:
	Gui, Submit, NoHide
	IniWrite, %topPmargin%, settings.ini, margins, Top
	IniWrite, %leftPmargin%, settings.ini, margins, Left
	IniWrite, %rightPmargin%, settings.ini, margins, Right
	IniWrite, %bottomPmargin%, settings.ini, margins, Bottom
	IniWrite, %KeyDelay%, settings.ini, pace, keyDelay
	IniWrite, %pageScaling%, settings.ini, scalings, pagePercent
	IniWrite, %systemScaling%, settings.ini, scalings, systemPercent
	IniWrite, %staffHeight%, settings.ini, scalings, staffHeight
	IniWrite, %ppw%, settings.ini, pagesizes, ppageWidth
	IniWrite, %pph%, settings.ini, pagesizes, ppageHeight
	IniWrite, %spw%, settings.ini, pagesizes, spageWidth
	IniWrite, %sph%, settings.ini, pagesizes, spageHeight
	IniWrite, %partp1offset%, settings.ini, additionaloffset, partp1offset
	IniWrite, %partp2onoffset%, settings.ini, additionaloffset, partp2onoffset
	IniWrite, %scorep1offset%, settings.ini, additionaloffset, scorep1offset
	IniWrite, %scorep2onoffset%, settings.ini, additionaloffset, scorep2onoffset


	changesSaved()
Return

RestoreDefaults:
	gosub, createSettingsINIFile
	changesSaved()
Return
;------------------------/////////------------------------


; These are instructions for what to do when each hotkey is pressed.
Button101:
	goToFinale()
	transpose()
return

Button102:
    goToFinale()
	activateExpressionTool()
return

Button103:
	goToFinale()
	activateSpeedyNoteEntry()
return

Button104:
	goToFinale()
	activateSelectionTool()
return

Button105:
    goToFinale()
	activateTimeSignatureTool()
return

Button106:
	goToFinale()
	activateArticulationTool()
return

Button107:
	goToFinale()
	activateSlur()
return

Button108:
    goToFinale()
	activateDecrescendo()
return

Button109:
	goToFinale()
	activateStaffTool()
return

Button110:
	goToFinale()
	showHideGrid()
return

Button111:
    goToFinale()
    activateClefTool()
return

Button112:
	goToFinale()
	toggleConcertPitch()
return

Button113:
	goToFinale()
	activateCrescendo()
return

Button114:
    goToFinale()
	activateChordTool()
return

Button115:
	goToFinale()
	activatePageLayoutTool()
return





Button201:
	goToFinale()
	switchtoFavorFlats()
return

Button202:
    goToFinale()
    switchToFavorSharps()
return

Button203:
	goToFinale()
	switchToDefaultSpelling()
return

Button204:
	goToFinale()
	switchToUseSpellingTables()
return

Button205:
    goToFinale()
	addHiddenTextAboveTheStaff()
return

Button206:
	goToFinale()
	retranscribeToFavorFlats()
return

Button207:
	goToFinale()
	retranscribeToFavorSharps()
return

Button208:
    goToFinale()
	doubleNoteLengths()
return

Button209:
	goToFinale()
	halveNoteLengths()
return

Button210:
	goToFinale()
	addBoldTextAboveTheStaff()
return

Button211:
    goToFinale()
	switchToLayer1()
return

Button212:
	goToFinale()
	switchToLayer2()
return

Button213:
	goToFinale()
	pasteDynamicsOnly()
return

Button214:
    goToFinale()
    addTempoMarking()
return

Button215:
	goToFinale()
	addItalicTextBelowTheStaff()
return




Button301:
	goToFinale()
	addInfoToScore()
return

Button302:
    goToFinale()
	prepScore()
return

Button303:
	goToFinale()
	finishingTouchesAndChecksOnScore()
return

Button304:
	goToFinale()
	goToGlobalStaffAttributes()
return

Button305:
    goToFinale()
	showHideRestsInEmptyMeasures()
return

Button306:
	goToFinale()
	makeHollywoodMeasureNumbers()
return

Button307:
	goToFinale()
	makeConventionalMeasureNumbers()
return

Button308:
    goToFinale()
	showHideMeasureNumbers()
return

Button309:
	goToFinale()
	printTabloid()
return

Button310:
	goToFinale()
	
return

Button311:
    goToFinale()
	makeBigTimeSignatures()
return

Button312:
	goToFinale()
	makeNormalTimeSignatures()
return

Button313:
	goToFinale()
	flipAccidentalsEnharmonically()
return

Button314:
    goToFinale()

return

Button315:
	goToFinale()
	
return





Button401:
	goToFinale()
	makePartScore()
return

Button402:
    goToFinale()
	prepPart()
return

Button403:
	goToFinale()
	addTitlePage()
return

Button404:
	goToFinale()
	dropSystemMargins()
return

Button405:
    goToFinale()
    spaceSystemsWithAdditionalGaps()
return

Button406:
	goToFinale()
	
return

Button407:
	goToFinale()
	
return

Button408:
    goToFinale()
	
return

Button409:
	goToFinale()
	printLetter()
return

Button410:
	goToFinale()
	printConcert()
return

Button411:
    goToFinale()
	makeBigTimeSignaturesInParts()
return

Button412:
	goToFinale()
	makeNormalTimeSignaturesInParts()
return

Button413:
	goToFinale()
	adjustMMR()
return

Button414:
    goToFinale()
	
return

Button415:
	goToFinale()
	
return



Button501:
	goToFinale()
	changeToXShapedNoteheads()
return

Button502:
    goToFinale()
	addOctave()
return

Button503:
	goToFinale()
	openCanonicUtilities()
return

Button504:
	goToFinale()
	singleOutVoice()
return

Button505:
    goToFinale()
    goToVerticalCollisionRemover()
return

Button506:
	goToFinale()
	grabRestOfMeasures()
return

Button507:
	goToFinale()
	increaseMeasureWidth()`
return

Button508:
    goToFinale()
	explodeWithTG()
return

Button509:
	goToFinale()
	implodeToTopStaffOfSelection()
return

Button510:
	goToFinale()
	fixScoreSpacingBeta()
return

Button511:
    goToFinale()
	makeGroup()
return

Button512:
	goToFinale()
	deleteGroup()
return

Button513:
	goToFinale()
	
return

Button514:
    goToFinale()
	
return

Button515:
	goToFinale()
	
return



Button601:
	goToFinale()
	resizePageSystemStaffAllParts()
return

Button602:
    goToFinale()
    makeAllUpperCase()
return

Button603:
	goToFinale()
	addInfoToParts()
return

Button604:
	goToFinale()
	setTitlePageLayout()
return

Button605:
    goToFinale()
    
return

Button606:
	goToFinale()

return

Button607:
	goToFinale()

return

Button608:
    goToFinale()
	
return

Button609:
	goToFinale()
	
return

Button610:
	goToFinale()
return

Button611:
    goToFinale()

return

Button612:
	goToFinale()

return

Button613:
	goToFinale()
	
return

Button614:
    goToFinale()

return

Button615:
	goToFinale()
	printDraftOnLetter()
return



#if ((WinActive("Finale") or WinActive("Finale Hotkey Interface")) and !WinExist("MMR Width")) ;---------------------------------------
	; This part assigns the key that makes the interface appear and disappear.
	CapsLock::
	IfWinExist, Finale Hotkey Interface
	{
		Gui, Cancel
		WinActivate, Finale
		Return
	}
	Else
	{
		Gui, Show, x326 y205 h315 w514, Finale Hotkey Interface
		 
		GuiControl, Choose, TabGroup, 1
		Return
	}
	Return
#If ;-------------------------------------------------------------------


#if (WinExist("MMR Width") and WinActive("Finale")) ;------------------
	e::
	changeMMRWidth(10)
	Return
	d::
	changeMMRWidth(-10)
	Return
	+e::
	changeMMRWidth(2)
	Return
	+d::
	changeMMRWidth(-2)
	Return
	CapsLock::
	WinClose, MMR Width
	Return
#If ;-------------------------------------------------------------------




; If the interface isn't the active window, none of the keys on the grid will affect anything.
GuiControlGet,Current_Tab,,TabGroup
#if (WinActive("Finale Hotkey Interface") && (Current_Tab() != 10)) ;-------------------------------
	{
	; This assigns hotkeys 1-9 to the menus/tabs.
	1::GuiControl, Choose, TabGroup, 1
	2::GuiControl, Choose, TabGroup, 2
	3::GuiControl, Choose, TabGroup, 3
	4::GuiControl, Choose, TabGroup, 4
	5::GuiControl, Choose, TabGroup, 5
	6::GuiControl, Choose, TabGroup, 6
	7::GuiControl, Choose, TabGroup, 7
	8::GuiControl, Choose, TabGroup, 8
	9::GuiControl, Choose, TabGroup, 9

	0::GUIControl, Choose, TabGroup, 10

	; This dynamically changes the button label based on which tab is open.  Basically, it makes
	; it possible to use any given hotkey on the grid MULTIPLE TIMES depending on which menu/tab
	; is selected.

	q::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%01
	return
	w::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%02
	return
	e::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%03
	return
	r::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%04
	return
	t::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%05
	return
	a::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%06
	return
	s::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%07
	return
	d::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%08
	return
	f::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%09
	return
	g::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%10
	return
	z::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%11
	return
	x::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%12
	return
	c::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%13
	return
	v::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%14
	return
	b::
	GuiControlGet, TabGroup
	Gosub, Button%TabGroup%15
	return


}
#If ;-------------------------------------------------------------------



GuiClose:
ExitApp

createSettingsINIFile:
FileDelete, settings.ini
ConfigData=
(
[margins]
Top=0.3
Left=0.5
Right=0.5
Bottom=0.5

[scalings]
pagePercent=100
systemPercent=100
staffHeight=96e

[pagesizes]
ppageWidth=9
ppageHeight=12
spageWidth=11
spageHeight=17

[additionaloffset]
partp1offset=2.45
partp2onoffset=0.9
scorep1offset=1.4
scorep2onoffset=1.2

[pace]
keyDelay=10
)
FileAppend, %ConfigData%, settings.ini
return