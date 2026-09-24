// ==========================================
// 1. BANCO DE DATOS LOCAL
// ==========================================

// Catálogo de productos para el Menú Digital
const productosMenu = [
  { id: 1, nombre: "Croissant", categoria: "Panadería", tipo: "Calientes", precio: 4500, disponible: true },
  { id: 2, nombre: "Pan de Queso", categoria: "Panadería", tipo: "Calientes", precio: 3000, disponible: true },
  { id: 3, nombre: "Brownie", categoria: "Panadería", tipo: "Calientes", precio: 9500, disponible: true },
  { id: 4, nombre: "Almuerzo Ejecutivo", categoria: "Almuerzos", tipo: "Calientes", precio: 18000, disponible: true },
  { id: 5, nombre: "Café Americano", categoria: "Bebidas", tipo: "Fríos", precio: 5000, disponible: true },
  { id: 6, nombre: "Capuchino", categoria: "Bebidas", tipo: "Fríos", precio: 6500, disponible: true },
  { id: 7, nombre: "Latte", categoria: "Bebidas", tipo: "Fríos", precio: 7000, disponible: true },
  { id: 8, nombre: "Ensalada César", categoria: "Ensaladas", tipo: "Fríos", precio: 12000, disponible: true }
];

// Estado de pedidos de la aplicación
let pedidos = [];

// Lista de repartidores registrados
let domiciliarios = [
  { nombre: "Carlos Domiciliario", disponible: true, pedidos: 0 },
  { nombre: "Pedro Repartidor", disponible: true, pedidos: 0 },
  { nombre: "Laura Entrega", disponible: true, pedidos: 0 }
];

// Variables globales del carrito/selección
let productosSeleccionadosModal = [];
let idPedidoEnAsignacion = null; // Para saber qué pedido se está asignando en el modal

// ==========================================
// 2. INICIALIZACIÓN DE LA APLICACIÓN
// ==========================================

document.addEventListener("DOMContentLoaded", () => {
  inicializarNavegacionSidebar();
  inicializarEventos();
  inicializarMenuDigital();
  actualizarTodo();
});

// ==========================================
// 3. NAVEGACIÓN Y EVENTOS GENERALES
// ==========================================

function inicializarNavegacionSidebar() {
  document.querySelectorAll('.sidebar-nav .nav-link').forEach(link => {
    link.addEventListener('click', function (e) {
      if (this.id === 'btnLogout' || !this.dataset.section) return;

      e.preventDefault();

      document.querySelectorAll('.sidebar-nav .nav-link').forEach(l => l.classList.remove('active'));
      this.classList.add('active');

      document.querySelectorAll('.content-section').forEach(sec => sec.classList.add('d-none'));

      const sectionId = this.dataset.section;
      const targetSection = document.getElementById(sectionId);
      if (targetSection) {
        targetSection.classList.remove('d-none');
      }
    });
  });
}

