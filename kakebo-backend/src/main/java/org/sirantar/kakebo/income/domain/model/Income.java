package org.sirantar.kakebo.income.domain.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "T_INCOMES")
public class Income {

	@Id
	Integer id;
	BigDecimal amount;
	String incomeName;
	LocalDateTime incomeDate;

}
