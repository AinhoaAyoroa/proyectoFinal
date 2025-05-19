package com.example.demo.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.Pedido;
import com.example.demo.service.PedidoService;

@RestController
@RequestMapping("/api/pedidos")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    @GetMapping
    public ResponseEntity<List<Pedido>> getAll(
            @RequestParam(value = "estado", required = false) String estado) {
        List<Pedido> lista = (estado == null)
            ? pedidoService.listAllPedidos()
            : pedidoService.listAllPedidosByEstado(estado);
        return ResponseEntity.ok(lista);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pedido> getById(@PathVariable Long id) {
        return pedidoService.getPedidoById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Pedido> create(@RequestBody Pedido pedido) {
        Pedido saved = pedidoService.savePedido(pedido);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Pedido> update(
            @PathVariable Long id,
            @RequestBody Pedido pedido) {
        pedido.setId(id);
        return ResponseEntity.ok(pedidoService.updatePedido(pedido));
    }

    @PatchMapping("/{id}/estado")
    public ResponseEntity<Pedido> updateEstado(
            @PathVariable Long id,
            @RequestParam("nuevo") String nuevoEstado) {

        return pedidoService.getPedidoById(id)
            .map(p -> {
                p.setEstado(nuevoEstado);
                Pedido actualizado = pedidoService.updatePedido(p);
                return ResponseEntity.ok(actualizado);
            })
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        boolean ok = pedidoService.deletePedido(id);
        return ok
            ? ResponseEntity.ok().build()
            : ResponseEntity.notFound().build();
    }
}
