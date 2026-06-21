package org.sirantar.kakebo.income.domain.repository;

import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface IncomeRepository extends CrudRepository<Incomes, Long> {

    @Query("SELECT i FROM Incomes i WHERE YEAR(i.incomeDate) = :year AND MONTH(i.incomeDate) = :month")
    List<Incomes> findByYearAndMonth(@Param("year") int year, @Param("month") int month);
}
