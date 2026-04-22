import Expense from "./expense.model.js";
import ExpenseMedia from "../expensesMedia/expenseMedia.model.js";
import fs from "fs";
import path from "path";

class ExpenseController {

  static getAllExpenses = async (req, res, next) => {
    try {
      const userId = req.user.id;

      const expenses = await Expense.find({ user: userId }).lean();

      if (req.headers.accept?.includes("text/html")) {
        return res.status(200).render("expenses-list", { expenses });
      }

      return res.status(200).json(expenses);
    } catch (error) {
      next(error);
    }
  };

  static getExpenseById = async (req, res, next) => {
    try {
      const userId = req.user.id;
      const expenseId = req.params.id;

      const expense = await Expense.findOne({
        _id: expenseId,
        user: userId
      }).lean();

      if (!expense) {
        return res.status(404).json({
          message: "Expense not found"
        });
      }

      if (req.headers.accept?.includes("text/html")) {
        return res.status(200).render("expense-detail", { expense });
      }

      return res.status(200).json(expense);
    } catch (error) {
      next(error);
    }
  };

  static createExpense = async (req, res, next) => {
    try {
      const userId = req.user.id;

      const expense = await Expense.create({
        description: req.body.description,
        amount: req.body.amount,
        date: req.body.date,
        category: req.body.category,
        user: userId
      });

      if (req.headers.accept?.includes("text/html")) {
        return res.redirect(`/expenses/${expense._id}`);
      }

      return res.status(201).json(expense);
    } catch (error) {
      next(error);
    }
  };

  static updateExpense = async (req, res, next) => {
    try {
      const userId = req.user.id;
      const expenseId = req.params.id;

      const expense = await Expense.findOneAndUpdate(
        { _id: expenseId, user: userId },
        { $set: req.body },
        { new: true }
      );

      if (!expense) {
        return res.status(404).json({
          message: "Expense not found"
        });
      }

      if (req.headers.accept?.includes("text/html")) {
        return res.redirect(`/expenses/${expense._id}`);
      }

      return res.status(200).json({
        message: "Expense updated successfully",
        expense
      });
    } catch (error) {
      next(error);
    }
  };

  /**
   * ✅ Exclusão em cascata:
   * - Remove arquivos físicos
   * - Remove documentos ExpenseMedia
   * - Remove a despesa
   *
   * ⚠️ NÃO depende de premiumOnly
   */
  static deleteExpense = async (req, res, next) => {
    try {
      const userId = req.user.id;
      const expenseId = req.params.id;

      // ✅ Verifica ownership
      const expense = await Expense.findOne({
        _id: expenseId,
        user: userId
      });

      if (!expense) {
        return res.status(404).json({
          message: "Expense not found"
        });
      }

      // ✅ Busca mídias vinculadas
      const medias = await ExpenseMedia.find({ expenseId });

      // ✅ Remove arquivos físicos
      for (const media of medias) {
        if (media.url) {
          const filePath = path.resolve(media.url.replace(/^\//, ""));
          if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
          }
        }
      }

      // ✅ Remove documentos de mídia
      await ExpenseMedia.deleteMany({ expenseId });

      // ✅ Remove a despesa
      await Expense.deleteOne({ _id: expenseId });

      return res.status(200).json({
        message: "Expense and related media removed successfully"
      });

    } catch (error) {
      next(error);
    }
  };
}

export default ExpenseController;