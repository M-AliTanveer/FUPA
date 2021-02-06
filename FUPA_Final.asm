TITLE My First Program (Test.asm)
INCLUDE Irvine32.inc
includelib winmm.lib

PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD

.data
AskSectionName byte "Enter Section Names (20 character max):",10,13, 0
AskTestName byte "Enter Quiz Name (50 characters max): ", 0
TestName byte "FAST-NU FUPA Test", 0, 32 DUP(0)
SectionStr byte "Section(s):", 0
SectionStr2 byte "Section", 0
Section1Name byte "English", 0, 12 DUP(0)
Section2Name byte "Mathematics", 0, 8 DUP(0)
Section3Name byte "Physics", 0, 12 DUP(0)
Section4Name byte "Chemistry", 0, 10 DUP(0)
Section5Name byte "Prog. Fundamentals", 0, 1 DUP(0)
QuestionNoStr byte "Question No.", 0
TimeStr byte "Total Time: ", 0
TimeStr2 byte "Time: ", 0
TimeStr3 byte "Time Left: ",0
MinutesStr byte " minutes", 0
timeOverStr byte "TIME IS UP FOR THIS SECTION!", 0
mainMenu byte "Enter a number to select:", 13, 10, 0
teacherStr byte "1. FUPA Teacher", 0
studentStr byte "2. FUPA Student", 0
StudentTeacherMenuFile byte "Student_Teacher_Menu.txt", 0
ChoiceSelectionMenuFile byte "Select_Choices_Menu.txt", 0
TeacherMenu2File byte "Teacher_Menu_2.txt", 0
StudentMenu2File byte "Student_Menu_2.txt", 0
quizcodeStr byte "Enter 8 character long Quiz Code: ", 0
quizcodeStr2 byte "Quiz code has to be 8 characters long. Please Re-enter", 13, 10, 0
quizcodeStr3 byte "Incorrect Quiz code. Try Again!", 13, 10, 0
quizcode byte 10 DUP(0)
txtStr byte 8 DUP(0), ".txt", 0
StudentTeacherMenuPrint byte 3050 DUP(0)
ChoiceSelectionMenuPrint byte 2100 DUP(0)
t_marks word ?
recordname byte "record.txt", 0
password byte "fupa1234", 0
passwordInput byte 20 DUP(0)
passwordStr byte "Enter administrator password: ", 0
incorrectPass byte "The Password you entered is incorrect. Redirecting to Main Menu.", 0
timeIsUp byte "TIME IS UP FOR THIS SECTION!", 0, "You will be allowed to answer this last question.", 0
timeStatus byte 0
wrongTimeStr byte "This quiz is not open at this time.", 0, "ACCESS DENIED!", 0
negativeMarkingStr BYTE "Enable negative marking in this quiz? [y/n]: ", 0
negativeMarkingError BYTE 0Dh, 0Ah, "Press 'y' or 'n' (lowercase) to select an option.", 0Dh, 0Ah, 0
negativeByte BYTE ?
audioFileError byte "error.wav", 0
audioFileTimeUp byte "timeup.wav", 0

Score_Card STRUCT
	score_points sdword ?
	roll_no byte 10 dup(0)
	total_marks word ?
Score_Card ENDS

scores Score_Card 20 Dup({-1, 10 dup(0) , 0})

score_msg byte "*QUIZ RESULTS*", 0
score_msg2 byte "Roll Number       Marks      Total Marks", 0

_INPUT_RECORD STRUCT
    EventType   WORD ?
    WORD ?                    ;to align to dword boundary
    UNION 
        KeyEvent              KEY_EVENT_RECORD          <>
        MouseEvent            MOUSE_EVENT_RECORD        <>
        Position WINDOW_BUFFER_SIZE_RECORD <>
        ENDS
_INPUT_RECORD ENDS

inputhandle DWORD 0
outputhandle DWORD 0
recordcount  DWORD 0
InputRecord _INPUT_RECORD <>
ConsoleMode DWORD 0
max_size COORD {120,30}
color WORD 0
timeCmp SYSTEMTIME <>

AskStartTime BYTE "Enter quiz open time. ", 0Dh, 0Ah, "Hours: ", 0, "Minutes: ", 0
AskEndTime BYTE "Enter number of hours the quiz will be open (Answer sheet will be released after this time): ", 0
StartTimeFile WORD 2 DUP(?)
EndTimeFile WORD 2 DUP(?)
StartTimeError BYTE "Invalid input for time. Try again.", 0Dh, 0Ah, 0
msg1 byte "Enter number of sections (max:5) : ", 0
msg1_support byte "You entered sections out of range (range:1-5). Please re-enter.", 0
msg2 byte "Enter number of questions per section (max:20) : ", 0
msg2_support byte "You entered the number out of range (range:1-20). Please re-enter.", 0
msg3 byte "Enter number of minutes per section (range:1-20): ", 0
msg4 byte "Enter Roll No (8 character) : ", 0
msg5 byte "Choose any option by entering the alphabet character of that option written before the options (Range: a-d).", 0Ah, "You will not be given second chance if you enter a character wrong or even out of range.", 0Ah, "GOOD LUCK", 0
msg6 byte "Double click the answer: ", 0
Score_msg3 byte "Your score is : ", 0
enterQ byte "Enter Question ", 0
enterC byte "Enter Choice : ", 0
enterA byte "Enter an alphabet pointing the right answer (a/b/c/d) : ", 0
enterA_support byte "The alphabet is not in range. (Range:a,b,c,d). Please re-enter.", 0
enterA_flag Byte ?
answerSheetLockedStr BYTE "Answer sheet is not available at this time.", 0
AnswerIsThis byte "Answer: ", 0

score sbyte ?
Roll byte 10 dup(0)
totaltime dword ?
currtime dword ?
timeleftmin dword ? ;time left
timeleftsec dword ? ;seconds left
numSections Byte ?
numQuestions Byte ?
Question1 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question2 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question3 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question4 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question5 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question6 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question7 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question8 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question9 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question10 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question11 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question12 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question13 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question14 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question15 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question16 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question17 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question18 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question19 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 1 dup(0)
Question20 Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Ah, 1 dup(0)

