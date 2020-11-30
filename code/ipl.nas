;KotonOS

CYL	EQU		10				;シリンダーの数を定数として定義

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

:ディスク読み込み
	MOV		AX,0x0820		
	MOV		ES,AX			;読み込み先上位アドレス指定
	MOV		CH,0			;シリンダ0番
	MOV		CL,2			;セクタ2番、1番はヘッダに使用されている
	MOV		DH,0			;ヘッド0番

loadloop:
	MOV		SI,0			;失敗回数のカウンタ

retry:
	MOV		AH,0x02			;ディスク読み込み
	MOV		AL,1			;1セクタ分読み込み
	MOV		BX,0			;読み込み先下位アドレス指定
	MOV		DL,0			;ドライブ0番
	INT		0x13			;ディスクBIOS呼び出し
	JC		error			;エラー処理にジャンプ

;次のセクタ読み込み
	MOV		AX,ES
	ADD		AX,0x0020
	MOV		ES,AX			;アドレスを0x200進める
	ADD		CL,1
	CMP		CL,18			;18セクタまで読み込み
	JBE		loadloop

;裏面読み込み
	MOV		CL,1			;セクタ1番から読み直す
	ADD		DH,1
	CMP		DH,2			;裏面を読み込む
	JB		loadloop

;次のシリンダー読み込み
	MOV		DH,0			;表面に直す
	ADD		CH,1
	CMP		CH,CYL			;10シリンダ分読み込む
	JB		loadloop

;OS本体処理へ移行
	JMP		0xc200

	MOV		SI,suc_msg		;サクセスメッセージの格納
	JMP		print

error:
	MOV		AH,0x00			;ディスクリセット
	MOV		DL,0x00			;ディスク0番
	INT		0x13			;ディスクBIOS呼び出し
	ADD		SI,1
	CMP		SI,5			;5回失敗でブートをあきらめる
	JB		retry
	MOV		SI,err_msg		;エラーメッセージの格納

print:
	MOV		AH,0x00			;カラーコードを有効化
	MOV		AL,0x13			;8ビットカラー
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
suc_msg:
	DB		0x0a, 0x0a
	DB		"Aoi >LOAD SUCCESSFUL"
	DB		0x0a
	DB		0

err_msg:
	DB		0x0a, 0x0a
	DB		"Aoi >LOAD ERROR"
	DB		0x0a
	DB		0

	RESB	0x7dfe-$

	DB		0x55, 0xaa
