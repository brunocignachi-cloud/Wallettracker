import expenseRoutes from "./expenses/expense.routes.js"
import userRoutes from "./user/user.routes.js"
import authRoutes from "./auth/auth.routes.js"
import expenseMediaRoutes from "./expensesMedia/expenseMedia.routes.js";

const routes = (app) => {
    app.use("/expenses", expenseRoutes);
    app.use("/user", userRoutes);
    app.use("/auth", authRoutes);
    app.use("/expenses/media", expenseMediaRoutes); 
};

export default routes;