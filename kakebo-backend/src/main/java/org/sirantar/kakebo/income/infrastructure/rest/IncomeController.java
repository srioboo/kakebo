package org.sirantar.kakebo.income.infrastructure.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import org.sirantar.kakebo.income.applictation.service.IncomeService;
import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
public class IncomeController {

	private final IncomeService incomeService;

	@Autowired
	public IncomeController(IncomeService incomeService) {
		this.incomeService = incomeService;
	}

	@GetMapping("/incomes")
	@Operation(summary = "Get all incomes", description = "Retrieve a list of all incomes")
	public ResponseEntity<Iterable<Incomes>> getIncomes() {
		return ResponseEntity.ok(incomeService.getIncomes());
	}

	@GetMapping("/incomes/{id}")
	@Operation(summary = "Get one determined income", description = "Get all the data related with the income given in the parameter")
	public Incomes getIncome(
		@PathVariable
		@Parameter(name = "id", description = "Value of the income identifier", example = "1")
		Long id) {
		return incomeService.getIncome(id);
	}

	@PostMapping(path = "/incomes", consumes = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Create a new income", description = "Create and persist a new income")
	public ResponseEntity<Incomes> createIncome(@RequestBody Incomes incomes) {
		Incomes createdIncome = incomeService.createIncome(incomes);
		return ResponseEntity.ok(createdIncome);
	}

	@PutMapping(path = "/incomes/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Update an existing income", description = "Update the data of an existing income")
	public ResponseEntity<Incomes> updateIncome(
		@PathVariable
		@Parameter(name = "id", description = "Value of the income identifier", example = "1")
		Long id,
		@RequestBody Incomes incomes) {
		Incomes updatedIncome = incomeService.updateIncome(id, incomes);
		if (updatedIncome != null) {
			return ResponseEntity.ok(updatedIncome);
		}
		return ResponseEntity.notFound().build();
	}

	@DeleteMapping(path = "/incomes/{id}")
	@Operation(summary = "Delete an income", description = "Delete an income by its identifier")
	public ResponseEntity<Void> deleteIncome(
		@PathVariable
		@Parameter(name = "id", description = "Value of the income identifier", example = "1")
		Long id) {
		incomeService.deleteIncome(id);
		return ResponseEntity.noContent().build();
	}
}
