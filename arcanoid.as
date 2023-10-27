;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d
SPACE EQU ' '
BALL EQU '0'
INITIALX EQU 41d
INITIALY EQU 21d

TIMER_UNITS   EQU FFF6h
ACTIVATE_TIMER EQU FFF7h

OFF EQU 0d
ON  EQU 1d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
                Text			         STR     ' ', FIM_TEXTO
                LinePrintstr       WORD    0d
                StringPrintstr     WORD    0d
                L1			  STR     '*******************************************************************************'
                L2			  STR     '*      VIDAS : <3 <3 <3       PLAYER: Paulo         GAME : Arcanoid             *'
                L3			  STR     '*                                                                               *'
                L4			  STR     '*                                                                               *'
                L5			  STR     '*                                                                               *'
                L6			  STR     '*                                                                               *'
                L7			  STR     '*  ###########################################################################  *'
                L8			  STR     '*  ###########################################################################  *'
                L9			  STR     '*  ###########################################################################  *'
                L10			  STR     '*  ###########################################################################  *'
                L11       STR     '*  ###########################################################################  *'
                L12       STR     '*  ###########################################################################  *'
                L13       STR     '*  ###########################################################################  *'
                L14       STR     '*                                                                               *'
                L15       STR     '*                                                                               *'
                L16       STR     '*                                                                               *'
                L17       STR     '*                                                                               *'
                L18       STR     '*                                                                               *'
                L19       STR     '*                                                                               *'
                L20       STR     '*                                                                               *'
                L21       STR     '*                                                                               *'
                L22       STR     '*                                                                               *'
                L23       STR     '*                                                                               *'
                L24       STR     '*********************************************************************************',FIM_TEXTO
                Positionx WORD            0d
                Positiony WORD            0d
                Startbar  WORD            41d
                Lengthbar WORD            14d
                Caracterprint STR         'k',FIM_TEXTO

                Directionup  WORD         -1d
                Directiondown WORD         1d
                Directionx WORD            1d
                Directiony WORD            -1d


RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d
Caracter   WORD '0'

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    Movleft
INT1            WORD    Movright

                ORIG    FE0Fh
INT15           WORD    Printball
                        ;Timer
;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Rotina Timer
;------------------------------------------------------------------------------

Timer:  PUSH R1
        PUSH R2


        MOV R1, 12d
        MOV R2, 40d
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1

        MOV R1, M[ Caracter ]
        MOV M[ IO_WRITE ], R1
        INC M[ Caracter ]

        ;CALL ConfigureTimer

        POP R2
        POP R1
        RTI
;------------------------------------------------------------------------------
; Rotina ConfigureTimer
;------------------------------------------------------------------------------

ConfigureTimer: PUSH R1
        PUSH R2

        MOV R1, 5d
        MOV M[ TIMER_UNITS ], R1

        MOV R1, ON
        MOV M[ ACTIVATE_TIMER ], R1

        POP R2
        POP R1

        RET

;------------------------------------------------------------------------------
; Printball
;------------------------------------------------------------------------------

        Printball: PUSH R1
        PUSH R2
        PUSH R3
        ;Tratar a colisão com o y tanto de cima quanto de baixo

        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, ' '
        MOV M[ IO_WRITE ], R1


        MOV R1,M[Directionx]
        ADD R1,M[Positionx]
        MOV M[Positionx],R1

        MOV R1,M[Directiony]
        ADD R1,M[Positiony]
        MOV M[Positiony],R1

        MOV R1,0d
        CMP R1,M[Positiony]
        JMP.Z COLLISIONYUP
        MOV R1,22d
        CMP R1,M[Positiony]
        JMP.Z COLLISIONYDOWN
        MOV R1, 79d
        CMP R1,M[Positionx]
        JMP.Z COLLISIONXRIGHT
        MOV R1,1
        CMP R1,M[Positionx]
        JMP.Z COLLISIONXLEFT





















        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL
        MOV M[ IO_WRITE ], R1

        JMP FIM

        ;Caso colida

        COLLISIONYUP : MOV R1 ,M[Directiondown]
        MOV M[Directiony],R1

        ADD M[Positiony],R1
        ADD M[Positiony],R1



        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL
        MOV M[ IO_WRITE ], R1
        JMP NOTERASER

        COLLISIONYDOWN :MOV R1,M[Positionx]
        CMP R1,M[Startbar]
        JMP.N LOSE
        MOV R2,M[Startbar]
        ADD R2,M[Lengthbar]
        CMP R1,R2
        JMP.P LOSE
        ;INC M[Caracter]

        MOV R1 ,M[Directionup]
        MOV M[Directiony],R1

        ADD M[Positiony],R1
        ADD M[Positiony],R1


        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL


        ;CALL Colisionbar

        JMP NOTERASER

        COLLISIONXRIGHT :MOV R1 ,M[Directionup]
        MOV M[Directionx],R1

        ADD M[Positionx],R1
        ADD M[Positionx],R1

        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL
        MOV M[ IO_WRITE ], R1
        JMP NOTERASER

        COLLISIONXLEFT : MOV R1 ,M[Directiondown]
        MOV M[Directionx],R1

        ADD M[Positionx],R1
        ADD M[Positionx],R1

        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL
        MOV M[ IO_WRITE ], R1
        JMP NOTERASER

        LOSE : MOV R1,INITIALX
        MOV R2,INITIALY
        MOV M[Positionx],R1
        MOV M[Positiony],R2
        MOV R1,M[Directionup]
        MOV R2,M[Directiondown]

        MOV M[Directionx],R2
        MOV M[Directiony],R1
        FIM : NOP
        NOTERASER : CALL ConfigureTimer

        POP R3
        POP R2
        POP R1
        RTI
