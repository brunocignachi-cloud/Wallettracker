import "dotenv/config";
import app from "./src/app.js";
import connectDB from "./src/config/dbConnect.js";

const port = process.env.PORT || 3000;

const startServer = async () => {
    try {
        await connectDB();

        app.listen(port, () => {
            console.log(`Servidor rodando em http://localhost:${port}`);
        });

    } catch (error) {
        console.error("Erro ao iniciar o servidor:", error);
        process.exit(1);
    }
};

startServer();