/**
 * ViewModel - Coordinador entre Model y View
 * 
 * RESPONSABILIDAD:
 * - Gestionar el estado de la aplicación
 * - Coordinar acciones entre Model y View
 * - Lógica de presentación
 * - NO manipula el DOM directamente (delega a View)
 */
class ViewModel {
    constructor() {
        // Referencias a los modelos
        this.catalogModel = new CatalogModel();
        this.cartModel = new CartModel();

        // Estado de la aplicación
        this.state = {
            currentScreen: 'home',
            currentCategory: 'todos',
            searchTerm: '',
            selectedProduct: null,
            selectedSize: { nombre: 'Regular', precio: 0 },
            selectedExtras: [],
            quantity: 1
        };

        // Opciones de tamaños disponibles (igual para todas las categorías)
        this.sizeOptions = [
            { nombre: 'Regular', precio: 0 },
            { nombre: 'Grande', precio: 4000 },
            { nombre: 'XL', precio: 7000 }
        ];

        // ========================================
        // EXTRAS ESPECÍFICOS POR CATEGORÍA
        // ========================================
        this.extraOptionsByCategory = {
            'bowls': [
                { nombre: '🥑 Aguacate', precio: 3000 },
                { nombre: '🍗 Proteína Extra', precio: 5000 },
                { nombre: '🌰 Semillas Mix', precio: 2000 },
                { nombre: '🥚 Huevo', precio: 2500 }
            ],
            'ensaladas': [
                { nombre: '🧀 Queso Feta', precio: 3000 },
                { nombre: '🥓 Tocineta', precio: 4000 },
                { nombre: '🥜 Nueces', precio: 2500 },
                { nombre: '🥄 Aderezo Premium', precio: 2000 }
            ],
            'bebidas': [
                { nombre: '🍯 Miel', precio: 1500 },
                { nombre: '🥛 Proteína en Polvo', precio: 3000 },
                { nombre: '🧊 Shot de Jengibre', precio: 2000 },
                { nombre: '🌿 Espirulina', precio: 2500 }
            ],
            'postres': [
                { nombre: '🍓 Fresas Extra', precio: 2000 },
                { nombre: '🍫 Chocolate Oscuro', precio: 2500 },
                { nombre: '🥥 Coco Rallado', precio: 1500 },
                { nombre: '🍯 Miel de Maple', precio: 2000 }
            ]
        };

        // Inicializar
        this.init();
    }

    /**
     * Inicializar aplicación
     */
    init() {
        view.renderScreen('home');
    }

    // ========================================
    // NAVEGACIÓN
    // ========================================

    navigateToHome() {
        this.state.currentScreen = 'home';
        view.renderScreen('home');
        view.updateBottomNav('home');
    }

    navigateToCatalog() {
        this.state.currentScreen = 'catalog';
        view.renderScreen('catalog');
        view.updateBottomNav('catalog');
        
        const categories = this.catalogModel.getCategories();
        view.renderCategoryFilters(categories, this.state.currentCategory);
        
        const products = this.catalogModel.filter(this.state.currentCategory, this.state.searchTerm);
        view.renderProducts(products);
    }

    navigateToDetail(productId) {
        this.state.selectedProduct = this.catalogModel.findById(productId);
        this.resetDetailState();
        
        this.state.currentScreen = 'detail';
        view.renderScreen('detail');
        view.hideBottomNav();
        
        // Obtener extras según la categoría del producto
        const categoria = this.state.selectedProduct.categoria;
        const extrasParaCategoria = this.extraOptionsByCategory[categoria] || [];
        
        view.renderProductDetail(
            this.state.selectedProduct,
            this.sizeOptions,
            extrasParaCategoria,  // Extras específicos de la categoría
            this.state.selectedSize,
            this.state.selectedExtras,
            this.state.quantity
        );
        
        this.updateDetailPrice();
    }

