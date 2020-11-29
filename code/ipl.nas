;KotonOS

	ORG		0x7c00			;�v���O�����W�J�ʒu�w��

:�W���I��FAT12�t�H�[�}�b�g�t���b�s�[�f�B�X�N�̂��߂̋L�q
	JMP		entry			;�v���O�����{�̂փW�����v
	DB		0x90			;nop
	DB		"HELLOIPL"		;�u�[�g�Z�N�^��
	DW		512				;�Z�N�^�T�C�Y(�o�C�g)
	DB		1				;�N���X�^�T�C�Y(�Z�N�^)
	DW		1				;FAT�J�n�ʒu(�Z�N�^)
	DB		2				;FAT��
	DW		224				;���[�g�f�B���N�g���T�C�Y(�G���g��)
	DW		2880			;�h���C�u�T�C�Y(�Z�N�^)
	DB		0xf0			;���f�B�A�^�C�v
	DW		9				;FAT�̈撷(�Z�N�^)
	DW		18				;�g���b�N�T�C�Y(�Z�N�^)
	DW		2				;�w�b�h��
	DD		0				;�p�[�e�B�V������
	DD		2880			;�h���C�u�T�C�Y(�Z�N�^)
	DB		0, 0, 0x29		;�}�W�b�N
	DD		0xffffffff		;�{�����[���V���A���ԍ��H
	DB		"KotonOS    "	;�f�B�X�N��
	DB		"FAT12   "		;�t�H�[�}�b�g��
	RESB	18				;�]��

;�v���O����
entry:						;���W�X�^������
	MOV		AX,0
	MOV		SS,AX			
	MOV		SP,0x7c00		
	MOV		DS,AX			
	MOV		ES,AX			
	MOV		SI,msg			;���b�Z�[�W�̊i�[
	MOV		AL,0x13			;�J���[�R�[�h��L����
	INT		0x10			;�r�f�IBIOS�Ăяo��
	MOV		AX,0
putloop:					;���b�Z�[�W�̕\��
	MOV		AL,[SI]
	ADD		SI,1
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			;1�����\��
	MOV		BX,3			;�J���[�R�[�h
	INT		0x10			;�r�f�IBIOS�Ăяo��
	JMP		putloop
fin:
	HLT						;CPU��~
	JMP		fin

;���b�Z�[�W����
msg:
	DB		0x0a, 0x0a
	DB		"Aoi Kotonoha logs in"
	DB		0x0a
	DB		0

	RESB	0x7dfe-$

	DB		0x55, 0xaa