;This array will clean or reinitialize the array to use them on the second run.
Reinitializer Byte 100 DUP (0), 0Ah, 0Dh, 20 dup (0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Dh, 20 dup(0), 0Ah, 0Ah, 1 dup(0)

;This "offarray" is a special array, it is storing the offset of all array so we can access all the above array by just adding 4 into this array
offarray dword offset Question1, offset Question2, offset Question3, offset Question4, offset Question5, offset Question6, offset Question7, offset Question8, offset Question9, offset Question10, offset Question11, offset Question12, offset Question13, offset Question14, offset Question15, offset Question16, offset Question17, offset Question18, offset Question19, offset Question20

filename BYTE "QuizFile.txt",0
filehandle DWORD ?

;shadow array to know whats been generated and what not. indexes correspond to question numbers. any with value other than 0 has been generated
shadow byte 20 DUP(0)
;to format the choices
format byte ". ", 0

.code

QuizCodeTeacher PROC USES EAX ECX EDX EDI ESI
	call ClrScr
	mov al, 0
	mov edi, offset quizcode
	mov ecx, 10
	rep stosb
quizcodeask:
	mov edx, offset quizcodeStr
	call WriteString
	mov edx, offset quizcode
	mov ecx, 10
	call ReadString
	mov edx, offset quizcode
	call StrLength
	cmp eax, 8
	je quizcodecorrect
	mov edx, offset quizcodeStr2
	call WriteString
	jmp quizcodeask

quizcodecorrect:
	lea esi, quizcode
	lea edi, txtStr
	mov ecx, 8
	cld
	rep movsb
	mov edx, offset txtStr
	call CreateOutputFile
	mov filehandle, eax

	ret
QuizCodeTeacher ENDP

QuizCodeStudent PROC USES EAX ECX EDX ESI EDI
	call ClrScr

studentcodeask:
	mov al, 0
	mov edi, offset quizcode
	mov ecx, 10
	rep stosb

	mov edx, offset quizcodeStr
	call WriteString
	mov edx, offset quizcode
	mov ecx, 10
	call ReadString
	mov edx, offset quizcode
	call StrLength
	cmp eax, 8
	je studentcodecorrect
	mov edx, offset quizcodeStr2
	call WriteString
	jmp studentcodeask

studentcodecorrect:
	lea esi, quizcode
	lea edi, txtStr
	mov ecx, 8
	cld
	rep movsb
	mov edx, offset txtStr
	call OpenInputFile
	cmp eax, 0FFFFFFFFh
	je quizdoesnotexist
	mov filehandle, eax
	jmp _studentquizcontinue
quizdoesnotexist:
	mov edx, offset quizcodeStr3
	call WriteString
	jmp studentcodeask

_studentquizcontinue:
	ret
QuizCodeStudent ENDP

WriteNames PROC USES EAX EDX ECX		; requires an open file handle
	mov eax, filehandle
	mov ecx, 50
	mov edx, offset TestName
	call WriteToFile

	mov eax, filehandle
	mov ecx, 100
	mov edx, offset Section1Name
	call WriteToFile

	ret
WriteNames ENDP

ReadNames PROC USES EAX EDX ECX
	mov eax, filehandle
	mov ecx, 50
	mov edx, offset TestName
	call ReadFromFile

	mov eax, filehandle
	mov ecx, 100
	mov edx, offset Section1Name
	call ReadFromFile

	ret
ReadNames ENDP

AskForSectionNames PROC USES EAX ECX EDX EDI
	call ClrScr
	mov edx, offset AskSectionName
	call WriteString

	mov edx, offset Section1Name
	movzx ecx, numSections

	askSectionsLoop:
		push ecx
		mov ecx, 20
		mov al, 0
		mov edi, edx
		cld
		rep stosb
		mov ecx, 19
		call ReadString
		add edx, 20
		pop ecx
		LOOP askSectionsLoop

	call ClrScr
	ret
AskForSectionNames ENDP

PrintInMiddle PROTO, stringAddr:DWORD, lengthStr:DWORD, lineNumber:BYTE
PrintInMiddle PROC USES EAX EDX stringAddr:DWORD, lengthStr:DWORD, lineNumber:Byte	; Requires the string to be printed, its length and the line number
																					; of the line you want the string to be printed on
	call GetMaxXY
	shr dl, 1
	mov al, BYTE PTR lengthStr
	shr al, 1
	sub dl, al
	mov dh, lineNumber
	call GotoXY
	mov edx, stringAddr
	call WriteString
;	call crlf
	
	ret
PrintInMiddle ENDP

DisplayTestInfo PROC USES EAX EBX EDX ECX ESI
	call ClrScr
	mov edx, offset TestName
	call StrLength
	INVOKE PrintInMiddle, Addr TestName, eax, 2
	call crlf
	call crlf

	mov edx, offset SectionStr
	call StrLength
	INVOKE PrintInMiddle, Addr SectionStr, eax, 4
	call crlf
	movzx ecx, numSections
	mov edx, offset Section1Name
	mov bl, 5

printSectionNames:
	call StrLength
	mov esi, eax
	INVOKE PrintInMiddle, edx, esi, bl
	call crlf
	inc bl
	add edx, 20
	LOOP printSectionNames
	call crlf

	mov edx, offset TimeStr
	call StrLength
	add eax, 11
	add bl, 2
	mov esi, eax
	INVOKE PrintInMiddle, Addr Timestr, esi, bl
	mov eax, totaltime
	mul numSections
	call WriteDec
	mov edx, offset	MinutesStr
	call WriteString
	call crlf
	call crlf
	
	call WaitMsg
	call ClrScr
	ret
DisplayTestInfo ENDP

Randomizer PROC USES EAX EBX ECX
	;function used: x(index) = (2y+3)%size
	call GetMseconds ;this gets milliseconds into eax. we will be using this as our y
	shl eax, 2
	add eax, 3
	xor edx,edx ; extends the number as edx:eax so we can use divide (mov edx,0)
	movzx ebx, numQuestions ;this is num of qs
	div ebx
	mov ecx, edx ; value of x
	mov ebx, offset shadow
	add ebx, edx 
	movzx eax, byte ptr [ebx]
	cmp eax, 0
	je newnumfound
					;in the case that we get an already used question number, we perform linear probing
	finder:
		add edx, 1
		mov eax, edx
		xor edx, edx
		movzx ebx, numQuestions
		div ebx
		mov ebx, offset shadow
		add ebx, edx
		movzx eax,byte ptr [ebx]
		cmp eax, 0
		je newnumfound
		jmp finder

	newnumfound:
		;new index val is is edx
		mov shadow[edx], 10
		mov eax, edx
		mov edx, offarray[eax*4]  ;actual me ise return krna he

;offset returned in edx
ret
Randomizer ENDP

ReadSectionQuestion PROC USES EAX ECX EDX		; requires an open input filehandle
	mov eax, filehandle
	mov edx, offset numSections
	mov ecx, 1
	call ReadFromFile
	mov eax, filehandle
	mov edx, offset numQuestions
	mov ecx, 1
	call ReadFromFile
	mov eax, filehandle
	mov edx, offset totaltime
	mov ecx, 4
	call ReadFromFile
	mov eax, filehandle
	mov edx, offset StartTimeFile
	mov ecx, 4
	call ReadFromFile
	mov eax, filehandle
	mov edx, offset EndTimeFile
	mov ecx, 4
	call ReadFromFile
	mov eax, filehandle
	mov edx, offset negativeByte
	mov ecx, 1
	call ReadFromFile

	push cx
	mov cx, StartTimeFile[2]			;;;;;;;;;;;; REMOVE
	mov cx, StartTimeFile[2]
	pop cx

	ret
ReadSectionQuestion ENDP

ReadQuestions PROC USES EAX ECX EDX				; requires an open input filehandle (reads questions for one section, has to be called every section)
	mov eax, lengthof Question1
	movzx ecx, numQuestions
	mul ecx
	mov ecx, eax
	mov eax, filehandle
	mov edx, offarray
	call ReadFromFile

	ret
ReadQuestions ENDP

WriteQuestions PROC USES EAX EDX ECX			; requires an open output filehandle
	mov eax, lengthof Question1
	mul numQuestions
	mov ecx, eax
	mov eax, filehandle
	mov edx, offarray
	call WriteToFile
	jc show_error_file
	ret
show_error_file:
	call WriteWindowsMsg
	ret
WriteQuestions ENDP

WriteSectionQuestion PROC USES EAX EDX ECX		; requires an open output filehandle (writes questions for one section, is called every section in MakeTest)
	mov eax, filehandle
	mov edx, offset numSections
	mov ecx, 1
	call WriteToFile
	mov eax, filehandle
	mov edx, offset numQuestions
	mov ecx, 1
	call WriteToFile
	mov eax, filehandle
	mov edx, offset totaltime
	mov ecx, 4
	call WriteToFile
	mov eax, filehandle
	mov edx, offset StartTimeFile
	mov ecx, 4
	call WriteToFile
	mov eax, filehandle
	mov edx, offset EndTimeFile
	mov ecx, 4
	call WriteToFile
	mov eax, filehandle
	mov edx, offset negativeByte
	mov ecx, 1
	call WriteToFile

	push cx
	mov cx, StartTimeFile[2]			;;;;;;;;;;;; REMOVE
	mov cx, StartTimeFile[2]
	pop cx

	ret
WriteSectionQuestion ENDP

Reinitialize PROC USES ECX EBX ESI EDI

movzx ecx, numQuestions
mov ebx, offset offarray
L1:
	push ecx
	cld
	mov ecx, lengthof Reinitializer
	mov edi, [ebx]
	mov esi, offset Reinitializer
	rep movsb
	pop ecx
	add ebx, 4
loop L1

ret
Reinitialize ENDP

ChoiceLimiter PROC

	mov enterA_flag, 0
	cmp al, 'a'
	jz quit
	cmp al, 'b'
	jz quit
	cmp al, 'c'
	jz quit
	cmp al, 'd'
	jz quit
mov enterA_flag, 1

quit:
	ret
ChoiceLimiter ENDP

AskForTestName PROC USES EDX ECX
	call ClrScr
	mov edx, offset AskTestName
	call WriteString
	mov edx, offset TestName
	mov ecx, 50
	call ReadString

	ret
AskForTestName ENDP

AskStartEndTime PROC USES eax ebx ecx edx
	call clrscr

startLabel1:
	mov edx, offset AskStartTime
	call writestring
	call ReadDec
	cmp eax, 24
	jae StartError1
	mov StartTimeFile, ax
	jmp startLabel2
	StartError1:
		mov edx, offset StartTimeError
		call writestring
		jmp startLabel1
startLabel2:
	mov edx, offset AskStartTime
	add edx, 32
	call writestring
	call ReadDec
	cmp eax, 60
	jae StartError2
	mov StartTimeFile[2], ax
	jmp endLabel1
	StartError2:
		mov edx, offset StartTimeError
		call writestring
		jmp startLabel2

	call crlf
endLabel1:
	mov edx, offset AskEndTime
	call writestring
	call ReadDec
	cmp eax, 0
	je endError1
	mov ebx, 24
	sub bx, StartTimeFile
	sub bx, ax
	jz endError1
	mov bx, StartTimeFile
	mov EndTimeFile, bx
	add EndTimeFile, ax
	mov bx, StartTimeFile[2]
	mov EndTimeFile[2], bx
	jmp _continueTime
	endError1:
		lea edx, StartTimeError
		call writestring
		jmp endLabel1

_continueTime:
	ret
AskStartEndTime ENDP

AskNegativeMarking PROC USES EAX EDX
	call clrscr
_negativeMarkLabel:
	mov edx, offset negativeMarkingStr
	call WriteString
	call ReadChar
	cmp al, "y"
	je _negativeMarkProceed
	cmp al, "n"
	je _negativeMarkProceed
	mov edx, offset negativeMarkingError
	call WriteString
	jmp _negativeMarkLabel

_negativeMarkProceed:
	mov negativeByte, al

	ret
AskNegativeMarking ENDP

MakeTest PROC USES EAX EBX ECX EDX ESI
	LOCAL QuestionCount:BYTE			; for writing question number

	call AskForTestName					; asking for the name of test
start:
	mov esi, offset Section1Name		; for writing the name of section the question will be put in
	mov edx, offset msg1
	call WriteString		;you will be asked for number of sections
	mov eax, 0
	call ReadDec			;you will input
	cmp al, 0
	je __notZero1
	cmp al, 5				;it will check the number of section with the max number of section
	jbe _storesection			;if it is below or equal to max, it will proceed, otherwise, will be ask to re-enter again
	__notZero1:
	mov edx, offset msg1_support
	call WriteString
	call Crlf
	jmp start				;after the telling the problem with your input, you will be moved to start.
	
	_storesection:
		mov numSections, al

	_proceed:
		mov edx, offset msg2
		call WriteString		;you will be asked for the number of questions
		mov eax, 0
		call ReadDec			;you will input
		cmp al, 0
		je __notZero2
		cmp al, 20				;it will check the number of questions with the max number of question
		jbe _storequestions			;if it is below or equal to the max number, it will proceed, otherwise, will be ask to re-enter again
		__notZero2:
		mov edx, offset msg2_support
		call WriteString
		call Crlf
		jmp _proceed			;it will lead to enter the number of question.

	_storequestions:
		mov numQuestions, al

	_proceed1:
		mov edx, offset msg3
		call WriteString			; you will be asked for the number of minutes per section
		mov eax, 0
		call ReadDec
		cmp al, 0
		je __notZero3
		cmp al, 20
		jbe _proceed2
		__notZero3:
		mov edx, offset msg2_support
		call WriteString
		call Crlf
		jmp _proceed1


	_proceed2:
		mov totaltime, eax
		call AskStartEndTime		; asking for the quiz open/close timings by umer
		call AskNegativeMarking		; asking for enable/disable negative marking by umer
		call WriteSectionQuestion	; Added by Umer to write the number of sections and questions to start of file
		call AskForSectionNames		; asking for name of sections
		call WriteNames				; writing test name and section names to file

	movzx ecx, numSections
	_for1:
		mov QuestionCount, 1		; for writing question number
		mov ebx, offset offarray	;the offset of first question stored in ebx taken from the array of offsets, It will also bring to the first question for the second section
		push ecx
		movzx ecx, numQuestions
		_for2:
			push ecx
			
			call clrscr				;The screen will be cleared for every new question
			
			INVOKE PrintInMiddle, Addr SectionStr2, lengthof SectionStr2-1, 0		; writing the name of section on top of the page
			push eax
			mov edx, esi
			call StrLength
			INVOKE PrintInMiddle, esi, eax, 1
			call Crlf
			pop eax
			
			mov edx, offset enterQ
			call WriteString		;You will be asked to enter the question

			push eax
			movzx eax, QuestionCount	; writing the question number
			call WriteDec
			pop eax
			inc QuestionCount
			call crlf

			mov edx, [ebx]
			mov ecx, 98				;the first 100 bytes are allocated for question
			call ReadString
			
			mov edx, offset enterC		;After entering the question, you will be asked to enter four choices
			call WriteString
			mov edx, [ebx]
			add edx, 102			;Since everything related to the question is getting stored in a single array, we formatted those array with a pattern, after 100 bytes, there are two for nextline '\n' feed and return carriage '\r' so that cursor moves to te beginning of next line
			mov ecx, 19				;20 bytes allocated for each choice
			call ReadString
			
			mov edx, offset enterC
			call WriteString			;Choice # 2
			mov edx, [ebx]
			add edx, 124				;offset of the position allocated for choice 2
			mov ecx, 19
			call ReadString
			
			mov edx, offset enterC		;Choice # 3
			call WriteString
			mov edx, [ebx]
			add edx, 146
			mov ecx, 19
			call ReadString
			
			mov edx, offset enterC		;Choice # 4
			call WriteString
			mov edx, [ebx]
			add edx, 168
			mov ecx, 19
			call ReadString
			
		AnswerChoice:
			mov edx, offset enterA		;prompt
			call WriteString
			mov edx, [ebx]
			add edx, 190			;Answer's byte
			mov eax, 0
			call ReadChar		;Since ReadChar doesn't echo the read character to the console
			call WriteChar		;It will be good to write that read character in the console :)
			call ChoiceLimiter
			cmp enterA_flag, 1
			jz _dothis
			mov [edx], al
			call Crlf
			jmp _proceed3
			_dothis:
				call crlf
				mov edx, offset enterA_support
				call WriteString
				call crlf
				jmp AnswerChoice

			_proceed3:
				add ebx, 4		;The offset for the next question array
				mov ecx, 0		;I like to clear the register before working with those, co-op with me
				pop ecx
				dec ecx			;The loop incrementer is popped and decremented, there's a reason for the decrement, in the next line comment
		
		jnz _for2		;The ideal and the first idea was to loop this process using loop, but loop is used for short jumps, so I have to use jnz
		
		call WriteQuestions		; Added by Umer to write questions to file for this section
		
		call Reinitialize		;This instruction will clean the array, put your filing work before this
		add esi, 20
		pop ecx
		dec ecx
	jnz _for1			;same reason for this jnz

