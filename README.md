# Finale-Hotkey-Grid
Finale Hotkey Grid is an alternative hotkey layout for Finale using the Grid and a Graphical User Interface (GUI).  WINDOWS ONLY.  In additiona to handling basic tool switching with a visually guided GUI (switching from the Selection Tool to Speedy Note Entry), the GRID 

Instead of combinations of keys depressed, it uses a sequence. With the help of a visual interface that is toggled by using CAPS LOCK, the interface guides you through a host of preprogrammed macros that do everything from simply switching tools to re-configuring measure numbering styles. The current version operates outside of Finale as an Autohotkey script to execute simple (tool switches) and complex (adding inserts, preparing parts) macros in Finale.


# Getting Started

download .exe and run (or AHK)

# Making Modifications

## Installing AutoHotkey

## Running the Script

## How-to-Mod...

### Modify button names

Each button is added to the gui like so
```autohotkey
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transpose
```
Changing the name of a button is as easy as changing the last argumkent on the line. "Transpose" -> "Transposition"
```autohotkey
Gui, Add, Button, x6 y37 %defaultTextButtonSize% gButton101, Transposition
```


# Development ToDos

- link to location of exe on getting started
- 
