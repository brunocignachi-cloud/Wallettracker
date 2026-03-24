import User from "./user.model.js";

const userService = {

    async getAllUsers() {
        return await User.find().select("-password");
    },

    async getUserById(id) {
        return await User.findById(id).select("-password");
    },

    async createUser(data) {
        return await User.create(data);
    },

    async updateUser(id, data) {
        return await User.findByIdAndUpdate(id, data, { new: true });
    },

    async deleteUser(id) {
        return await User.findByIdAndDelete(id);
    },

    async findByEmail(email) {
        return await User.findOne({ email });
    }

};

export default userService;