;	mov ecx, lengthof Question1
;	mov esi, offset Question1
;	mov edi, type Question1
;	call DumpMem
;
;	mov ecx, lengthof Question2
;	mov esi, offset Question2
;	mov edi, type Question2
;	call DumpMem

ret
MakeTest ENDP

DisplaySectionInfo PROC USES EDX EAX
	call ClrScr
	mov edx, offset SectionStr2
	call StrLength
	INVOKE PrintInMiddle, Addr SectionStr2, eax, 4
	call crlf

	mov edx, esi
	call StrLength
	INVOKE PrintInMiddle, edx, eax, 5
	call crlf

	mov edx, offset TimeStr2
	call StrLength
	add eax, 10
	INVOKE PrintInMiddle, Addr TimeStr2, eax, 7
	mov eax, totaltime
	call WriteDec
	mov edx, offset MinutesStr
	call WriteString
	call Crlf
	call Crlf
	call Crlf

	call WaitMsg
	ret
DisplaySectionInfo ENDP

TimeChecker PROC USES EAX EBX ECX EDX 
	LOCAL timespent:DWORD, minutes:DWORD, seconds:DWORD
mov eax,0
call getMseconds
mov timespent,eax
mov ebx, timespent
sub ebx, currtime
mov ecx, timespent
mov currtime, ecx
mov eax,ebx
xor edx,edx
mov ecx,1000
div ecx ;turned milliseconds into seconds
mov seconds, eax
mov eax, seconds
xor edx,edx
mov ecx,60
div ecx ;turned seconds into minutes
mov minutes, eax
mov seconds, edx
mov ebx, timeleftsec
mov ecx, 60
sub ecx, ebx
add ecx, seconds

