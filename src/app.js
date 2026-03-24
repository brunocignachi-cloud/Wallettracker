import express from "express";
import routes from "./_modules/index.js";
import swaggerUi from "swagger-ui-express";
import YAML from "yamljs";
import path from "path";

const app = express();

app.use(express.json())
app.use(express.urlencoded({ extended: true }));

routes(app);

const swaggerDocument = YAML.load("./src/config/swagger.yaml");

app.use("/uploads", express.static(path.resolve("uploads")));
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

export default app;