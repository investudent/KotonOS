;KotonOS

	ORG		0xc200

	MOV		SI,msg
	MOV		AH,0x00			;カラーコードを有効化
	MOV		AL,0x13			;8ビットカラー
	INT		0x10			;ビデオBIOS呼び出し
	MOV		AX,0
puts:						;メッセージの表示
	MOV		AL,[SI]
	ADD		SI,1
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			;1文字表示
	MOV		BX,3			;カラーコード
	INT		0x10			;ビデオBIOS呼び出し
	JMP		puts
fin:
	HLT						;CPU停止
	JMP		fin

;メッセージ部分
msg:
	DB		0x0a, 0x0a
	DB		"Aoi >Boot completely"
	DB		0x0a
	DB		0