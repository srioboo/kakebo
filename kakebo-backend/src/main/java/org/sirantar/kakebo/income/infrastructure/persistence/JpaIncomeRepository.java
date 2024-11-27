package org.sirantar.kakebo.income.infrastructure.persistence;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.income.domain.model.Income;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class JpaIncomeRepository implements IncomeRepository {

	@PersistenceContext
	private EntityManager entityManager;

	//@Override
	//public Income save(Income expense) {
	//	return null;
	//}

	@Override
	public Optional<Income> findById(Long id) {

		return Optional.ofNullable(entityManager.find(Income.class, 1L));
	}

	@Override
	public List<Income> findAll() {
		return List.of();
	}
}
