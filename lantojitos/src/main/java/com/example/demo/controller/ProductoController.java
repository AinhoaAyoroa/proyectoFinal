package com.example.demo.controller;

//import java.util.HashMap;
import java.util.List;

//import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
//import org.springframework.web.servlet.NoHandlerFoundException;

import com.example.demo.model.Producto;
import com.example.demo.service.ProductoService;

@RestController
@RequestMapping("/api/productos")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    @GetMapping
    public ResponseEntity<List<Producto>> listAllProductos() {
        List<Producto> productos = productoService.listAllProductos();
        return new ResponseEntity<>(productos, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Producto> getProductoById(@PathVariable Long id) {
        return productoService.getProductoById(id)
                .map(prod -> new ResponseEntity<>(prod, HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<Object> createProducto(@RequestBody Producto producto) {
        Producto saved = productoService.saveProducto(producto);
        if (saved == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("Producto creado correctamente con id " + saved.getId(), HttpStatus.CREATED);
    }

    @PutMapping
    public ResponseEntity<Object> updateProducto(@RequestBody Producto producto) {
        if (producto.getId() == null || !productoService.getProductoById(producto.getId()).isPresent()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        Producto updated = productoService.updateProducto(producto);
        return new ResponseEntity<>(updated, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteProducto(@PathVariable Long id) {
        boolean deleted = productoService.deleteProducto(id);
        if (!deleted) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>("Producto eliminado correctamente", HttpStatus.OK);
    }

    @GetMapping("/categoria/{categoria}")
    public ResponseEntity<List<Producto>> getProductosByCategoria(@PathVariable String categoria) {
        List<Producto> lista = productoService.findProductosByCategoria(categoria);
        return new ResponseEntity<>(lista, HttpStatus.OK);
    }

    // errores
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<String> handleTypeMismatch(MethodArgumentTypeMismatchException ex) {
        return new ResponseEntity<>("Parámetro inválido: " + ex.getName(), HttpStatus.BAD_REQUEST);
    }

 // @ExceptionHandler(NoHandlerFoundException.class)
 //  public ResponseEntity<Map<String, Object>> handleNotFound(NoHandlerFoundException ex) {
 //      Map<String, Object> resp = new HashMap<>();
 //      resp.put("error", "404 Not Found");
 //      resp.put("mensaje", "Recurso no encontrado: " + ex.getRequestURL());
 //       return new ResponseEntity<>(resp, HttpStatus.NOT_FOUND);
 //   }
}