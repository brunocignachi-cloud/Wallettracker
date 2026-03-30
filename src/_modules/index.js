import expenseRoutes from "./expenses/expense.routes.js"
import userRoutes from "./user/user.routes.js"
import authRoutes from "./auth/auth.routes.js"
import expenseMediaRoutes from "./expensesMedia/expenseMedia.routes.js";

const routes = (app) => {

    app.get("/", (req, res) => {
        res.status(200).send("API rodando com sucesso. Teste sem front-end desenvolvido");
    });
    
    app.use("/expenses", expenseRoutes);
    app.use("/user", userRoutes);
    app.use("/auth", authRoutes);
    app.use("/expenses", expenseMediaRoutes); 
};

export default routes;