cmp ecx, 60 ;maybe seconds are over 60 indicating a minute just by sum of seconds
jb notgreat
	inc minutes
	sub ecx, 60
	
	mov ebx, timeleftmin
	cmp ebx, minutes
	jae notgreat
	mov ecx,60
	
notgreat:
	mov ebx, 60
	sub ebx, ecx
	mov timeleftsec,ebx

	cmp ebx, 60
	jb returner
		sub ebx, 60
		mov timeleftsec,ebx
		dec minutes


returner:
mov ebx, timeleftmin
cmp ebx, minutes
ja subtractallowed
mov timeleftmin,0
jmp returning

subtractallowed:
	sub ebx, minutes
	mov timeleftmin,ebx

returning:
ret
TimeChecker ENDP

TakeTest PROC USES EAX EBX ECX EDX ESI EDI
	LOCAL QuestionNumber:BYTE

call clrscr
mov esi, offset Section1Name
askrollagain:
mov edx, offset msg4				; asking for roll number
call WriteString
mov edx, offset Roll		
mov ecx, 9
call ReadString
cmp eax, 8
jne askrollagain
call clrscr
call ReadSectionQuestion
call ReadNames

; comparing start and end time with current time by umer

INVOKE GetSystemTime, Addr timeCmp	; getting current time in UTC format
add timeCmp.wHour, 5				; making it to local Paskitan Time (UTC +5)
push dx								; checking if test is being taken at correct time

