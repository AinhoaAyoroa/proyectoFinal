package com.example.demo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.model.Pedido;
import com.example.demo.repository.PedidoRepository;

@Service
@Transactional
public class PedidoServiceImpl implements PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;

    @Override
    public List<Pedido> listAllPedidos() {
        return pedidoRepository.findAll();
    }

    @Override
    public List<Pedido> listAllPedidosByEstado(String estado) {
        return pedidoRepository.findByEstado(estado);
    }

    @Override
    public Optional<Pedido> getPedidoById(Long id) {
        return pedidoRepository.findById(id);
    }

    @Override
    public Pedido savePedido(Pedido pedido) {
        return pedidoRepository.save(pedido);
    }

    @Override
    public Pedido updatePedido(Pedido pedido) {
        return pedidoRepository.save(pedido);
    }

    @Override
    public boolean deletePedido(Long id) {
        Optional<Pedido> ped = pedidoRepository.findById(id);
        if (ped.isPresent()) {
            pedidoRepository.delete(ped.get());
            return true;
        }
        return false;
    }
}
