import Expense from "./expense.model.js";

class ExpenseController {

    static getAllExpenses = async (req, res, next) => {
        try {
            const expenses = await Expense.find().lean(); // Busca todas as depesas
            if (req.headers.accept?.includes("text/html")) {// Verifica se o cliente aceita HTML
                return res.status(200).render("expenses-list", { expenses }); // Renderiza a página HTML com a lista de despesas, caso o cliente aceite HTML
            }
            res.status(200).json(expenses); // Retorna a lista de despesas em formato JSON, caso não seja solicitado HTML
        } catch (error) {
            next(error); 
        }
    }
    
    static getExpenseById = async (req, res, next) => {
        try {
            const expense = await Expense.findById(req.params.id).lean(); // Busca a despesa pelo ID
            if (!expense) { // Verifica se a despesa existe
                return res.status(404).json({ message: "Expense not found" }); // Retorna um erro 404 caso a despesa não seja encontrada
            }
            if (req.headers.accept?.includes("text/html")) { // Verifica se o cliente aceita HTML
                return res.status(200).render("expense-detail", { expense }); // Renderiza a página HTML com os detalhes da despesa, caso o cliente aceite HTML
            } 
            res.status(200).json(expense); // Retorna os detalhes da despesa em formato JSON, caso não seja solicitado HTML
        } catch (error) {
            next(error);
        }
    }

    static createExpense = async (req, res, next) => {
        try {
            const expense = await Expense.create(req.body); // Cria uma nova despesa
            if (req.headers.accept?.includes("text/html")) { // Verifica se o cliente aceita HTML
                return res.redirect(`/expenses/${expense._id}`); // Redireciona para a página de detalhes da despesa recém-criada, caso o cliente aceite HTML
            }
            res.status(201).json(expense); // Retorna a nova despesa criada em formato JSON
        } catch (error) {
            next(error);
        }
    }

    static updateExpense = async (req, res, next) => {
        try{
            const id = req.params.id;
            const expense = await Expense.findByIdAndUpdate(id, { $set: req.body }, { new: true });
            if (!expense) {
                return res.status(404).json({ message: "Expense not found" });
            }
            if (req.headers.accept?.includes("text/html")) {
                return res.redirect(`/expenses/${id}`);
            }
            res.status(200).json({ message: "Expense updated.", expense: expense });
        } catch (error) {
            next(error);
        }
    }

    static deleteExpense = async (req, res, next) => {
        try {
            const id = req.params.id;
            await Expense.findByIdAndDelete(id);
            if (!id) {
                return res.status(404).json({ message: "Expense not found" });
            };
            if (req.headers.accept?.includes("text/html")) {
                return res.redirect("/bookings");
            };
            res.status(200).json({ message: "Booking removido com sucesso" });        
        } catch (error) {
            next(error);
        };        
    }

}

export default ExpenseController;