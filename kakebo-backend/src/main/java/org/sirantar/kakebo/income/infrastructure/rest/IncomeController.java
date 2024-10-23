package org.sirantar.kakebo.income.infrastructure.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/incomes/")
public class IncomeController {

    @GetMapping("/income/")
    public void getIncome(){

    }
}
