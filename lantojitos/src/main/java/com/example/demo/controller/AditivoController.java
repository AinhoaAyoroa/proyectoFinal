package com.example.demo.controller;

import java.util.HashMap;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.model.Aditivo;
import com.example.demo.service.AditivoService;

@RestController
@RequestMapping("/api/aditivos")
public class AditivoController {

    @Autowired
    private AditivoService aditivoService;

    @GetMapping
    public ResponseEntity<List<Aditivo>> listAll() {
        return new ResponseEntity<>(aditivoService.listAllAditivos(), HttpStatus.OK);
    }

    @GetMapping("/tipo/{tipo}")
    public ResponseEntity<List<Aditivo>> listByTipo(@PathVariable String tipo) {
        return new ResponseEntity<>(aditivoService.findByTipo(tipo), HttpStatus.OK);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleError(Exception ex) {
        Map<String, String> err = new HashMap<>();
        err.put("error", ex.getMessage());
        return new ResponseEntity<>(err, HttpStatus.BAD_REQUEST);
    }
}
