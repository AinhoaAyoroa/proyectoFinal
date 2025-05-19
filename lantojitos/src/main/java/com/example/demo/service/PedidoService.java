package com.example.demo.service;

import java.util.List;
import java.util.Optional;
import com.example.demo.model.Pedido;

public interface PedidoService {
    List<Pedido> listAllPedidos();
    List<Pedido> listAllPedidosByEstado(String estado);
    Optional<Pedido> getPedidoById(Long id);
    Pedido savePedido(Pedido pedido);
    Pedido updatePedido(Pedido pedido);
    boolean deletePedido(Long id);
}
