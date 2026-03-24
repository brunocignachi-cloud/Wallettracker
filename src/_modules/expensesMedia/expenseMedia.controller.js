import ExpenseMedia from "./expenseMedia.model.js";
import Expense from "../expenses/expense.model.js";

class ExpenseMediaController {

  static create = async (req, res, next) => {
    try {
      const { id: expenseId } = req.params;
      const userId = req.user.id; 

      const expense = await Expense.findOne({
        _id: expenseId,
        user: userId
      });

      if (!expense) {
        return res.status(403).json({
          message: "Despesa não encontrada ou não pertence ao usuário"
        });
      }

      if (!req.files || req.files.length === 0) {
        return res.status(400).json({
          message: "Nenhum arquivo enviado"
        });
      }

      const mediaDocs = req.files.map(file => ({
        expenseId,
        userId,
        type: file.mimetype.startsWith("video") ? "video" : "photo",
        url: `/${file.path}`
      }));

      const savedMedia = await ExpenseMedia.insertMany(mediaDocs);

      return res.status(201).json(savedMedia);

    } catch (error) {
      next(error);
    }
  };

  static getByExpense = async (req, res, next) => {
    try {
      const { id: expenseId } = req.params;
      const userId = req.user.id; 

      const expense = await Expense.findOne({
        _id: expenseId,
        user: userId
      });

      if (!expense) {
        return res.status(403).json({
          message: "Despesa não encontrada ou não pertence ao usuário"
        });
      }

      const media = await ExpenseMedia.find({
        expenseId,
        userId
      }).lean();

      return res.status(200).json(media);

    } catch (error) {
      next(error);
    }
  };

  static delete = async (req, res, next) => {
    try {
      const { mediaId } = req.params;
      const userId = req.user.id;

      const media = await ExpenseMedia.findOneAndDelete({
        _id: mediaId,
        userId
      });

      if (!media) {
        return res.status(404).json({
          message: "Mídia não encontrada ou acesso negado"
        });
      }

      return res.status(200).json({
        message: "Mídia removida com sucesso"
      });

    } catch (error) {
      next(error);
    }
  };
}

export default ExpenseMediaController;