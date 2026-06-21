package org.sirantar.kakebo.income;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.income.domain.model.Incomes;
import org.sirantar.kakebo.income.domain.repository.IncomeRepository;
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
class IncomesFilterRestTest {

    @LocalServerPort
    private int port;

    @Autowired
    private IncomeRepository incomeRepository;

    private final RestTemplate restTemplate = new RestTemplate();
    private String baseUrl;

    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
        incomeRepository.deleteAll();

        LocalDate now = LocalDate.now();
        incomeRepository.save(new Incomes(1, BigDecimal.valueOf(200), "ingreso-mes-actual",
            now.atStartOfDay()));
        incomeRepository.save(new Incomes(2, BigDecimal.valueOf(75), "ingreso-enero-2020",
            LocalDateTime.of(2020, 1, 20, 10, 0)));
    }

    @Test
    void getIncomes_withNoParams_returnsCurrentMonthOnly() {
        var response = restTemplate.getForEntity(baseUrl + "/incomes", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        DocumentContext ctx = JsonPath.parse(response.getBody());
        List<Map<String, Object>> incomes = ctx.read("$");

        assertThat(incomes).hasSize(1);
        assertThat((String) incomes.get(0).get("incomeName")).isEqualTo("ingreso-mes-actual");
    }

    @Test
    void getIncomes_withSpecificYearAndMonth_returnsMatchingIncomes() {
        var response = restTemplate.getForEntity(baseUrl + "/incomes?year=2020&month=1", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

        DocumentContext ctx = JsonPath.parse(response.getBody());
        List<Map<String, Object>> incomes = ctx.read("$");

        assertThat(incomes).hasSize(1);
        assertThat((String) incomes.get(0).get("incomeName")).isEqualTo("ingreso-enero-2020");
    }

    @Test
    void getIncomes_withInvalidMonth_returnsBadRequest() {
        try {
            restTemplate.getForEntity(baseUrl + "/incomes?month=13", String.class);
            fail("Expected HttpClientErrorException for invalid month");
        } catch (HttpClientErrorException e) {
            assertThat(e.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        }
    }
}