mov dx, timeCmp.wHour
cmp dx, StartTimeFile
jb wrongTime						; if current time is before starting time of quiz, error
cmp dx, EndTimeFile
ja wrongTime						; if current time is after ending time of quiz, error

mov dx, timeCmp.wHour
cmp dx, StartTimeFile
jne _endMinuteCheck
mov dx, timeCmp.wMinute				; comparing minutes (basically same as the hour)
cmp dx, StartTimeFile[2]
jb wrongTime
jmp _timeCorrect

_endMinuteCheck:
	mov dx, timeCmp.wHour
	cmp dx, EndTimeFile
	jne _timeCorrect
	mov dx, timeCmp.wMinute
	cmp dx, EndTimeFile[2]
	ja wrongTime
	jmp _timeCorrect

wrongTime:							; display error if attempting quiz at wrong time and returning back to main
	pop dx
	INVOKE PlaySound, offset audioFileError, NULL, 00020000h
	mov edx, offset wrongTimeStr
	mov ebx, edx
	add ebx, 36
	call MsgBox
	ret
	
_timeCorrect:						; continuing if within the defined time
pop dx							; comparing time over
call DisplayTestInfo

mov score, 0
movzx ecx, numSections
_QuestionLoop1:
	call ReadQuestions
	;Enter the file reading part here, we will be getting all questions of a single section in a discussed format in the arrays.
	call DisplaySectionInfo

	push eax				; getting the current time for the timer
	mov eax,0
	call getMseconds
	mov currtime,eax
	push totaltime
	pop timeleftmin
	mov timeleftsec, 0
	pop eax
	
	mov QuestionNumber, 1
	mov timeStatus, 0
	push ecx
	movzx ecx, numQuestions
	_QuestionLoop2:
		call ClrScr
		push ecx
		
		INVOKE PrintInMiddle, Addr SectionStr2, lengthof SectionStr2-1, 0		; writing the name of section on top of the page
		push eax
		mov edx, esi
		call StrLength
		INVOKE PrintInMiddle, esi, eax, 1

		push eax
		mov eax, white+(red*16)
		call SetTextColor
		pop eax
		mov edx, offset TimeStr3												; writing the time remaining for this section
		call StrLength
		add eax, 5
		INVOKE PrintInMiddle, Addr TimeStr3, eax, 3
		mov eax, timeleftmin
		call writedec
		mov al, ':'
		call writechar
		cmp timeleftsec, 10
		jae _noZeroAdded
		mov eax, 0
		call WriteDec
	_NoZeroAdded:
		mov eax, timeleftsec
		call writedec
		call Crlf
		call Crlf
		pop eax
		push eax
		mov eax, white+(black*16)
		call SetTextColor
		pop eax

		mov edx, offset QuestionNoStr
		call WriteString		;You will be asked to enter the question

		push eax
		movzx eax, QuestionNumber	; writing the question number
		call WriteDec
		mov al, ":"
		call WriteChar
		mov al, " "
		call WriteChar
		pop eax
		inc QuestionNumber

