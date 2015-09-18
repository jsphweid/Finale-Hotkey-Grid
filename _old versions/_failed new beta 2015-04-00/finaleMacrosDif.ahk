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

createNewExpression(verticalBaselineAdjustment, verticalEntryAdjustment, aboveOrBelow9or10, styleButton)
{
	switchToEVPUs()
	ExpressionTool()
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
	Control, Choose, 7, ComboBox2, Expression Designer
	sleep, 100
	ControlClick, %styleButton%, Expression Designer,,,, NA
	ControlFocus, FinDisp2
	WinWaitActive, Expression Selection
	Send {enter}
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

ExpressionTool()
{
	Send !te
}

SpeedyNoteEntry()
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
	; easyCheck([22], "Global Staff Attributes")
	easyCheck([22], "Global Staff Attributes")
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












