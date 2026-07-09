<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://ai.google.dev/static/site-assets/images/share-ais-513315318.png" />
</div>

# Run and deploy your AI Studio app

This contains everything you need to run your app locally.

View your app in AI Studio: https://ai.studio/apps/39c66049-bd84-412e-9244-c0d6ccce7e25

## Run Locally

**Prerequisites:**  Node.js


1. Install dependencies:
   `npm install`
2. Set the `GEMINI_API_KEY` in [.env.local](.env.local) to your Gemini API key
3. Run the app:
   `npm run dev`

---

## 🚀 Como Implantar no Google Cloud Run (Modo Gratuito)

Este aplicativo já está totalmente preparado para ser implantado no **Google Cloud Run** de forma 100% gratuita ou se mantendo confortavelmente dentro do **Free Tier** do Google Cloud.

Incluímos um script automatizado (`deploy-cloudrun.sh`) que configura os parâmetros perfeitos recomendados pelo Google para evitar quaisquer cobranças:

### ⚙️ Por que esta configuração é Gratuita?
- **Mínimo de instâncias = 0:** O aplicativo escala para zero instâncias quando não há visitas, gastando exatamente **R$ 0,00** quando ocioso.
- **CPU alocada apenas durante requisições (`--cpu-throttling`):** Você só consome recursos de CPU do Free Tier nos milissegundos em que uma requisição está sendo processada.
- **Memória limitada a 512MiB e 1 vCPU:** Mantém o consumo super enxuto e ideal para o nosso servidor web Express ultraleve.
- **Limite de 3 instâncias máximas:** Protege você contra picos de tráfego imprevistos ou ataques de spam que poderiam passar do limite gratuito.

---

### 📋 Passo a Passo para Implantação

1. **Abra o terminal na pasta raiz do projeto.**

2. **Dê permissão de execução ao script de deploy:**
   ```bash
   chmod +x deploy-cloudrun.sh
   ```

3. **Execute o script:**
   ```bash
   ./deploy-cloudrun.sh
   ```

4. **Siga as instruções simples na tela** (o script irá detectar o seu projeto ativo do Google Cloud ou solicitará o ID do seu projeto).

---

### 🔑 Configurando a Chave do Gemini AI com Segurança
Após concluir a publicação, para habilitar as consultas inteligentes de IA, configure a variável de ambiente executando:
```bash
gcloud run services update simuboi --region=us-east1 --set-env-vars=GEMINI_API_KEY=SUA_CHAVE_DO_GEMINI_AQUI
```
*(ou se preferir, acesse a aba "Variables & Secrets" do seu serviço no Console Web do Google Cloud).*

