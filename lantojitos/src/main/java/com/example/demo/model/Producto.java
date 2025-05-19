package com.example.demo.model;

import java.io.Serializable;
import java.util.Set;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "productos")
@Data
@NoArgsConstructor
public class Producto implements Serializable {

    private static final long serialVersionUID = 25L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nombre;

    @Column
    private String descripcion;

    @Column(name = "precio_base", nullable = false)
    private double precioBase;

    @Column(nullable = false)
    private String categoria;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "producto_aditivos",
        joinColumns = @JoinColumn(name = "producto_id"),
        inverseJoinColumns = @JoinColumn(name = "aditivo_id")
    )
    @ToString.Exclude
    private Set<Aditivo> aditivos;

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Producto other = (Producto) obj;
        return id != null && id.equals(other.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }
}