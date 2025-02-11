package org.sirantar.kakebo.income;

import static org.assertj.core.api.Assertions.assertThat;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {

	@Autowired
	TestRestTemplate restTemplate;

	@Test
	void queryIncomeTest() {
		ResponseEntity<String> response = restTemplate.getForEntity("incomes/1", String.class);

		assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

		DocumentContext documentContext = JsonPath.parse(response.getBody());

		Number id = documentContext.read("$.id");
		assertThat(id).isEqualTo(1);

		String name = documentContext.read("$.incomeName");
		assertThat(name).isEqualTo("income 1");

		// TODO add  rest
	}

	@Test
	void createIncomeTest() {
		Incomes income = new Incomes(1, BigDecimal.TEN, "new income", LocalDateTime.of(2025, 10, 10, 1, 0, 0));
		ResponseEntity<Incomes> createResponse = restTemplate.postForEntity("/income", income, Incomes.class);

		// assertThat(createRespponse.get)


	}

/*
	@Test
	void crearRemolachaTest() {
		Verdura remolacha = new Verdura(0, "Remolacha", 4.52, false);
		ResponseEntity<Verdura> createResponse = restTemplate.postForEntity("/verduras", remolacha, Verdura.class);
		// comprobación status respuesta
		assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);

		// recuperación URI del objeto creado
		URI remolachaLocation = createResponse.getHeaders().getLocation();
		// recuperación del nuevo id
		Number nuevoId = recuperarId(remolachaLocation);

		// comprobación body respuesta
		Verdura remolachaCreada = JsonPath.parse(createResponse.getBody()).json();
		assertThat(remolachaCreada.getId()).isEqualTo(nuevoId);
		assertThat(remolachaCreada.getNombre()).isEqualTo("Remolacha");
		assertThat(remolachaCreada.getPrecio()).isEqualTo(4.52);
		assertThat(remolachaCreada.isTroceable()).isFalse();
		// comprobación get by id del objeto creado
		ResponseEntity<String> getResponse = restTemplate.getForEntity(remolachaLocation, String.class);
		assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
		DocumentContext documentContext = JsonPath.parse(getResponse.getBody());
		Number id = documentContext.read("$.id");
		assertThat(id).isNotNull(); // no sabemos cuál será
		     assertThat(id).isNotEqualTo(0);
			 assertThat(Long.valueOf(id.longValue())).isEqualTo((long)nuevoId); // o sí
		String nombre = documentContext.read("$.nombre");
		assertThat(nombre).isEqualTo("Remolacha");
		Double precio = documentContext.read("$.precio");
		assertThat(precio).isEqualTo(4.52);
		Boolean troceable = documentContext.read("$.troceable");
		assertThat(troceable).isFalse();
	}

	private long recuperarId(URI remolachaLocation) {
		String path = remolachaLocation.getPath();
		String idText = path.substring(path.lastIndexOf('/') + 1);
		return Long.parseLong(idText);                                                        }

 */

}
