package com.example.demo.model;

import java.io.Serializable;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "aditivos")
@Data
@NoArgsConstructor
public class Aditivo implements Serializable {
    private static final long serialVersionUID = 25L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private String tipo;

    @Column(name = "precio_extra", nullable = false)
    private double precioExtra;
    
    
    
}
