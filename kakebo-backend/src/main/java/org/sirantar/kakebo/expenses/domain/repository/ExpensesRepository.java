package org.sirantar.kakebo.expenses.domain.repository;

import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ExpensesRepository extends CrudRepository<Expenses, Long> {

    @Query("SELECT e FROM Expenses e WHERE YEAR(e.expenseDate) = :year AND MONTH(e.expenseDate) = :month")
    List<Expenses> findByYearAndMonth(@Param("year") int year, @Param("month") int month);
}
