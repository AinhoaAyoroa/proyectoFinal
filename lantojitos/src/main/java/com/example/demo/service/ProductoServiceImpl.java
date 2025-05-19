package com.example.demo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.model.Producto;
import com.example.demo.repository.ProductoRepository;
// import com.example.demo.service.ProductoService;

@Service
@Transactional
public class ProductoServiceImpl implements ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    @Override
    public List<Producto> listAllProductos() {
        return productoRepository.findAll();
    }

    @Override
    public Optional<Producto> getProductoById(Long id) {
        return productoRepository.findById(id);
    }

    @Override
    public Producto saveProducto(Producto producto) {
        return productoRepository.save(producto);
    }

    @Override
    public Producto updateProducto(Producto producto) {
        return productoRepository.save(producto);
    }

    @Override
    public boolean deleteProducto(Long id) {
        Optional<Producto> prod = productoRepository.findById(id);
        if (prod.isPresent()) {
            productoRepository.delete(prod.get());
            return true;
        }
        return false;
    }

    @Override
    public List<Producto> findProductosByCategoria(String categoria) {
        return productoRepository.findByCategoria(categoria);
    }
}