import mongoose from "mongoose";

const UserSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true,
            unique: true, // Garante que o email seja único no banco de dados
            immutable: true // Garante que o email não possa ser alterado após a criação do usuário
        },
        password: {
            type: String,
            required: true
        },
        premium: {
            type: Boolean, 
            required: true,
            default: false // Define o padrão do usuário como não premium
        }
    }
);

const User = mongoose.model("User", UserSchema);

export default User;