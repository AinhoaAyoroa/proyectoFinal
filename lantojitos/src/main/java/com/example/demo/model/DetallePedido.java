package com.example.demo.model;

import java.io.Serializable;
import java.util.Set;
import java.util.HashSet;         
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name = "detalles_pedido")
@Data
@NoArgsConstructor
public class DetallePedido implements Serializable {

    private static final long serialVersionUID = 25L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private int cantidad;
    private double precio;

    @Column(name = "costo_extra")
    private double costoExtra;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pedido_id")
    @ToString.Exclude
    @JsonBackReference
    private Pedido pedido;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "producto_id")
    private Producto producto;

    @ManyToMany
    @JoinTable(
      name = "detalle_pedido_aditivo",
      joinColumns = @JoinColumn(name = "detalle_pedido_id"),
      inverseJoinColumns = @JoinColumn(name = "aditivo_id")
    )
    private Set<Aditivo> aditivos = new HashSet<>();
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null) return false;
        if (getClass() != obj.getClass()) return false;
        DetallePedido other = (DetallePedido) obj;
        if (id == null) {
            if (other.id != null) return false;
        } else if (!id.equals(other.id)) return false;
        return true;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}