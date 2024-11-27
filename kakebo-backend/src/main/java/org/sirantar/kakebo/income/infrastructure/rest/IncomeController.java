package org.sirantar.kakebo.income.infrastructure.rest;

import org.sirantar.kakebo.income.applictation.service.IncomeService;
import org.sirantar.kakebo.income.domain.model.Income;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/")
public class IncomeController {

	private final IncomeService incomeService;

	@Autowired
	public IncomeController(IncomeService incomeService) {
		this.incomeService = incomeService;
	}

	@GetMapping("/incomes")
	public List<Income> getIncomes() {
		return incomeService.getIncomes();
	}

	@GetMapping("/incomes/{id}")
	public Income getIncome(@PathVariable Long id) {
		return incomeService.getIncome(id);
	}
}
