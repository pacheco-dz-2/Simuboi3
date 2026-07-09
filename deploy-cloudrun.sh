#!/bin/bash

# ==============================================================================
# Script de Implantação do SimuBoi no Google Cloud Run (Modo 100% Gratuito / Free Tier)
# ==============================================================================
#
# Este script automatiza o deploy garantindo as configurações ideais para se manter
# dentro do limite de uso gratuito do Google Cloud Run.
#
# Requisitos:
# 1. Google Cloud CLI instalado (gcloud)
# 2. Login efetuado: gcloud auth login
# 3. Projeto selecionado: gcloud config set project SEU_PROJECT_ID
# ==============================================================================

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Preparando implantação do SimuBoi no Google Cloud Run ===${NC}"

# Verificar se o gcloud está instalado
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Erro: Google Cloud CLI (gcloud) não está instalado.${NC}"
    echo "Por favor, instale o gcloud SDK antes de continuar: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Detectar o ID do projeto ativo
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "(unset)" ]; then
    echo -e "${YELLOW}Aviso: Nenhum projeto do Google Cloud foi detectado como ativo.${NC}"
    echo "Digite o ID do seu projeto do Google Cloud:"
    read -r PROJECT_ID
    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}Erro: ID de projeto inválido.${NC}"
        exit 1
    fi
    gcloud config set project "$PROJECT_ID"
else
    echo -e "${GREEN}Projeto ativo detectado: $PROJECT_ID${NC}"
fi

# Região recomendada (us-east1 tem suporte total e é excelente para latência/preço)
REGION="us-east1"

echo -e "${BLUE}\nIniciando o deploy no Cloud Run...${NC}"
echo -e "Configurações aplicadas para o ${GREEN}Modo Gratuito (Free Tier)${NC}:"
echo -e " - Mínimo de Instâncias: ${YELLOW}0${NC} (escala para zero quando inativo, custo $0)"
echo -e " - Máximo de Instâncias: ${YELLOW}3${NC} (evita surpresas ou ataques de negação de serviço)"
echo -e " - Alocação de CPU: ${YELLOW}Apenas durante o processamento de requisições (Throttling)${NC}"
echo -e " - Recursos: ${YELLOW}1 vCPU e 512MiB RAM${NC} (ideal para o servidor Express leve)"
echo -e " - Sem CPU Boost: para evitar sobretaxas temporárias na inicialização"

# Comando de deploy oficial do Cloud Run
gcloud run deploy simuboi \
  --source . \
  --region "$REGION" \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 3 \
  --memory 512Mi \
  --cpu 1 \
  --no-cpu-boost \
  --cpu-throttling

# Verificar o status do deploy
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✔ Implantação concluída com sucesso!${NC}"
    echo -e "Para que a inteligência artificial (Gemini) funcione perfeitamente, não se esqueça de adicionar a sua chave secreta como variável de ambiente no serviço:"
    echo -e "Você pode fazer isso pelo console web do Google Cloud ou executando o comando abaixo:"
    echo -e "${YELLOW}gcloud run services update simuboi --region=$REGION --set-env-vars=GEMINI_API_KEY=sua_chave_aqui${NC}"
else
    echo -e "\n${RED}❌ Ocorreu um erro durante a implantação. Verifique os logs acima.${NC}"
fi
