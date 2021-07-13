# TM4C1294_SM_IAR9
Exemplos Assembly ARM Cortex-M (IDE IAR EWARM V9.10)
No exercício 10, é idealizado um multiplicador que realiza a multiplicação entre 2 registradores
main    
        MOV R0, #10             ;;Neste passo, é adicionado o valor decimal 10 no registrador R0
        MOV R1, #5              ;;Neste passo, é adicionado o valor decimal 5 no registrador R1
        MOV R2, #0              ;;Neste passo, é adicionado o valor 0 no registrador R2
        
Mul16b
        LSRS R1, R1, #1         ;;Aqui, é realizado um deslocamento a direita do registrador R1, colocando o valor do bit menos
                                ;;significativo no flag de Carry

                                ;;Quando o flag Carry está em 0, quer dizer que o bit menos significativo do R1, que vai realizar 
                                ;;a multiplicação bit a bit com o registrador R2, é 0, então o registrador R2 irá ser somado com 0s
                                ;;Quando o flag Carry está em 1, quer dizer que o bit menos significativo do R1, que vai realizar a 
                                ;;multiplicação bit a bit com o registrador R2, é 1, então o registrador R2 irá ser somado ao R1
                                ;;deslocado para a esquerda

                                ;;Ex.: 1010 - Valor do R0 (10)
                                ;;    x0101 - Valor do R1 (5)
                                ;;    -----
                                ;;     1010 - Neste caso, ele está na sub_rotina "mult"
                                ;;    00000 - Neste caso, ele está na sub_rotina "desloc"
                                ;;   101000 - Neste caso, ele está na sub_rotina "mult", observe que este valor é o 
                                ;;   ------
                                ;;   110010

        BCS mult                ;;Se o flag de Carry estiver em 1, é realizado um desvio para a sub_rotina "mult"
        BCC desloc              ;;Se o flag de Carry estiver em 0, é realizado um desvio para a sub_rotina "desloc"
        
mult    ADD R2, R0              ;;Neste passo, o valor do registrador R2 é somado com o valor do R0
        LSL R0, R0, #1          ;;Neste passo, é realizado um deslocamento para a esquerda do registrador R0, em 1 unidade
        B sair                  ;;Neste passo, é realizado um desvio para a sub_rotina "sair"

desloc  ADD R2, #0              ;;Neste passo, o valor do registrador R2 é somado com 0
        LSL R0, R0, #1          ;;Neste passo, é realizado um deslocamento para a esquerda do registrador R0, em 1 unidade
        B sair                  ;;Neste passo, é realizado um desvio para a sub_rotina "sair"

sair
        BNE Mul16b              ;;Meste passo, é realizado um desvio para o começo da sub_rotina Mul16b

fim     B fim
