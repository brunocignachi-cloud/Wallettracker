import ExpenseMedia from "./expenseMedia.model.js";
import Expense from "../expenses/expense.model.js";
import fs from "fs";
import path from "path";

class ExpenseMediaController {

  /**
   * 📸 Upload de mídias (Premium)
   * POST /expenses/media/:expenseId
   */
  static create = async (req, res, next) => {
    try {
      const { expenseId } = req.params;
      const userId = req.user.id;

      // ✅ Verifica se a despesa existe e pertence ao usuário
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

      /**
       * ✅ NUNCA salvar path físico no banco
       * ✅ Sempre salvar URL pública relativa
       *
       * Resultado:
       * /uploads/expenses/<expenseId>/<filename>
       */
      const mediaDocs = req.files.map(file => ({
        expenseId,
        userId,
        type: file.mimetype.startsWith("video") ? "video" : "photo",
        url: `/uploads/expenses/${expenseId}/${file.filename}`
      }));

      const savedMedia = await ExpenseMedia.insertMany(mediaDocs);

      return res.status(201).json(savedMedia);

    } catch (error) {
      next(error);
    }
  };

  /**
   * 📂 Listar mídias de uma despesa (Premium)
   * GET /expenses/media/:expenseId
   */
  static getByExpense = async (req, res, next) => {
    try {
      const { expenseId } = req.params;
      const userId = req.user.id;

      // ✅ Verifica ownership da despesa
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

  /**
   * 🗑️ Remover mídia individual (Premium)
   * DELETE /expenses/media/:mediaId
   */
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

      /**
       * ✅ Remove arquivo físico correspondente
       * media.url = /uploads/expenses/<expenseId>/<filename>
       */
      if (media.url) {
        const filePath = path.join(
          process.cwd(),
          media.url.replace(/^\//, "")
        );

        if (fs.existsSync(filePath)) {
          fs.unlinkSync(filePath);
        }
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
