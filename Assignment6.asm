TITLE Assignment6    (Assignment6.asm)

; Author: Holly Murray
; Last Modified: 3/15/2020
; OSU email address: murrayho@oregonstate.edu
; Course number/section: 271-400
; Project Number: #6                
; Due Date: 3/29/2020
; Description: This program generates an array of 200 numbers. It then sorts the array from smallest to largest. The median of the
;of array is displayed and the count of each value in the array is shown as well.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

;String variables
	programmerTitle		BYTE	"Assigment #6 by Holly Murray", 0
	introduction1		BYTE	"Please provide 10 signed decimal integers. Each number needs to be small enough to fit in a 32 bit register.", 0
	introduction2		BYTE	"This program shows the array unsorted, sorted, and the count of the number of times a number was found.", 0
	spacing				BYTE	",  ",0
	getData				BYTE	"Please enter a signed integer:     ",0
	farewell1			BYTE	"Program is over. Goodbye!",0
	isValidPrompt		BYTE	"Valid Number",0
	isNotValidPrompt	BYTE	"Not a Valid Number",0
	EC2					BYTE	"**EC: Input lines are numbered for every valid input ",0
	EC2Msg				BYTE	"Now finding counts first and then sorting and displaying the median: ",0
	ErrorMsg			BYTE	"Error: Non integer detected",0
	isNegMsg			BYTE	"Value is Negative",0
	inConvertMsg		BYTE	"In Converting Numbers",0
	sumMSG				BYTE	"The sum of these numbers is: " , 0
	avgMSG				BYTE	"The rounded average of these numbers is: " , 0
	displayNumbersMSG	BYTE	"You entered the following numbers: ",0
	blanks				BYTE	" ",0

;Integer Variables
	signedInteger		BYTE	15 DUP(0)
	bufferArray			DWORD	1 DUP(0)
	tempArray			DWORD	1 DUP(0)
	averageArray		SDWORD  10 DUP(0)
; (insert variable definitions here)

.code


;********************************************************************************************
;getString Macro: print the string which is stored in a specified memory location. 
;Recieves: 2 Offsets for prompt and array address, one value for size of array
;Returns: N/A
;PreConditions: Must be passed two offsets and a value for array size
;PostConditions: Outputs a prompt and gets a value from the user
; Registers changed: none
;********************************************************************************************	
getString	Macro	prompt, arrayAddress, arraySize
		push	edx
		push	ecx

		mov		edx, prompt
		call	WriteString
		mov		edx, arrayAddress
		mov		ecx, arraySize
		call	ReadString
	
		pop		ecx
		pop		edx
EndM

;********************************************************************************************
;displayString Macro: get the user's keyboard input into a memory location
;Recieves: Recieves an offset for an array and a value for the array size
;Returns: N/A
;PreConditions: Must be passed an offset value and the length of the offset value
;PostConditions: Ouputs a string
; Registers changed: None
;********************************************************************************************	
displayString Macro arrayAddress, arraySize
		push	edx
		mov		edx, arrayAddress
		call	WriteString
		pop		edx
EndM

;********************************************************************************************
;Introduction Procdure: . Displays program name and describes the program
;Recieves: Recieves four strings by reference to output an introduction
;Returns: N/A
;PreConditions: Must be passed an offset value for each prompt (4)
;PostConditions: Ouputs four prompts
; Registers changed: None
;********************************************************************************************
introduction Proc
		enter	0,0
		push	edx
	
	;output string
		mov		edx, [ebp+20]
		call	WriteString
		call	Crlf
	
	;output string
		mov		edx, [ebp+16]
		call	WriteString
		call	Crlf
	
	;output string
		mov		edx, [ebp+12]
		call	WriteString
		call	Crlf

	;output string
		mov		edx, [ebp+8]
		call	WriteString
		call	Crlf
	
		pop		edx
		pop		ebp
		ret		16
introduction Endp



;********************************************************************************************
;Farewell Procdure: outputs good bye to the user. The program terminates.
;Recieves: Recieves one string by reference to say goodbye
;Returns: N/A
;PreConditions: Must be passed an offset value 
;PostConditions: Ouputs a string
; Registers changed: None
;********************************************************************************************	
Farewell Proc
		enter 0,0
		call	 Crlf
		push	edx
	
		mov		edx, [ebp+8]
		call	WriteString
		call	Crlf
	
		pop		edx
		pop		ebp
		ret		4
