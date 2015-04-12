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
#Include, includes\ahkCustomMacros.ahk

; includes all of the functions for each Finale Macro.
#Include, includes\finaleMacros.ahk

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
; Gui, Add, Button, x206 y217 %defaultTextButtonSize% gButton313 , oooooooooooo
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
#Include, includes\myBinds.ahk


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
#Include, includes\defaultSettings.ahk
