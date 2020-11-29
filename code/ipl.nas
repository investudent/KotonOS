;KotonOS

	ORG		0x7c00			;プログラム展開位置指定

:標準的なFAT12フォーマットフロッピーディスクのための記述
	JMP		entry			;プログラム本体へジャンプ
	DB		0x90			;nop
	DB		"HELLOIPL"		;ブートセクタ名
	DW		512				;セクタサイズ(バイト)
	DB		1				;クラスタサイズ(セクタ)
	DW		1				;FAT開始位置(セクタ)
	DB		2				;FAT数
	DW		224				;ルートディレクトリサイズ(エントリ)
	DW		2880			;ドライブサイズ(セクタ)
	DB		0xf0			;メディアタイプ
	DW		9				;FAT領域長(セクタ)
	DW		18				;トラックサイズ(セクタ)
	DW		2				;ヘッド数
	DD		0				;パーティション数
	DD		2880			;ドライブサイズ(セクタ)
	DB		0, 0, 0x29		;マジック
	DD		0xffffffff		;ボリュームシリアル番号？
	DB		"KotonOS    "	;ディスク名
	DB		"FAT12   "		;フォーマット名
	RESB	18				;余白

;プログラム
entry:						;レジスタ初期化
	MOV		AX,0
	MOV		SS,AX			
	MOV		SP,0x7c00		
	MOV		DS,AX			
	MOV		ES,AX			
	MOV		SI,msg			;メッセージの格納
	MOV		AL,0x13			;カラーコードを有効化
	INT		0x10			;ビデオBIOS呼び出し
	MOV		AX,0
putloop:					;メッセージの表示
	MOV		AL,[SI]
	ADD		SI,1
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			;1文字表示
	MOV		BX,3			;カラーコード
	INT		0x10			;ビデオBIOS呼び出し
	JMP		putloop
fin:
	HLT						;CPU停止
	JMP		fin

;メッセージ部分
msg:
	DB		0x0a, 0x0a
	DB		"Aoi Kotonoha logs in"
	DB		0x0a
	DB		0

	RESB	0x7dfe-$

	DB		0x55, 0xaa
