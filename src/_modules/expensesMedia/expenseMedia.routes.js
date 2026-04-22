import express from "express";
import expenseMediaController from "./expenseMedia.controller.js";
import { upload } from "../../middlewares/upload.middleware.js";
import { premiumOnly } from "../../middlewares/premiumOnly.middleware.js";
import authMiddleware from "../../middlewares/auth.middleware.js";

const router = express.Router();

router.use(authMiddleware);

router.post(
  "/:expenseId",
  premiumOnly,
  upload.array("media", 5),
  expenseMediaController.create
);

router.get(
  "/:expenseId",
  premiumOnly,
  expenseMediaController.getByExpense
);

router.delete(
  "/:mediaId",
  premiumOnly,
  expenseMediaController.delete
);

export default router;