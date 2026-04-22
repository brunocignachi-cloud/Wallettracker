import express from "express";
import cors from "cors";
import routes from "./_modules/index.js";
import swaggerUi from "swagger-ui-express";
import YAML from "yamljs";
import path from "path";

// ✅ 1. Criar o app PRIMEIRO
const app = express();

// ✅ 2. Configurar CORS (antes das rotas)
app.use(cors());

// ✅ 3. Body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ 4. Rotas
routes(app);

// ✅ 5. Swagger
const swaggerDocument = YAML.load("./src/config/swagger.yaml");

// ✅ 6. Arquivos estáticos e docs

app.use(
  "/uploads",
  express.static(path.join(process.cwd(), "uploads"))
);

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

export default app;