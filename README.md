# Finale-Hotkey-Grid
Finale Hotkey Grid is an alternative hotkey layout for Finale using the Grid and a Graphical User Interface (GUI).  WINDOWS ONLY.  In additiona to handling basic tool switching with a visually guided GUI (switching from the Selection Tool to Speedy Note Entry), the GRID 

Instead of combinations of keys depressed, it uses a sequence. With the help of a visual interface that is toggled by using CAPS LOCK, the interface guides you through a host of preprogrammed macros that do everything from simply switching tools to re-configuring measure numbering styles. The current version operates outside of Finale as an Autohotkey script to execute simple (tool switches) and complex (adding inserts, preparing parts) macros in Finale.


# Getting Started
- Download [zip](https://github.com/jsphweid/Finale-Hotkey-Grid/archive/v0.19.zip)
- Extract zip to any folder
- Run finale-grid-hotkey executable that works for your processor (either 32 bit or 64 bit)
- While Finale is running, hit CAPS to toggle on/off the GUI and you're there!

All you really need to run the Finale Hotkey Grid is the .exe and the folder "icons."  These two things must be in the same folder (they are by default).

# Making Modifications
Alright.  So maybe you want to switch some of the buttons around or add your own macros to my interface.  Cool.  Currently, the only way to do any of these is to change some code.  But it's okay, it's not that difficult, even if you can't really code.  To start, you must have AutoHotkey installed.

## Installing AutoHotkey and an optional text editor
Download the most current version from [AHKScript.org](http://ahkscript.org/).  After you install that, it might be wise to get a good text editor.  Sure you can just open the scripts in Notepad and edit them, but there is no highlighting, auto-complete, and other things that make more advanced text editors preferable to code with.  I use Sublime Text 3.  There is a package for AHK thankfully available [here](https://github.com/ahkscript/SublimeAutoHotkey).  Additionally, you can use [SciTE4AutoHotkey](http://fincs.ahk4.net/scite4ahk/).  All are free.

## How-to-Mod...

### Introduction
Now we're ready to change some code.  Load up your text editor of choice and open the finale-hotkey-grid.ahk file.  This is the main script file.  In the folder "includes" are four other .ahk files that are necessary for the main file to run.  I could have put all of the lines of code in one big file but I chose to separate them for the sake of organization.  

### Modify button names
Let's say we simply want to change the name of a button because you didn't like my name.

Open finale-hotkey-grid.ahk in your text editor of choice.  Search for "Transpose". The first instance you'll come across is probably this:
```autohotkey
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transpose
```
The code is pretty self-explanatory.  It tells the GUI to add a button at location x6 y37 with my default size.  The button's g-label (more on that later) is "Button101".  The actual text for the button that is displayed is "Transpose".  If I wanted to change it to something else, I would simply do the following:
```autohotkey
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transposition
```
This doesn't change any of the routing, just the name/text that is displayed on the actual GUI.

### Going Deeper
Let's talk a little more about the routing.  Besides the main script file, the only other .ahk file you might mess with is "finaleMacros.ahk".  This file contains all of the actually macros: functions in this case.  The functions, in this case, are nothing more than a set of instructions to tell the computer what to do.  A basic example (in plain English): click here, click there, hit enter, wait for a window to be active, type "45", hit enter again.  Those instructions might take up lines 70-86 in some .ahk file.  How do I tell the computer to execute those lines every time a button is pressed?  Basically, by wrapping it in {}'s and giving it a name like myFirstMacro().  That's all a basic function is.

So where is the part that tells the computer to run a particular function when a button is pressed?  Let's continue.

### Changing Routing

Let's go back to the main file, "finale-hotkey-grid.ahk".  This file contains a bunch of sprawled out badly written code that is extremely redundant but it makes certain things easy to see, if you don't mind scrolling/searching.  Let's take a look at our "Transpose" button.

This is the part where the button is created:
```autohotkey
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transpose
```
Notice the G-Label "Button101".  This is important now.  When this Button (also called a Control) is pressed, AHK looks for a Label titled "Button101".  So search the document for "Button101".  Besides the line of code directly above, the other instance of that term is here:

# Development ToDos

- link to location of exe on getting started
- 
