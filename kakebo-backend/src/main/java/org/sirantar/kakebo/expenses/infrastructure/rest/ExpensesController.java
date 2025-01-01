package org.sirantar.kakebo.expenses.infrastructure.rest;

import com.fasterxml.jackson.core.JsonProcessingException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.websocket.server.PathParam;
import org.sirantar.kakebo.expenses.application.service.ExpensesService;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

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
	public List<Expenses> getExpenses() {
		// TODO - use DTO and conversors
		return expensesService.getExpenses();
	}

	@GetMapping(path = "/expenses/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
	@Operation(summary = "Get one determined expense", description = "Get all the data related with the expense given in the parameter")
	public Expenses getExpenseById(
		@PathParam("id")
		@Parameter(name = "id", description = "Value of the expernse identifier ", example = "1")
		Long id) throws JsonProcessingException {
		// TODO - use DTO and conversors
		// ObjectMapper om = new ObjectMapper();
		return expensesService.getExpenseById(id);
	}
}
