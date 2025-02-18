# Software Básico - Projeto 2
Universidade de Brasilia
Software Básico - 2024/2

## Como compilar
O projeto disponibiliza um makefile, então ter a ferramenta make instalada e digitar um "./make"

## Como rodar
Após a compilação, será gerado um arquivo chamado "carregador". Agora basta fazer ./carregador <argumentos>

## Detalhes do funcionamento
No primeiro momento verificamos se é possível carregar o programa inteiramente em algum dos endereços passados. Se for possível, ótimo, carrega nele e encerra. Caso o programa não caiba em nenhum segmento por inteiro, então verificamos se temos espaço disponível para o programa e, se não tiver, é mostrado na tela uma mensagem de que não será possível carregador. Caso contrário, temos a certeza de que é possível fazer essa alocação, então pegamos todo os bytes do primeiro segmento, depois do segundo e etc, até termos espaço suficiente para alocação e, após isso, encerramos a execução

## Exemplos
./carregador 125 100 500 4000 300 20000 125 30000 345
Neste caso, a saída esperada é de que o programa esteja completamente incluso no primeiro segmento e o programa irá retornar "Mensagem 1: Cabe no Primeiro!"

## Testes
Para garantir a assertividade dessa solução, também foram criados vários testes de unidade e um script em python para rodá-los.

## Autores
Bruno Henrique Duarte - 221022239
Maxwell Oliveira dos Reis - 221002100