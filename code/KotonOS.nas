;KotonOS

	ORG		0xc200

	MOV		SI,msg
	MOV		AH,0x00			;�J���[�R�[�h��L����
	MOV		AL,0x13			;8�r�b�g�J���[
	INT		0x10			;�r�f�IBIOS�Ăяo��
	MOV		AX,0
puts:						;���b�Z�[�W�̕\��
	MOV		AL,[SI]
	ADD		SI,1
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			;1�����\��
	MOV		BX,3			;�J���[�R�[�h
	INT		0x10			;�r�f�IBIOS�Ăяo��
	JMP		puts
fin:
	HLT						;CPU��~
	JMP		fin

;���b�Z�[�W����
msg:
	DB		0x0a, 0x0a
	DB		"Aoi >Boot completely"
	DB		0x0a
	DB		0