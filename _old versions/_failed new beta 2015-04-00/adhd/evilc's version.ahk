; Welcome to GRID Hotkey Interface v0.11.  I made this in an attempt to redesign hotkeys for Finale so
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
 
#SingleInstance force
; ==============================
 
ADHD := New ADHDLib
 
ADHD.run_as_admin()
 
ADHD.config_about({name: "Test", version: 1.0, author: "nobody", link: "<a href=""http://google.com"">Somewhere</a>"})
ADHD.config_size(600,500)
ADHD.config_tabs(Array("Menu 1", "Menu 2", "Menu 3"))

ADHD.config_event("option_changed", "option_changed_hook")
ADHD.config_event("on_exit", "on_exit_hook")

;ADHD.config_ignore_noaction_warning()
ADHD.config_hotkey_add({uiname: "ExpressionTool", subroutine: "Button102"})

ADHD.init()
ADHD.create_gui()
ADHD.gui_add("CheckBox", "MyCheckBox", "x5 y350 W120", "test", 0)
 
ADHD.finish_startup()

; ==============================
; How fast AHK does Send commands, basically.
SetKeyDelay, 20
 
; Makes sure that CAPS doesn't get stuck on
SetCapsLockState, AlwaysOff

; Add custom tabs
; This creates the menus/tabs that each contain 15 buttons.
;Gui, Add, Tab2,x-4 y-3 w520 h330 vTabGroup AltSubmit, Menu 1|Menu 2|Menu 3|Menu 4|Menu 5|Menu 6|Menu 7|Menu 8|Menu 9

; This part creates each button for each menu/tab.
Gui, Tab, 1
Gui, Add, Button, x6 y37 w100 h90 gButton101, Export to PDF
Gui, Add, Button, x106 y37 w100 h90 gButton102, Expression Tool
Gui, Add, Button, x206 y37 w100 h90 gButton103 , Speedy Note Entry
Gui, Add, Button, x306 y37 w100 h90 gButton104 , Selection Tool
Gui, Add, Button, x406 y37 w100 h90 gButton105 , Time Signature Tool
Gui, Add, Button, x6 y127 w100 h90 gButton106 , Articulation Tool
Gui, Add, Button, x106 y127 w100 h90 gButton107 , Slur
Gui, Add, Button, x206 y127 w100 h90 gButton108 , Decrescendo
Gui, Add, Button, x306 y127 w100 h90 gButton109 , Staff Tool
Gui, Add, Button, x406 y127 w100 h90 gButton110 , Page Layout
Gui, Add, Button, x6 y217 w100 h90 gButton111 , Canonic Utilities
Gui, Add, Button, x106 y217 w100 h90 gButton112 , Toggle Concert Pitch
Gui, Add, Button, x206 y217 w100 h90 gButton113 , Crescendo
Gui, Add, Button, x306 y217 w100 h90 gButton114 , Simple Entry
Gui, Add, Button, x406 y217 w100 h90 gButton115 , Show / Hide Grid
 
Gui, Tab, 2
Gui, Add, Button, x6 y37 w100 h90 gButton201, Default Spelling
Gui, Add, Button, x106 y37 w100 h90 gButton202, Use Spelling Tables
Gui, Add, Button, x206 y37 w100 h90 gButton203 , Favor Flats
Gui, Add, Button, x306 y37 w100 h90 gButton204 , Favor Sharps
Gui, Add, Button, x406 y37 w100 h90 gButton205 , Chord Tool
Gui, Add, Button, x6 y127 w100 h90 gButton206 , Change selected to Layer 1
Gui, Add, Button, x106 y127 w100 h90 gButton207 , Change selected to Layer 2
Gui, Add, Button, x206 y127 w100 h90 gButton208 , Note Lengths Doubled
Gui, Add, Button, x306 y127 w100 h90 gButton209 , Note Lengths Halved
Gui, Add, Button, x406 y127 w100 h90 gButton210 , Pastes to Selected the Dynamics of Copied Material
Gui, Add, Button, x6 y217 w100 h90 gButton211 , Clef Tool
; Gui, Add, Button, x106 y217 w100 h90 gButton212 , oooooooooooo
; Gui, Add, Button, x206 y217 w100 h90 gButton213 , oooooooooooo
; Gui, Add, Button, x306 y217 w100 h90 gButton214 , oooooooooooo
; Gui, Add, Button, x406 y217 w100 h90 gButton215 , oooooooooooo
 
