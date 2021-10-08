dim args
Set args = WScript.Arguments
Set WshShell = CreateObject("WScript.Shell") 

WshShell.run "cmd /c " &args(0) &args(1),0