    navigateToCart() {
        this.state.currentScreen = 'cart';
        view.renderScreen('cart');
        view.updateBottomNav('cart');
        view.renderCart(this.cartModel.items);
    }

    // ========================================
    // CATÁLOGO
    // ========================================

    filterByCategory(categoria) {
        this.state.currentCategory = categoria;
        const products = this.catalogModel.filter(categoria, this.state.searchTerm);
        view.renderProducts(products);
        view.updateCategoryFilter(categoria);
    }

    search(term) {
        this.state.searchTerm = term;
        const products = this.catalogModel.filter(this.state.currentCategory, term);
        view.renderProducts(products);
    }

    quickAddToCart(productId) {
        const producto = this.catalogModel.findById(productId);
        const item = new CartItemModel(
            producto,
            { nombre: 'Regular', precio: 0 },
            [],
            1
        );
        
        this.cartModel.addItem(item);
        view.updateCartBadge(this.cartModel.getTotalItems());
        view.showToast('¡Producto agregado al carrito!');
    }

    // ========================================
    // DETALLE DEL PRODUCTO
    // ========================================

    resetDetailState() {
        this.state.selectedSize = { nombre: 'Regular', precio: 0 };
        this.state.selectedExtras = [];
        this.state.quantity = 1;
    }

    selectSize(size) {
        this.state.selectedSize = size;
        view.updateSizeSelection(size);
        this.updateDetailPrice();
    }

    toggleExtra(extra) {
        const index = this.state.selectedExtras.findIndex(e => e.nombre === extra.nombre);
        
        if (index > -1) {
            this.state.selectedExtras.splice(index, 1);
        } else {
            this.state.selectedExtras.push(extra);
        }
        
        view.updateExtraSelection(extra.nombre, index === -1);
        this.updateDetailPrice();
    }

    increaseQuantity() {
        this.state.quantity++;
        view.updateQuantity(this.state.quantity);
        this.updateDetailPrice();
    }

    decreaseQuantity() {
        if (this.state.quantity > 1) {
            this.state.quantity--;
            view.updateQuantity(this.state.quantity);
            this.updateDetailPrice();
        }
    }

    updateDetailPrice() {
        let precio = this.state.selectedProduct.precio;
        precio += this.state.selectedSize.precio;
        this.state.selectedExtras.forEach(extra => {
            precio += extra.precio;
        });
        precio *= this.state.quantity;

        view.updateDetailPrice(precio);
    }

    addToCart() {
        const item = new CartItemModel(
            this.state.selectedProduct,
            this.state.selectedSize,
            [...this.state.selectedExtras],
            this.state.quantity
        );

        this.cartModel.addItem(item);
        view.updateCartBadge(this.cartModel.getTotalItems());
        view.showToast('¡Producto agregado al carrito!');
        
        this.navigateToCatalog();
    }

    // ========================================
    // CARRITO
    // ========================================

    increaseCartItemQuantity(index) {
        const item = this.cartModel.items[index];
        this.cartModel.updateQuantity(index, item.cantidad + 1);
        view.renderCart(this.cartModel.items);
    }

    decreaseCartItemQuantity(index) {
        const item = this.cartModel.items[index];
        if (item.cantidad > 1) {
            this.cartModel.updateQuantity(index, item.cantidad - 1);
            view.renderCart(this.cartModel.items);
        }
    }

    removeCartItem(index) {
        this.cartModel.removeItem(index);
        view.updateCartBadge(this.cartModel.getTotalItems());
        view.renderCart(this.cartModel.items);
    }

    checkout() {
        if (this.cartModel.isEmpty()) {
            view.showToast('El carrito está vacío');
            return;
        }

        view.showToast('¡Pedido realizado con éxito! 🎉');
        this.cartModel.clear();
        view.updateCartBadge(0);
        
        setTimeout(() => {
            view.renderCart(this.cartModel.items);
        }, 1500);
    }
}