; Welcome to GRID Hotkey Interface v0.10.  I made this in an attempt to redesign hotkeys for Finale so
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

; There are certain commands that wait until Finale's window is active.  It is important
; for the program to be able to find the correct window, which depends on which version 
; of finale you have.  
global versionAndWindowTitle := "Finale 2012c"

; This creates the menus/tabs that each contain 15 buttons.
Gui, Add, Tab2,x-4 y-3 w520 h330 vTabGroup AltSubmit, Menu 1|Menu 2|Menu 3|Menu 4|Menu 5|Menu 6|Menu 7|Menu 8|Menu 9

; This part creates each button for each menu/tab.
Gui, Tab, 1
Gui, Add, Button, x6 y37 w100 h90 gButton101, Export to PDF
global Button101Keystrokes = "!ftp"
Gui, Add, Button, x106 y37 w100 h90 gButton102, Expression Tool
global Button102Keystrokes = "!te"
Gui, Add, Button, x206 y37 w100 h90 gButton103 , Speedy Note Entry
global Button103Keystrokes = "!ts"
Gui, Add, Button, x306 y37 w100 h90 gButton104 , Selection Tool
global Button104Keystrokes = "!tt"
Gui, Add, Button, x406 y37 w100 h90 gButton105 , Time Signature Tool
global Button105Keystrokes = "!tg"
Gui, Add, Button, x6 y127 w100 h90 gButton106 , Articulation Tool
global Button106Keystrokes = "!ta"
Gui, Add, Button, x106 y127 w100 h90 gButton107 , Slur
global Button107Keystrokes = "!ths"
Gui, Add, Button, x206 y127 w100 h90 gButton108 , Decrescendo
global Button108Keystrokes = "!thr"
Gui, Add, Button, x306 y127 w100 h90 gButton109 , Staff Tool
global Button109Keystrokes = "!tf"
Gui, Add, Button, x406 y127 w100 h90 gButton110 , Page Layout
global Button110Keystrokes = "!tp"
Gui, Add, Button, x6 y217 w100 h90 gButton111 , Canonic Utilities
global Button111Keystrokes = "!i{Up}{Up}{Right}{Down 3}{Enter}"
Gui, Add, Button, x106 y217 w100 h90 gButton112 , Toggle Concert Pitch
global Button112Keystrokes = "!d{Left}i"
Gui, Add, Button, x206 y217 w100 h90 gButton113 , Crescendo
global Button113Keystrokes = "!thc"
Gui, Add, Button, x306 y217 w100 h90 gButton114 , Simple Entry
global Button114Keystrokes = "!tib"
Gui, Add, Button, x406 y217 w100 h90 gButton115 , Show / Hide Grid
global Button115Keystrokes = "!vgg"

Gui, Tab, 2
Gui, Add, Button, x6 y37 w100 h90 gButton201, Default Spelling
global Button201Keystrokes = "!ehd"
Gui, Add, Button, x106 y37 w100 h90 gButton202, Use Spelling Tables
global Button202Keystrokes = "!eht"
Gui, Add, Button, x206 y37 w100 h90 gButton203 , Favor Sharps
global Button203Keystrokes = "!ehs"
Gui, Add, Button, x306 y37 w100 h90 gButton204 , Favor Flats
global Button204Keystrokes = "!ehf"
Gui, Add, Button, x406 y37 w100 h90 gButton205 , Chord Tool
global Button205Keystrokes = "!to"
Gui, Add, Button, x6 y127 w100 h90 gButton206 , Change selected to Layer 1
global Button206Keystrokes = "!ev2{Enter}"
Gui, Add, Button, x106 y127 w100 h90 gButton207 , Change selected to Layer 2
global Button207Keystrokes = "!!ev1{Enter}"
Gui, Add, Button, x206 y127 w100 h90 gButton208 , Note Lengths Doubled
global Button208Keystrokes = "!lcd{Tab 4}{Down}{Enter}"
Gui, Add, Button, x306 y127 w100 h90 gButton209 , Note Lengths Halved
global Button209Keystrokes = "!lcd{Tab 4}{Up}{Enter}"
Gui, Add, Button, x406 y127 w100 h90 gButton210 , Pastes to Selected the Dynamics of Copied Material
global Button210Keystrokes = "!e{Down 11}{Enter}!nvi{Enter}^v!es"
Gui, Add, Button, x6 y217 w100 h90 gButton211 , Clef Tool
global Button211Keystrokes = "!tc"
; Gui, Add, Button, x106 y217 w100 h90 gButton212 , oooooooooooo
; global Button212Keystrokes = "!d{Left}i"
; Gui, Add, Button, x206 y217 w100 h90 gButton213 , oooooooooooo
; global Button213Keystrokes = "!thc"
; Gui, Add, Button, x306 y217 w100 h90 gButton214 , oooooooooooo
; global Button214Keystrokes = "!tib"
; Gui, Add, Button, x406 y217 w100 h90 gButton215 , oooooooooooo
; global Button215Keystrokes = "!to"

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

