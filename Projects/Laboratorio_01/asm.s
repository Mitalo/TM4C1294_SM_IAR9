        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
main    MOV R0, #0x55           ;Neste passo, ele coloca o valor 55 (em hexadecimal) no Registrador R0

        MOV R1, R0, LSL #16     ;Neste passo, ele realiza o deslocamento para a esquerda
                                ;em 16 bits no Registrador R0 e coloca esse valor de deslocamento no registrador R1, sem alterar o R0

        MOV R2, R1, LSR #8      ;Neste passo, ele realiza o deslocamento para a direita em 8 bits do valor
                                ;contido no Registrador R1 e adiciona esse valor no Registrador R2, sem alterar R2

        MOV R3, R2, ASR #4      ;Neste passo, ele realiza um deslocamento aritmético para a direita no valor que estava
                                ;contido no Registrador R2 e adiciona esse valor no Registrador R3, sem alterar R3

        MOV R4, R3, ROR #2      ;Neste passo, ele realiza uma rotação de 2 bits para a direita no valor que estava contido no 
                                ;Registrador R3 e adiciona esse resultado no Registrador R4, sem alterar R3. Na rotação, ele não 
                                ;irá "perder" o valor que estava nos 2 bits menos significativos (LSB), mas coloca esses valores 
                                ;nos 2 mais significativos (MSB)

        MOV R5, R4, RRX         ;Neste passo, ele realiza o deslocamento de 1 bit para a direita do valor contido em R4 e adiciona
                                ;esse valor em R5, sem alterar R4

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
