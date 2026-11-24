# AgendaMonitoria

Sistema web para reservar vagas em horários de monitoria. O aluno vê os horários livres, reserva uma vaga e já informa a dúvida; o monitor vê quem vem, lê as dúvidas antes do atendimento e registra quem compareceu. Substitui a combinação por grupos de WhatsApp, em que vagas se perdem e o monitor não sabe o que vai ser perguntado.

MVP desenvolvido para o **POOALAB 2026.2**, da disciplina Programação Orientada a Objetos Avançada (UCSal).

## Equipe

| Integrante | Turma |
|---|---|
| Uelton Breno | T1 |
| Pedro Henrique Peixoto | T1 |

Equipe de 2 integrantes, com autorização do professor.

## Problema, público e proposta de valor

**Problema** (formulação do manual): para **alunos que procuram monitoria e para os monitores**, que enfrentam **desencontro de horários, falta de controle de vagas e atendimentos sem preparo** durante **a combinação dos encontros de monitoria**, a consequência é **perda de tempo, salas lotadas ou vazias e dúvidas que não são resolvidas**. Hoje esse público tenta resolver a situação por meio de **mensagens em grupos de WhatsApp e avisos em sala**.

**Proposta de valor:**
- **Para o aluno:** garantir a vaga em poucos cliques, sem depender de mensagens, e cancelar quando não puder ir.
- **Para o monitor:** saber com antecedência quantas pessoas vêm e quais são as dúvidas, e acompanhar a presença.

As hipóteses e as evidências de validação estão em [docs/problema-validacao.md](docs/problema-validacao.md). O recorte do MVP está em [docs/definicao-mvp.md](docs/definicao-mvp.md).

## Funcionalidades do MVP

**Aluno**
- Listar os horários futuros de monitoria, com filtro por disciplina e vagas restantes.
- Reservar uma vaga informando matrícula, nome e dúvida, e receber um código de reserva.
- Consultar a reserva pelo código e cancelar, confirmando a matrícula.

**Monitor**
- Ver os próprios horários com os alunos inscritos e as dúvidas de cada um.
- Registrar presença ou falta a partir do início do horário.
- Ver um resumo com reservas aguardando, comparecimentos, faltas e taxa de comparecimento.

**Regras de negócio**
- Matrícula com 6 a 12 números e nome com 3 a 80 caracteres.
- Dúvida com 10 a 500 caracteres.
- Só é possível reservar horários que ainda não começaram e que têm vaga.
- Um aluno não pode reservar duas vezes o mesmo horário.
- O cancelamento exige a matrícula da reserva e só vale antes do início do horário.
- A presença só pode ser registrada a partir do início do horário.
- Duas pessoas tentando a última vaga ao mesmo tempo nunca ficam as duas com a vaga.

## Tecnologias

| Tecnologia | Por quê |
|---|---|
| **Java 21 ou superior** | Linguagem da disciplina. O projeto usa records, `switch` com setas, virtual threads e `List.getFirst()`. |
| **Servidor HTTP do próprio JDK** (`com.sun.net.httpserver`) | Sobe o sistema web sem instalar nada além do Java, o que torna a execução reproduzível em qualquer computador. |
| **HTML e CSS gerados no servidor** | Telas simples, que funcionam sem JavaScript e com navegação por teclado. |
| **Armazenamento em memória** | Suficiente para demonstrar o fluxo, e os dados de demonstração voltam ao estado inicial a cada execução. |

Não há bibliotecas externas: não é preciso Maven, Gradle ou acesso à internet para compilar.

## Pré-requisitos

- **JDK 21 ou superior** (testado com o Temurin 25.0.4). Confira com `java -version` e `javac -version`.
- Um navegador atualizado.

## Instalação e execução

1. Baixe ou clone o repositório.
2. Na pasta do projeto, execute o script do seu sistema:

   **Windows**
   ```bat
   executar.bat
   ```

   **Linux ou macOS**
   ```sh
   sh executar.sh
   ```
3. Abra **http://localhost:8080** no navegador.
4. Para encerrar, pressione `Ctrl+C` no terminal.

Se a porta 8080 estiver ocupada, passe outra porta: `executar.bat 9090`.

O script compila o código para a pasta `build/` e inicia o sistema. O servidor só aceita conexões do próprio computador.

## Dados de demonstração

Todos os dados são fictícios e são criados a cada execução, com datas calculadas a partir do momento em que o sistema sobe:

- **4 disciplinas e 4 monitores** (Ana Lima, Bruno Costa, Carla Dias e Diego Rocha).
- **Um horário da monitora Ana que começou há 30 minutos**, com 3 reservas, para demonstrar o registro de presença.
- **Um horário lotado** (Estruturas de Dados, com a Carla), para mostrar que não aceita mais reservas.
- **Reservas com os códigos `DEMO01`, `DEMO02` e `DEMO03`**, que podem ser consultadas em "Minha reserva".

Para fazer reservas novas, use qualquer matrícula fictícia com 6 a 12 números, como `2026000200`. Não há login nem senha.

## Como executar os testes

**Windows**
```bat
testar.bat
```

