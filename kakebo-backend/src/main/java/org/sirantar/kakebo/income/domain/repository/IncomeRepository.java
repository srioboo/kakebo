package org.sirantar.kakebo.income.domain.repository;

import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.data.repository.CrudRepository;

public interface IncomeRepository extends CrudRepository<Incomes, Long> { }