;------------------------------------------------------------------------------
; Colisionbar
;------------------------------------------------------------------------------
        Colisionbar:PUSH R1
        PUSH R2
        MOV R1,M[Positionx]
        CMP R1,M[Startbar]
        JMP.N OUT
        MOV R2,M[Startbar]
        ADD R2,M[Lengthbar]
        CMP R1,R2
        JMP.P OUT
        ;INC M[Caracter]

        MOV R1 ,M[Directionup]
        MOV M[Directiony],R1

        ADD M[Positiony],R1
        ADD M[Positiony],R1


        MOV R1, M[Positiony]
        MOV R2, M[Positionx]
        SHL R1, 8d
        OR R1, R2
        MOV M[CURSOR], R1
        MOV R1, BALL

        OUT : nop


        POP R2
        POP R1
        RET
;------------------------------------------------------------------------------
; Rotina de Interrupção WriteCharacter
;------------------------------------------------------------------------------
WriteCharacter: PUSH	R1
				PUSH	R2

				MOV		R1, M[ TextIndex ]
				MOV		R1, M[ R1 ]
				CMP 	R1, FIM_TEXTO
				JMP.Z	Halt
				MOV   M[ IO_WRITE ], R1
				INC		M[ RowIndex ]
				INC		M[ ColumnIndex ]
				INC		M[ TextIndex ]
				MOV		R1, M[ RowIndex ]
				MOV		R2, M[ ColumnIndex ]
				SHL		R1, ROW_SHIFT
				OR		R1, R2
				MOV		M[ CURSOR ], R1

				POP		R2
				POP		R1
				RTI
;------------------------------------------------------------------------------
; Esqueleto
;------------------------------------------------------------------------------
        esqueleto: PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4
        PUSH R5
        POP R1
        POP R2
        POP R3
        POP R4
        POP R5
        RET
;------------------------------------------------------------------------------
; Print STR
;------------------------------------------------------------------------------
        Printstr: PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4
        ;mov R3 , M[LinePrintstr]
        ;mov R4 , 0d
        ;mov R1, 0d
        ;mov R2 , M[StringPrintstr]
        ;mov R2 , M[R2]
        ;LA : CMP R2 , FIM_TEXTO
        ;JMP.Z ALI
        ;mov R3 , M[LinePrintstr]
        ;shl R3 , 8d
        ;or R3,R4
        ;mov M[CURSOR] , R3
        ;mov R3 , R2
        ;mov M[IO_WRITE] , R3
        ;INC R4
        ;INC R1
        ;mov R2 , M[R1 + StringPrintstr]
        ;JMP LA
        ;ALI : NOP

        mov R3 , M[LinePrintstr]
        mov R4 , 0d
        mov R1, 0d
        mov R2 , M[StringPrintstr]
        mov R2 , M[R2]
        LA : CMP R4 , 40
        JMP.Z ALI
        mov R3 , 0d
        shl R3 , ROW_SHIFT
        or R3,R4
        mov M[CURSOR] , R3
        mov R3 , R2
        mov M[IO_WRITE] , R3
        INC R4
        INC R1
        mov R2 , M[R1 + StringPrintstr]
        JMP LA
        ALI : NOP

        POP R4
        POP R3
        POP R2
        POP R1


        RTI
