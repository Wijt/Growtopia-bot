#include <Misc.au3>
#include <Notify.au3>
FileInstall("notifyIcon.png", @TempDir & "notifyIcon.png", 1)

Global $x = ObjCreate('System.Collections.ArrayList')	;X koordinatlarýný tutucak bir liste oluþturuyoruz.
Global $y = ObjCreate('System.Collections.ArrayList')	;Y koordinatlarýný tutucak bir liste oluþturuyoruz.

Global $pause=False										;Programýn durup durmama bilgisini saklayacak bir deðiþken oluþturuyoruz.

Global $sAutoIt_Path = StringRegExpReplace(@AutoItExe, "(^.*\\)(.*)", "\")

main() 													;Ana fonksiyonumuzu 1 kere çaðýrýyoruz.

Func main()
   bildirimGoster("Bot baþlatýldý.")
   Opt("TrayAutoPause", 0)
   While True											;Sonrasýnda ana fonksiyon sonsuz bir döngü içine giriyor.
	  If $pause=False then								;eðer oyun durmamýþsa
		 If _IsPressed ("A0") Then                     	;eðer shift tuþuna basýlmýþsa
		   If _IsPressed ("01") Then				   		;ve ayný zamanda mouse sol tuþuna týklanmýþsa
			   AutoItSetOption("MouseCoordMode", 0)
			   Local $aPos = MouseGetPos()					;yerel bir deðiþken oluþturup o anki mouse koordinatýný x ve y olarak bu deðiþkene atama iþlemi yapýyoruz
			   $x.Add($aPos[0])								;x listesine mousenin x koordinatýný
			   $y.Add($aPos[1])								;y listesineyse mousenin y koordinatýný
			   Sleep(50)
			EndIf
		 Else											;eðer shift tuþuna basýlmamýþsa
			For $i = 0 To $y.Count - 1					;y koordinatýný kadar yani kaç defa týkladýysak o kadar sýrayla iþlem yap
			   _MouseClickPlus("Growtopia","left", $x.Item($i), $y.Item($i), 1);burda mouse týklama fonksiyonunu çaðýrýyoruz aslýnda dediðimiz þey þu growtopia uygulamasýna x ve y konumlarýna 1 defa sol týkla týkla
			   if kontrolEt() Then						;o sýrada oyunu durdurma komutu varmý yokmu onu kontrol ettiriyoruz eðer varsa
				  ExitLoop								;döngüden çýkarttýrýyoruz ve programý durduruyoruz veya shifte basarak kaydettiðimiz noktalarý siliyoruz.
			   EndIf
			Next
			;If $y.Count > 0 Then
			;   ControlSend("Growtopia","","","wwww")
			;   Sleep(300)
			;EndIf
		 EndIf
		 Sleep(50)										;döngü sürekli olarak çalýþýcaðý için bilgisayarýmýz yorulabilir bu yüzden her çalýmasýndan sonra 50 mili saniye bekletiyoruz böylelikle daha az çalýþýyor
	  EndIf
	  kontrolEt()										;burada da yine ayný þekilde kontrol yaptýrýyoruz ki programa komut göndermiþmiyiz kontrol edilsin.
   WEnd
EndFunc

Func kontrolEt()
   If _IsPressed ("12") And _IsPressed ("58") Then ; alt+x kombinasyonu yapýlýrsa durdur fonksiyonunu çalýþýtýr.
	  durdur()
	  return True
   EndIf
   If _IsPressed ("12") And _IsPressed ("43") Then ; alt+c kombinasyonu yapýlýrsa noktalarý sil fonksiyonunu çalýþtýr.
	  noktalariSil()
	  bildirimGoster("Tüm noktalarýnýz silindi.")
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
   If $pause=True Then ;durdur deðiþkeni true ise false false ise true yaptýrýyoruz.
	  $pause=False
	  bildirimGoster("Bot tekrar baþlatýldý.")
	  Sleep(1000)
   Else
	  $pause=True
	  bildirimGoster("Bot durdu.")
	  Sleep(1000)
   EndIf
EndFunc


;BURDAN SONRASI MOUSE TIKLAMASIYLA ALAKALI ÝNCELEMENÝZE GEREK YOK
;===============================================================================
;
; Açýklama:  	 Belirtilen pencereye týklama gönderen fonksiyon.
; Paremetreler:  $Window    =  Týklamanýn gönderileceði pencere
;                $Button     =  "left" yada "right" yani mousenin sol mu sað mý butonu olduðunu belirtiyoruz
;                $X       = 	x koordinatý
;                $Y       =  	y koordinatý
;                $Clicks     =  kaç kere týklanýcaðý
; Ek bilgi:      herhangi bir hata olmamasý için "MouseCoordMode" 0 þeklinde çalýþtýrmalýsýnýz.
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