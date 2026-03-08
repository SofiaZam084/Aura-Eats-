class CartItemModel {
    constructor(producto, tamaño, extras, cantidad) {
        this.producto = producto; // ProductModel
        this.tamaño = tamaño;     // { nombre: string, precio: number }
        this.extras = extras;     // Array de { nombre: string, precio: number }
        this.cantidad = cantidad; // number
    }

    /**
     * Lógica de negocio: Calcular precio total del item
     * @returns {number} Precio total
     */
    calcularPrecio() {
        let precio = this.producto.precio;
        
        // Sumar precio por tamaño
        precio += this.tamaño.precio;
        
        // Sumar precio de cada extra
        this.extras.forEach(extra => {
            precio += extra.precio;
        });
        
        // Multiplicar por cantidad
        return precio * this.cantidad;
    }

    /**
     * Generar descripción legible del item
     * @returns {string} Descripción formateada
     */
    obtenerDescripcion() {
        const parts = [this.tamaño.nombre];
        
        if (this.extras.length > 0) {
            const extrasNombres = this.extras.map(e => e.nombre).join(', ');
            parts.push(extrasNombres);
        }
        
        return parts.join(' • ');
    }
}