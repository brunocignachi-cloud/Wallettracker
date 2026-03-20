import express from 'express';
import expenseController from './expense.controller.js';

const router = express.Router();

router
    .get("/", expenseController.getAllExpenses)
    .get("/:id", expenseController.getExpenseById)
    .post("/", expenseController.createExpense)
    .put("/:id", expenseController.updateExpense)
    .delete("/:id", expenseController.deleteExpense);

export default router;
