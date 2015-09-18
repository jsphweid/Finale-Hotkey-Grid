IfNotExist, config.ini
    gosub, CreateIniFile
ButtonIndex:=0 ; since we skip some lines, a_index isn't practical
HotkeysTable:={q:1, w:2, e:3, r:4, t:5, a:6, s:7, d:8, f:9, g:10, z:11, x:12, c:13, v:14, b:15}
Gui, Add, Tab2,x-4 y-3 w520 h330 vTabGroup AltSubmit +theme, Menu 1|Menu 2|Menu 3|Menu 4|Menu 5|Menu 6|Menu 7|Menu 8|Menu 9

; #include finaleMacros.ahk
; #include ahkCustomMacros.ahk
; #include finaleMacrosDif.ahk

IniRead, tabsbuttons, config.ini
Loop, parse, tabsbuttons, `n
{ ; how many tabs you want to add or have
    
; I wanted to make all positions as variables
; and you can change them as you wish
; or based on the tabs information that you can add
; or the width of the button can be based on the length of the longest text and so on
; but you may want to add that later on

;THIS BIT JUST CREATES THE GUI
x:= -94 ; to start from 6 when we add the 100 in our loop, since on every irretation we add it
y:= 37  ; start of from 37; we don't need the above approch since we only increment when the row is already have 5 buttons
Row:=1  ; keep track of rows in tab
Gui, Tab, %A_Index%
TabsIndex:=A_Index
IniRead, buttonstext, config.ini, tab%a_index%
loop, parse, buttonstext, `n ; each varible name is consistant of the word  "tab" + a_index (1,2,3,4...)
    {
    if !A_LoopField ; skip empty lines, if you want or whatever
        continue
    ButtonIndex++
    ; set the left and top position, and keep track of our row number
    ; 90 is the button's hight and 37 is the margin
    ; you wan change those how ever you see fit
    if A_Index in 6,11,16
        x:=6, y:=Row*90+37, Row++ 
    else
        x+=100 ; keep the top position as the previous button, and increment the left position by 100
    Gui, Add, Button, x%x% y%y% w100 h90 gGO_SEARCH_FOR_FUNCTION_OR_LABEL_WITH_MY_TEXT v%TabsIndex%_%ButtonIndex%, %A_LoopField%
    }
}

Gui, +hWndGuiHwND
Hotkey, If, OurTargetWindow()
for key in HotkeysTable
    Hotkey, %key%, GO_SEARCH_FOR_FUNCTION_OR_LABEL_WITH_MY_TEXT
Hotkey, if
; lets make hotkeys for the tabs index
; it's simple really, no need for the 9 lines
; and 100 chars
Hotkey, IfWinActive, ahk_id %GUIhWnd% ; hotkeys: shortcuts for the main window.
Loop, 9 ; loop from 1 throgh 9
    Hotkey, Numpad%A_Index%, ChangeTabIndexPlease
Hotkey, IfWinActive

gui ,show
return
OurTargetWindow(){
    return, WinActive("Finale") or WinActive("Finale Hotkey Interface")
    ; return true ; I used this for testing
}
#If OurTargetWindow() ; I always command lines like this: "AUTOHOTKEY THING", because it just has to be here
ChangeTabIndexPlease:
GuiControl, Choose, TabGroup, % SubStr(A_ThisHotkey, 0) ; get only the last character, it's the number we want
return
GO_SEARCH_FOR_FUNCTION_OR_LABEL_WITH_MY_TEXT:
gui, submit, nohide
if A_GuiControl ; no if the call came from the gui window, A_GuiControl would be empty, and it would have the control's label
    GuiControlGet, ControlToOperateOn,, %A_GuiControl% ; get the control text, we could ommit the vlable in creating the buttons
else {
    Butonstext:=HotkeysTable[A_ThisHotkey] ; get the index of this hotkey from the hotkeystable
    msgbox, %butonstext%
    IniRead, buttonstext, config.ini, tab%tabGroup% ; get the section with the name "tab%n%" where n is our group index
    ButtonsArray:=StrSplit(buttonstext, "`n", "`r") ; split the text into items
    ControlToOperateOn:=ButtonsArray[Butonstext] ; get the text from the ini file
}
if !ControlToOperateOn
    return
