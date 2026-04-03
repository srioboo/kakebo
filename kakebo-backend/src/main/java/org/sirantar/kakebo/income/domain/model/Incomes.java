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

	public Incomes() {
	}

	public Incomes(Integer id, BigDecimal amount, String incomeName, LocalDateTime incomeDate) {
		this.id = id;
		this.amount = amount;
		this.incomeName = incomeName;
		this.incomeDate = incomeDate;
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

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		Incomes incomes = (Incomes) o;

		if (id != null ? !id.equals(incomes.id) : incomes.id != null) return false;
		if (amount != null ? !amount.equals(incomes.amount) : incomes.amount != null) return false;
		if (incomeName != null ? !incomeName.equals(incomes.incomeName) : incomes.incomeName != null)
			return false;
		return incomeDate != null ? incomeDate.equals(incomes.incomeDate) : incomes.incomeDate == null;
	}

	@Override
	public int hashCode() {
		int result = id != null ? id.hashCode() : 0;
		result = 31 * result + (amount != null ? amount.hashCode() : 0);
		result = 31 * result + (incomeName != null ? incomeName.hashCode() : 0);
		result = 31 * result + (incomeDate != null ? incomeDate.hashCode() : 0);
		return result;
	}
}