Gui, Tab, 3
Gui, Add, Button, x6 y37 w100 h90 gButton301, Make Big Time Signatures
Gui, Add, Button, x106 y37 w100 h90 gButton302, Make Regular Time Signatures
; Gui, Add, Button, x206 y37 w100 h90 gButton303 , oooooooooooo
Gui, Add, Button, x306 y37 w100 h90 gButton304 , Global Staff Attributes
Gui, Add, Button, x406 y37 w100 h90 gButton305 , Show/Hide rests in empty measures (selected staves)
Gui, Add, Button, x6 y127 w100 h90 gButton306 , LA-type Measure Numbers
Gui, Add, Button, x106 y127 w100 h90 gButton307 , Conventional Measure Numbers
Gui, Add, Button, x206 y127 w100 h90 gButton308 , Show/Hide Measure Numbers (selected staves)
; Gui, Add, Button, x306 y127 w100 h90 gButton309 , oooooooooooo
; Gui, Add, Button, x406 y127 w100 h90 gButton310 , oooooooooooo
; Gui, Add, Button, x6 y217 w100 h90 gButton311 , oooooooooooo
; Gui, Add, Button, x106 y217 w100 h90 gButton312 , oooooooooooo
; Gui, Add, Button, x206 y217 w100 h90 gButton313 , oooooooooooo
; Gui, Add, Button, x306 y217 w100 h90 gButton314 , oooooooooooo
; Gui, Add, Button, x406 y217 w100 h90 gButton315 , oooooooooooo

return

; includes my customized macros for AHK... Things that let me write code better (better check/uncheck checkboxes)
; My custom Toggle Checkbox function...
customToggle(classNN, windowsTitle)
{
	ControlGet, isOrIsntChecked, Checked,, %classNN%, %windowTitle%
	if (isOrIsntChecked = 0){
		Control Check,, %classNN%
	} else {
		Control Uncheck,, %classNN%
	}
}
 
; My custom Check / Uncheck function...
easyCheck(buttonsNumbersToCheck, winTitle)
{
	for k, v in buttonsNumbersToCheck
	{
		Control, Check,, Button%v%, %winTitle%
	}
}
 
easyUncheck(buttonsNumbersToUncheck, winTitle)
{
	for k, v in buttonsNumbersToUncheck
	{
		Control, Uncheck,, Button%v%, %winTitle%
	}
}
 
; includes all of the functions for each Finale Macro.
; This function is a list of instructions for what to do when a button on the grid is pressed.
; Once a button is pressed, it basically takes away the interface and makes Finale the active window.
 
; helper functions
changeTimeSigInDocOptions(font, type, size, top, bottom)
{
	i := 0
	while (i < 90) and !(WinActive("Document Options - Fonts"))
	{
		Send ^{tab}
		i++
		sleep, 6
	}
	ifWinActive, Document Options - Fonts
	{
		ControlFocus, ComboBox3
		Send ntt
		send !n
		ControlFocus, Edit1
		Send {del 20}%font%{tab}%type%{tab}%size%
		ControlFocus, Button6
		Send {enter}
	}
	else
	MsgBox, Couldn't find time signatures
 
	i := 0
	while (i < 90) and !(WinActive("Document Options - Time Signatures"))
	{
		Send ^{tab}
		i++
		sleep, 6
	}
	ifWinActive, Document Options - Time Signatures
	{
		ControlFocus, ComboBox38
		Send e
		ControlFocus, Edit7
		Send {del 6}%top%
		ControlFocus, Edit9
		Send {del 6}%bottom%
	}
	else
	{
		MsgBox, Couldn't find time signatures
	}
	ControlFocus, Button160
	Send {enter}
	Sleep, 100
}
 
 
openGlobalStaffAttributes()
{
	Send !i{up 2}{right}{down 9}{enter}
}
 
switchToEVPUs()
{
	Send !ene	
}
 
; BELOW ARE THE FUNCTIONS THEMSELVES FOR EACH INDIVIDUAL MACRO
; ---------------------------------------------------------------------------------------------------------------

