import express from "express";
import expenseMediaController from "./expenseMedia.controller.js";
import { upload } from "../../middlewares/upload.middleware.js";
import { premiumOnly } from "../../middlewares/premiumOnly.middleware.js";
import authMiddleware from "../../middlewares/auth.middleware.js";


const router = express.Router();

router
  .post(
    "/:id/media",
    authMiddleware,
    premiumOnly,
    upload.array("media", 5),
    expenseMediaController.create
  )

  .get(
    "/:id/media",
    authMiddleware,
    expenseMediaController.getByExpense
  )

  .delete(
    "/media/:mediaId",
    authMiddleware,
    premiumOnly,
    expenseMediaController.delete
  );

export default router;