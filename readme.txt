Diese Routinen dienen zur Simulation der transient Spektren.
Sie benutzen die Funktionen von EasySpin als Grundlage.

Hauptroutine :  make_transient_fit.m

Alle anderen Routinen sind Unterprogramme. Die Routinen 
sind alle ausf�hrlich intern dokomentiert.
Beispielfiles sind unter examples vorhanden.
!!! Wichtig: Es muss ein File mit dem Namen: probename_spectrum.dat (das Spektrum )
	vorhanden sein. Au�erdem mu� sich mindestenn ein file der Messung im
	Verzeichniss befinden um die experimentellen Parameter auszulesen !!! 
		 				

!!! Wichtig: EasySpin kann zum Zeitpunkt der Programmierung nicht mit
	entarteten Zust�nden umgehen. Dies kann wenn man absichtlich entartete 
	Zust�nde simuliert zu einiger Verwirrung f�hren. Also E nie auf 
	Null setzten, sonder wenn Null gew�nscht, dann ganz 
	klein setzen (z.B. E = 0.000000001). !!!