exportToPDF()
{
	Send !ftp
}
 
activateExpressionTool()
{
	Send !te
}
 
activateSpeedyNoteEntry()
{
	Send !ts
}
 
activateSelectionTool()
{
	Send !tt
}
 
activateTimeSignatureTool()
{
	Send !tg
}
 
activateMeasureTool()
{
	Send !tm
}
 
activateArticulationTool()
{
	Send !ta
}
 
activateSlur()
{
	Send !ths
}
 
activateDecrescendo()
{
	Send !thr
}
 
activateCrescendo()
{
	Send !thc
}
 
showHideGrid()
{
	Send !vgg
}
 
activateSimpleEntry()
{
	Send !tib
}
 
toggleConcertPitch()
{
	Send !d{Left}i
}
 
openCanonicUtilities()
{
	Send !i{Up}{Up}{Right}{Down 3}{Enter}
}
 
activatePageLayoutTool()
{
	Send !tp
}
 
activateStaffTool()
{
	Send !tf
}
 
switchToDefaultSpelling()
{
	Send !ehd
}
 
switchToUseSpellingTables()
{
	Send !eht
}
 
switchtoFavorFlats()
{
	Send !ehf
}
 
switchToFavorSharps()
{
	Send !ehs
}
 
activateChordTool()
{
	Send !to
}
 
switchToLayer1()
{
	Send !ev2{Enter}
}
 
switchToLayer2()
{
	Send !ev1{Enter}
}
 
doubleNoteLengths()
{
	Send !lcd{Tab 4}{Down}{Enter}
}
 
halveNoteLengths()
{
	Send !lcd{Tab 4}{Up}{Enter}
}
 
pasteDynamicsOnly()
{
	Send !e{Down 11}{Enter}!nvi{Enter}^v!es
}
 
activateClefTool()
{
	Send !tc
}
 
makeBigTimeSignatures()
{
	Send !d{Left}d
	changeTimeSigInDocOptions("EngraverTime", "Regular", 40, 0, -290)
	openGlobalStaffAttributes()
}
 
makeNormalTimeSignatures()
{
	Send !d{Left}d
	changeTimeSigInDocOptions("Maestro", "Regular", 24, 0, 0)
	openGlobalStaffAttributes()
	WinWaitActive, Global Staff Attributes
	Send +{tab 10}{space 2}
	ControlClick, Button1, Global Staff Attributes,,,, NA
}
 
showHideRestsInEmptyMeasures()
{
	openGlobalStaffAttributes()
	WinWaitActive, Global Staff Attributes
	customToggle("Button8", "Global Staff Attributes")
	ControlClick, Button1, Global Staff Attributes,,,, NA
}
 
