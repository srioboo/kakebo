package org.sirantar.kakebo.expenses.domain.repository;


import org.sirantar.kakebo.expenses.domain.model.Expenses;

import java.util.List;

public interface ExpensesRepository {

	Expenses save(Expenses expense);

	Expenses findById(Long id);

	List<Expenses> findAll();

}
