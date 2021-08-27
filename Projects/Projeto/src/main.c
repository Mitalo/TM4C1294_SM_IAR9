#include <stdint.h>

void wrx();
void pop_R0_R1();
void MUDA_R8(uint32_t A);
void SETA_R9(uint32_t valor);
void SETA_R10(uint32_t valor);
void SETA_R11(uint32_t valor);
uint32_t Retorna_R9();
uint32_t Retorna_R10();
uint32_t Retorna_R11();
uint32_t Retorna_R6();
uint32_t Retorna_R7();
uint32_t Retorna_R12();

void caractere_errado()
{
      pop_R0_R1();
      wrx();
}

void A_R8(uint32_t A)
{
      MUDA_R8(A);
}
void Armazena_elemento(uint32_t operando)
{
      Armazena(operando);
}
void Armazena_2elemento(uint32_t operando)
{
      Armazena2(operando);
}
void Armazena_op(uint32_t operador)
{
      Armazena_operador(operador);
}

uint32_t Comparacao(uint32_t parametro, uint32_t n_numeros)
{
    uint32_t operacao, resultado, retorno;
    uint32_t par = parametro;
    if((48 <= par) && (par <= 57) && (n_numeros < 3 || ((n_numeros < 13) && (n_numeros >= 10))))
    {
        n_numeros++;
        A_R8(n_numeros);
        switch(n_numeros)
        {
            case 1: SETA_R9(par); break;
            case 2: SETA_R10(par); break;
            case 3: SETA_R11(par); break;
            case 11: SETA_R9(par); break;
            case 12: SETA_R10(par); break;
            case 13: SETA_R11(par); break;
        }     
    }
    else if(((n_numeros >= 1) && (n_numeros <= 3)) && ((par == '+') || (par == '-') || (par == '*') || (par == '/')))//se for digitado '+', '-', '*', '/'
    {
        Armazena_op(par);
        switch(n_numeros)
        {
            case 1: 
                Armazena_elemento(Retorna_R9()-'0');
                A_R8(10);
                //arrumar pra pegar o valor de R9
            break;//se for 1, R9
            case 2:
                Armazena_elemento((Retorna_R9()-'0')*10 + (Retorna_R10()-'0'));
                A_R8(10);
            break;//se for 2, R9*10+R10
            case 3: 
                Armazena_elemento((Retorna_R9()-'0')*100 + (Retorna_R10()-'0')*10 + (Retorna_R11()-'0'));
                A_R8(10);
            break;//se for 3, R9*100+R10*10+R11
        }
    }
    else if((n_numeros > 10) && (par == 61))//se for digitado '='
    {
        switch(n_numeros)
        {
            case 11:
                Armazena_2elemento(Retorna_R9()-'0');
                A_R8(0);
            break;//se for 1, R9
            case 12:
                Armazena_2elemento((Retorna_R9()-'0')*10 + (Retorna_R10()-'0'));
                A_R8(0);
            break;//se for 2, R9*10+R10
            case 13: 
                Armazena_2elemento((Retorna_R9()-'0')*100 + (Retorna_R10()-'0')*10 + (Retorna_R11()-'0'));
                A_R8(0);
            break;//se for 3, R9*100+R10*10+R11   
        }
      //return resultado;
    }
    else caractere_errado();
    
    return par;
}

uint32_t calcula()
{
    switch(Retorna_R7())
    {
        case '+':
            return Retorna_R12()+Retorna_R6();
        break;
        case '-':
            return Retorna_R12()-Retorna_R6();
        break;
        case '*':
            return Retorna_R12()*Retorna_R6();
        break;
        case '/':
            return Retorna_R12()/Retorna_R6();
        break;
    }
}

int main()
{
  return 0;
}
