        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
main    
        MOV R0, #5              ;;Neste passo, foi adicionado o valor 5 no registrador R0
        PUSH {R1, R2}           ;;Neste passo, foram colocados os valores dos registradores R1 e R2 na pilha
        MOV R1, R0              ;;Neste passo, o registrador R1 recebe o valor do registrador R0, para ser decrementado posteriormente
        CMP R0, #0              ;;Neste passo, � verificado se o valor do registrador R0 � zero, afetando o flag Z
        BEQ fatorial_de_zero    ;;Neste passo, se o flag Z estiver em 1, � realizado um desvio para a sub_rotina "fatorial_de_zero"
        BL fatorial              ;;Neste passo, � chamada a sub_rotina "fatorial"
        B .
        
fatorial_de_zero
        MOV R0, #1              ;;Aqui, caso o valor de entrada seja 0, a sa�da obtida ser� 0
        BX LR                   ;;Retorna para a chamada da sub_rotina
        
fatorial
        SUB R1, #1              ;;Aqui, o valor do registrador R1 � decrementado em 1 unidade, para realizarmos o c�lculo do fatorial
        CBZ R1, retorno         ;;Neste passo, � verificado se o registrador R1 chegou em 0, se sim, � realizado um desvio para o retorno
        SMULL R0, R2, R0, R1    ;;Neste passo, � realizada uma multiplica��o sinalizada entre os registradores R0 e R1, 
                                ;;adicionando o resultado nos registradores R0 e R2, sendo que no R0 ficam os bits menos 
                                ;;significativos e no R2 os mais significativos
        CMP R2, #0              ;;Aqui, � realizada a verifica��o se R2 � 0, se sim, o Flag Z � setado
        BNE extrapolou          ;;Se o flag Z est� em 0, significa que foram extrapolados os 32 bits
        B fatorial              ;;Aqui � realizado um desvio para o come�o da sub_rotina

retorno BX LR                   ;;Retorna para a chamada da sub_rotina

extrapolou
        MOV R0, #-1             ;;Se os 32 bits extrapolaram, � adicionado o valor -1 em R0
        POP {R1, R2}            ;;Neste passo, s�o "devolvidos" os valores iniciais dos registradores R1 e R2
     
        BX LR                   ;;Retorna � chamada da fun��o
     
fim     B fim

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
