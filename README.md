# L'antojitos - Proyecto final
Este repositorio contiene:  
1. **Backend**: API REST con Spring Boot + MySQL  
2. **Frontend**: App móvil/web con Flutter (cliente de pedidos)  
3. **Dashboard de Pedidos**: App Flutter para manejar y actualizar en tiempo real los pedidos  
4. **Esquema SQL**: Import de la base de datos MySQL

## 📋 Prerrequisitos
- **Java 17**  
- **Maven**  
- **MySQL ≥ 8**  
- **Flutter ≥ 3**  
- **Visual Studio Code** (u otro IDE compatible)  
- **Navegador** (preferentemente Chrome para la web)  
- **Docker** (opcional pero recomendado para la base de datos)

## 🔧 Instrucciones:
1. **Arrancar MySQL**  
   - Si usas Docker:  
     ```bash
     docker run -d --name lantojitos-db -p 3306:3306 \
       -e MYSQL_ROOT_PASSWORD=tu_password \
       -e MYSQL_DATABASE=lantojitos_db \
       mysql:8
     ```
2. **Importar esquema y datos iniciales**  
   ```bash
   mysql -u root -p lantojitos_db < import_lantojitos.sql
3. **Configurar Spring Boot**
   - Edita src/main/resources/application.properties con tus credenciales MySQL y URL
4. **Arrancar la API**
5. **Arrancar lantojitos_app con:**
   ```bash
      flutter -run
   ```
7. **Arrancar ordenes_app**

## 🎯 Uso
- **Home (lantojitos_app)**  
  Muestra catálogo de mini-bocadillos
- **Detalle de Producto (lantojitos_app)**  
  Personaliza tu pan, carne, toppings y pincho
- **Carrito (lantojitos_app)**  
  Consulta la selección, elimina ítems o confirma el pedido

- **Dashboard de Pedidos (ordenes_app)**  
  - Lista de pedidos pendientes (auto-refrescado cada 4 s)
  - Pulsa sobre un pedido para ver detalle de líneas, extras y aditivos  
  - Botón “Marcar como FINALIZADO” para actualizar estado en tiempo real
