import express from "express";
import routes from "./_modules/index.js";
import swaggerUi from "swagger-ui-express";
import YAML from "yamljs";

const app = express();

app.use(express.json())
routes(app);

const swaggerDocument = YAML.load("./src/config/swagger.yaml");

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

export default app;