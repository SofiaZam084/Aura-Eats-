class CatalogModel {
    constructor() {
        this.productos = this.initializeProducts();
    }

    /**
     * Inicializar catálogo de productos
     * @returns {Array<ProductModel>} Lista de productos
     */
    initializeProducts() {
        return [
            new ProductModel(1, "Bowl Buddha", "Quinoa, garbanzos, kale, aguacate, zanahoria y aderezo tahini", 18000, "bowls", "🥗"),
            new ProductModel(2, "Bowl Energético", "Arroz integral, pollo orgánico, brócoli, sweet potato y semillas", 22000, "bowls", "🍲"),
            new ProductModel(3, "Bowl Vegano", "Lentejas, espinaca, tofu, edamame y salsa de jengibre", 19500, "bowls", "🥙"),
            new ProductModel(4, "Ensalada César Fit", "Lechuga romana, pollo a la parrilla, parmesano y aderezo ligero", 16500, "ensaladas", "🥬"),
            new ProductModel(5, "Ensalada Mediterránea", "Mix de lechugas, tomate, pepino, aceitunas, queso feta", 17000, "ensaladas", "🥒"),
            new ProductModel(6, "Green Smoothie", "Espinaca, mango, plátano, spirulina y leche de almendras", 12000, "bebidas", "🍵"),
            new ProductModel(7, "Jugo Detox", "Apio, pepino, limón, jengibre y manzana verde", 11000, "bebidas", "🥤"),
            new ProductModel(8, "Bowl de Açaí", "Açaí, granola casera, fresas, banano y miel de abeja", 15000, "postres", "🍇"),
            new ProductModel(9, "Yogurt Bowl", "Yogurt griego, frutas del bosque, chía y almendras", 13500, "postres", "🍨"),
            new ProductModel(10, "Wrap de Pollo", "Tortilla integral, pollo, hummus, vegetales frescos", 16000, "bowls", "🌯")
        ];
    }

    /**
     * Lógica de negocio: Buscar producto por ID
     * @param {number} id - ID del producto
     * @returns {ProductModel|undefined} Producto encontrado
     */
    findById(id) {
        return this.productos.find(p => p.id === id);
    }

    /**
     * Lógica de negocio: Filtrar productos por categoría y término de búsqueda
     * @param {string} categoria - Categoría a filtrar
     * @param {string} searchTerm - Término de búsqueda
     * @returns {Array<ProductModel>} Productos filtrados
     */
    filter(categoria, searchTerm) {
        return this.productos.filter(p => {
            const matchCategory = categoria === 'todos' || p.categoria === categoria;
            const matchSearch = !searchTerm || 
                               p.nombre.toLowerCase().includes(searchTerm.toLowerCase()) ||
                               p.descripcion.toLowerCase().includes(searchTerm.toLowerCase());
            return matchCategory && matchSearch;
        });
    }

    /**
     * Obtener todas las categorías únicas
     * @returns {Array<string>} Lista de categorías
     */
    getCategories() {
        const categories = ['todos'];
        const uniqueCategories = [...new Set(this.productos.map(p => p.categoria))];
        return categories.concat(uniqueCategories);
    }
}