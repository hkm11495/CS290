TITLE Assignment2    (Assignment2.asm)

; Author: Holly Murray
; Last Modified: 1/23/2020
; OSU email address: murrayho@oregonstate.edu
; Course number/section: 271-400
; Project Number: #2                
; Due Date: 1/26/2020
; Description: This program ask a user for their name and to input a number 1 through 46.
;	it will validate that the number is within the range and then output the Fibonnaci
;	sequence from the inputted value.

INCLUDE Irvine32.inc

; (insert constant definitions here)

MINBOUND=1
MAXBOUND=46
.data

;String variables
	programmerName	BYTE	"Holly Murray", 0
	getUserName		BYTE	"Please Enter User Name: ",0
	greeting1		BYTE	"Welcome, ",0
	greeting2		BYTE	"! This program computes a fibonnaci sequence.",0
	userName		BYTE	33 DUP(0)
	instruction1	BYTE	"Please enter a number, N, for the fibonacci numbers 1-> 46",0
	error1			BYTE	"Error: You entered a value less than one. Try again.",0
	error2			BYTE	"Error: You entered a value greater than 46. Try again.",0
	spacing			BYTE	"     ",0
	farewell1		BYTE	"Program is over. Goodbye, ",0
;Integer Variables
	fibN			DWORD	?
	sumFibN			DWORD	?
	fibN0			DWORD	0
	fibN1			DWORD	0
	check5Values	DWORD	0
	numCount		DWord	0
; (insert variable definitions here)

.code
main PROC
;introduction
		mov		ebx, 0
		mov		edx, OFFSET programmerName
		call	WriteString
		call	crlf

		mov		edx, OFFSET getUserName
		call	WriteString
		call	crlf

		mov		edx, OFFSET userName
		mov		ecx, 32
		call	ReadString							;read string for username

		mov		edx, OFFSET greeting1
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		mov		edx, OFFSET greeting2
		call	WriteString
		call	crlf

;userInstructions
	getFibNum:
		mov		edx, OFFSET instruction1			;output instructions
		call	WriteString
		call	crlf

;get user data
		call	readInt
		mov		fibN, eax

		cmp		eax, MINBOUND						;check value is not <1
		jl		LessThanOne							;jump if less than one
		cmp		eax, MAXBOUND						;check value is not >46
		jg		GreaterThan46						;jump if greater than 46
		jmp		inBounds							;jump if in bounds
	inBounds:
		jmp		ShowFibNums							;jump to loop that outputs fib sequence
	LessThanOne:
		mov		edx, OFFSET error1
		call	WriteString
		call	crlf
		jmp		getFibNum							;jump to top of get Fib num to get a new number from user
	GreaterThan46:
		mov		edx, OFFSET error2
		call	WriteString
		call	crlf
		jmp		getFibNum							;jump to top of get Fib num to get a new number from user

;display fibs
	ShowFibNums:									;initialize loop values
		mov		ecx, fibN
		sub		ecx, 1
		mov		eax, fibN0

	FibLoop:
		cmp		fibN1,0								;check to see if this is the first number of the sequence or not
		je		firstStep
		jmp		notFirstStep
	firstStep:										;first number of the sequence block
		mov		eax, 1
		mov		fibN1, eax
		mov		sumFibN, eax
		call	WriteDec
		mov		eax, fibN0
		mov		ebx, 1
		mov		edx, OFFSET spacing
		call	WriteString
	notFirstStep:									;block for all numbers not the first sequence
		add		eax, fibN1
		mov		sumFibN,eax
		call	WriteDec
		mov		eax, fibN1
		mov		fibN0, eax
		mov		eax, sumFibN
		mov		fibN1, eax
		mov		eax, fibN0
		add		ebx, 1
		cmp		ebx,5								;check to see if this is the 5th number on the line
		je		addNewLine							;jump to new line block if it is the 5th sequence
		mov		edx, OFFSET spacing
		call	WriteString
		jmp EndLoop
	addNewLine:
		call	crlf
		mov		ebx, 0								;reset counter for 5th number in line
	EndLoop:
		loop	FibLoop

;farewell
		call	crlf
		mov		edx, OFFSET farewell1
		call	WriteString
		call	crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
