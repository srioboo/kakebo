package org.sirantar.kakebo.expenses;

import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
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
public class ExpenseJsonTest {

	private static final Expenses EXPENSE = new Expenses(1, BigDecimal.valueOf(10), "expense 1",
		LocalDateTime.of(2025, 1, 1, 0, 0));

	private static final String JSON_EXPENSE = """
		  {
			"id": 1,
			"amount": 10,
			"expenseName": "expense 1",
			"expenseDate": "2025-01-01T00:00:00"
		  }
		""";

	@Autowired
	private JacksonTester<Expenses> jsonTester;

	@Test
	void serializationExpensesTest() throws IOException {
		JsonContent<Expenses> jsonMyExpense = jsonTester.write(EXPENSE);

		assertThat(jsonMyExpense).hasJsonPathNumberValue("@.id");
		assertThat(jsonMyExpense).extractingJsonPathNumberValue("@.id").isEqualTo(1);

		assertThat(jsonMyExpense).hasJsonPathNumberValue("@.amount");
		assertThat(jsonMyExpense).extractingJsonPathNumberValue("@.amount").isEqualTo(10);

		assertThat(jsonMyExpense).hasJsonPathStringValue("@.expenseName");
		assertThat(jsonMyExpense).extractingJsonPathStringValue("@.expenseName").isEqualTo("expense 1");

		assertThat(jsonMyExpense).hasJsonPathStringValue("@.expenseDate");
		assertThat(jsonMyExpense).extractingJsonPathStringValue("@.expenseDate").isEqualTo("2025-01-01T00:00:00");
	}

	@Test
	void deserializationExperensesTest() throws IOException {
		ObjectContent<Expenses> objectMyExpense = jsonTester.parse(JSON_EXPENSE);
		assertThat(objectMyExpense).isEqualTo(EXPENSE);
		Expenses expense = jsonTester.parseObject(JSON_EXPENSE);
		assertThat(expense.getId()).isEqualTo(1);
		assertThat(expense.getAmount()).isEqualTo(10L);
		assertThat(expense.getExpenseName()).isEqualTo("income 1");
		assertThat(expense.getExpenseDate()).isEqualTo("2025-01-01T00:00:00");
	}
}