makeHollywoodMeasureNumbers()
{
	switchToEVPUs()
	activateMeasureTool()
	Send !me
	WinWaitActive, Measure Number
	easyUncheck([8,11,12,14], "Measure Number")
	easyCheck([9,10,17,23,24], "Measure Number")
	Send !t
	WinWaitActive, Font
	Send Times New Roman{tab}Bold{tab}22
	easyUncheck([1,2,3,4,5], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number
	Send !n
	WinWaitActive, Font
	Send Times New Roman{tab}Bold{tab}22
	easyUncheck([1,2,3,4,5], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number
	Send !o
	WinWaitActive, Position Measure Number
	ControlFocus, ComboBox1
	Send {up 2}{down 2}
	ControlFocus, Edit1
	Send {del 5}0
	ControlFocus, Edit2
	Send {del 5}-300
	ControlClick, Button1, Measure Number,,,, NA
	WinWaitActive, Measure Number
	Send !s
	WinWaitActive, Position Measure Number
	ControlFocus, ComboBox1
	Send {up 2}{down 2}
	ControlFocus, Edit1
	Send {del 5}0
	ControlFocus, Edit2
	Send {del 5}-300
	ControlClick, Button1, Position Measure Number,,,, NA
	ControlClick, Button1, Measure Number,,,, NA
	WinWaitActive, Finale
	Send {esc}
}
 
makeConventionalMeasureNumbers()
{
	Send !tm
	switchToEVPUs()
	Send !me
	WinWaitActive, Measure Number
	easyCheck([8,11,14], "Measure Number")
	easyUncheck([9,10,12,17,18,20,23,24], "Measure Number")
	Send !f
	WinWaitActive, Font
	Send Times New Roman{tab}Italic{tab}11
	easyCheck([1], "Font")
	easyUncheck([2,3,4,5], "Font")
	ControlClick, Button6, Font,,,, NA
	WinWaitActive, Measure Number
	Send !p
	WinWaitActive, Position Measure Number
	ControlFocus, ComboBox1
	Send {up 2}
	ControlFocus, Edit1
	Send {del 5}6
	ControlFocus, Edit2
	Send {del 5}50
	ControlClick, Button1, Position Measure Number,,,, NA
	ControlClick, Button1, Measure Number,,,, NA
	WinWaitActive, Finale
	Send {esc}
}
 
showHideMeasureNumbers()
{
	openGlobalStaffAttributes()
	WinWaitActive, Global Staff Attributes
	customToggle("Button16", "Global Staff Attributes")
	ControlFocus, Button1
	Send {enter}
}
 
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

goToFinale()
{
	Gui, Cancel
	WinActivate, Finale 
	WinWaitActive, Finale
	Send {esc}
}

; These are instructions for what to do when each hotkey is pressed.
Button101:
	goToFinale()
	exportToPDF()
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
	activateSimpleEntry()
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
	openCanonicUtilities()
return
 
Button115:
	goToFinale()
	activatePageLayoutTool()
return
 
 
 
 
 
Button201:
	goToFinale()
	switchToDefaultSpelling()
return
 
Button202:
    goToFinale()
	switchToUseSpellingTables()
return
 
Button203:
	goToFinale()
	switchtoFavorFlats()
return
 
Button204:
	goToFinale()
	switchToFavorSharps()
return
 
Button205:
    goToFinale()
	activateChordTool()
return
 
Button206:
	goToFinale()
	switchToLayer1()
return
 
Button207:
	goToFinale()
	switchToLayer2()
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
	pasteDynamicsOnly()
return
 
Button211:
    goToFinale()
	activateClefTool()
return
 
Button212:
	goToFinale()
 
return
 
Button213:
	goToFinale()
 
return
 
Button214:
    goToFinale()
 
return
 
Button215:
	goToFinale()
 
return
 
 
 
 
Button301:
	goToFinale()
	makeBigTimeSignatures()
return
 
Button302:
    goToFinale()
	makeNormalTimeSignatures()
return
 
Button303:
	goToFinale()
	showHideRestsInEmptyMeasures()
return
 
Button304:
	goToFinale()
 
return
 
Button305:
    goToFinale()
 
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
 
return
 
Button310:
	goToFinale()
 
return
 
Button311:
    goToFinale()
 
return
 
Button312:
	goToFinale()
 
return
 
Button313:
	goToFinale()
 
return
 
Button314:
    goToFinale()
 
return
 
Button315:
	goToFinale()
 
return
 
 
 
 
#if (WinActive("Finale") or WinActive("Finale Hotkey Interface")) ;---------------------------------------
	; This part assigns the key that makes the interface appear and disappear.  Another great choice is 
	; using CapsLock if you want to switch Tab out below.
	CapsLock::
	IfWinExist, Finale Hotkey Interface
	{
		Gui, Cancel
		Return
	}
	IfWinNotExist, Finale Hotkey Interface
	{
		Gui, Show, x326 y205 h315 w514, Finale Hotkey Interface
		GuiControl, Choose, TabGroup, 1
		Return
	}
	Return
#If ;-------------------------------------------------------------------
 
 
 
; If the interface isn't the active window, none of the keys on the grid will affect anything.
#if (WinActive("Finale Hotkey Interface")) ;-------------------------------
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

option_changed_hook:
   ;runs when option is changed - MyCheckBox will already hold current value
 
   return
 
on_exit_hook:
   ; runs just before app exit
   return
 
; KEEP THIS AT THE END!!
#Include adhd\ADHDLib.ahk		; If you have the library in the same folder as your macro, use this
;#Include <ADHDLib>			; If you have the library in the Lib folder (C:\Program Files\Autohotkey\Lib), use this