# TM4C1294_SM_IAR9
Exemplos Assembly ARM Cortex-M (IDE IAR EWARM V9.10)
Nesse projeto, podemos observar o funcionamento de operações com os registradores, como deslocamentos e rotações.
Os comentários de cada função estão no próprio código

Mudando o comando MOV para MVN, os valores sofrem o deslocamento e são invertidos, ou seja, o que era '1' fica '0' e o que era '0' fica '1'.

        MOV R0, #0x55           ;Neste passo, ele coloca o valor 55 (em hexadecimal) no Registrador R0

        MVN R1, R0, LSL #16     ;Neste passo, ele realiza o deslocamento para a esquerda
                                ;em 16 bits no Registrador R0 e coloca esse valor de deslocamento no registrador R1, sem alterar o R0

        MVN R2, R1, LSR #8      ;Neste passo, ele realiza o deslocamento para a direita em 8 bits do valor
                                ;contido no Registrador R1 e adiciona esse valor no Registrador R2, sem alterar R2

        MOV R3, R2, ASR #4      ;Neste passo, ele realiza um deslocamento aritmético para a direita no valor que estava
                                ;contido no Registrador R2 e adiciona esse valor no Registrador R3, sem alterar R3

        MOV R4, R3, ROR #2      ;Neste passo, ele realiza uma rotação de 2 bits para a direita no valor que estava contido no 
                                ;Registrador R3 e adiciona esse resultado no Registrador R4, sem alterar R3. Na rotação, ele não 
                                ;irá "perder" o valor que estava nos 2 bits menos significativos (LSB), mas coloca esses valores 
                                ;nos 2 mais significativos (MSB)

        MOV R5, R4, RRX         ;Neste passo, ele realiza o deslocamento de 1 bit para a direita do valor contido em R4 e adiciona
                                ;esse valor em R5, sem alterar R4
