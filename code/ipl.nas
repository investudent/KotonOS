;KotonOS

CYL	EQU		10				;�V�����_�[�̐���萔�Ƃ��Ē�`

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

:�f�B�X�N�ǂݍ���
	MOV		AX,0x0820		
	MOV		ES,AX			;�ǂݍ��ݐ��ʃA�h���X�w��
	MOV		CH,0			;�V�����_0��
	MOV		CL,2			;�Z�N�^2�ԁA1�Ԃ̓w�b�_�Ɏg�p����Ă���
	MOV		DH,0			;�w�b�h0��

loadloop:
	MOV		SI,0			;���s�񐔂̃J�E���^

retry:
	MOV		AH,0x02			;�f�B�X�N�ǂݍ���
	MOV		AL,1			;1�Z�N�^���ǂݍ���
	MOV		BX,0			;�ǂݍ��ݐ扺�ʃA�h���X�w��
	MOV		DL,0			;�h���C�u0��
	INT		0x13			;�f�B�X�NBIOS�Ăяo��
	JC		error			;�G���[�����ɃW�����v

;���̃Z�N�^�ǂݍ���
	MOV		AX,ES
	ADD		AX,0x0020
	MOV		ES,AX			;�A�h���X��0x200�i�߂�
	ADD		CL,1
	CMP		CL,18			;18�Z�N�^�܂œǂݍ���
	JBE		loadloop

;���ʓǂݍ���
	MOV		CL,1			;�Z�N�^1�Ԃ���ǂݒ���
	ADD		DH,1
	CMP		DH,2			;���ʂ�ǂݍ���
	JB		loadloop

;���̃V�����_�[�ǂݍ���
	MOV		DH,0			;�\�ʂɒ���
	ADD		CH,1
	CMP		CH,CYL			;10�V�����_���ǂݍ���
	JB		loadloop

;OS�{�̏����ֈڍs
	JMP		0xc200

	MOV		SI,suc_msg		;�T�N�Z�X���b�Z�[�W�̊i�[
	JMP		print

error:
	MOV		AH,0x00			;�f�B�X�N���Z�b�g
	MOV		DL,0x00			;�f�B�X�N0��
	INT		0x13			;�f�B�X�NBIOS�Ăяo��
	ADD		SI,1
	CMP		SI,5			;5�񎸔s�Ńu�[�g��������߂�
	JB		retry
	MOV		SI,err_msg		;�G���[���b�Z�[�W�̊i�[

print:
	MOV		AH,0x00			;�J���[�R�[�h��L����
	MOV		AL,0x13			;8�r�b�g�J���[
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
