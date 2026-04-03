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

	public Incomes createIncome(Incomes incomes) {
		return incomeRepository.save(incomes);
	}

	public Incomes updateIncome(Long id, Incomes incomes) {
		Optional<Incomes> existingIncome = incomeRepository.findById(id);
		if (existingIncome.isPresent()) {
			Incomes income = existingIncome.get();
			if (incomes.getAmount() != null) {
				income.setAmount(incomes.getAmount());
			}
			if (incomes.getIncomeName() != null) {
				income.setIncomeName(incomes.getIncomeName());
			}
			if (incomes.getIncomeDate() != null) {
				income.setIncomeDate(incomes.getIncomeDate());
			}
			return incomeRepository.save(income);
		}
		return null;
	}

	public void deleteIncome(Long id) {
		incomeRepository.deleteById(id);
	}

}
