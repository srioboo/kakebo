package org.sirantar.kakebo.expenses;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.expenses.domain.model.Expenses;
import org.sirantar.kakebo.expenses.domain.repository.ExpensesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("dev")
@TestPropertySource(properties = "spring.sql.init.mode=never")
class ExpensesFilterRestTest {

    @LocalServerPort
    private int port;

    @Autowired
    private ExpensesRepository expensesRepository;

    private final RestTemplate restTemplate = new RestTemplate();
    private String baseUrl;

    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
        expensesRepository.deleteAll();

        LocalDate now = LocalDate.now();
        expensesRepository.save(new Expenses(1, BigDecimal.valueOf(100), "gasto-mes-actual",
            now.atStartOfDay()));
        expensesRepository.save(new Expenses(2, BigDecimal.valueOf(50), "gasto-enero-2020",
            LocalDateTime.of(2020, 1, 15, 10, 0)));
    }

    @Test
    void getExpenses_withNoParams_returnsCurrentMonthOnly() {
        var response = restTemplate.getForEntity(baseUrl + "/expenses", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        DocumentContext ctx = JsonPath.parse(response.getBody());
        List<Map<String, Object>> expenses = ctx.read("$");

        assertThat(expenses).hasSize(1);
        assertThat((String) expenses.get(0).get("expenseName")).isEqualTo("gasto-mes-actual");
    }

    @Test
    void getExpenses_withSpecificYearAndMonth_returnsMatchingExpenses() {
        var response = restTemplate.getForEntity(baseUrl + "/expenses?year=2020&month=1", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        DocumentContext ctx = JsonPath.parse(response.getBody());
        List<Map<String, Object>> expenses = ctx.read("$");

        assertThat(expenses).hasSize(1);
        assertThat((String) expenses.get(0).get("expenseName")).isEqualTo("gasto-enero-2020");
    }

    @Test
    void getExpenses_withInvalidMonth_returnsBadRequest() {
        try {
            restTemplate.getForEntity(baseUrl + "/expenses?month=13", String.class);
            fail("Expected HttpClientErrorException for invalid month");
        } catch (HttpClientErrorException e) {
            assertThat(e.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        }
    }
}