Farewell EndP


;********************************************************************************************
;readVal Procdure: invoke the getString macro to get the user's string of digits. It converts the 
; digit string to numeric, while validating input. Calls ConvertToNum to convert digits to numbers
;Recieves: Offset of average array, length of average array, offset of the error message, offset of the get data array,
; offset of the signed integer array, and the length of the signed integer arrray
;Returns: N/A
;PreConditions: Must be passed an offset of 3 arrays, an offset of a prompt, and two values for length of the arrays
;PostConditions: Possible outputs of error messages, collects numeric data from user and stores into an array.
; Then the digits that are valid are convereted to numbers.
;Registers changed: None
;********************************************************************************************	
readVal Proc
			push	ebp
			mov		ebp, esp
			pushad
		;address of average array
			mov		edi, [ebp+24]
		;length of average array
			mov		ecx, [ebp+28]
			mov		ebx, 0
			mov		bl, 1
	getTenNumbers:
			push	ecx
	getUserData:		
		;prompt to get get string from user
			mov		edx, [ebp+16]	
		;get array for input values
			mov		esi, [ebp+12]
		;size of array
			mov		ecx, [ebp+8]
			mov		eax,0
		;call get string for user input  *(prompt, array for value)
			mov		al, bl
			call		WriteDec
			mov		al, 32
			call	WriteChar
			getString  edx, esi, ecx
	
		;loop through and check to make sure values are numeric or first value is negative
		
		;check first value
			
			lodsb
			sub			esi, Type BYTE

		;check for negative
			cmp		al, 45
			je		isNegative
		isPostive:
			jmp		checkValues
		isNegative:
			;mov		[esi], al
			lodsb
			dec		ecx		
			;add		esi, TYPE BYTE

		checkValues:
		;add byte to al

			mov		al,  [esi]
		
		;Check that we are done reading string
			cmp		al, 0
			je		EndOfNumber
	
		;Check string byte value is between 48 and 57
			cmp		al, 48
			jl		NotValid
			cmp		al, 57
			jg		NotValid
	
		;If valid keep looping through rest of the array
		Valid:
			add		esi, TYPE BYTE
			loop	checkValues
			jmp		EndofNumber
	
		;Output Error message and go back to beginning of get User Data
		NotValid:
			mov		edx, [ebp+20]
			Call	WriteString
			Call	crlf
			jmp		getUserData 
		
		EndofNumber:
			mov		eax, [ebp+8]
			sub		eax, ecx
			add		bl,1

		;address of average array
			push	edi
			push	eax
		
		;array address of numbers
			sub		esi, TYPE BYTE
			push	esi
		
		;CONVERT DIGIT TO NUMERIC3
			call	ConvertToNum
	
			pop		ecx
			add		edi, TYPE DWORD

		loop getTenNumbers

			popad
			pop		ebp
			ret		24
readVal	EndP



