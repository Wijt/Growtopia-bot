#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.0
	Author:         Szhlopp
	
	Easily include files in your autoIt script and executables!
#ce ----------------------------------------------------------------------------


$NameOfRes = InputBox("Resource Name", "Name of the new file.", "Newfile_1")
if @error = 1 then exit
if StringLeft($NameOfRes, 1) <> "$" then $NameOfRes = "$" & $NameOfRes

; Check if name already exists
$Fr = FileRead(@ScriptDir & '\DataFiler_file.au3')

Do
	
if Int(StringInStr($Fr, $NameOfRes)) = 0 Then ExitLoop

$NameOfRes = InputBox("Resource Name", "File already exists. Please enter a new name.", "Newfile_1")
if @error = 1 then exit
if StringLeft($NameOfRes, 1) <> "$" then $NameOfRes = "$" & $NameOfRes


Until False


if @error <> 1 then
$fod = FileOpenDialog("Open a file", @DesktopDir, "All (*.*)", 1)
if @error = 1 then Exit
;ConsoleWrite($fod & @CRLF)
$openF = FileOpen($fod, 16)
$read = FileRead($openF)
$filelen = StringLen($read)
$filelen = Int(Ceiling($filelen / 200))

$StringSplit = StringLeft($read, 200)
$read = StringTrimLeft($read, 200)
;FileWrite(@ScriptDir & '\DataFiler_file.au3', "Global " & $NameOfRes & @CRLF)
FileWrite(@ScriptDir & '\DataFiler_file.au3', "Func _Write" & StringTrimLeft($NameOfRes, 1) & "ToDir($dir)" & @CRLF)

FileWrite(@ScriptDir & '\DataFiler_file.au3', $NameOfRes & '="' & $StringSplit & '"' & @CRLF)

For $i = 0 To $filelen - 1
	$StringSplit = StringLeft($read, 200)
	FileWrite(@ScriptDir & '\DataFiler_File.au3', $NameOfRes & "&=" & '"' & $StringSplit & '"' & @CRLF)
	If StringLen($StringSplit) <= 199 Then ExitLoop
	$read = StringTrimLeft($read, 200)
Next

FileWrite(@ScriptDir & '\DataFiler_file.au3', "$_file_writer = " & $NameOfRes & @CRLF)
FileWrite(@ScriptDir & '\DataFiler_file.au3', "$_file_writer = Binary($_file_writer)" & @CRLF & "FileWrite($dir, $_file_writer)" & @CRLF)
FileWrite(@ScriptDir & '\DataFiler_File.au3', "EndFunc" & @CRLF)
MsgBox(0, "", "File Finished")
EndIf