        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
main    
        MOV R0, #10             ;;Neste passo, � adicionado o valor decimal 10 no registrador R0
        MOV R1, #5              ;;Neste passo, � adicionado o valor decimal 5 no registrador R1
        MOV R2, #0              ;;Neste passo, � adicionado o valor 0 no registrador R2
        
        BL Mul16b               ;;Chama a sub_rotina
        B .
        
Mul16b
        LSRS R1, R1, #1         ;;Aqui, � realizado um deslocamento a direita do registrador R1, colocando o valor do bit menos
                                ;;significativo no flag de Carry

                                ;;Quando o flag Carry est� em 0, quer dizer que o bit menos significativo do R1, que vai realizar 
                                ;;a multiplica��o bit a bit com o registrador R2, � 0, ent�o o registrador R2 ir� ser somado com 0s
                                ;;Quando o flag Carry est� em 1, quer dizer que o bit menos significativo do R1, que vai realizar a 
                                ;;multiplica��o bit a bit com o registrador R2, � 1, ent�o o registrador R2 ir� ser somado ao R1
                                ;;deslocado para a esquerda

                                ;;Ex.: 1010 - Valor do R0 (10)
                                ;;    x0101 - Valor do R1 (5)
                                ;;    -----
                                ;;     1010 - Neste caso, ele est� na sub_rotina "mult"
                                ;;    00000 - Neste caso, ele est� na sub_rotina "desloc"
                                ;;   101000 - Neste caso, ele est� na sub_rotina "mult", observe que este valor � o 
                                ;;   ------
                                ;;   110010

        BCS mult                ;;Se o flag de Carry estiver em 1, � realizado um desvio para a sub_rotina "mult"
        BCC desloc              ;;Se o flag de Carry estiver em 0, � realizado um desvio para a sub_rotina "desloc"
        
mult    ADD R2, R0              ;;Neste passo, o valor do registrador R2 � somado com o valor do R0
        LSL R0, R0, #1          ;;Neste passo, � realizado um deslocamento para a esquerda do registrador R0, em 1 unidade
        B sair                  ;;Neste passo, � realizado um desvio para a sub_rotina "sair"

desloc  ADD R2, #0              ;;Neste passo, o valor do registrador R2 � somado com 0
        LSL R0, R0, #1          ;;Neste passo, � realizado um deslocamento para a esquerda do registrador R0, em 1 unidade
        B sair                  ;;Neste passo, � realizado um desvio para a sub_rotina "sair"

sair
        BNE Mul16b              ;;Meste passo, � realizado um desvio para o come�o da sub_rotina Mul16b
        
        BX LR                   ;;Retorna a chamada da sub_rotina
        
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
