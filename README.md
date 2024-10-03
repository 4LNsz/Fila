# Sistema de fila

Challenge #1 para o WinsVue.
Sistema de fila, grupos e times.

## Problema
Desenvolvemos um modo de jogo PvP que reúne 10 jogadores divididos igualmente em dois times, competindo rodada a rodada até que um dos times alcance 13 pontos e conquiste a vitória.

Com o modo de jogo finalizado, precisamos de um sistema de filas que identifique grupos de jogadores buscando partida e forme times prontos para iniciar o jogo.

## Condições gerais
1. Por se tratar de um sistema de fila que comporta a formação de times baseados em grupos, os jogadores em um grupo "incompleto" não podem ser separados e precisam permanecer juntos durante a formação de um time.
2. Os grupos dos jogadores devem ser persistidos para que ao fim da partida, os mesmos retornem a busca de novos times e partidas no mesmo grupo.

## Solução requerida
1. A formação de times de 5 jogadores;
2. A preservação dos grupo;
3. A definição dos times de ataque e defesa da times partida;
4. O consumo de uma função (Fictícia), quando os times estiverem prontos para iniciar a partida.