;*************************************************************************************************************
;ConvertToNum Procdure: converts string digits to numeric values and stores converted numbers in average array
;Recieves: Offset of average array, the length of the numbers left in the string (non 0's at the end), and the address of 
; the last value stored in the string
;Returns: N/A
;PreConditions: Must be passed an offset of two arrays and the length of the number of digits in the array
;PostConditions: moves  the numeric value into average array
;Registers changed: None
;***************************************************************************************************************
ConvertToNum Proc

		push	ebp
		mov		ebp, esp
		pushad
		mov		edi, [ebp+16]

		mov		ecx, [ebp+12]
	;last value in array from call
		mov		esi, [ebp+8]

		mov		eax, 0
		mov		ebx, 1
		mov		edx, 0
	
	;initialize array value with zero
		mov		[edi], eax
	
	convertNums:
		mov		edx, 0
		mov		eax,0
	;move array byte into dl
		mov		dl, [esi]
	;check for minus sign
		cmp		dl, 45
		je		isNegative
	;subtract 48 from decimal value
		sub		dl, 48
	
	;sign extend dl into eax
		movsx	eax, dl
	
	;multiply by current tens place (starts with one)
		mul		ebx

	;add number to the values alreayd in edi
		add		[edi], eax

	;mulitply each tens place by ten^(n)
		mov		eax,0
		mov		eax, ebx
		mov		ebx,10
		mul		ebx
		mov		ebx, eax
	;move	esi to the next byte
		sub		esi, TYPE BYTE
	
		LOOP	convertNums


		jmp		nonNegative
	isNegative:
		mov		eax, [edi]
		mov		ebx, -1
		imul	ebx
		mov		[edi], eax

	nonNegative:
		mov		eax, [edi]
	
		popad
		pop		ebp
		ret		12
ConvertToNum EndP


;********************************************************************************************
;WriteVal Procdure: converts a numeric value to a string of digits and invoke the display String 
; macro to produce the output. calls get digits, get count, make negative, initialize array
;Recieves:	OFFSET spacing,OFFSET displayNumbersMSG, LENGTHOF averageArray, OFFSET averageArray, OFFSET signedInteger,	
;LENGTHOF signedInteger		
;Returns: N/A
;PreConditions: Must be passed an offset of two prompts and the length of two arrays, and the offset of two arrays
;PostConditions: moves an digits into an array to be outputted to the screen
;Registers changed: None
;********************************************************************************************	
WriteVal Proc
		push		ebp
		mov			ebp, esp
		pushad
		mov			edx, [ebp+24]
		call		WriteString
		mov			eax, 0
		mov			edx,0
	;numeric array address
		mov		edi, [ebp+16]
		mov		eax,[edi]
		mov		ecx, [ebp+20]
	
	AvgArrLoop:
		push	ecx

	;address for input string
		mov		esi, [ebp+12]
		mov		eax, [ebp+8]
	
	;initialize input string with zeros
		push	esi
		push	eax
		call	initializeArray
	
	;check if negative
		mov		ecx, 1
		mov		eax, [edi]
		
		cmp		eax, 0
		jge		isPositive1
		
	isNegative1:
		push	edi
		push	esi
		call	makeNegative
		add		esi, TYPE BYTE

	isPositive1:
		
		mov		ebx, 1
		push	ecx
		mov		ecx,0
		

	;get the tens place of the leftmost digit
	getCount:	
	;make divisor 10^n ebx: 1, 10, 100, 1000...
		mov		edx, 0
		mov		eax, ebx
		mov		ebx, 10
		imul	ebx
	;ebx=10^n
		mov		ebx, eax

		;eax equals array value in edi
		
		mov		eax, [edi]
		
		div		ebx
	;if dividend is zero then we are above the number of values in the number

		cmp		eax, 0
		je		AddToArray
		add		ecx, 1
		jmp		getCount
	
	AddToArray:
		add		ecx, 1
		push	ecx
		push	ebx
		push	edi
		push	esi
	;Convert numeric back to digit
		call	getdigits
	
	;move esi back to beginning of array
		mov		esi, [ebp+12]
	
	;output digit as string
		displayString	esi, ecx
		mov		edx, [ebp+28]
		call	WriteString
		mov		edx, 0
		
	;gets store negative multiplier
		pop		ebx
		mov		eax, [edi]
		imul	ebx
		mov		[edi], eax
		
	;go to next value in the Average array values
		add		edi, TYPE DWORD
		pop		ecx
		LOOP	AvgArrLoop
		popad
		pop	ebp
		ret 24
WriteVal	EndP

;****************************************************************************************************************
;makeNegative: returns if a integer should be converted to a negative value or a postive value.
; makes value positive temporarily for division purposes later on.
;Recieves:	address of integer array and address of average array
;Returns: ecx as negative one for multiplier
;PreConditions: Must be passed offset of two arrays
;PostConditions: ecx=-1 if negative
;Registers changed: ecx
;***************************************************************************************************************
makeNegative Proc
		push	ebp
		mov		ebp, esp
		
		push	eax
		push	ebx
		push	edx
		push	esi
		push	edi


		mov		edi,[ebp+12]
		mov		esi,[ebp+8]
	

	;mov	numeric value into eax
		mov		eax,[edi]
		
	;clear	edx
		mov		edx, 0
		mov		ebx, -1
	
	;mulitply current value by negative one
		imul	ebx
	
	;move positive value into edi
		mov		[edi], eax
	
	;start array with negative sign and adjust esi
		mov		al,	45
	
	;make first value of digit array '-'
		mov		[esi],	al
		mov		ecx, -1
		
		pop		edi
		pop		esi
		pop		edx
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
makeNegative EndP


;****************************************************************************************************************
;getDigits: Convert numeric back to digit 
;Recieves:	Count of digits, number to divide by to get values (10^n) , average array address, integer array address
;Returns: N/A
;PreConditions: two values (count of digits in number and divisor), two addresses of arrays
;PostConditions: converts numeric value to digit and is store in integer array address
;Registers changed: N/A
;***************************************************************************************************************
getdigits Proc
		push	ebp
		mov		ebp, esp
		pushad
		mov		ecx,[ebp+20]
		mov		ebx,[ebp+16]
		mov		edi,[ebp+12]
		mov		esi,[ebp+8]
	
		mov		eax, [edi]
		push	eax
		mov		eax, 0
	
	L1:
	;adjust divisor
		mov		eax, ebx
		mov		edx, 0
		mov		ebx, 10
		div		ebx
	
		mov		ebx, eax
		mov		eax, [edi]	
	
		div		ebx
	;move remainder from division into edi
		mov		[edi], edx
	;add 48 to the dividend
		add		al ,48
		mov		[esi], al
		
	;increment esi
		add		esi, TYPE BYTE
	
		LOOP	L1
	
	;restore value of edi back into the array
		pop		eax
		mov		[edi], eax
		
		popad
		pop		ebp
		ret		16
getdigits EndP


;****************************************************************************************************************
;inititalizeArray: Fill array with zeros
;Recieves:	offset array, length of array by value
;Returns: N/A
;PreConditions: offset of an array, and length of an array
;PostConditions: fills array with zeros
;Registers changed: N/A
;***************************************************************************************************************
initializeArray Proc
		push	ebp
		mov		ebp, esp
		pushad
		push	ecx	
		mov		esi, [ebp+12]
		mov		ecx, [ebp+8]
		push	esi
		push	eax
		
		mov		eax, 0
	L1: 
		mov		[esi], eax
		add		esi, TYPE BYTE
		LOOP	L1

		pop		eax
		pop		esi
		pop		ecx	
		popad
		pop		ebp
		ret		8
initializeArray EndP


;****************************************************************************************************************
;getAverage: gets the average of an array
;Recieves:	offset of an array, prompt, and length of array
;Returns: N/A
;PreConditions: array filled of numbers, length of the array, prompt 
;PostConditions: outputs the average of the array to the screen
;Registers changed: N/A
;***************************************************************************************************************
getAverage Proc
	
		push	ebp
		mov		ebp, esp
		pushad
		mov		edx, [ebp+16]
		mov		ebx, [ebp+12]
		mov		edi, [ebp+8]

		call	WriteString
	
	;parameters for calcSum
		push	ebx
		push	edi
	
		mov		edx, 0
	
		;get sum of numbers
		call	calcSum
	
		;divide by count in array
		push	ebx
	
		cmp		eax, 0
		jl		negValue
		jg		posValue

	negValue:
		mov		ebx, -1
		imul	ebx
		mov		ecx,ebx
		jmp		calcAverage
	posValue:
		mov		ecx, 1
	calcAverage:
	
		pop		ebx
	
	;divide	eax (calcSum) by ebx
		div		ebx
	;save	dividend
		push	eax
	;save remainder
		push	edx
	;reset edx
		mov		edx, 0
	;move length of string into eax
		mov		eax, [ebp+12]
		mov		ebx,2
	;divide length of string by two
		div		ebx
	;if remainder is zero, even number divisble by two
		cmp		edx, 0
		je		RoundNum
		add		eax, edx
	
	RoundNum:
		pop		edx
		cmp		edx, eax
		pop		eax
		jge		AddOne
		jmp		dontRound
	AddOne:
		add		eax,1
	dontRound:
		mov		ebx, ecx
		imul	ebx

		;call	WriteInt
		;call	crlf

		mov		esi,[ebp+20]
		mov		[esi],eax

		popad
		pop		ebp
		ret	    16
getAverage EndP


;****************************************************************************************************************
;getSum outputs the sum of an array
;Recieves:	offset of an array, prompt, and length of array
;Returns: N/A
;PreConditions: array filled of numbers, length of the array, prompt 
;PostConditions: outputs the sum of the array to the screen
;Registers changed: N/A
;***************************************************************************************************************
getSUM Proc
	

		push	ebp
		mov		ebp, esp
		pushad
		
		mov		edx, [ebp+16]
		mov		ecx, [ebp+12]
		mov		edi, [ebp+8]
	

		call	crlf
		call	WriteString
		
		push	ecx
		push	edi
	;gets the sum
		call	calcSum
		mov		esi, [ebp+20]
		mov		[esi], eax
	;output sum to the screen
	
		popad
		pop		ebp
		ret		16
		;ret		12
getSUM EndP

;**************************************************************************;
;calcSum: calculates the sum of an array
;Recieves:	offset of an array, and length of array
;Returns: eax
;PreConditions: recieves address of an array of numbers and length of the array
;PostConditions: stores sum in eax
;Registers changed: eax
;**************************************************************************
calcSum	Proc
		push	ebp
		mov		ebp, esp
		push	edi
		push	ecx
		mov		ecx, [ebp+12]
		mov		edi, [ebp+8]
		push	ebx
		
		mov		eax, 0
		mov		ebx, 0
	
		L1:
		mov		ebx, [edi]
		add		eax, ebx
		add		edi, TYPE DWORD

		LOOP	L1

		pop		ebx
		pop		ecx
		pop		edi
		pop		ebp
		ret		8

calcSum EndP



;********************************************************************************************
;Main Procedure: Calls other procedures.
;Recieves:n N/A
;Returns: N/A
;********************************************************************************************

main PROC
;******************************
;*** MAIN ASSIGNMENT ***	
;******************************	
	
;***Introduction****
	push	OFFSET programmerTitle
	push	OFFSET introduction1
	push	OFFSET introduction2	
	push	OFFSET EC2
	call	Introduction
	call		crlf

;*** GET STRING FROM USER AND CONVERT TO NUMERIC ***
	push	LENGTHOF	averageArray
	push	OFFSET		averageArray
	push	OFFSET		ErrorMsg	
	push	OFFSET		getData				
	push	OFFSET		signedInteger	
	push	LENGTHOF	signedInteger			
	call	readVal
	call		crlf


;*** GET NUMERIC VALUES AND CONVERT THEM BACK TO STRING ***
	push	OFFSET		spacing
	push	OFFSET		displayNumbersMSG
	push	LENGTHOF	averageArray
	push	OFFSET		averageArray			
	push	OFFSET		signedInteger	
	push	LENGTHOF	signedInteger			
	call	WriteVal

	call		crlf	
;******** GET SUM  ********
	push	OFFSET		tempArray
	push	OFFSET		sumMSG
	push	LENGTHOF	averageArray
	push	OFFSET		averageArray
	call	getSum
	
;*** GET NUMERIC VALUES AND CONVERT THEM BACK TO STRING ***
	push	OFFSET		blanks
	push	OFFSET		blanks
	push	LENGTHOF	tempArray
	push	OFFSET		tempArray			
	push	OFFSET		signedInteger	
	push	LENGTHOF	signedInteger			
	call	WriteVal

	call		crlf
;*** GET AVERAGE ***
	push	OFFSET		tempArray
	push	OFFSET		avgMSG
	push	LENGTHOF	averageArray
	push	OFFSET		averageArray
	call	getAverage
	
;*** GET NUMERIC VALUES AND CONVERT THEM BACK TO STRING ***
	push	OFFSET		blanks
	push	OFFSET		blanks
	push	LENGTHOF	tempArray
	push	OFFSET		tempArray			
	push	OFFSET		signedInteger	
	push	LENGTHOF	signedInteger			
	call	WriteVal

;***FAREWELL MESSAGE***
	push	OFFSET farewell1
	call	Farewell

	call		crlf

	
	exit	; exit to operating system
main ENDp

; (insert additional procedures here)

END main