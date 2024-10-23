package org.sirantar.kakebo.income.applictation.service;

import org.sirantar.kakebo.income.applictation.dto.IncomeDTO;
import org.sirantar.kakebo.income.domain.model.Income;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;

public class IncomeService {

	private IncomeRepository incomeRepository;

	public IncomeService(IncomeRepository incomeRepository){
		this.incomeRepository = incomeRepository;
	}

	public IncomeDTO getIncome(Long id){
		Income income = incomeRepository.findById(id);
		return new IncomeDTO(null, null, null);
	}

}
