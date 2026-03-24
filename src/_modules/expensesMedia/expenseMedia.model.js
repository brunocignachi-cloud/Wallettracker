import mongoose from "mongoose";

const ExpenseMediaSchema = new mongoose.Schema(
  {
    expenseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Expense",
      required: true,
      index: true
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    type: {
      type: String,
      enum: ["photo", "video"],
      required: true
    },
    url: {
      type: String,
      required: true
    }
  },
  {
    timestamps: true,
    versionKey: false
  }
);

export default mongoose.model("ExpenseMedia", ExpenseMediaSchema);