package org.sirantar.kakebo.expenses.application.service;

import org.sirantar.kakebo.expenses.application.dto.ExpenseDTO;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.expenses.domain.repository.ExpensesRepository;

public class ExpensesService {

	private final ExpensesRepository expensesRepository;

	public ExpensesService(ExpensesRepository expensesRepository){
		this.expensesRepository = expensesRepository;
	}


	// TODO - here getExpensed, save ect

	public ExpenseDTO getExpenseById(Long id){
		Expenses expenses = expensesRepository.findById(id);
		return new ExpenseDTO(expenses.getId());
	}
}
