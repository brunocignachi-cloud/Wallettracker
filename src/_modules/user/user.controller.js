import userService from "./user.service.js";

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
    }

};

export default userController;