; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード	
[INSTRSET "i486p"]				; 486の命令まで使いたいという記述
[BITS 32]						; 32ビットモード用の機械語を作らせる

; オブジェクトファイルのための情報

[FILE "naskfunc.nas"]			; ソースファイル名情報

		GLOBAL	_io_hlt,_write_mem8,_io_cli,_io_sti,_io_stihlt			; このプログラムに含まれる関数名
		GLOBAL	_io_in8,_io_in16,_io_in32
		GLOBAL	_io_out8,_io_out_16,_io_out32
		GLOBAL	_io_get_eflags,_io_set_eflags


; 以下は実際の関数

[SECTION .text]		; オブジェクトファイルではこれを書いてからプログラムを書く

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_write_mem8:	; void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4]		; [ESP+4]にaddrが入っているのでそれをECXに読み込む
		MOV		AL,[ESP+8]		; [ESP+8]にdataが入っているのでそれをALに読み込む
		MOV		[ECX],AL
		RET

_io_cli:
		CLI
		RET

_io_sti:
		STI
		RET

_io_stihlt:
		STI
		HLT
		RET

_io_in8:	;int io_in8(int port)
		MOV		EDX,[ESP+4]
		MOV		EAX,0
		IN		AL,DX
		RET

_io_in16:	;int io_in16(int port)
		MOV		EDX,[ESP+4]
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:	;int io_in32(int port)
		MOV		EDX,[ESP+4]
		IN		EAX,DX
		RET

_io_out8:	;void io_out8(int port,int data)
		MOV		EDX,[ESP+4]
		MOV		AL,[ESP+8]
		OUT		DX,AL
		RET

_io_out16:	;void io_out16(int port,int data)
		MOV		EDX,[ESP+4]
		MOV		EAX,[ESP+8]
		OUT		DX,AX
		RET

_io_out32:	;void io_out32(int port,int data)
		MOV		EDX,[ESP+4]
		MOV		EAX,[ESP+8]
		OUT		DX,EAX
		RET

_io_get_eflags:	;int io_get_eflags()
		PUSHFD
		POP		EAX
		RET

_io_set_eflags:	;void io_set_eflags(int eflags)
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD
		RET