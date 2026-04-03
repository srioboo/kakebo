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

	public Expenses() {
	}

	public Expenses(Integer id, BigDecimal amount, String expenseName, LocalDateTime expenseDate) {
		this.id = id;
		this.amount = amount;
		this.expenseName = expenseName;
		this.expenseDate = expenseDate;
	}

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

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		Expenses expenses = (Expenses) o;

		if (id != null ? !id.equals(expenses.id) : expenses.id != null) return false;
		if (amount != null ? !amount.equals(expenses.amount) : expenses.amount != null) return false;
		if (expenseName != null ? !expenseName.equals(expenses.expenseName) : expenses.expenseName != null)
			return false;
		return expenseDate != null ? expenseDate.equals(expenses.expenseDate) : expenses.expenseDate == null;
	}

	@Override
	public int hashCode() {
		int result = id != null ? id.hashCode() : 0;
		result = 31 * result + (amount != null ? amount.hashCode() : 0);
		result = 31 * result + (expenseName != null ? expenseName.hashCode() : 0);
		result = 31 * result + (expenseDate != null ? expenseDate.hashCode() : 0);
		return result;
	}
}
