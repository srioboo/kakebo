package org.sirantar.kakebo.income.applictation.dto;

import java.math.BigDecimal;

public class IncomeDTO {

	private Long id;
	private String name;
	private BigDecimal amount;

	public IncomeDTO(BigDecimal amount, String name, Long id) {
		this.amount = amount;
		this.name = name;
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
}
