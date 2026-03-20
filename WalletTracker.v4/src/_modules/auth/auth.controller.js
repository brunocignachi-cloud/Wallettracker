import authService from "./auth.service.js";

const authController = {

    async register(req, res) {
        try {

            const user = await authService.register(req.body);

            res.status(201).json({
                id: user._id,
                name: user.name,
                email: user.email
            });

        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    },

    async login(req, res) {
        try {

            const { user, token } = await authService.login(req.body);

            res.json({
                token,
                user: {
                    id: user._id,
                    name: user.name,
                    email: user.email,
                    premium: user.premium
                }
            });

        } catch (error) {
            res.status(401).json({ error: error.message });
        }
    }

};

export default authController;