function inicializarEventos() {
  // Cambio entre pestañas internas
  const tabs = document.querySelectorAll(".nav-tab-btn");
  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      tabs.forEach(t => {
        t.classList.remove("bg-white", "border", "shadow-sm", "text-dark");
        t.classList.add("text-muted", "border-0");
      });

      tab.classList.remove("text-muted", "border-0");
      tab.classList.add("bg-white", "border", "shadow-sm", "text-dark");

      const targetId = tab.getAttribute("data-target");
      document.querySelectorAll(".tab-pane-content").forEach(pane => pane.classList.add("d-none"));
      
      const targetPane = document.getElementById(targetId);
      if (targetPane) targetPane.classList.remove("d-none");
    });
  });

  // Toggle del Menú de Perfil
  const btnAvatar = document.getElementById("btnAvatar");
  const menuPerfil = document.getElementById("menuPerfil");

  if (btnAvatar && menuPerfil) {
    btnAvatar.addEventListener("click", (e) => {
      e.stopPropagation();
      menuPerfil.classList.toggle("d-none");
      menuPerfil.classList.toggle("show");
    });

    document.addEventListener("click", (e) => {
      if (!menuPerfil.contains(e.target) && e.target !== btnAvatar) {
        menuPerfil.classList.add("d-none");
        menuPerfil.classList.remove("show");
      }
    });
  }

  // Offcanvas Mi Perfil y Ajustes
  const opcionMiPerfil = document.getElementById("opcionMiPerfil");
  if (opcionMiPerfil) {
    opcionMiPerfil.addEventListener("click", () => {
      const el = document.getElementById("panelMiPerfil");
      if (el) bootstrap.Offcanvas.getOrCreateInstance(el).show();
      if (menuPerfil) menuPerfil.classList.add("d-none");
    });
  }

  const opcionAjustes = document.getElementById("opcionAjustes");
  if (opcionAjustes) {
    opcionAjustes.addEventListener("click", () => {
      const el = document.getElementById("panelAjustes");
      if (el) bootstrap.Offcanvas.getOrCreateInstance(el).show();
      if (menuPerfil) menuPerfil.classList.add("d-none");
    });
  }

  // Cerrar Sesión
  const opcionCerrarSesion = document.getElementById("opcionCerrarSesion");
  if (opcionCerrarSesion) {
    opcionCerrarSesion.addEventListener("click", () => {
      if (confirm("¿Estás seguro de que deseas cerrar sesión?")) {
        if (menuPerfil) menuPerfil.classList.add("d-none");
        window.location.href = "login.html";
      }
    });
  }

  // Creación de Pedido desde el Modal
  const formNuevoPedido = document.getElementById("formNuevoPedido");
  if (formNuevoPedido) {
    formNuevoPedido.addEventListener("submit", (e) => {
      e.preventDefault();
      crearNuevoPedido();
    });
  }

  // Confirmación del Modal Asignar Domiciliario
  const btnConfirmarAsignacion = document.getElementById("btnConfirmarAsignacion");
  if (btnConfirmarAsignacion) {
    btnConfirmarAsignacion.addEventListener("click", confirmarAsignacionDomiciliario);
  }
}

// ==========================================
// 4. LÓGICA DEL MENÚ DIGITAL Y CATÁLOGO
// ==========================================

function inicializarMenuDigital() {
  const inputBuscar = document.getElementById("inputBuscar");
  const selectCategoria = document.getElementById("selectCategoria");

  if (inputBuscar) inputBuscar.addEventListener("input", filtrarProductos);
  if (selectCategoria) selectCategoria.addEventListener("change", filtrarProductos);

  renderizarProductos(productosMenu);
}

function formatearPrecio(valor) {
  return "$ " + valor.toLocaleString("es-CO");
}

function renderizarProductos(lista) {
  const gridProductos = document.getElementById("gridProductos");
  const mensajeVacio = document.getElementById("mensajeVacio");
  const tplProducto = document.getElementById("tplProducto");

  if (!gridProductos || !tplProducto) return;

  gridProductos.replaceChildren();

  if (lista.length === 0) {
    if (mensajeVacio) mensajeVacio.classList.remove("d-none");
    return;
  }

  if (mensajeVacio) mensajeVacio.classList.add("d-none");

  lista.forEach(prod => {
    const el = tplProducto.content.cloneNode(true);

    const elemTitulo = el.querySelector(".product-title");
    const elemSub = el.querySelector(".product-sub");
    const elemPrecio = el.querySelector(".product-price");
    const elemStatus = el.querySelector(".product-status");
    const btnAgregar = el.querySelector(".btn-seleccionar-prod");

    if (elemTitulo) elemTitulo.textContent = prod.nombre;
    if (elemSub) elemSub.textContent = `${prod.categoria} · ${prod.tipo}`;
    if (elemPrecio) elemPrecio.textContent = formatearPrecio(prod.precio);
    
    if (elemStatus) {
      elemStatus.textContent = prod.disponible ? "Disponible" : "Agotado";
      if (!prod.disponible) {
        elemStatus.className = "product-status badge bg-danger-subtle text-danger border border-danger-subtle mb-2";
      }
    }

    if (btnAgregar) {
      const estaSeleccionado = productosSeleccionadosModal.some(p => p.id === prod.id);
      if (estaSeleccionado) {
        btnAgregar.classList.replace("btn-outline-warning", "btn-success");
        btnAgregar.innerHTML = `<i class="bi bi-check-lg me-1"></i>Agregado`;
      }

      btnAgregar.addEventListener("click", () => {
        const index = productosSeleccionadosModal.findIndex(p => p.id === prod.id);
        if (index === -1) {
          productosSeleccionadosModal.push(prod);
          btnAgregar.classList.replace("btn-outline-warning", "btn-success");
          btnAgregar.innerHTML = `<i class="bi bi-check-lg me-1"></i>Agregado`;
        } else {
          productosSeleccionadosModal.splice(index, 1);
          btnAgregar.classList.replace("btn-success", "btn-outline-warning");
          btnAgregar.innerHTML = `<i class="bi bi-plus-lg me-1"></i>Agregar`;
        }
      });
    }

    gridProductos.appendChild(el);
  });
}

