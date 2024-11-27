package org.sirantar.kakebo.income.domain.repository;

import org.sirantar.kakebo.income.domain.model.Income;

import java.util.List;
import java.util.Optional;

public interface IncomeRepository {

	List<Income> findAll();

	Optional<Income> findById(Long id);

}
