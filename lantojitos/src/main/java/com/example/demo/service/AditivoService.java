package com.example.demo.service;

import java.util.List;
import com.example.demo.model.Aditivo;

public interface AditivoService {
    List<Aditivo> listAllAditivos();
    List<Aditivo> findByTipo(String tipo);
}