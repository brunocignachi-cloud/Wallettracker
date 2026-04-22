import userService from "./user.service.js";
import jwt from "jsonwebtoken";

const userController = {

    async getAllUsers(req, res) {
        try {
            const users = await userService.getAllUsers();
            res.json(users);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async getUserById(req, res) {
        try {
            const user = await userService.getUserById(req.params.id);
            res.json(user);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async updateUser(req, res) {
        try {
            const user = await userService.updateUser(req.params.id, req.body);
            res.json(user);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async deleteUser(req, res) {
        try {
            await userService.deleteUser(req.params.id);
            res.json({ message: "Usuário deletado" });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },


  async upgradeToPremium(req, res) {
    try {
      const userId = req.user.id;

      const user = await userService.upgradeToPremium(userId);

      // ✅ GERAR NOVO TOKEN AQUI (sem helper)
      const token = jwt.sign(
        {
          id: user._id,
          premium: user.premium
        },
        process.env.JWT_SECRET,
        { expiresIn: "7d" }
      );

      res.json({
        message: "Usuário atualizado para Premium",
        premium: user.premium,
        token // ✅ TOKEN NOVO
      });

    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  async downgradeFromPremium(req, res) {
    try {
      const userId = req.user.id;

      const user = await userService.downgradeFromPremium(userId);

      // ✅ GERAR NOVO TOKEN AQUI TAMBÉM
      const token = jwt.sign(
        {
          id: user._id,
          premium: user.premium
        },
        process.env.JWT_SECRET,
        { expiresIn: "7d" }
      );

      res.json({
        message: "Usuário voltou para plano normal",
        premium: user.premium,
        token
      });

    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

};

export default userController;