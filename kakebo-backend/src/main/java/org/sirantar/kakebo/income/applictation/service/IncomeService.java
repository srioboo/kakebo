package org.sirantar.kakebo.income.applictation.service;

import org.sirantar.kakebo.income.applictation.dto.IncomeDTO;
import org.sirantar.kakebo.income.domain.model.Income;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class IncomeService {

	private final IncomeRepository incomeRepository;

	public IncomeService(IncomeRepository incomeRepository){
		this.incomeRepository = incomeRepository;
	}

	public List<Income> getIncomes() {
		return incomeRepository.findAll();
	}

	public Income getIncome(Long id){
		Optional<Income> result = incomeRepository.findById(id);
		return result.orElse(new Income());
	}

}
