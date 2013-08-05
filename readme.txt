Diese Routinen dienen zur Simulation der transient Spektren.
Sie benutzen die Funktionen von EasySpin als Grundlage.

Hauptroutine :  make_transient_fit.m

Alle anderen Routinen sind Unterprogramme. Die Routinen 
sind alle ausführlich intern dokomentiert.
Beispielfiles sind unter examples vorhanden.
!!! Wichtig: Es muss ein File mit dem Namen: probename_spectrum.dat (das Spektrum )
	vorhanden sein. Außerdem muß sich mindestenn ein file der Messung im
	Verzeichniss befinden um die experimentellen Parameter auszulesen !!! 
		 				

!!! Wichtig: EasySpin kann zum Zeitpunkt der Programmierung nicht mit
	entarteten Zuständen umgehen. Dies kann wenn man absichtlich entartete 
	Zustände simuliert zu einiger Verwirrung führen. Also E nie auf 
	Null setzten, sonder wenn Null gewünscht, dann ganz 
	klein setzen (z.B. E = 0.000000001). !!!