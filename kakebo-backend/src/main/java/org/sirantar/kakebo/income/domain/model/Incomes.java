package org.sirantar.kakebo.income.domain.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "t_incomes")
public class Incomes {

	@Id
	Integer id;
	BigDecimal amount;
	String incomeName;
	LocalDateTime incomeDate;

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

	public String getIncomeName() {
		return incomeName;
	}

	public void setIncomeName(String incomeName) {
		this.incomeName = incomeName;
	}

	public LocalDateTime getIncomeDate() {
		return incomeDate;
	}

	public void setIncomeDate(LocalDateTime incomeDate) {
		this.incomeDate = incomeDate;
	}
}
