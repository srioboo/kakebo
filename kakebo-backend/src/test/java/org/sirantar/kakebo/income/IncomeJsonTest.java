package org.sirantar.kakebo.income;

import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.json.JsonTest;
import org.springframework.boot.test.json.JacksonTester;
import org.springframework.boot.test.json.JsonContent;
import org.springframework.boot.test.json.ObjectContent;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.assertThat;

@JsonTest
public class IncomeJsonTest {

	private static final Incomes INCOME = new Incomes(1, BigDecimal.valueOf(10), "income 1",  LocalDateTime.of(2024, 12, 12, 22, 0));

	// TODO add json
	private static final String JSON_INCOME = """
		{
			"id": 1,
			"amount": 10,
			"nombre": "income 1",
			"date": 2025/12/12
		}
		""";


	@Autowired
	private JacksonTester<Incomes> jsonTester;

	@Test
	void serializationIncomesTest() throws IOException {
		JsonContent<Incomes> jsonMyIncome = jsonTester.write(INCOME);

		assertThat(jsonMyIncome).hasJsonPathNumberValue("@.id");
	}

	@Test
	void deserializationIncomesTest() throws IOException {

		ObjectContent<Incomes> objectMyIncome = jsonTester.parse(JSON_INCOME);
		assertThat(objectMyIncome).isEqualTo(INCOME);
		Incomes income = jsonTester.parseObject(JSON_INCOME);
		assertThat(income.getId()).isEqualTo(1);
		assertThat(income.getAmount()).isEqualTo(10L);
		assertThat(income.getIncomeName()).isEqualTo("income 1");
		assertThat(income.getIncomeDate()).isEqualTo(2005);
	}
}
