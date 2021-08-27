// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Calculadora utilizando a interface serial
// Italo Ribeiro Fabiani

#include <stdint.h>
#include <string.h>
#include <stdlib.h>

void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void Uart0_Init(void);
void transmite_resultado(int32_t resultado, uint8_t tamanho);
uint8_t Uart0_Rcv(void);
void Uart0_Send(uint8_t dado);
uint32_t verifica_numero(uint8_t entrada);
uint32_t verifica_operacao(uint8_t entrada);
int32_t calcula(int32_t *num, uint8_t operacao);
int32_t retorna_num(uint8_t *num, uint8_t tamanho);
uint8_t tam_res(int32_t res);

int main(void)
{
  uint8_t entrada = 0, cont = 0, operacao = 0, i, t1 = 0, t2 = 0, tamanho_resultado = 0;
  uint8_t num1[3]={0};
  uint8_t num2[3]={0};
  int32_t numero[2]={0};
  int32_t resultado = 0;
  uint8_t op_tam[3]={0};
  GPIO_Init();
  Uart0_Init();
  uint8_t mensagem[]="Divisao por zero!";
  
    while (1)
    {
       entrada = Uart0_Rcv();
       if (verifica_numero(entrada) && (cont < 3 || (cont >= 10 && cont < 13)))//cont verifica se 3 números foram digitados e nada a mais que isso
       {
         Uart0_Send(entrada);
         if(cont < 3)
           num1[cont] = entrada-'0';//armazena em um vetor o primeiro operando
         if(cont >= 10 && cont < 13)
           num2[cont-10] = entrada-'0';//armazena em um vetor o segundo operando
         cont++;
       }   
       else if ((cont >= 1 && cont <= 3) && verifica_operacao(entrada))
       {
         Uart0_Send(entrada);
         t1 = cont;//t1 é o tamanho do primeiro número (1-3)
         cont = 10;
         operacao = entrada;
       }
       else if(cont >= 11 && entrada == '=')
       {
         Uart0_Send(entrada);
         t2 = cont-10;//t2 é o tamanho do segundo número (1-3)
         numero[0] = retorna_num(num1, t1);//converte os caracteres em número e o coloca na primeira posição do vetor
         numero[1] = retorna_num(num2, t2);//converte os caracteres em número e o coloca na segunda posição do vetor
         
         resultado = calcula(numero, operacao);//calcula o resultado
         if (resultado < 0)//se o resultado for negativo, é transmitido um sinal de - e o resultado é invertido para ser transmitido
         {
           Uart0_Send('-');
           resultado = -resultado;
         }
         cont = 0;
         if(numero[1] == 0 && operacao == '/')//se houver uma divisão por zero, o programa irá avisar
         {
            for(i = 0; i < 18; i++)
              Uart0_Send(mensagem[i]);
            Uart0_Send('\n');
         }
         else transmite_resultado(resultado, tam_res(resultado));//o resultado é transmitido
       }
    }
    return 0;
}
