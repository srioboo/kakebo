package org.sirantar.kakebo.expenses.application.service;

import org.sirantar.kakebo.expenses.application.dto.ExpenseDTO;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.expenses.domain.repository.ExpensesRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ExpensesService {

	private final ExpensesRepository expensesRepository;

	public ExpensesService(ExpensesRepository expensesRepository){
		this.expensesRepository = expensesRepository;
	}


	public List<ExpenseDTO> getExpenses(){

		List<ExpenseDTO> result = new ArrayList<>();

		// TODO - get from respository
		result.add(new ExpenseDTO(1));

		return result;
	}

	public ExpenseDTO getExpenseById(Long id){
		Optional<Expenses> expenses = expensesRepository.findById(id);
		return expenses.map(value -> new ExpenseDTO(value.getId())).orElseGet(() -> new ExpenseDTO(1));
	}
}
