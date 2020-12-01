TOOLS	=./tools/
CODE	=./code/
INC		= $(TOOLS)haribote/
NASK	=$(TOOLS)nask.exe
EDING	=$(TOOLS)edimg.exe
CC1      = $(TOOLS)cc1.exe -I$(INC) -Os -Wall -quiet
GAS2NASK = $(TOOLS)gas2nask.exe -a
OBJ2BIM  = $(TOOLS)obj2bim.exe
BIM2HRB  = $(TOOLS)bim2hrb.exe
RULEFILE = $(TOOLS)haribote/haribote.rul

#ê∂ê¨ãKë•

KotonOS,img : ipl.bin KotonOS.sys
	$(EDING) imgin:$(TOOLS)fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:KotonOS.sys to:@: \
		imgout:KotonOS.img

ipl.bin : $(CODE)ipl.nas
	$(NASK) $(CODE)ipl.nas ipl.bin ipl.lst

KotonOS.sys : asmhead.bin bootpack.hrb
	copy /B asmhead.bin+bootpack.hrb KotonOS.sys
	
bootpack.hrb : bootpack.bim 
	$(BIM2HRB) bootpack.bim bootpack.hrb 0
	
bootpack.bim : bootpack.obj naskfunc.obj 
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		bootpack.obj naskfunc.obj
# 3MB+64KB=3136KB

naskfunc.obj : $(CODE)naskfunc.nas 
	$(NASK) $(CODE)naskfunc.nas naskfunc.obj naskfunc.lst

bootpack.obj : bootpack.nas 
	$(NASK) bootpack.nas bootpack.obj bootpack.lst

bootpack.nas : bootpack.gas 
	$(GAS2NASK) bootpack.gas bootpack.nas

bootpack.gas : $(CODE)bootpack.c 
	$(CC1) -o bootpack.gas $(CODE)bootpack.c

asmhead.bin : $(CODE)asmhead.nas 
	$(NASK) $(CODE)asmhead.nas asmhead.bin asmhead.lst