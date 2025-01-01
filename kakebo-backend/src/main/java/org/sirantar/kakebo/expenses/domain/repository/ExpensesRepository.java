package org.sirantar.kakebo.expenses.domain.repository;


import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;

public interface ExpensesRepository extends CrudRepository<Expenses, Long> {
}
