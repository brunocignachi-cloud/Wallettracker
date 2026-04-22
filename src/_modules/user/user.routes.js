import express from "express";
import userController from "./user.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";

const router = express.Router();

router
    .get("/", authMiddleware, userController.getAllUsers)
    .get("/:id", authMiddleware, userController.getUserById)
    .put("/:id", authMiddleware, userController.updateUser)
    .delete("/:id", authMiddleware, userController.deleteUser)
    .patch("/upgrade", authMiddleware, userController.upgradeToPremium)
    .patch("/downgrade",authMiddleware,userController.downgradeFromPremium);

export default router;
