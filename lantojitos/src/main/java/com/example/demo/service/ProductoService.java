package com.example.demo.service;

import java.util.List;
import java.util.Optional;
import com.example.demo.model.Producto;

public interface ProductoService {
    List<Producto> listAllProductos();
    Optional<Producto> getProductoById(Long id);
    Producto saveProducto(Producto producto);
    Producto updateProducto(Producto producto);
    boolean deleteProducto(Long id);
    List<Producto> findProductosByCategoria(String categoria);
}