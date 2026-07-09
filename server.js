import 'dotenv/config';
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import { GoogleGenAI } from '@google/genai';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para processar corpos de requisições em formato JSON
app.use(express.json());

// Inicializa o cliente do Gemini SDK com tratamento de erro amigável se a chave estiver ausente
let ai = null;
try {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    console.warn("AVISO: GEMINI_API_KEY não foi encontrada nas variáveis de ambiente (.env).");
  } else {
    ai = new GoogleGenAI({
      apiKey: apiKey,
      httpOptions: {
        headers: {
          'User-Agent': 'aistudio-build',
        }
      }
    });
  }
} catch (error) {
  console.error("Erro ao inicializar o cliente do Gemini:", error);
}

// ROTA DA API: Interação segura com a API do Gemini no backend
app.post('/api/chat', async (req, res) => {
  try {
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'O campo "message" é obrigatório no corpo da requisição.' });
    }

    if (!ai) {
      // Tentativa de inicialização tardia caso a variável tenha sido configurada posteriormente
      const apiKey = process.env.GEMINI_API_KEY;
      if (!apiKey) {
        return res.status(500).json({ 
          error: 'Serviço temporariamente indisponível. A variável de ambiente GEMINI_API_KEY não foi configurada.' 
        });
      }
      ai = new GoogleGenAI({
        apiKey: apiKey,
        httpOptions: {
          headers: {
            'User-Agent': 'aistudio-build',
          }
        }
      });
    }

    // Faz a chamada oficial usando o SDK recomendado e o modelo gemini-3.5-flash
    const response = await ai.models.generateContent({
      model: 'gemini-3.5-flash',
      contents: message,
    });

    // Retorna a resposta segura e extraída adequadamente usando o getter .text
    return res.json({ 
      text: response.text 
    });

  } catch (error) {
    console.error('Erro ao processar chamada ao Gemini:', error);
    return res.status(500).json({ 
      error: 'Ocorreu um erro ao processar sua solicitação com o modelo de inteligência artificial.',
      details: error instanceof Error ? error.message : String(error)
    });
  }
});

// Servir arquivos estáticos do diretório 'dist'
app.use(express.static(path.join(__dirname, 'dist')));

// Tratar todas as outras requisições enviando o index.html (SPA routing)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