function filtrarProductos() {
  const inputBuscar = document.getElementById("inputBuscar");
  const selectCategoria = document.getElementById("selectCategoria");

  const textoBusqueda = inputBuscar ? inputBuscar.value.toLowerCase().trim() : "";
  const categoriaSeleccionada = selectCategoria ? selectCategoria.value : "Todos";

  const productosFiltrados = productosMenu.filter(p => {
    const coincideNombre = p.nombre.toLowerCase().includes(textoBusqueda);
    const coincideCategoria = categoriaSeleccionada === "Todos" || p.categoria === categoriaSeleccionada;
    return coincideNombre && coincideCategoria;
  });

  renderizarProductos(productosFiltrados);
}

// ==========================================
// 5. REGISTRO Y CREACIÓN DE NUEVO PEDIDO
// ==========================================

function crearNuevoPedido() {
  const nombre = document.getElementById("nombreCliente").value;
  const telefono = document.getElementById("telefonoCliente").value;
  const direccion = document.getElementById("direccionCliente").value;
  const pago = document.getElementById("metodoPago").value;
  const observaciones = document.getElementById("observaciones").value;

  let textoProductos = "Sin productos seleccionados";
  let totalCalculado = 0;

  if (productosSeleccionadosModal.length > 0) {
    textoProductos = productosSeleccionadosModal.map(p => p.nombre).join(", ");
    totalCalculado = productosSeleccionadosModal.reduce((acc, p) => acc + p.precio, 0);
  }

  const nuevoId = `#PED-${String(pedidos.length + 1).padStart(3, '0')}`;

  const nuevo = {
    id: nuevoId,
    hora: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
    cliente: nombre,
    telefono: telefono,
    direccion: direccion,
    productos: textoProductos,
    precio: totalCalculado > 0 ? formatearPrecio(totalCalculado) : "$ 0",
    pago: pago,
    estado: "Pendiente",
    repartidor: "",
    observaciones: observaciones
  };

  pedidos.push(nuevo);

  document.getElementById("formNuevoPedido").reset();
  productosSeleccionadosModal = [];
  filtrarProductos();

  const modalElem = document.getElementById("nuevoPedido");
  if (modalElem) {
    const modal = bootstrap.Modal.getInstance(modalElem) || new bootstrap.Modal(modalElem);
    modal.hide();
  }

  actualizarTodo();
}

// ==========================================
// 6. ASIGNACIÓN DE DOMICILIARIOS (MODAL)
// ==========================================

function abrirModalAsignar(idPedido) {
  idPedidoEnAsignacion = idPedido;
  const select = document.getElementById("selectDomiciliarios");
  const lblPedido = document.getElementById("lblPedidoId");

  if (lblPedido) lblPedido.textContent = idPedido;

  if (select) {
    select.innerHTML = "";
    domiciliarios.forEach(d => {
      const opt = document.createElement("option");
      opt.value = d.nombre;
      opt.textContent = `${d.nombre} (${d.disponible ? 'Disponible' : 'Ocupado'})`;
      select.appendChild(opt);
    });
  }

  const modalEl = document.getElementById("modalAsignarDomiciliario");
  if (modalEl) {
    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
    modal.show();
  }
}

function confirmarAsignacionDomiciliario() {
  const select = document.getElementById("selectDomiciliarios");
  if (!select || !idPedidoEnAsignacion) return;

  const repartidorSeleccionado = select.value;

  cambiarEstadoPorId(idPedidoEnAsignacion, "En Camino", repartidorSeleccionado);

  const modalEl = document.getElementById("modalAsignarDomiciliario");
  if (modalEl) {
    const modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) modal.hide();
  }

  idPedidoEnAsignacion = null;
}

// ==========================================
// 7. RENDERIZADO DE PESTAÑAS (VISTAS)
// ==========================================

