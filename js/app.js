const view = new View();

// El ViewModel se crea después (depende de que view exista)
const viewModel = new ViewModel();

// CONFIGURACIÓN INICIAL

// Inicializar badge del carrito en 0
view.updateCartBadge(0);

// Log para confirmar que la app se inicializó correctamente
console.log('✅ VerdeBienestar iniciado correctamente');
console.log('📦 Arquitectura: MVVM Modular');
console.log('📁 Archivos cargados:', {
    models: ['ProductModel', 'CartItemModel', 'CatalogModel', 'CartModel'],
    viewmodels: ['ViewModel'],
    views: ['View']
});

// Comentar o eliminar en producción
window.DEBUG = {
    view: view,
    viewModel: viewModel,
    catalogModel: viewModel.catalogModel,
    cartModel: viewModel.cartModel
};

console.log('💡 Tip: Abre la consola y escribe "DEBUG" para ver los objetos de la app');