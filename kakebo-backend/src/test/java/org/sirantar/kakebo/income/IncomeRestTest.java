package org.sirantar.kakebo.income;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.sirantar.kakebo.income.domain.model.Incomes;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class IncomeRestTest {

	@LocalServerPort
	private int port;

	private String baseUrl;

	private RestTemplate restTemplate = new RestTemplate();

	@org.junit.jupiter.api.BeforeEach
	void setUp() {
		baseUrl = "http://localhost:" + port;
	}

	@Test
	@Disabled
	void queryIncomeTest() {
		var response = restTemplate.getForEntity(baseUrl + "/incomes/1", String.class);

		assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);

		DocumentContext documentContext = JsonPath.parse(response.getBody());

		Number id = documentContext.read("$.id");
		assertThat(id).isEqualTo(1);

		String name = documentContext.read("$.incomeName");
		assertThat(name).isEqualTo("new income");

		// TODO add rest
	}

	@Test
	@Disabled
	void createIncomeTest() {
		Incomes income = new Incomes(1, BigDecimal.TEN, "new income", LocalDateTime.of(2025, 10, 10, 1, 0, 0));

		var response = restTemplate.postForEntity(baseUrl + "/incomes", income, Incomes.class);

		// TODO: revisar el post, no está devolviendo un 201 Created, sino un 200 OK, revisar el controller
		assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
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