LabelOrFunction:=RegExReplace(ControlToOperateOn, "\s|\(|\)|/|\\") ; this is to make it a valid function or label name, so make sure you use these label's name
; advice:
    ; either make all the calls to lables or all calls to functions
    ; and let those labels or functions do what ever they are supposed to do
    ; and don't mix labels and functions in here
    
if IsLabel(LabelOrFunction) ; we found this as a label, so there is a function with this same name it won't be called
    gosub, %LabelOrFunction%
else if IsFunc(LabelOrFunction) ; we found this as a function
{
	; goToFinale()
    %LabelOrFunction%()
}
else
    MsgBox, 4112, error, no label or function with the name "%LabelOrFunction%" to call
return

ExporttoPDF: ; just a dummy label
MsgBox, 4160, Label, You call the label "%a_thislabel%"
return

ExpressionTool: ; just a dummy function
MsgBox, 4160, Function, You call the function "%a_thislabel%"
return

GuiContextMenu:
gui, submit, nohide
ButtonvLabel:=A_GuiControl ; we need it to change it's text in the menu
GuiControlGet,ButtonName,, %A_GuiControl%
IniRead, CommandList, config.ini, tab%TabGroup%
try menu, contextmenu, DeleteAll ; try is here because the first time the contextmenu isn't a valid menu
Loop, parse, CommandList, `n, `r
{
    if !A_LoopField
        continue ; don't include empty lines
    if !(A_LoopField=ButtonName){ ; if this is our button that we right clicked, don't add it
        if A_Index in 6,11,16
            menu, contextmenu, add
        menu, contextmenu, add, %A_LoopField%, ChangePosition
    }

}
menu, contextmenu, show
return
ChangePosition:
gui, +OwnDialogs
NewText:=A_ThisMenuItem ; this is just to get an idea
MsgBox, 4132, Rearrange, do you want to swap`nthis: "%ButtonName%"`nwith: "%NewText%"
IfMsgBox, no
    return

; remember the order of this two command is vital
; to not have two buttons with the same text
GuiControl,text, %NewText%, %ButtonName% ; this one gets the button from it's text
GuiControl,text, %ButtonvLabel%, %NewText% ; this one uses the button that was right clicked

; here you can do something the tab1/tab2/tab3 variables
gui, submit, nohide
; to swap between the two buttons text
StringReplace, CommandList, CommandList, %ButtonName%,  Dummytextsothatwedontmixeverythingup
StringReplace, CommandList,CommandList, %NewText%,  %ButtonName%
StringReplace, CommandList, CommandList, Dummytextsothatwedontmixeverythingup,  %NewText%
CommandList:=trim(CommandList)
; do what ever you want with this newly arranged buttons text
IniDelete, config.ini, tab%tabGroup% ; you must delete this section before adding to it, or you will have problems
IniWrite, %CommandList%, config.ini, tab%tabGroup% ; this will add this section at the end of the ini file
; so don't rely on the order of tabs in the ini file
; but use the index of the section "tab1" "tab2" tab3
Return

GuiEscape:
GuiClose:
ExitApp
return

CreateIniFile:
ConfigData=
(
[tab1]
Export to PDF
Expression Tool
Speedy Note Entry
Selection Tool
Time Signature Tool
Articulation Tool
Slur
Decrescendo
Staff Tool
Show / Hide Grid
Canonic Utilities
Toggle Concert Pitch
Crescendo
Simple Entry
Page Layout Tool

[Tab2]
Use Spelling Tables
Favor Flats
Favor Sharps
Chord Tool
Change selected to Layer 1
Change selected to Layer 2
Note Lengths Doubled
Note Lengths Halved
Pastes to Selected the Dynamics of Copied Material
Clef Tool

[tab3]
Make Big Time Signatures
Make Regular Time Signatures

Global Staff Attributes
Show/Hide rests in empty measures (selected staves)
LA-type Measure Numbers
Conventional Measure Numbers
Show/Hide Measure Numbers (selected staves)
)
FileAppend, %ConfigData%, config.ini
return