package org.sirantar.kakebo.expenses.infrastructure.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import org.sirantar.kakebo.expenses.application.service.ExpensesService;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "https://localhost:5173")
@RequestMapping("/")
public class ExpensesController {

	private final ExpensesService expensesService;

	@Autowired
	public ExpensesController(ExpensesService expensesService) {
		this.expensesService = expensesService;
	}

	@GetMapping(path = "/expenses")
	@Operation(summary = "Get all expenses", description = "Retrieve a list of all expenses")
	public ResponseEntity<Iterable<Expenses>> getExpenses() {
		// TODO - use DTO and conversors
		return ResponseEntity.ok(expensesService.getExpenses());
	}

	@GetMapping(path = "/expenses/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Get one determined expense", description = "Get all the data related with the expense given in the parameter")
	public Expenses getExpenseById(
		@PathVariable
		@Parameter(name = "id", description = "Value of the expense identifier", example = "1")
		Long id) {
		// TODO - use DTO and conversors
		// ObjectMapper om = new ObjectMapper();
		return expensesService.getExpenseById(id);
	}

	@PostMapping(path = "/expenses", consumes = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Create a new expense", description = "Create and persist a new expense")
	public ResponseEntity<Expenses> createExpense(@RequestBody Expenses expenses) {
		Expenses createdExpense = expensesService.createExpense(expenses);
		return ResponseEntity.ok(createdExpense);
	}

	@PutMapping(path = "/expenses/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Update an existing expense", description = "Update the data of an existing expense")
	public ResponseEntity<Expenses> updateExpense(
		@PathVariable
		@Parameter(name = "id", description = "Value of the expense identifier", example = "1")
		Long id,
		@RequestBody Expenses expenses) {
		Expenses updatedExpense = expensesService.updateExpense(id, expenses);
		if (updatedExpense != null) {
			return ResponseEntity.ok(updatedExpense);
		}
		return ResponseEntity.notFound().build();
	}

	@DeleteMapping(path = "/expenses/{id}")
	@Operation(summary = "Delete an expense", description = "Delete an expense by its identifier")
	public ResponseEntity<Void> deleteExpense(
		@PathVariable
		@Parameter(name = "id", description = "Value of the expense identifier", example = "1")
		Long id) {
		expensesService.deleteExpense(id);
		return ResponseEntity.noContent().build();
	}
}
