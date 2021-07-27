        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
; System Control definitions
SYSCTL_RCGCGPIO_R       EQU     0x400FE608
SYSCTL_PRGPIO_R		EQU     0x400FEA08
PORTF_BIT               EQU     0000000000100000b ; bit  5 = Port F
PORTJ_BIT               EQU     0000000100000000b ; bit  8 = Port J
PORTN_BIT               EQU     0001000000000000b ; bit 12 = Port N

; GPIO Port definitions
GPIO_PORTF_BASE    	EQU     0x4005D000
GPIO_PORTJ_BASE    	EQU     0x40060000
GPIO_PORTN_BASE    	EQU     0x40064000

GPIO_DIR                EQU     0x0400
GPIO_PUR                EQU     0x0510
GPIO_DEN                EQU     0x051C

GPIO_PORTN_DATA_R    	EQU     0x40064000
GPIO_PORTN_DIR_R     	EQU     0x40064400
GPIO_PORTN_DEN_R     	EQU     0x4006451C

GPIO_PORTF_DATA_R    	EQU     0x4005D000
GPIO_PORTF_DIR_R     	EQU     0x4005D400
GPIO_PORTF_DEN_R     	EQU     0x4005D51C

GPIO_PORTJ_DATA_R       EQU     0x40060000
GPIO_PORTJ_DIR_R        EQU     0x40060400
GPIO_PORTJ_DEN_R        EQU     0x4006051C
GPIO_PORTJ_PUR_R        EQU     0x40060510

__iar_program_start
                
        
main    
        BL sub_config_F
        BL sub_config_N
        BL sub_config_J
        
        MOV R1, #00000000b ; estado inicial
        MOV R5, #00000000b
        MOV R10, #0
        MOV R7, #0
        
        LDR R6, = GPIO_PORTF_DATA_R
 	LDR R0, = GPIO_PORTN_DATA_R
        LDR R9, = GPIO_PORTJ_DATA_R
        
        
loop	STR R1, [R0, R2, LSL #2] ; aciona LED com estado atual
        STR R5, [R6, R4, LSL #2]
        MOVT R3, #0x000F ; constante de atraso 
delay   CBZ R3, theend ; 1 clock
        SUB R3, R3, #1 ; 1 clock
        B delay ; 3 clocks

theend  LDR R8, [R9, R11, LSL #2]
        CMP R8, #1
        IT EQ
          BLEQ sobe
        CMP R8, #2
        IT EQ
          BLEQ desce
        

        AND R7, R10, #1 ;Aqui, é adicionado no R7 a operação AND de R10 com 1, ou seja, R7 vai ficar só com o valor
                        ;do bit menos significativo do R10
        MOV R1, R7, LSL #1      ;Aqui, o R1 recebe o valor de R7 deslocado em 1 para a esquerda. Fiz isso para
                                 ;poder mudar o led D1 da placa;
        
        MOV R7, #0
        
        AND R7, R10, #2 ;Aqui é feito o mesmo procedimento do anterior, porém agora só pega o segundo bit
        ORR R1, R7, LSR #1
        
        MOV R7, #0
        
        AND R7, R10, #4
        LSL R7, #2
        MOV R5, R7
        
        MOV R7, #0
        
        AND R7, R10, #8
        LSR R7, #3
        ORR R5, R7
        
        MOV R7, #0
        
        ;OR R1 ; troca o estado
        ;OR R5, R5, R4

        B loop

sub_config_N
        MOV R2, #PORTN_BIT
	LDR R0, =SYSCTL_RCGCGPIO_R
	LDR R1, [R0] ; leitura do estado anterior
	ORR R1, R2 ; habilita port N
	STR R1, [R0] ; escrita do novo estado
        LDR R0, =SYSCTL_PRGPIO_R
n_wait	LDR R2, [R0] ; leitura do estado atual
	TEQ R1, R2 ; clock do port N habilitado?
	BNE n_wait ; caso negativo, aguarda

        MOV R2, #00000011b ; bit 0
        
	LDR R0, = GPIO_PORTN_DIR_R
	LDR R1, [R0] ; leitura do estado anterior
	ORR R1, R2 ; bit de saída
	STR R1, [R0] ; escrita do novo estado

	LDR R0, =GPIO_PORTN_DEN_R
	LDR R1, [R0] ; leitura do estado anterior
	ORR R1, R2 ; habilita função digital
	STR R1, [R0] ; escrita do novo estado

        BX LR

sub_config_F
        MOV R4, #PORTF_BIT
	LDR R0, =SYSCTL_RCGCGPIO_R
	LDR R5, [R0] ; leitura do estado anterior
	ORR R5, R4 ; habilita port N
	STR R5, [R0] ; escrita do novo estado
        LDR R0, =SYSCTL_PRGPIO_R
f_wait	LDR R4, [R0] ; leitura do estado atual
	TEQ R5, R4 ; clock do port N habilitado?
	BNE f_wait ; caso negativo, aguarda

        MOV R4, #00010001b ; bit 0
        
	LDR R0, =GPIO_PORTF_DIR_R
	LDR R5, [R0] ; leitura do estado anterior
	ORR R5, R4 ; bit de saída
	STR R5, [R0] ; escrita do novo estado

	LDR R0, =GPIO_PORTF_DEN_R
	LDR R5, [R0] ; leitura do estado anterior
	ORR R5, R4 ; habilita função digital
	STR R5, [R0] ; escrita do novo estado

        BX LR
        
sub_config_J
        
        MOV R12, #PORTJ_BIT
        LDR R0, =SYSCTL_RCGCGPIO_R
        LDR R11, [R0]
        ORR R11, R12
        STR R11, [R0]
        
        LDR R0, =SYSCTL_PRGPIO_R
j_wait  LDR R12, [R0]
        TEQ R11, R12
        BNE j_wait
        
        LDR R0, =GPIO_PORTJ_DIR_R
        LDR R11, [R0]
        BIC R11, #00000011b
        STR R11, [R0]
        
        LDR R0, =GPIO_PORTJ_PUR_R
        LDR R11, [R0]
        ORR R11, #00000011b
        STR R11, [R0]
        
        LDR R0, =GPIO_PORTJ_DEN_R
        LDR R11, [R0]
        ORR R11, #00000011b
        STR R11, [R0]
        
        
        
        BX LR

sobe    ADD R10, #1
        BX LR
desce   SUB R10, #1
        BX LR

        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
