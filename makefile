#¶¬‹K‘¥

KotonOS,img : ipl.bin
	./tools/edimg.exe imgin:./tools/fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 imgout:KotonOS.img

ipl.bin :
	./tools/nask.exe ./code/ipl.nas ipl.bin ipl.lst
