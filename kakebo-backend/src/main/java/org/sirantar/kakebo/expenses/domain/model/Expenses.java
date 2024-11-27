package org.sirantar.kakebo.expenses.domain.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "t_expenses")
public class Expenses {

	@Id
	Integer id;
	BigDecimal amount;
	String expenseName;
	LocalDateTime expenseDate;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getExpenseName() {
		return expenseName;
	}

	public void setExpenseName(String expenseName) {
		this.expenseName = expenseName;
	}

	public LocalDateTime getExpenseDate() {
		return expenseDate;
	}

	public void setExpenseDate(LocalDateTime expenseDate) {
		this.expenseDate = expenseDate;
	}

}