;------------------------------------------------------------------------------
; Printmenu
;------------------------------------------------------------------------------
        Printmenu: PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4



        mov R3 , M[LinePrintstr]
        mov R4 , 0d
        mov R1 , 0d
        mov R2 , M[StringPrintstr]
        mov R2 , M[R2]

        COMP: CMP R2 , FIM_TEXTO
        JMP.Z fim
        CMP R4 , 80
        JMP.Z pulo
        mov R3 , M[LinePrintstr]
        shl R3 , ROW_SHIFT
        or R3,R4
        mov M[CURSOR] , R3
        mov R3 , R2
        mov M[IO_WRITE] , R3
        INC R4
        INC R1
        mov R2 , M[R1 + StringPrintstr]
        JMP COMP

        pulo:INC M[LinePrintstr]
        shl R3 , ROW_SHIFT
        MOV R4 ,0d
        INC R1
        JMP COMP

        fim : NOP
        POP R4
        POP R3
        POP R2
        POP R1


        RET
;------------------------------------------------------------------------------
; Printbar
;------------------------------------------------------------------------------
        Printbar : PUSH R1
        PUSH R2
        PUSH R3
        PUSH R4

        MOV R4 , 0
        MOV R3 , M[Startbar]
        JMPBAR: CMP R4 , M[Lengthbar]
        JMP.Z END
        MOV R1 , 22
        MOV R2 , '='
        shl R1 , 8d
        or R1,R3
        mov M[CURSOR] , R1
        mov R1 , R2
        mov M[IO_WRITE] , R1
        INC R4
        INC R3
        JMP JMPBAR
        END: NOP




        POP R4
        POP R3
        POP R2
        POP R1


        RET

;------------------------------------------------------------------------------
; Muda caracter
;------------------------------------------------------------------------------
                Changecaracter : PUSH R1
                PUSH R2
                PUSH R3

                MOV R1 , M[Positiony]
                MOV R3 , M[Positionx]
                MOV R2 , M[Caracterprint]
                ;MOV R2 , M[R2]

                shl R1 , 8d
                or R1,R3
                mov M[CURSOR] , R1
                mov R1 , R2
                mov M[IO_WRITE] , R1





                POP R3
                POP R2
                POP R1


                RET

;------------------------------------------------------------------------------
; Movleft
;------------------------------------------------------------------------------


              Movleft: PUSH R1
              PUSH R2
              PUSH R3
              PUSH R4

              DEC M[Startbar]
              MOV R3 , M[Startbar]
              MOV R1 , 22
              MOV R2 , '='
              shl R1 , 8d
              or R1,R3
              mov M[CURSOR] , R1
              mov R1 , R2
              mov M[IO_WRITE] , R1


              ADD R3 , M[Lengthbar];
              INC R3
              MOV R1 , 22
              MOV R2 , ' '
              shl R1 , 8d
              or R1,R3
              mov M[CURSOR] , R1
              mov R1 , R2
              mov M[IO_WRITE] , R1

              POP R4
              POP R3
              POP R2
              POP R1


              RTI



;------------------------------------------------------------------------------
; Movright
;------------------------------------------------------------------------------


              Movright: PUSH R1
              PUSH R2
              PUSH R3
              PUSH R4

              MOV R3 , M[Startbar]
              MOV R1 , 22
              MOV R2 , ' '
              shl R1 , 8d
              or R1,R3
              mov M[CURSOR] , R1
              mov R1 , R2
              mov M[IO_WRITE] , R1

              INC M[Startbar]
              MOV R3,  M[Startbar]
              ADD R3 , M[Lengthbar];
              MOV R1 , 22
              MOV R2 , '='
              shl R1 , 8d
              or R1,R3
              mov M[CURSOR] , R1
              mov R1 , R2
              mov M[IO_WRITE] , R1

              POP R4
              POP R3
              POP R2
              POP R1


              RTI






;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT



        MOV R1, 0
        MOV M[LinePrintstr],R1
        MOV R1,L1
        MOV M[StringPrintstr],R1
        CALL Printmenu


        MOV R1, INITIALX
        MOV M[Positionx], R1
        MOV R1, INITIALY
        MOV M[Positiony], R1





        CALL Printbar
        CALL ConfigureTimer

















Cycle: 			BR		Cycle
Halt:           BR		Halt
