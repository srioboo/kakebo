package org.sirantar.kakebo.expenses.application.service;

import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.expenses.domain.repository.ExpensesRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ExpensesService {

	private final ExpensesRepository expensesRepository;

	public ExpensesService(ExpensesRepository expensesRepository) {
		this.expensesRepository = expensesRepository;
	}

	public Iterable<Expenses> getExpenses() {
		return expensesRepository.findAll();
	}

	public Expenses getExpenseById(Long id) {
		Optional<Expenses> expenses = expensesRepository.findById(id);
		return expenses.orElse(new Expenses());
	}
}
