package org.sirantar.kakebo.ingresos.infraestruture;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class IngresosController {

    @GetMapping("/ingresos/")
    public void getIngresos(){

    }
}
