class View {

    // NAVEGACIÓN
   
    /**
     * Renderizar pantalla específica
     * @param {string} screenName - Nombre de la pantalla (home, catalog, detail, cart)
     */
renderScreen(screenName) {
    // Ocultar todas las pantallas
    document.querySelectorAll('.screen').forEach(screen => {
        screen.classList.add('hidden');
    });

    // Mostrar pantalla solicitada
    const screen = document.getElementById(screenName + 'Screen');
    if (screen) {
        screen.classList.remove('hidden');
        screen.classList.add('fade-in');
    }
    
    // Ocultar/mostrar header según la pantalla
    const header = document.querySelector('.app-header');
    if (screenName === 'detail') {
        header.style.display = 'none';
    } else {
        header.style.display = 'flex';
    }
}

    /**
     * Actualizar navegación inferior
     * @param {string} activeScreen - Pantalla activa
     */
    updateBottomNav(activeScreen) {
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => item.classList.remove('active'));

        const screenMap = { home: 0, catalog: 1, cart: 2 };
        if (screenMap[activeScreen] !== undefined) {
            navItems[screenMap[activeScreen]].classList.add('active');
        }

        this.showBottomNav();
    }

    /**
     * Ocultar barra de navegación inferior
     */
    hideBottomNav() {
        document.getElementById('bottomNav').style.display = 'none';
    }

    /**
     * Mostrar barra de navegación inferior
     */
    showBottomNav() {
        document.getElementById('bottomNav').style.display = 'flex';
    }

    // ========================================
    // CATÁLOGO
    // ========================================

    /**
     * Renderizar filtros de categorías
     * @param {Array<string>} categories - Lista de categorías
     * @param {string} activeCategory - Categoría activa
     */
    renderCategoryFilters(categories, activeCategory) {
        const container = document.getElementById('categoryFilters');
        
        const categoryNames = {
            'todos': 'Todos',
            'bowls': 'Bowls',
            'ensaladas': 'Ensaladas',
            'bebidas': 'Bebidas',
            'postres': 'Postres'
        };

        container.innerHTML = categories.map(cat => `
            <div class="category-chip ${cat === activeCategory ? 'active' : ''}" 
                 onclick="viewModel.filterByCategory('${cat}')">
                ${categoryNames[cat] || cat}
            </div>
        `).join('');
    }

    /**
     * Actualizar filtro activo
     * @param {string} activeCategory - Categoría activa
     */
    updateCategoryFilter(activeCategory) {
        document.querySelectorAll('.category-chip').forEach(chip => {
            chip.classList.remove('active');
        });
        event.target.classList.add('active');
    }

    /**
     * Renderizar grid de productos
     * @param {Array<ProductModel>} products - Lista de productos a mostrar
     */
    renderProducts(products) {
        const grid = document.getElementById('productGrid');
        
        if (products.length === 0) {
            grid.innerHTML = `
                <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #666;">
                    No se encontraron productos
                </div>
            `;
            return;
        }

        grid.innerHTML = products.map(producto => `
            <div class="product-card" onclick="viewModel.navigateToDetail(${producto.id})">
                <div class="product-image">${producto.emoji}</div>
                <div class="product-info">
                    <div class="product-name">${producto.nombre}</div>
                    <div class="product-description">${producto.descripcion}</div>
                    <div class="product-footer">
                        <div class="product-price">$${producto.precio.toLocaleString()}</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); viewModel.quickAddToCart(${producto.id})">
                            +
                        </button>
                    </div>
                </div>
            </div>
        `).join('');
    }

    // ========================================
    // DETALLE DEL PRODUCTO
    // ========================================

    /**
     * Renderizar pantalla de detalle del producto
     * @param {ProductModel} producto - Producto a mostrar
     * @param {Array} sizeOptions - Opciones de tamaño
     * @param {Array} extraOptions - Opciones de extras
     * @param {Object} selectedSize - Tamaño seleccionado
     * @param {Array} selectedExtras - Extras seleccionados
     * @param {number} quantity - Cantidad
     */
    renderProductDetail(producto, sizeOptions, extraOptions, selectedSize, selectedExtras, quantity) {
        // Renderizar información básica
        document.getElementById('detailImage').textContent = producto.emoji;
        document.getElementById('detailName').textContent = producto.nombre;
        document.getElementById('detailDescription').textContent = producto.descripcion;

        // Renderizar opciones de tamaño
        const sizeContainer = document.getElementById('sizeOptions');
        sizeContainer.innerHTML = sizeOptions.map(size => `
            <div class="size-option ${size.nombre === selectedSize.nombre ? 'active' : ''}" 
                 onclick='viewModel.selectSize(${JSON.stringify(size)})'>
                <div class="size-name">${size.nombre}</div>
                <div class="size-price">${size.precio > 0 ? '+$' + size.precio.toLocaleString() : 'Sin cargo'}</div>
            </div>
        `).join('');

        // Renderizar extras
        const extrasContainer = document.getElementById('extrasGrid');
        extrasContainer.innerHTML = extraOptions.map(extra => {
            const isSelected = selectedExtras.some(e => e.nombre === extra.nombre);
            return `
                <div class="extra-option ${isSelected ? 'active' : ''}" 
                     onclick='viewModel.toggleExtra(${JSON.stringify(extra)})'>
                    <div class="extra-name">${extra.nombre}</div>
                    <div class="extra-price">+$${extra.precio.toLocaleString()}</div>
                </div>
            `;
        }).join('');

        // Renderizar cantidad
        document.getElementById('quantityValue').textContent = quantity;
    }

    /**
     * Actualizar selección de tamaño visualmente
     * @param {Object} size - Tamaño seleccionado
     */
    updateSizeSelection(size) {
        document.querySelectorAll('.size-option').forEach(option => {
            option.classList.remove('active');
        });
        event.target.closest('.size-option').classList.add('active');
    }

    /**
     * Actualizar selección de extra visualmente
     * @param {string} extraName - Nombre del extra
     * @param {boolean} isActive - Si está activo o no
     */
    updateExtraSelection(extraName, isActive) {
        const extras = document.querySelectorAll('.extra-option');
        extras.forEach(extra => {
            if (extra.textContent.includes(extraName)) {
                if (isActive) {
                    extra.classList.add('active');
                } else {
                    extra.classList.remove('active');
                }
            }
        });
    }

    /**
     * Actualizar cantidad mostrada
     * @param {number} quantity - Nueva cantidad
     */
    updateQuantity(quantity) {
        document.getElementById('quantityValue').textContent = quantity;
    }

    /**
     * Actualizar precio en botón de agregar
     * @param {number} precio - Precio total calculado
     */
    updateDetailPrice(precio) {
        const btn = document.getElementById('addToCartBtn');
        btn.textContent = `Agregar al Carrito - $${precio.toLocaleString()}`;
    }

    // ========================================
    // CARRITO
    // ========================================

    /**
     * Renderizar pantalla de carrito
     * @param {Array<CartItemModel>} items - Items del carrito
     */
    renderCart(items) {
        const container = document.getElementById('cartContent');

        // Estado vacío
        if (items.length === 0) {
            container.innerHTML = `
                <div class="cart-empty">
                    <div class="cart-empty-icon">🛒</div>
                    <div class="cart-empty-text">Tu carrito está vacío</div>
                    <button class="cta-button" onclick="viewModel.navigateToCatalog()">
                        Volver al Menú
                    </button>
                </div>
            `;
            return;
        }

        // Renderizar items
        const itemsHTML = items.map((item, index) => `
            <div class="cart-item">
                <div class="cart-item-image">${item.producto.emoji}</div>
                <div class="cart-item-info">
                    <div class="cart-item-name">${item.producto.nombre}</div>
                    <div class="cart-item-details">${item.obtenerDescripcion()}</div>
                    <div class="cart-item-price">$${item.calcularPrecio().toLocaleString()}</div>
                </div>
                <div class="cart-item-controls">
                    <div class="cart-quantity-control">
                        <button class="cart-quantity-btn" onclick="viewModel.decreaseCartItemQuantity(${index})">−</button>
                        <div class="cart-quantity">${item.cantidad}</div>
                        <button class="cart-quantity-btn" onclick="viewModel.increaseCartItemQuantity(${index})">+</button>
                    </div>
                    <button class="delete-btn" onclick="viewModel.removeCartItem(${index})">🗑️ Eliminar</button>
                </div>
            </div>
        `).join('');

        // Calcular totales
        const subtotal = items.reduce((sum, item) => sum + item.calcularPrecio(), 0);
        const domicilio = 5000;
        const total = subtotal + domicilio;

        // Renderizar resumen
        const summaryHTML = `
            <div class="cart-summary">
                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span>$${subtotal.toLocaleString()}</span>
                </div>
                <div class="summary-row">
                    <span>Domicilio:</span>
                    <span>$${domicilio.toLocaleString()}</span>
                </div>
                <div class="summary-row total">
                    <span>Total:</span>
                    <span>$${total.toLocaleString()}</span>
                </div>
                <button class="checkout-btn" onclick="viewModel.checkout()">
                    Realizar Pedido
                </button>
            </div>
        `;

        container.innerHTML = itemsHTML + summaryHTML;
    }

    // ========================================
    // UTILIDADES
    // ========================================

    /**
     * Actualizar badge del carrito
     * @param {number} count - Número de items
     */
    updateCartBadge(count) {
        const badge = document.getElementById('cartBadge');
        badge.textContent = count;
        badge.style.display = count > 0 ? 'flex' : 'none';
    }

    /**
     * Mostrar notificación toast
     * @param {string} message - Mensaje a mostrar
     */
    showToast(message) {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
        }, 2000);
    }
}