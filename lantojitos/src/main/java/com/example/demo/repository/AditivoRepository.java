package com.example.demo.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.demo.model.Aditivo;

@Repository
public interface AditivoRepository extends JpaRepository<Aditivo, Long> {
    List<Aditivo> findByTipo(String tipo);
}