; Navigating in scroll view to left and right using F2 and F3
F3::^PgDn
F2::^PgUp


; If the interface isn't the active window, none of the keys on the grid will affect anything.
#if (WinActive("Finale Hotkey Interface")) ;-------------------------------

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


; This function is a list of instructions for what to do when a button on the grid is pressed.
; Once a button is pressed, it basically takes away the interface, makes Finale the active window,
; then sends the corresponding keystrokes to perform the macro.
theUsual(keystrokes)
{
	Gui, Cancel
	IfWinExist, %versionAndWindowTitle%
	{
		WinActivate, %versionAndWindowTitle% 
		WinWaitActive, %versionAndWindowTitle%

		Send %keystrokes%
	}
	else 
	MsgBox, Finale isn't running or your Finale version / Window title doesn't match the script
}





; These are instructions for what to do when each hotkey is pressed.
Button101:
	theUsual(Button101Keystrokes)
return

Button102:
    theUsual(Button102Keystrokes)
return

Button103:
	theUsual(Button103Keystrokes) 
return

Button104:
	theUsual(Button104Keystrokes)
return

Button105:
    theUsual(Button105Keystrokes)
return

Button106:
	theUsual(Button106Keystrokes) 
return

Button107:
	theUsual(Button107Keystrokes)
return

Button108:
    theUsual(Button108Keystrokes)
return

Button109:
	theUsual(Button109Keystrokes) 
return

Button110:
	theUsual(Button110Keystrokes)
return

Button111:
    theUsual(Button111Keystrokes)
return

Button112:
	theUsual(Button112Keystrokes) 
return

Button113:
	theUsual(Button113Keystrokes)
return

Button114:
    theUsual(Button114Keystrokes)
return

Button115:
	theUsual(Button115Keystrokes) 
return






Button201:
	theUsual(Button201Keystrokes)
return

Button202:
    theUsual(Button202Keystrokes)
return

Button203:
	theUsual(Button203Keystrokes) 
return

Button204:
	theUsual(Button204Keystrokes)
return

Button205:
    theUsual(Button205Keystrokes)
return

Button206:
	theUsual(Button206Keystrokes) 
return

Button207:
	theUsual(Button207Keystrokes)
return

Button208:
    theUsual(Button208Keystrokes)
return

Button209:
	theUsual(Button209Keystrokes) 
return

Button210:
	theUsual(Button210Keystrokes)
return

Button211:
    theUsual(Button211Keystrokes)
return

; Button212:
; 	theUsual(Button212Keystrokes) 
; return

; Button213:
; 	theUsual(Button213Keystrokes)
; return

; Button214:
;     theUsual(Button214Keystrokes)
; return

; Button215:
; 	theUsual(Button215Keystrokes) 
; return


#If ;-------------------------------------------------------------------

GuiClose:
ExitApp