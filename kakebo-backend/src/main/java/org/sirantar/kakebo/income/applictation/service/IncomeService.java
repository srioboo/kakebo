package org.sirantar.kakebo.income.applictation.service;

import org.sirantar.kakebo.income.domain.model.Incomes;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class IncomeService {

	private final IncomeRepository incomeRepository;

	public IncomeService(IncomeRepository incomeRepository) {
		this.incomeRepository = incomeRepository;
	}

	public Iterable<Incomes> getIncomes() {
		return incomeRepository.findAll();
	}

	public Incomes getIncome(Long id) {
		Optional<Incomes> result = incomeRepository.findById(id);
		return result.orElse(new Incomes());
	}

}