function renderizarPedidos() {
  const contenedor = document.getElementById("contenedorPedidos");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplCompacto = document.getElementById("tpl-pedido-listo-compacto");
  const tplDetallado = document.getElementById("tpl-pedido-detallado");

  const pedidosActivos = pedidos.filter(p => p.estado !== "Entregado");

  if (pedidosActivos.length === 0) {
    contenedor.innerHTML = `<p class="text-center text-muted py-4">No hay pedidos pendientes en lista.</p>`;
    return;
  }

  pedidos.forEach((p) => {
    if (p.estado === "Entregado") return;

    if (p.estado === "Listo" && !p.repartidor) {
      if (!tplCompacto) return;
      const clon = tplCompacto.content.cloneNode(true);

      const elId = clon.querySelector(".data-id");
      const elHora = clon.querySelector(".data-hora");
      const elCliente = clon.querySelector(".data-cliente");
      const elDireccion = clon.querySelector(".data-direccion");
      const elPrecio = clon.querySelector(".data-precio");

      if (elId) elId.textContent = p.id;
      if (elHora) elHora.textContent = p.hora;
      if (elCliente) elCliente.textContent = p.cliente;
      if (elDireccion) elDireccion.textContent = p.direccion;
      if (elPrecio) elPrecio.textContent = p.precio;

      const btnEstado = clon.querySelector(".btn-estado");
      if (btnEstado) {
        btnEstado.onclick = () => abrirModalAsignar(p.id);
      }

      contenedor.appendChild(clon);
    } else {
      if (!tplDetallado) return;
      const clon = tplDetallado.content.cloneNode(true);
      const badge = clon.querySelector(".data-badge-estado");
      const btn = clon.querySelector(".btn-accion");
      const btnIcon = clon.querySelector(".btn-icon");
      const btnTexto = clon.querySelector(".btn-texto");
      const repartidorWrapper = clon.querySelector(".data-repartidor-wrapper");

      const elId = clon.querySelector(".data-id");
      const elPrecio = clon.querySelector(".data-precio");
      const elCliente = clon.querySelector(".data-cliente");
      const elTelefono = clon.querySelector(".data-telefono");
      const elDireccion = clon.querySelector(".data-direccion");
      const elPago = clon.querySelector(".data-pago");

      if (elId) elId.textContent = p.id;
      if (elPrecio) elPrecio.textContent = p.precio;
      if (elCliente) elCliente.textContent = p.cliente;
      if (elTelefono) elTelefono.textContent = p.telefono;
      if (elDireccion) elDireccion.textContent = p.direccion;
      if (elPago) elPago.textContent = p.pago;

      const elemProd = clon.querySelector(".data-productos");
      if (elemProd) elemProd.textContent = p.productos ? `📦 ${p.productos}` : "";

      const elemObs = clon.querySelector(".data-observaciones");
      if (elemObs) elemObs.textContent = p.observaciones ? `📝 ${p.observaciones}` : "";

      if (p.estado === "Pendiente") {
        if (badge) {
          badge.textContent = "Pendiente";
          badge.className = "badge px-2 py-1 bg-warning-subtle text-warning-emphasis";
        }
        if (btn) {
          btn.className = "btn btn-sm btn-outline-primary px-3 d-flex align-items-center gap-1";
          if (btnIcon) btnIcon.className = "bi bi-cup-hot";
          if (btnTexto) btnTexto.textContent = "Preparar";
          btn.onclick = () => cambiarEstadoPorId(p.id, "En Preparación");
        }
      } else if (p.estado === "En Preparación") {
        if (badge) {
          badge.textContent = "En Preparación";
          badge.className = "badge px-2 py-1 bg-info-subtle text-info";
        }
        if (btn) {
          btn.className = "btn btn-sm btn-outline-success px-3 d-flex align-items-center gap-1";
          if (btnIcon) btnIcon.className = "bi bi-check-circle";
          if (btnTexto) btnTexto.textContent = "Marcar Listo";
          btn.onclick = () => cambiarEstadoPorId(p.id, "Listo");
        }
      } else if (p.estado === "En Camino") {
        if (badge) {
          badge.textContent = "En Camino";
          badge.className = "badge px-2 py-1 bg-primary-subtle text-primary";
        }
        if (repartidorWrapper) {
          repartidorWrapper.classList.remove("d-none");
          const elRepartidor = clon.querySelector(".data-repartidor");
          if (elRepartidor) elRepartidor.textContent = p.repartidor;
        }
        if (btn) {
          btn.className = "btn btn-sm text-white px-3 d-flex align-items-center gap-1";
          btn.style.backgroundColor = "#8b5cf6";
          if (btnIcon) btnIcon.className = "bi bi-truck";
          if (btnTexto) btnTexto.textContent = "Confirmar Entrega";
          btn.onclick = () => cambiarEstadoPorId(p.id, "Entregado");
        }
      }

      contenedor.appendChild(clon);
    }
  });
}

