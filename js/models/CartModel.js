class CartModel {
    constructor() {
        this.items = [];
    }

    /**
     * Lógica de negocio: Agregar item al carrito
     * @param {CartItemModel} item - Item a agregar
     */
    addItem(item) {
        this.items.push(item);
    }

    /**
     * Lógica de negocio: Eliminar item del carrito
     * @param {number} index - Índice del item a eliminar
     */
    removeItem(index) {
        this.items.splice(index, 1);
    }

    /**
     * Lógica de negocio: Actualizar cantidad de un item
     * @param {number} index - Índice del item
     * @param {number} newQuantity - Nueva cantidad
     */
    updateQuantity(index, newQuantity) {
        if (newQuantity > 0) {
            this.items[index].cantidad = newQuantity;
        }
    }

    /**
     * Lógica de negocio: Calcular subtotal del carrito
     * @returns {number} Subtotal
     */
    calcularSubtotal() {
        return this.items.reduce((sum, item) => sum + item.calcularPrecio(), 0);
    }

    /**
     * Obtener cantidad total de items
     * @returns {number} Total de items
     */
    getTotalItems() {
        return this.items.reduce((sum, item) => sum + item.cantidad, 0);
    }

    /**
     * Vaciar el carrito
     */
    clear() {
        this.items = [];
    }

    /**
     * Verificar si el carrito está vacío
     * @returns {boolean} True si está vacío
     */
    isEmpty() {
        return this.items.length === 0;
    }
}