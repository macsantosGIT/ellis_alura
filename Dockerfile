# Etapa 1: Escolher uma imagem base
# Usar uma imagem 'slim' é uma boa prática para produção, pois mantém o tamanho da imagem menor.
# A versão 3.11 é estável e compatível com o que foi especificado no readme (Python 3.10+).
FROM python:3.13.4-alpine3.22

# Etapa 2: Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Etapa 3: Copiar o arquivo de dependências
# Copiamos o requirements.txt primeiro para aproveitar o cache de camadas do Docker.
# A instalação das dependências só será executada novamente se este arquivo mudar.
COPY requirements.txt .

# Etapa 4: Instalar as dependências
# Usamos --no-cache-dir para reduzir o tamanho da imagem final.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Etapa 5: Copiar o código da aplicação
COPY . .

# Etapa 6: Expor a porta em que a aplicação será executada
EXPOSE 8000

# Etapa 7: Comando para iniciar a aplicação
# Usamos --host 0.0.0.0 para que a aplicação seja acessível de fora do contêiner.
# O uvicorn é o servidor ASGI recomendado para FastAPI.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