;		mov edx, offset msg5
;		call WriteString
;		call Crlf
		call Randomizer		;called the randomizer (made by Ali) which will return the offset of a question in edx
		mov ebx, edx
		call WriteString	;which will then print.
		call Crlf		;idk for sure, that the array will have the \n char, that's why adding this, remove it if looks out of format
		call crlf
		
		mov al, 'a'
		call WriteChar
		mov edx, offset format
		call WriteString		;so that it will look like this:	a. choice is here. \n b. Choice is here and so on...
		mov edx, ebx
		add edx, 102
		call WriteString	;Write Choice # 1
		call crlf

		inc al
		call WriteChar
		mov edx, offset format
		call WriteString
		mov edx, ebx
		add edx, 124
		call WriteString	;	Write Choice # 2
		call Crlf

		inc al
		call WriteChar
		mov edx, offset format
		call WriteString
		mov edx, ebx
		add edx, 146
		call WriteString	;Write Choice # 3
		call Crlf

		inc al
		call WriteChar
		mov edx, offset format
		call WriteString
		mov edx, ebx
		add edx, 168
		call WriteString	;Write Choice # 4
		call Crlf

		call Crlf
	AnswerChoice2:
		mov edx, offset msg6
		call WriteString		;You will be asked to enter the answer
		mov eax, 0
		call crlf
		call Choice_Selection_Menu
		
		call Get_Student_Input ; returns in al (mouse implementation)

		call ChoiceLimiter
		cmp enterA_flag, 1
		jz _dothis2
		call Crlf
		jmp _AnswerCompare
		_dothis2:
			call crlf
			mov edx, offset enterA_support
			call WriteString
			call crlf
			jmp AnswerChoice2
	
	_AnswerCompare:
		mov edx, ebx
		add edx, 190
		cmp al, [edx]		;The character you read will be compared to the last byte of Question array
		jne scoredec		;if not correct, go to score decrementer label
		add score, 2		;if answer is correct, score will be incremented by 2
		jmp here

		scoredec:
			cmp negativeByte, "n"
			je here
			dec score

		here:
			push eax
			push ecx
			call timechecker			; checking the remaining time
			mov ecx, timeleftmin
			mov eax, timeleftsec
			add eax, ecx
			cmp eax, 0
			je _NoTimeLeft
			pop ecx
			pop eax

			pop ecx
			dec ecx
	jnz _QuestionLoop2
	jmp _timeleft

_NoTimeLeft:
	pop ecx
	pop eax
	pop ecx
	call clrscr
	push eax
	mov edx, offset timeOverStr
	call StrLength
	INVOKE PrintInMiddle, Addr timeOverStr, eax, 4
	mov eax, 2000
	call Delay
	pop eax

_timeleft:	
	add esi, 20
	push ecx
	mov edi, offset shadow
	mov ecx, 20
	mov al, 0
	cld
	rep stosb
	pop ecx

	pop ecx
	dec ecx
jnz _QuestionLoop1

call clrscr
mov edx, offset score_msg3
call WriteString			;Your score is : score
cmp score, 0
jge _positive
mov score, 0

_positive:
movzx eax, score
call WriteDec
call crlf
call crlf

movzx eax, numSections		; storing total marks in t_marks
mul numQuestions
push ecx
mov ecx, 2
mul ecx
pop ecx
mov t_marks, ax

call RecordFiler
call WaitMsg

	; GIVING OPTION TO CHECK ANSWER SHEET by umer
	mov eax, filehandle
	call CloseFile
	call CheckAnswerSheet		

ret
TakeTest ENDP

CheckAnswerSheet PROC						; checking if student is allowed to access answer sheet at this point
	call clrscr
	call Student_Menu_2
_checkAnswersLoop:
	call Get_Initial_Choice

	cmp eax, 1
	jne _gotomain
	INVOKE GetSystemTime, Addr timeCmp
	add timeCmp.wHour, 5
	mov dx, EndTimeFile
	cmp timeCmp.wHour, dx
	jb _notAllowedYet
	ja _seeAnswerSheet
	mov dx, EndTimeFile[2]
	cmp timeCmp.wMinute, dx
	jb _notAllowedYet

_seeAnswerSheet:
	mov edx, offset txtStr
	call OpenInputFile
	mov filehandle, eax
	call ReadSectionQuestion
	mov eax, filehandle
	call ReadNames
	movzx ecx, numSections
	mov esi, offset Section1Name

AnswerSheetLoop:
	call clrscr
	INVOKE PrintInMiddle, Addr SectionStr2, lengthof SectionStr2-1, 0		; writing the name of section on top of the page
	mov edx, esi
	call StrLength
	INVOKE PrintInMiddle, esi, eax, 1
	call crlf

	call ReadQuestions		; reading questions for each section from file
	push ecx
	movzx ecx, numQuestions
	mov ebx, 0

	AnswerSheetLoop2:
		call crlf
		mov al, bl
		inc al
		call WriteDec
		mov al, "."
		call WriteChar
		mov al, " "
		call WriteChar
		mov edi, offarray[ebx*4]
		mov edx, edi
		call WriteString
		call crlf
		mov edx, offset AnswerIsThis
		call WriteString
		add edi, 190
		mov al, [edi]
		call WriteChar
		call crlf

		inc ebx
		LOOP AnswerSheetLoop2

	pop ecx
	call crlf
	call WaitMsg
	add esi, 20
	dec ecx
	cmp ecx, 0
	jne AnswerSheetloop
	jmp _gotomain

_notAllowedYet:
	INVOKE PlaySound, offset audioFileError, NULL, 00020000h
	mov edx, offset answerSheetLockedStr
	mov ebx, offset wrongTimeStr
	add ebx, 36
	call MsgBox
	jmp _checkAnswersLoop

_gotomain:
	ret
CheckAnswerSheet ENDP

Student_Teacher_Colour PROC USES EAX ECX ESI
	mov ecx, 244
	mov esi, offset StudentTeacherMenuPrint
	cld
	colourloop1:
		lodsb
		call WriteChar
		LOOP colourloop1

	mov ecx, 21
outercolourloop:
	push ecx
	mov eax, lightblue+(black*16)
	call SetTextColor
	mov ecx, 60
	colourloop2:
		lodsb
		call WriteChar
		LOOP colourloop2

	mov eax, white+(black*16)
	call SetTextColor
	lodsb
	call WriteChar

	mov eax, lightred+(black*16)
	call SetTextColor
	mov ecx, 61
	colourloop3:
		lodsb
		call WriteChar
		LOOP colourloop3
	pop ecx
	LOOP outercolourloop

	mov eax, white+(black*16)
	call SetTextColor
	mov ecx, 244
	colourloop4:
		lodsb
		call WriteChar
		LOOP colourloop4

	ret
Student_Teacher_Colour ENDP

Teacher_Menu_Colour PROC USES EAX ECX ESI
	mov ecx, 244
	mov esi, offset StudentTeacherMenuPrint
	cld
	colourloop11:
		lodsb
		call WriteChar
		LOOP colourloop11

	mov ecx, 21
