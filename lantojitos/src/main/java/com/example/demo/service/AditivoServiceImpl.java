package com.example.demo.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.demo.model.Aditivo;
import com.example.demo.repository.AditivoRepository;
// import com.example.demo.service.AditivoService;

@Service
@Transactional
public class AditivoServiceImpl implements AditivoService {

    @Autowired
    private AditivoRepository aditivoRepository;

    @Override
    public List<Aditivo> listAllAditivos() {
        return aditivoRepository.findAll();
    }

    @Override
    public List<Aditivo> findByTipo(String tipo) {
        return aditivoRepository.findByTipo(tipo);
    }
}