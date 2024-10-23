package org.sirantar.kakebo.income.infrastructure.persistence;

import org.sirantar.kakebo.income.domain.model.Income;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;

public class JpaIncomeRepository implements IncomeRepository {

	@Override
	public Income findById(Long id) {
		return null;
	}
}