outercolourloop1:
	push ecx
	mov eax, lightmagenta+(black*16)
	call SetTextColor
	mov ecx, 60
	colourloop22:
		lodsb
		call WriteChar
		LOOP colourloop22

	mov eax, white+(black*16)
	call SetTextColor
	lodsb
	call WriteChar

	mov eax, lightgreen+(black*16)
	call SetTextColor
	mov ecx, 61
	colourloop33:
		lodsb
		call WriteChar
		LOOP colourloop33
	pop ecx
	LOOP outercolourloop1

	mov eax, white+(black*16)
	call SetTextColor
	mov ecx, 244
	colourloop44:
		lodsb
		call WriteChar
		LOOP colourloop44

	ret
Teacher_Menu_Colour ENDP

Student_Teacher_Menu PROC USES EAX EDX ECX
	LOCAL tempFileHandle:DWORD

	call clrscr
	mov edx, offset StudentTeacherMenuFile
	call OpenInputFile
	mov tempFileHandle, eax
	mov ecx, 3050
	mov edx, offset StudentTeacherMenuPrint
	mov eax, tempFileHandle
	call ReadFromFile
	call Student_Teacher_Colour
	mov eax, tempFileHandle
	call CloseFile

	ret
Student_Teacher_Menu ENDP

Teacher_Menu_2 PROC USES EAX EDX ECX
	LOCAL tempFileHandle2:DWORD

	call clrscr
	mov edx, offset TeacherMenu2File
	call OpenInputFile
	mov tempFileHandle2, eax
	mov ecx, 3050
	mov edx, offset StudentTeacherMenuPrint
	mov eax, tempfileHandle2
	call ReadFromFile
	call Teacher_Menu_Colour
	mov eax, tempFileHandle2
	call CloseFile

	ret
Teacher_Menu_2 ENDP

Student_Menu_Colour PROC USES EAX ECX ESI
	mov ecx, 244
	mov esi, offset StudentTeacherMenuPrint
	cld
	colourloop11:
		lodsb
		call WriteChar
		LOOP colourloop11

	mov ecx, 21
outercolourloop1:
	push ecx
	mov eax, yellow+(black*16)
	call SetTextColor
	mov ecx, 60
	colourloop22:
		lodsb
		call WriteChar
		LOOP colourloop22

	mov eax, white+(black*16)
	call SetTextColor
	lodsb
	call WriteChar

	mov eax, red+(black*16)
	call SetTextColor
	mov ecx, 61
	colourloop33:
		lodsb
		call WriteChar
		LOOP colourloop33
	pop ecx
	LOOP outercolourloop1

	mov eax, white+(black*16)
	call SetTextColor
	mov ecx, 244
	colourloop44:
		lodsb
		call WriteChar
		LOOP colourloop44

	ret
Student_Menu_Colour ENDP

Student_Menu_2 PROC USES EAX EDX ECX
	LOCAL tempFileHandle3:DWORD

	call clrscr
	mov edx, offset StudentMenu2File
	call OpenInputFile
	mov tempFileHandle3, eax
	mov ecx, 3050
	mov edx, offset StudentTeacherMenuPrint
	mov eax, tempfileHandle3
	call ReadFromFile
	call Student_Menu_Colour
	mov eax, tempFileHandle3
	call CloseFile

	ret
Student_Menu_2 ENDP

Choice_Selection_Menu PROC USES EAX EDX ECX
	LOCAL tempFileHandle2:DWORD
	
	mov edx, offset ChoiceSelectionMenuFile
	call OpenInputFile
	mov tempFileHandle2, eax
	mov ecx, 2100
	mov edx, offset ChoiceSelectionMenuPrint
	mov eax, tempFileHandle2
	call ReadFromFile
	mov eax, lightcyan+(black*16)						; setting background and forground for options
	call SetTextColor
	mov edx, offset ChoiceSelectionMenuPrint
	call WriteString
	mov eax, tempFileHandle2
	call CloseFile
	mov eax, white+(black*16)						; resetting the colours to black and white
	call SetTextColor

	ret
Choice_Selection_Menu ENDP

Get_Initial_Choice PROC USES EBX EDX
	mov eax, 0090h         ;ENABLE_MOUSE_INPUT | DISABLE_QUICK_EDIT_MODE 
	invoke SetConsoleMode, inputhandle, eax
	input_loop:
	invoke ReadConsoleInput,inputhandle,ADDR InputRecord,1,ADDR recordcount
	cmp InputRecord.MouseEvent.dwEventFlags, 0002h 
	jne input_loop
	call GetMaxXY
	shr dx,1
	cmp InputRecord.Position.dwSize.X, dx
	jbe goto_teacher
	mov ebx, 2
	jmp done
	goto_teacher:
	mov ebx, 1

	done:

	mov eax, ConsoleMode
	invoke SetConsoleMode, inputhandle, eax
	mov eax,ebx
	ret
Get_Initial_Choice ENDP

timeprintproc PROC USES EAX EDX
		call timechecker
        mov eax, white+(red*16)
        call SetTextColor
        mov edx, offset TimeStr3                                                ; writing the time remaining for this section
        call StrLength
        add eax, 5
        INVOKE PrintInMiddle, Addr TimeStr3, eax, 3
        mov eax, timeleftmin
        call writedec
        mov al, ':'
        call writechar
        cmp timeleftsec, 10
        jae _noZeroAdded_2
        mov eax, 0
        call WriteDec
_NoZeroAdded_2:
        mov eax, timeleftsec
        call writedec
        mov eax, white+(black*16)
        call SetTextColor
		mov eax, timeleftmin
		add eax, timeleftsec
		cmp eax, 0
		jne _timeremaining
		cmp timeStatus, 1
		je _timeremaining
		INVOKE PlaySound, offset audioFileTimeUp, NULL, 00020000h
		mov ebx, offset timeIsUp
		mov edx, ebx
		add edx, 29
		call MsgBox					; opening message box for time up string at time = 0
		mov timeStatus, 1

_timeremaining:
		ret
timeprintproc ENDP

