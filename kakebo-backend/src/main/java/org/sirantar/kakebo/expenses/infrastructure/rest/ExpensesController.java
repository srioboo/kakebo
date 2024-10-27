package org.sirantar.kakebo.expenses.infrastructure.rest;

import jakarta.websocket.server.PathParam;
import org.sirantar.kakebo.expenses.application.dto.ExpenseDTO;
import org.sirantar.kakebo.expenses.application.service.ExpensesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/")
public class ExpensesController {

	private final ExpensesService expensesService;

	@Autowired
	public ExpensesController(ExpensesService expensesService){
		this.expensesService = expensesService;
	}

    @GetMapping(path = "/expenses")
    public List<ExpenseDTO> getExpenses() {
		return expensesService.getExpenses();
    }

	@GetMapping(path = "/expenses/{id}")
	public ExpenseDTO getExpenseById(@PathParam("id") String id) {
		System.out.println("entra, id ->" + id); // TODO - eliminar
		return expensesService.getExpenseById(1L);
	}
}
