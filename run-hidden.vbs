Set objWshShell = CreateObject("WScript.Shell")

'Get the first argument passed to the script
strApplication = WScript.Arguments(0)

'Check if there are any additional arguments
If WScript.Arguments.Count > 1 Then
  'Concatenate the additional arguments into a single string
  For i = 1 To WScript.Arguments.Count-1
    strArguments = strArguments & " " & WScript.Arguments(i)
  Next
Else
  'If there are no additional arguments, set to an empty string
  strArguments = ""
End If

'Launch the application hidden
objWshShell.Run strApplication & " " & strArguments, 0, False
