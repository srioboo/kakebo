package org.sirantar.kakebo.expenses.domain.repository;


import org.sirantar.kakebo.expenses.domain.model.Expenses;

import java.util.List;
import java.util.Optional;

public interface ExpensesRepository {

	Expenses save(Expenses expense);

	Optional<Expenses> findById(Long id);

	List<Expenses> findAll();

}