**Linux ou macOS**
```sh
sh testar.sh
```

São 22 testes automatizados, que devem terminar com `22 testes: 22 passaram, 0 falharam.`:
- **`ServicoAgendaTeste`:** as regras de reserva, cancelamento, presença e listagem.
- **`ConcorrenciaTeste`:** 200 reservas simultâneas em virtual threads para um horário de 3 vagas, conferindo que só 3 são aceitas.
- **`HtmlTeste`:** o escape de caracteres especiais, que protege contra a injeção de código nas páginas.
- **`ServidorTeste`:** sobe o servidor de verdade e percorre o fluxo pelo HTTP, como um navegador.

Como o projeto não usa bibliotecas externas, os testes rodam com um executor próprio (`ExecutorTestes`), que encontra os métodos anotados com `@Teste` por reflexão. Os testes manuais estão em [tests/roteiro-testes-manuais.md](tests/roteiro-testes-manuais.md).

## Roteiro curto do fluxo principal

1. Em **Horários**, filtre por "Cálculo I" e clique em **Reservar** no horário do Bruno.
2. Preencha a matrícula `2026000200`, um nome e a dúvida, e clique em **Confirmar reserva**.
3. Anote o código exibido e veja que a vaga foi descontada na lista de horários.
4. Em **Área do monitor**, escolha **Ana Lima**: no horário em andamento, clique em **Compareceu** para um aluno e veja o resumo mudar.

O roteiro completo da apresentação está em [demo/roteiro-demonstracao.md](demo/roteiro-demonstracao.md).

## Organização do código

```
src/main/java/br/ucsal/agendamonitoria/
├── App.java            monta as peças e sobe o servidor
├── dominio/            Horario, Reserva, Monitor, Disciplina e exceções de negócio
├── regras/             uma classe por regra de reserva
├── repositorio/        interfaces e implementações em memória
├── servico/            ServicoAgenda, com os casos de uso
├── web/                servidor, roteador por anotações e páginas
└── demo/               dados fictícios de demonstração
src/test/java/br/ucsal/agendamonitoria/teste/   testes automatizados
docs/                   problema, validação, MVP, pitch e declaração de IA
demo/                   roteiro de demonstração
tests/                  roteiro de testes manuais
```

## Relação com POOA

| Conteúdo | Onde está | Por que foi usado |
|---|---|---|
| **SOLID: aberto/fechado e responsabilidade única** | `regras/` | Cada regra é uma classe que implementa `RegraReserva`. Uma regra nova entra sem mexer no `ServicoAgenda`. |
| **SOLID: inversão de dependência** | `ServicoAgenda`, `repositorio/` | O serviço depende das interfaces `HorarioRepositorio` e `ReservaRepositorio`. Trocar a memória por um banco de dados não muda o serviço, e os testes usam a mesma interface. |
| **Strategy (GoF)** | `RegraReserva` | As regras são estratégias de validação intercambiáveis, aplicadas em sequência. |
| **Collections e Streams** | `ServicoAgenda`, repositórios | Filtros e ordenação dos horários, `groupingBy` com `EnumMap` para o resumo do monitor e `ConcurrentHashMap` para os dados. |
| **Concorrência e virtual threads** | `ServicoAgenda`, `Servidor`, `ConcorrenciaTeste` | Uma `ReentrantLock` por horário impede que duas pessoas fiquem com a última vaga. Cada requisição roda em uma virtual thread, e o teste dispara 200 reservas simultâneas. |
| **Reflexão e anotações** | `web/Rota`, `web/Roteador`, `teste/ExecutorTestes` | `@Rota` liga métodos a endereços, descobertos por reflexão. `@Teste` faz o mesmo com os testes. |

## Limitações conhecidas

- **Sem login:** qualquer pessoa pode abrir a área de qualquer monitor. A matrícula funciona só como confirmação no cancelamento.
- **Dados em memória:** tudo volta ao estado de demonstração quando o sistema reinicia.
- **Os monitores não cadastram horários pela tela:** os horários vêm dos dados de demonstração.
- **Sem notificações:** o aluno não recebe lembrete por e-mail ou mensagem.
- **Acesso só pelo próprio computador:** o servidor escuta apenas em `localhost`.
- **A validação com usuários foi feita em pequena escala.** Veja os detalhes em [docs/problema-validacao.md](docs/problema-validacao.md).

## Próximos passos

1. Login de aluno e monitor, com perfis separados.
2. Cadastro de horários pelo próprio monitor.
3. Banco de dados, implementando as mesmas interfaces de repositório.
4. Lembrete automático antes do horário, para reduzir as faltas.

## Fontes, componentes de terceiros e uso de IA

- **Componentes de terceiros:** apenas o JDK (OpenJDK, licença GPLv2 com Classpath Exception). Nenhuma biblioteca, template ou código externo foi copiado.
- **Uso de IA:** o projeto foi desenvolvido com apoio do Claude (Anthropic). A declaração completa, exigida pelo Anexo E do manual, está em [docs/declaracao-ia-terceiros.md](docs/declaracao-ia-terceiros.md).