Get_Student_Input PROC USES EBX
	LOCAL counter:DWORD

	mov eax, 0090h         ;ENABLE_MOUSE_INPUT | DISABLE_QUICK_EDIT_MODE 
	invoke SetConsoleMode, inputhandle, eax
	input_loop_student:
	call getMseconds
	sub eax, currtime
	mov counter, eax
	cmp counter, 1000
	jb __inputinvoke
	call timeprintproc
__inputinvoke:
	invoke ReadConsoleInput,inputhandle,ADDR InputRecord,1,ADDR recordcount
	cmp InputRecord.MouseEvent.dwEventFlags, 0002h 
	jne input_loop_student
	cmp InputRecord.Position.dwSize.X, 60
	ja its_B_D
	cmp InputRecord.Position.dwSize.Y, 22
	jb its_A
	mov al, 'c'
	jmp end_of_func
	its_A:
	cmp InputRecord.Position.dwSize.Y, 14
	jb input_loop_student
	mov al, 'a'
	jmp end_of_func
	its_B_D:
	cmp InputRecord.Position.dwSize.Y, 22
	jb its_B
	mov al, 'd'
	jmp end_of_func
	its_B:
	cmp InputRecord.Position.dwSize.Y, 14
	jb input_loop_student
	mov al, 'b'
	jmp end_of_func

	end_of_func:
	mov bl,al
	mov eax, ConsoleMode
	invoke SetConsoleMode, inputhandle, eax
	mov al,bl
	ret
Get_Student_Input ENDP

RecordFiler PROC USES EAX EBX ECX EDX ESI EDI
	LOCAL recordHandle: DWORD

	mov edx, offset recordname
	call OpenInputFile
	mov recordHandle, eax
	mov ecx, 320
	mov edx, offset scores
	call ReadFromFile

	;movzx scores.score_points, score
	mov edx, offset scores

	mov ecx, 20
	comparer:
		mov eax, [edx]
		add edx, type scores
		cmp eax, -1
		je out_comparer
	loop comparer

	out_comparer:
		sub edx, type scores
		movzx eax, score
		mov [edx], eax
		add edx, 4
		Invoke str_copy, ADDR roll, edx
		add edx, 10
		mov ax, t_marks
		mov [edx], ax

	mov eax, recordHandle
	call CloseFile

	mov edx, offset recordname
	call CreateOutputFile
	mov recordHandle, eax
	mov ecx, 320
	mov edx, offset scores
	mov eax, recordHandle
	call WritetoFile

	mov eax, recordHandle
	call CloseFile

	ret
RecordFiler ENDP

RecordReader PROC USES EAX EBX ECX EDX ESI EDI
	LOCAL recordHandle: DWORD
	call clrscr
	mov edx, offset recordname
	call OpenInputFile
	mov recordHandle, eax
	mov ecx, 320
	mov edx, offset scores
	call ReadFromFile
	mov eax, recordHandle
	call CloseFile

	INVOKE PrintInMiddle, Addr score_msg, lengthof score_msg-1, 1
	;mov edx, offset score_msg
	;call WriteString
	call Crlf
	call Crlf
	mov edx, offset score_msg2
	call WriteString
	call Crlf
	call crlf

	mov esi, offset scores
	mov ecx, 20
	printer:
		mov eax, [esi]
		cmp eax, -1
		je out_printer
		add esi, 4
		mov edx, esi
		call WriteString
		push ecx
		mov ecx, 10
	
		spaceloop1:
			mov al, " "
			call WriteChar
		loop spaceloop1

		pop ecx
		sub esi, 4
		mov eax, [esi]
		call WriteDec
		push ecx
		mov ecx, 10
	
		spaceloop2:
			mov al, " "
			call WriteChar
		loop spaceloop2

		pop ecx
		add esi, 14
		mov eax, 0
		mov ax, [esi]
		call WriteDec
		call Crlf
		add esi, 2

	loop printer

	out_printer:
		call crlf
		call WaitMsg
		ret
RecordReader ENDP

ResultsOrMake PROC
	call Get_Initial_Choice
	ret
ResultsOrMake ENDP

main PROC
_AskMakeOrTake:
	push eax
	mov eax, white+(black*16)
	call SetTextColor
	pop eax
	call Student_Teacher_Menu	
	
	invoke GetStdHandle,STD_INPUT_HANDLE					; setting up mouse implementation
	mov inputhandle,eax
	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov outputhandle, eax
	invoke SetConsoleScreenBufferSize, eax, max_size
	invoke GetConsoleMode, inputhandle, ADDR ConsoleMode
	mov eax, ConsoleMode
	call Get_Initial_Choice ;returns in eax

	cmp al, 1
	je _MakeTestLabel
	cmp al, 2
	je _TakeTestLabel
	call clrscr
	jmp _AskMakeOrTake

_MakeTestLabel:
	call clrscr
	mov edx, offset passwordStr				; asking for password
	call WriteString
	mov edx, offset passwordInput
	mov ecx, 19
	call ReadString
	mov esi, offset password
	mov edi, offset passwordInput			
	mov edx, edi
	call StrLength
	mov ebx, eax
	mov edx, esi
	call StrLength							; comparing password length first
	cmp eax, ebx
	jne _incorrectPass
	mov ecx, 8
	cld
	repe cmpsb								; comparing password
	jne _incorrectPass
	call Teacher_Menu_2
	call ResultsOrMake
	cmp al, 1
	je _seeallrecords
	cmp al, 2
	je _maketestlabel2
_seeallrecords:
	call RecordReader
	jmp _AskMakeOrTake
_incorrectPass:							; sending to main menu if password incorrect
	INVOKE PlaySound, offset audioFileError, NULL, 00020000h
	mov edx, offset IncorrectPass
	mov ebx, offset wrongTimeStr
	add ebx, 36
	call MsgBox
	jmp _AskMakeOrTake

_maketestlabel2:
	call QuizCodeTeacher

	call MakeTest				; making test

	mov eax, filehandle			; closing file
	call CloseFile
	jmp _AskMakeOrTake
	
_TakeTestLabel:
	call QuizCodeStudent		; asking for quiz code

	call TakeTest

;	mov eax, filehandle
;	call CloseFile
	jmp _AskMakeOrTake

__exit:
	exit
main ENDP
END main