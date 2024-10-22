package org.sirantar.kakebo.ingresos.adapter.in.web;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class IngresosController {

    @GetMapping("/ingresos/")
    public void getIngresos(){

    }
}
