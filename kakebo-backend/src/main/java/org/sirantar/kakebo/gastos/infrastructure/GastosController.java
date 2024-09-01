package org.sirantar.kakebo.gastos.infrastructure;

import jakarta.websocket.server.PathParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GastosController {

    @GetMapping(path = "/hola/{id}")
    public void test(@PathParam("id") String id) {
        System.out.println("entra");
        System.out.println(id);

    }

}
