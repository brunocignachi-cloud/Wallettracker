import mongoose from "mongoose";

const ExpenseSchema = new mongoose.Schema(
    {
        description: {
            type: String,
            required: true,
        },
        amount: {
            type: Number,
            required: true, 
        },
        date: {
            type: Date,
            required: true,
        },
        category: {
            type: String,
            required: true,
        }
    },
    {
        timestamps: true,
        versionKey: false
    }
);

const Expense = mongoose.model("Expense", ExpenseSchema);

export default Expense;