function renderizarComandas() {
  const contenedor = document.getElementById("contenedorComandas");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplComanda = document.getElementById("tpl-comanda-card");
  const comandasCocina = pedidos.filter(p => p.estado === "En Preparación");

  if (comandasCocina.length === 0 || !tplComanda) {
    contenedor.innerHTML = `
      <div class="col-12 text-center py-5">
        <i class="bi bi-cup-hot display-4 text-muted d-block mb-2"></i>
        <p class="text-muted fs-6">No hay comandas pendientes por preparar en cocina.</p>
      </div>`;
    return;
  }

  comandasCocina.forEach(p => {
    const clon = tplComanda.content.cloneNode(true);
    
    const elId = clon.querySelector(".data-id");
    const badge = clon.querySelector(".data-badge");
    const elHora = clon.querySelector(".data-hora");
    const elProd = clon.querySelector(".data-productos");
    const elObs = clon.querySelector(".data-observaciones");
    const btnAccionCocina = clon.querySelector(".btn-accion-cocina, button");

    if (elId) elId.textContent = p.id;
    if (badge) {
      badge.textContent = p.estado;
      badge.className = "badge bg-info-subtle text-info border border-info-subtle";
    }
    if (elHora) elHora.textContent = p.hora;
    if (elProd) elProd.textContent = `📦 ${p.productos}`;
    if (elObs) elObs.textContent = p.observaciones ? `📝 ${p.observaciones}` : '';

    if (btnAccionCocina) {
      btnAccionCocina.onclick = () => cambiarEstadoPorId(p.id, "Listo");
    }

    contenedor.appendChild(clon);
  });
}

function renderizarSeguimiento() {
  const contenedor = document.getElementById("contenedorSeguimiento");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  // Busca cualquiera de las dos plantillas posibles según el HTML
  const tplSeguimiento = document.getElementById("tpl-seguimiento-card") || document.getElementById("tpl-seguimiento-row");
  if (!tplSeguimiento) return;

  const pedidosSeguimiento = pedidos.filter(p => p.estado !== "Entregado");

  if (pedidosSeguimiento.length === 0) {
    contenedor.innerHTML = `
      <div class="col-12 text-center py-5">
        <i class="bi bi-clock-history display-4 text-muted d-block mb-2"></i>
        <p class="text-muted fs-6">No hay pedidos en seguimiento en este momento.</p>
      </div>`;
    return;
  }

  pedidosSeguimiento.forEach(p => {
    const clon = tplSeguimiento.content.cloneNode(true);

    const elemId = clon.querySelector(".data-id");
    const elemCliente = clon.querySelector(".data-cliente");
    const elemBadge = clon.querySelector(".data-badge, .data-badge-estado, .data-estado");
    const elemProductos = clon.querySelector(".data-productos");
    const elemHora = clon.querySelector(".data-hora");
    const elemDireccion = clon.querySelector(".data-direccion");
    const elemRepartidor = clon.querySelector(".data-repartidor");
    const elemObs = clon.querySelector(".data-observaciones");

    if (elemId) elemId.textContent = p.id;
    if (elemCliente) elemCliente.textContent = `👤 ${p.cliente}`;
    if (elemHora) elemHora.textContent = p.hora;
    if (elemDireccion) elemDireccion.textContent = p.direccion;
    if (elemProductos) elemProductos.textContent = `📦 ${p.productos}`;
    if (elemObs) elemObs.textContent = p.observaciones ? `📝 ${p.observaciones}` : '';
    
    if (elemRepartidor) {
      elemRepartidor.textContent = p.repartidor ? p.repartidor : "Sin asignar";
    }

    if (elemBadge) {
      elemBadge.textContent = p.estado;
      let badgeClass = "badge bg-secondary";
      if (p.estado === "Pendiente") badgeClass = "badge bg-warning-subtle text-warning-emphasis";
      if (p.estado === "En Preparación") badgeClass = "badge bg-info-subtle text-info";
      if (p.estado === "Listo") badgeClass = "badge bg-success-subtle text-success";
      if (p.estado === "En Camino") badgeClass = "badge bg-primary-subtle text-primary";
      elemBadge.className = badgeClass;
    }

    // Proceso del Stepper si la plantilla cuenta con él
    const pasos = { "Pendiente": 1, "En Preparación": 2, "Listo": 3, "En Camino": 4, "Entregado": 5 };
    const pasoActual = pasos[p.estado] || 1;

    const stepElements = clon.querySelectorAll(".step-item, .stepper-step, .step");
    stepElements.forEach((stepEl, index) => {
      if (index < pasoActual) {
        stepEl.classList.add("active", "completed");
      } else {
        stepEl.classList.remove("active", "completed");
      }
    });

    const progressBar = clon.querySelector(".progress-bar, .stepper-bar");
    if (progressBar) {
      const porcentajes = { 1: "20%", 2: "40%", 3: "60%", 4: "80%", 5: "100%" };
      progressBar.style.width = porcentajes[pasoActual] || "0%";
    }

    contenedor.appendChild(clon);
  });
}

