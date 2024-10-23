package org.sirantar.kakebo.expenses.infrastructure.rest;

import jakarta.websocket.server.PathParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/expenses/")
public class ExpensesController {

	/* private final ExpensesService expensesService;

	public ExpensesController(ExpensesService expensesService){
		this.expensesService = expensesService;
	} */

    @GetMapping(path = "/hola/{id}")
    public void test(@PathParam("id") String id) {
        System.out.println("entra");
        System.out.println(id);

    }

}
