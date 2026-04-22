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
    },

    async upgradeToPremium(userId) {
        return await User.findByIdAndUpdate(
            userId,
            { premium: true },
            { new: true }
        );
    }, 

    async downgradeFromPremium(userId) {
    return await User.findByIdAndUpdate(
        userId,
        { premium: false },
        { new: true }
    );
    }

};

export default userService;