function renderizarDomiciliarios() {
  const contenedor = document.getElementById("contenedorDomiciliarios");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplDomiciliario = document.getElementById("tpl-domiciliario-card");
  if (!tplDomiciliario) return;

  domiciliarios.forEach(d => {
    const clon = tplDomiciliario.content.cloneNode(true);

    const elemNombre = clon.querySelector(".data-nombre");
    const elemBadge = clon.querySelector(".data-estado");
    const elemPedidos = clon.querySelector(".data-pedidos");

    if (elemNombre) elemNombre.textContent = d.nombre;
    
    if (elemBadge) {
      elemBadge.textContent = d.disponible ? "Disponible" : "Ocupado";
      elemBadge.className = `badge ${d.disponible ? 'bg-success' : 'bg-secondary'}`;
    }

    const totalEnRuta = pedidos.filter(p => p.repartidor === d.nombre && p.estado === "En Camino").length;
    if (elemPedidos) elemPedidos.textContent = totalEnRuta;

    contenedor.appendChild(clon);
  });
}

// ==========================================
// 8. TRANSICIÓN DE ESTADOS Y CONTADORES
// ==========================================

function cambiarEstadoPorId(idPedido, nuevoEstado, repartidor = "") {
  const pedido = pedidos.find(p => p.id === idPedido);
  if (!pedido) return;

  const repartidorAnterior = pedido.repartidor;

  pedido.estado = nuevoEstado;

  if (repartidor) {
    pedido.repartidor = repartidor;
  }

  // Actualización del estado de disponibilidad del repartidor
  if (nuevoEstado === "En Camino" && pedido.repartidor) {
    const dom = domiciliarios.find(d => d.nombre === pedido.repartidor);
    if (dom) dom.disponible = false;
  } else if (nuevoEstado === "Entregado" && repartidorAnterior) {
    const pedidosPendientesRepartidor = pedidos.filter(p => p.repartidor === repartidorAnterior && p.estado === "En Camino");
    if (pedidosPendientesRepartidor.length === 0) {
      const dom = domiciliarios.find(d => d.nombre === repartidorAnterior);
      if (dom) dom.disponible = true;
    }
  }

  actualizarTodo();
}

function actualizarContadores() {
  const total = document.getElementById("cantTotal");
  const pendientes = document.getElementById("cantPendientes");
  const preparacion = document.getElementById("cantPreparacion");
  const enCamino = document.getElementById("cantEnCamino");
  const entregados = document.getElementById("cantEntregados");

  if (total) total.textContent = pedidos.length;
  if (pendientes) pendientes.textContent = pedidos.filter(p => p.estado === "Pendiente").length;
  if (preparacion) preparacion.textContent = pedidos.filter(p => p.estado === "En Preparación").length;
  if (enCamino) enCamino.textContent = pedidos.filter(p => p.estado === "En Camino").length;
  if (entregados) entregados.textContent = pedidos.filter(p => p.estado === "Entregado").length;
}

function actualizarTodo() {
  actualizarContadores();
  renderizarPedidos();
  renderizarComandas();
  renderizarSeguimiento();
  renderizarDomiciliarios();
}