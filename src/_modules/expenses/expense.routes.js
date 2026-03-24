
import express from "express";
import expenseController from "./expense.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";

const router = express.Router();

router
  .get("/", authMiddleware, expenseController.getAllExpenses)
  .get("/:id", authMiddleware, expenseController.getExpenseById)
  .post("/", authMiddleware, expenseController.createExpense)
  .put("/:id", authMiddleware, expenseController.updateExpense)
  .delete("/:id", authMiddleware, expenseController.deleteExpense);

export default router;
