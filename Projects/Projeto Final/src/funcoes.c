#include <stdint.h>
#include <string.h>
#include <stdlib.h>

uint8_t Uart0_Rcv(void);
void Uart0_Send(uint8_t dado);

//função para verificar se é um número válido (0-9)
//entrada: valor recebido pela serial
//retorno: 1 - entrada válida, 0 - entrada inválida
uint32_t verifica_numero(uint8_t entrada)
{
  if(entrada >= '0' && entrada <= '9')
  {
    return 1;
  }
  else return 0;
}
//função para verificar se é uma operação válida (+-*/)
//entrada: valor recebido pela serial
//retorno: 1 - operação válida, 0 - operação inválida
uint32_t verifica_operacao(uint8_t entrada)
{
  if(entrada == '+' || entrada == '-' || entrada == '*' || entrada == '/')
  {
    //Uart0_Send(entrada);
    return entrada;
  }
  else return 0;
}
//função para realizar o cálculo
//entrada: vetor que possui os dois números digitados e a operação
//retorno: valor calculado
int32_t calcula(int32_t *num, uint8_t operacao)
{
  switch(operacao)
  {
  case '+': return (num[0]+num[1]); break;
  case '-': return (num[0]-num[1]); break;
  case '*': return (num[0]*num[1]); break;
  case '/': return (num[0]/num[1]); break;
  }
}
//função converter os caracteres recebidos pela serial em um número inteiro
//entrada: vetor com os dígitos recebidos pela serial e o tamanho (1-3 números)
//retorno: número formado a partir dos caracteres
int32_t retorna_num(uint8_t *num, uint8_t tamanho)
{
  switch(tamanho)
  {
  case 1: return (num[0]); break;
  case 2: return ((num[0])*10+(num[1])); break;
  case 3: return ((num[0])*100+(num[1])*10+(num[2])); break;
  }
}
//função para verificar o tamanho do resultado calculado (quantos dígitos)
//entrada: resultado da operação
//retorno: tamanho do número
uint8_t tam_res(int32_t res)
{
  uint8_t i = 1;
  while(res/=10)
    i++;
  return i;
}
//função que converte o resultado em caracteres ASCII e os transmite pela serial
//entrada: resultado calculado e tamanho do número
//retorno: não tem
void transmite_resultado(int32_t resultado, uint8_t tamanho)
{ 
  uint8_t *res = calloc(tamanho, sizeof(uint8_t));
  uint8_t i, tam = tamanho;
  while(tamanho--)
  {
    res[tamanho]=resultado%10+'0';//vai realizando divisões por 10 sucessivas e armazenando os números em uma posição do vetor
    //Uart0_Send(resultado%10+'0');
    resultado/=10;
  }
  for(i = 0; i < tam; i++)
    Uart0_Send(res[i]);
  Uart0_Send('\n');
}