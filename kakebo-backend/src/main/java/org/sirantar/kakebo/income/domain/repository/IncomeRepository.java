package org.sirantar.kakebo.income.domain.repository;

import org.sirantar.kakebo.income.domain.model.Income;

public interface IncomeRepository {

	Income findById(Long id);

}
