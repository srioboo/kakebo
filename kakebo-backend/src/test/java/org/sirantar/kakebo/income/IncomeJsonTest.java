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

	private static final Incomes INCOME = new Incomes(1, BigDecimal.valueOf(10), "income 1",
		LocalDateTime.of(2025, 1, 1, 0, 0));

	private static final String JSON_INCOME = """
		  {
			"id": 1,
			"amount": 10,
			"incomeName": "income 1",
			"incomeDate": "2025-01-01T00:00:00"
		  }
		""";

	@Autowired
	private JacksonTester<Incomes> jsonTester;

	@Test
	void serializationIncomesTest() throws IOException {
		JsonContent<Incomes> jsonMyIncome = jsonTester.write(INCOME);

		assertThat(jsonMyIncome).hasJsonPathNumberValue("@.id");
		assertThat(jsonMyIncome).extractingJsonPathNumberValue("@.id").isEqualTo(1);

		assertThat(jsonMyIncome).hasJsonPathNumberValue("@.amount");
		assertThat(jsonMyIncome).extractingJsonPathNumberValue("@.amount").isEqualTo(10);

		assertThat(jsonMyIncome).hasJsonPathStringValue("@.incomeName");
		assertThat(jsonMyIncome).extractingJsonPathStringValue("@.incomeName").isEqualTo("income 1");

		assertThat(jsonMyIncome).hasJsonPathStringValue("@.incomeDate");
		assertThat(jsonMyIncome).extractingJsonPathStringValue("@.incomeDate").isEqualTo("2025-01-01T00:00:00");
	}

	@Test
	void deserializationIncomesTest() throws IOException {
		ObjectContent<Incomes> objectMyIncome = jsonTester.parse(JSON_INCOME);
		assertThat(objectMyIncome).isEqualTo(INCOME);
		Incomes income = jsonTester.parseObject(JSON_INCOME);
		assertThat(income.getId()).isEqualTo(1);
		assertThat(income.getAmount()).isEqualTo(10L);
		assertThat(income.getIncomeName()).isEqualTo("income 1");
		assertThat(income.getIncomeDate()).isEqualTo("2025-01-01T00:00:00");
	}
}
