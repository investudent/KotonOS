TOOLS	=./tools/
CODE	=./code/
NASK	=$(TOOLS)nask.exe
EDING	=$(TOOLS)edimg.exe

#ê∂ê¨ãKë•

KotonOS,img : ipl.bin KotonOS.sys
	$(EDING) imgin:$(TOOLS)fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:KotonOS.sys to:@: \
		imgout:KotonOS.img

ipl.bin : $(CODE)ipl.nas
	$(NASK) $(CODE)ipl.nas ipl.bin ipl.lst

KotonOS.sys : $(CODE)KotonOS.nas
	$(NASK) $(CODE)KotonOS.nas KotonOS.sys KotonOS.lst