package org.sirantar.kakebo.expenses.infrastructure.presistence;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.expenses.domain.repository.ExpensesRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class JpaExpenseRepository implements ExpensesRepository {

	@PersistenceContext
	private EntityManager entityManager;


	@Override
	public Expenses save(Expenses expense) {
		return null;
	}

	@Override
	public Expenses findById(Long id) {
		return null;
	}

	@Override
	public List<Expenses> findAll() {
		return List.of();
	}
}
