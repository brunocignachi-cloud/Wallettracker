import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import userService from "../user/user.service.js";

const authService = {

    async register({ name, email, password }) {

        const userExists = await userService.findByEmail(email);

        if (userExists) {
            throw new Error("Email já cadastrado");
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const user = await userService.createUser({
            name,
            email,
            password: hashedPassword
        });

        return user;
    },

    async login({ email, password }) {

        const user = await userService.findByEmail(email);

        if (!user) {
            throw new Error("Credenciais inválidas");
        }

        const validPassword = await bcrypt.compare(password, user.password);

        if (!validPassword) {
            throw new Error("Credenciais inválidas");
        }

        const token = jwt.sign(
            {
                id: user._id,
                premium: user.premium
            },
            process.env.JWT_SECRET,
            { expiresIn: "7d" }
        );

        return { user, token };
    }

};

export default authService;