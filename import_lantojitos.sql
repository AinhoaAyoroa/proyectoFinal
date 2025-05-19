CREATE DATABASE IF NOT EXISTS `lantojitos_db`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `lantojitos_db`;

CREATE TABLE `productos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL,
  `precio_base` DECIMAL(10,2) NOT NULL,
  `categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `aditivos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,        
  `precio_extra` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `producto_aditivos` (
  `producto_id` BIGINT UNSIGNED NOT NULL,
  `aditivo_id`  BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`producto_id`, `aditivo_id`),
  CONSTRAINT `fk_pa_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `productos`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pa_aditivo`
    FOREIGN KEY (`aditivo_id`)
    REFERENCES `aditivos`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pedidos` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `estado` VARCHAR(30) NOT NULL,
  `precio_total` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `detalles_pedido` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,       
  `costo_extra` DECIMAL(10,2) NOT NULL,  
  `pedido_id` BIGINT UNSIGNED NOT NULL,
  `producto_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_detalle_pedido_pedido` (`pedido_id`),
  INDEX `idx_detalle_pedido_producto` (`producto_id`),
  CONSTRAINT `fk_detalle_pedido_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedidos`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_pedido_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `productos`(`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `detalle_pedido_aditivo` (
  `detalle_pedido_id` BIGINT UNSIGNED NOT NULL,
  `aditivo_id`       BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`detalle_pedido_id`, `aditivo_id`),
  CONSTRAINT `fk_dpa_detalle`
    FOREIGN KEY (`detalle_pedido_id`)
    REFERENCES `detalles_pedido`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_dpa_aditivo`
    FOREIGN KEY (`aditivo_id`)
    REFERENCES `aditivos`(`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO productos (id, nombre, descripcion, precio_base, categoria) VALUES
  (1, 'Mini Bocadillo Jamón Serrano',
      'Mini bocadillo de jamón serrano con tomate y aceite de oliva',
      4.50, 'Bocadillos'),
  (2, 'Mini Bocadillo Tortilla',
      'Mini bocadillo con tortilla española y mayonesa casera',
      3.95, 'Bocadillos'),
  (3, 'Mini Bocadillo Vegetal',
      'Mini bocadillo con verduras asadas, hummus y aguacate',
      5.25, 'Bocadillos'),
  (4, 'Mini Bocadillo Atún',
      'Mini bocadillo de atún con pimientos y cebolla caramelizada',
      4.75, 'Bocadillos'),
  (5, 'Mini Bocadillo Pollo al Curry',
      'Mini bocadillo con pollo al curry, manzana y salsa de yogur',
      5.00, 'Bocadillos');

INSERT INTO aditivos (id, nombre, tipo, precio_extra) VALUES
  -- Panes
  (10, 'Pan Blanco',    'Pan',     0.00),
  (11, 'Pan Integral',  'Pan',     0.00),
  (12, 'Pan Rojo',      'Pan',     0.20),
  (13, 'Pan Negro',     'Pan',     0.20),
  (14, 'Pan Rosa',      'Pan',     0.20),

  -- Carnes
  (36, 'Pollo a la plancha', 'Carne', 0.00),
  (37, 'Pollo crunchy',      'Carne', 0.80),
  (38, 'Ternera',            'Carne', 0.80),
  (39, 'Carrillera',         'Carne', 0.80),

  -- Toppings
  (20, 'Queso Cheddar',   'Topping', 0.50),
  (21, 'Bacon Crujiente', 'Topping', 0.75),
  (22, 'Tomate Cherry',   'Topping', 0.30),
  (23, 'Aceitunas',       'Topping', 0.40),

  -- Pinchos temáticos
  (30, 'Pincho Harry Potter',   'Pincho', 1.00),
  (31, 'Pincho Spiderman',      'Pincho', 1.00),
  (32, 'Pincho Batman',         'Pincho', 1.00),
  (33, 'Pincho Hello Kitty',    'Pincho', 1.00),
  (34, 'Pincho My Little Pony', 'Pincho', 1.00),
  (35, 'Pincho Fable',          'Pincho', 1.00);
