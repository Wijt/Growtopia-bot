#include <Misc.au3>
#include <Notify.au3>
FileInstall("notifyIcon.png", @TempDir & "notifyIcon.png", 1)

Global $x = ObjCreate('System.Collections.ArrayList')	;X koordinatlar�n� tutucak bir liste olu�turuyoruz.
Global $y = ObjCreate('System.Collections.ArrayList')	;Y koordinatlar�n� tutucak bir liste olu�turuyoruz.

Global $pause=False										;Program�n durup durmama bilgisini saklayacak bir de�i�ken olu�turuyoruz.

Global $sAutoIt_Path = StringRegExpReplace(@AutoItExe, "(^.*\\)(.*)", "\")

main() 													;Ana fonksiyonumuzu 1 kere �a��r�yoruz.

Func main()
   bildirimGoster("Bot ba�lat�ld�.")
   Opt("TrayAutoPause", 0)
   While True											;Sonras�nda ana fonksiyon sonsuz bir d�ng� i�ine giriyor.
	  If $pause=False then								;e�er oyun durmam��sa
		 If _IsPressed ("A0") Then                     	;e�er shift tu�una bas�lm��sa
		   If _IsPressed ("01") Then				   		;ve ayn� zamanda mouse sol tu�una t�klanm��sa
			   AutoItSetOption("MouseCoordMode", 0)
			   Local $aPos = MouseGetPos()					;yerel bir de�i�ken olu�turup o anki mouse koordinat�n� x ve y olarak bu de�i�kene atama i�lemi yap�yoruz
			   $x.Add($aPos[0])								;x listesine mousenin x koordinat�n�
			   $y.Add($aPos[1])								;y listesineyse mousenin y koordinat�n�
			   Sleep(50)
			EndIf
		 Else											;e�er shift tu�una bas�lmam��sa
			For $i = 0 To $y.Count - 1					;y koordinat�n� kadar yani ka� defa t�klad�ysak o kadar s�rayla i�lem yap
			   _MouseClickPlus("Growtopia","left", $x.Item($i), $y.Item($i), 1);burda mouse t�klama fonksiyonunu �a��r�yoruz asl�nda dedi�imiz �ey �u growtopia uygulamas�na x ve y konumlar�na 1 defa sol t�kla t�kla
			   if kontrolEt() Then						;o s�rada oyunu durdurma komutu varm� yokmu onu kontrol ettiriyoruz e�er varsa
				  ExitLoop								;d�ng�den ��kartt�r�yoruz ve program� durduruyoruz veya shifte basarak kaydetti�imiz noktalar� siliyoruz.
			   EndIf
			Next
			;If $y.Count > 0 Then
			;   ControlSend("Growtopia","","","wwww")
			;   Sleep(300)
			;EndIf
		 EndIf
		 Sleep(50)										;d�ng� s�rekli olarak �al���ca�� i�in bilgisayar�m�z yorulabilir bu y�zden her �al�mas�ndan sonra 50 mili saniye bekletiyoruz b�ylelikle daha az �al���yor
	  EndIf
	  kontrolEt()										;burada da yine ayn� �ekilde kontrol yapt�r�yoruz ki programa komut g�ndermi�miyiz kontrol edilsin.
   WEnd
EndFunc

Func kontrolEt()
   If _IsPressed ("12") And _IsPressed ("58") Then ; alt+x kombinasyonu yap�l�rsa durdur fonksiyonunu �al���t�r.
	  durdur()
	  return True
   EndIf
   If _IsPressed ("12") And _IsPressed ("43") Then ; alt+c kombinasyonu yap�l�rsa noktalar� sil fonksiyonunu �al��t�r.
	  noktalariSil()
	  bildirimGoster("T�m noktalar�n�z silindi.")
	  return True
   EndIf
EndFunc


Func bildirimGoster($message)
   _Notify_Set(0, 0xdddddd, 0x282828, "Comic Sans MS", False, 500)
   _Notify_Show(@TempDir & "notifyIcon.png", "Growtopia - BOT", $message, 3)
EndFunc


Func noktalariSil()
$x.Clear() ;iki listemizi de temizliyoruz.
$y.Clear()
EndFunc

Func durdur()
   If $pause=True Then ;durdur de�i�keni true ise false false ise true yapt�r�yoruz.
	  $pause=False
	  bildirimGoster("Bot tekrar ba�lat�ld�.")
	  Sleep(1000)
   Else
	  $pause=True
	  bildirimGoster("Bot durdu.")
	  Sleep(1000)
   EndIf
EndFunc


;BURDAN SONRASI MOUSE TIKLAMASIYLA ALAKALI �NCELEMEN�ZE GEREK YOK
;===============================================================================
;
; A��klama:  	 Belirtilen pencereye t�klama g�nderen fonksiyon.
; Paremetreler:  $Window    =  T�klaman�n g�nderilece�i pencere
;                $Button     =  "left" yada "right" yani mousenin sol mu sa� m� butonu oldu�unu belirtiyoruz
;                $X       = 	x koordinat�
;                $Y       =  	y koordinat�
;                $Clicks     =  ka� kere t�klan�ca��
; Ek bilgi:      herhangi bir hata olmamas� i�in "MouseCoordMode" 0 �eklinde �al��t�rmal�s�n�z.
;
;===============================================================================

Func _MouseClickPlus($Window, $Button = "left", $X = "", $Y = "", $Clicks = 1)
  Local $MK_LBUTTON    =  0x0001
  Local $WM_LBUTTONDOWN   =  0x0201
  Local $WM_LBUTTONUP    =  0x0202

  Local $MK_RBUTTON    =  0x0002
  Local $WM_RBUTTONDOWN   =  0x0204
  Local $WM_RBUTTONUP    =  0x0205

  Local $WM_MOUSEMOVE    =  0x0200

  Local $i              = 0

  Select
  Case $Button = "left"
     $Button     =  $MK_LBUTTON
     $ButtonDown =  $WM_LBUTTONDOWN
     $ButtonUp   =  $WM_LBUTTONUP
  Case $Button = "right"
     $Button     =  $MK_RBUTTON
     $ButtonDown =  $WM_RBUTTONDOWN
     $ButtonUp   =  $WM_RBUTTONUP
  EndSelect

  If $X = "" OR $Y = "" Then
     $MouseCoord = MouseGetPos()
     $X = $MouseCoord[0]
     $Y = $MouseCoord[1]
  EndIf

  For $i = 1 to $Clicks
     DllCall("user32.dll", "int", "SendMessage", "hwnd", WinGetHandle($Window), "int", $WM_MOUSEMOVE, "int", 0, "long", _MakeLong($X, $Y))

     DllCall("user32.dll", "int", "SendMessage", "hwnd", WinGetHandle($Window), "int", $ButtonDown, "int", $Button, "long", _MakeLong($X, $Y))

     DllCall("user32.dll", "int", "SendMessage", "hwnd", WinGetHandle($Window), "int", $ButtonUp, "int", $Button, "long", _MakeLong($X, $Y))
  Next
EndFunc

Func _MakeLong($LoWord,$HiWord)
  Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc