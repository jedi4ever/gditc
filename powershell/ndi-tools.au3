; https://www.autoitscript.com/autoit3/docs/tutorials/notepad/notepad.htm

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Patrick Debois

 Script Function:
	Install NDI Tools silently

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
; TODO: does not seem to have all the right settings - but we could use components?
Run('c:\downloads\ndi-tools.exe /LOADINF="c:\downloads\newtek-tools-silent.txt"')

Local $hWnd = WinWaitActive("Setup - NDI 4 Tools")


; Wait for 2 seconds.
Sleep(2000)
ControlClick ($hWnd, "", "I &accept the agreement" )

ControlClick ($hWnd, "", "&Next >" )
Sleep(2000)

ControlClick ($hWnd, "", "&Next >" )
Sleep(2000)

ControlClick ($hWnd, "", "&Next >" )
Sleep(2000)

ControlClick ($hWnd, "", "&Next >" )
Sleep(2000)

ControlClick ($hWnd, "", "&Install" )

; TODO: wait for Finish button
; TODO: uncheck , so nothing gets opened
