package org.sirantar.kakebo.expenses.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "T_EXPENSES")
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
}
