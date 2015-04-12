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