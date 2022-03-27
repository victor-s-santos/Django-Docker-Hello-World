# Docker

## O que é docker?
  __Um breve resumo prático__

- É uma ferramenta de containers (docker não é a única ferramenta a fazer isto). Oferecendo ambientes virtualizados, isolando totalmente sua aplicação e um sistema operacional para dentro de um container. É mais ou menos a ideia do virtualenv do python, no entando, além da linguagem de sua aplicação (no caso o python), você isola toda a infraestrutura do app (podendo ser banco de dados, apis, interface gráfica etc). Ou seja, tudo que é necessário instalar no sistema operacional para rodar a aplicação (no nosso caso, precisamos principalmente, para as nossas aplicações, o postgres além do python). Dependendo da aplicação que for usada, ela pode possuir dependências que são relacionadas ao sistema operacional, fazendo com que esta mesma aplicação precise de bibliotecas (ou procedimentos) diferentes de acordo com o sistema operacional utilizado. Ou seja, isolar o ambiente python, não é o bastante, pois as bibliotecas necessárias podem ser diferentes de acordo com o sistema operacional que o usuário está utilizando. Ao invés de exigir que a equipe tenha um ambiente de trabalho o mais próximo o possível, rodas-e a aplicação a partir de um container docker, fazendo com que não importe se o usuário está em um Linux, Mac ou Windows, a aplicação vai rodar e produzir o mesmo resultado em todos os casos. Ou seja, se na minha máquina funciona, na sua também vai, não há nenhum problema de dependência! 

- Um outro ponto que também merece destaque, é o fato de conseguirmos produzir um ambiente exatamente igual (ou quase) em produção e em desenvolvimento, o que facilita muito o desenvolvimento e encontrar a causa dos erros, quando eles ocorrem por problemas de versões de bibliotecas. É muito complicado descobrir qual é o problema que certa biblioteca está acusando em produção, quando você roda sua aplicação em um ambiente de produção diferente do ambiente de desenvolvimento.

## Subindo um servidor Django a partir de uma imagem do python 
  __Uma explicação mais prática__

- Para a execução do nosso hello world, vamos dividir em duas partes: a criação de um hello world com o django, e dockerizar esse cara:
- Inicialmente, vamos rodar alguns comandos docker para verificar que não temos containers ou imagens previamente rodando e baixadas respectivamente:


- __Criando o projeto no django__
    
    `É literalmente a criação de um hello world`
    - O primeiro passo é criar o ambiente virtual python (python -m venv .venv), 
    - crie o requirements.txt;
    - instalação das dependências, 
    - criação do projeto, 
    - configurações do settings.py.
    - As configurações que são necessárias no settings são as variáveis de ambiente, mas no caso não usaremos elas ainda, a única modificação necessária é o ALLOWED_HOSTS = ["*"];
    - Rodar runserver para testar.

- __Dockerizando a aplicação__

    - Agora o que faremos é criar uma imagem da nossa aplicação.
    - A criação do .dockerignore, nos permite retirar o virtualenv do python, arquivos desnecessários e o próprio .git.
    - Devemos criar o Dockerfile com o seguinte conteúdo:
    
        1. FROM python:3.8
            > Imagem base que será usada para criar a nossa imagem do docker

        2. ENV PYTHONDONTWRITEBYTECODE 1
            > Variável de ambiente responsável por orientar o python a não gerar arquivos .pyc
        3. ENV PYTHONUNBUFFERED 1
            > Variável de ambiente responsável por orientar o python a não armazenar mensagem de log em buffer, fazendo com que elas sejam exibidas e deletadas

        4. WORKDIR /code
            > Responsável por definir o diretório de trabalho

        5. COPY . /code
            > Copia tudo o que está aqui no diretório (.) e cola para aqui (/code) no container docker

        6. EXPOSE 8000
            > Expõe a porta onde será rodado o servidor

        7. RUN pip install -r requirements.txt
            > Roda o pip indicando para instalar os pacotes listados em requirements.txt. Lembrando que este requirements.txt foi copiado no item 5

        8. CMD python manage.py runserver 0.0.0.0:8000
            > Ao subir este container, o docker vai executar este comando, fazendo com que o servidor fique rodando enquanto ao subir o container.

- Ao criarmos o nosso Dockerfile, vamos buildá-lo, construindo a nossa imagem a partir do Dockerfile, e então subir o nosso container:

    - Para buildar, com o terminal aberto no diretório onde o Dockerfile se encontra, rodar:
        > docker build -t django_hello_world .

    - E podemos agora verificar a nossa imagem através do comando:
        > docker images
        - Percebe-se que temos 2 imagens: a do python, que foi a imagem base usada, e a imagem que criamos do django.
        - Como agora temos a imagem do python na nossa máquina, outros builds serão mais rápidos para esta mesma imagem base, pois ela já está baixada.

    - E subimos o container rodando:
        > docker run -p 8000:8000 django_hello_world

    - Para pararmos a execução deste container, em outro terminal executamos:
        > docker ps `Para obtermos a lista de todos os containers em execução`
        
        > docker stop nome_ou_id_do_container `Para de fato pararmos sua execução`

    - Podemos também subir o container e continuarmos utilizando o nosso terminal:
        > docker run -d -p 8000:8000 django_hello_world
        `Desta forma, nenhuma informação sobre o status do container ou do servidor será exibida mas podemos utilizar este terminal`

        