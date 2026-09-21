// Banco de datos local para la simulación
let pedidos = [];

let domiciliarios = [
  { nombre: "Carlos Domiciliario", disponible: true, pedidos: 0 },
  { nombre: "Pedro Repartidor", disponible: true, pedidos: 0 },
  { nombre: "Laura Entrega", disponible: true, pedidos: 0 }
];

document.addEventListener("DOMContentLoaded", () => {
  inicializarEventos();
  actualizarTodo();
});

// 1. EVENTOS PRINCIPALES Y MENÚ DE PERFIL
function inicializarEventos() {
  // Cambio entre pestañas
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

  // Toggle del Menú de Avatar
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

  // Apertura segura de Offcanvas (Mi Perfil)
  const opcionMiPerfil = document.getElementById("opcionMiPerfil");
  if (opcionMiPerfil) {
    opcionMiPerfil.addEventListener("click", () => {
      const el = document.getElementById("panelMiPerfil");
      if (el) {
        const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(el);
        bsOffcanvas.show();
      }
      if (menuPerfil) menuPerfil.classList.add("d-none");
    });
  }

  // Apertura segura de Offcanvas (Ajustes)
  const opcionAjustes = document.getElementById("opcionAjustes");
  if (opcionAjustes) {
    opcionAjustes.addEventListener("click", () => {
      const el = document.getElementById("panelAjustes");
      if (el) {
        const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(el);
        bsOffcanvas.show();
      }
      if (menuPerfil) menuPerfil.classList.add("d-none");
    });
  }

  // Cerrar Sesión
  const opcionCerrarSesion = document.getElementById("opcionCerrarSesion");
  if (opcionCerrarSesion) {
    opcionCerrarSesion.addEventListener("click", () => {
      alert("Sesión cerrada correctamente.");
      if (menuPerfil) menuPerfil.classList.add("d-none");
      window.location.href = "";
    });
  }

  // Creación de Pedido desde Modal
  const formNuevoPedido = document.getElementById("formNuevoPedido");
  if (formNuevoPedido) {
    formNuevoPedido.addEventListener("submit", (e) => {
      e.preventDefault();
      crearNuevoPedido();
    });
  }
}

// 2. REGISTRO DE NUEVO PEDIDO
function crearNuevoPedido() {
  const nombre = document.getElementById("nombreCliente").value;
  const telefono = document.getElementById("telefonoCliente").value;
  const direccion = document.getElementById("direccionCliente").value;
  const productos = document.getElementById("productosPedido").value;
  const precio = document.getElementById("precioPedido").value;
  const pago = document.getElementById("metodoPago").value;
  const observaciones = document.getElementById("observaciones").value;

  const nuevo = {
    id: `#PED-00${pedidos.length + 1}`,
    hora: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
    cliente: nombre,
    telefono: telefono,
    direccion: direccion,
    productos: productos,
    precio: `$ ${Number(precio).toLocaleString('es-CO')}`,
    pago: pago,
    estado: "Pendiente",
    repartidor: "",
    observaciones: observaciones
  };

  pedidos.push(nuevo);

  document.getElementById("formNuevoPedido").reset();
  const modalElem = document.getElementById("nuevoPedido");
  if (modalElem) {
    const modal = bootstrap.Modal.getInstance(modalElem) || new bootstrap.Modal(modalElem);
    modal.hide();
  }

  actualizarTodo();
}

// 3. VISTA PESTAÑA PEDIDOS
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

  pedidos.forEach((p, index) => {
    if (p.estado === "Entregado") return;

    if (p.estado === "Listo" && !p.repartidor) {
      const clon = tplCompacto.content.cloneNode(true);

      clon.querySelector(".data-id").textContent = p.id;
      clon.querySelector(".data-hora").textContent = p.hora;
      clon.querySelector(".data-cliente").textContent = p.cliente;
      clon.querySelector(".data-direccion").textContent = p.direccion;
      clon.querySelector(".data-precio").textContent = p.precio;

      const btnEstado = clon.querySelector(".btn-estado");
      btnEstado.onclick = () => cambiarEstado(index, "En Camino", "Pedro Repartidor");

      contenedor.appendChild(clon);
    } else {
      const clon = tplDetallado.content.cloneNode(true);
      const badge = clon.querySelector(".data-badge-estado");
      const btn = clon.querySelector(".btn-accion");
      const btnIcon = clon.querySelector(".btn-icon");
      const btnTexto = clon.querySelector(".btn-texto");
      const repartidorWrapper = clon.querySelector(".data-repartidor-wrapper");

      clon.querySelector(".data-id").textContent = p.id;
      clon.querySelector(".data-precio").textContent = p.precio;
      clon.querySelector(".data-cliente").textContent = p.cliente;
      clon.querySelector(".data-telefono").textContent = p.telefono;
      clon.querySelector(".data-direccion").textContent = p.direccion;
      clon.querySelector(".data-pago").textContent = p.pago;

      const elemProd = clon.querySelector(".data-productos");
      if (elemProd) elemProd.textContent = p.productos ? `📦 ${p.productos}` : "";

      const elemObs = clon.querySelector(".data-observaciones");
      if (elemObs) elemObs.textContent = p.observaciones ? `📝 ${p.observaciones}` : "";

      if (p.estado === "Pendiente") {
        badge.textContent = "Pendiente";
        badge.className = "badge px-2 py-1 bg-warning-subtle text-warning-emphasis";

        btn.className = "btn btn-sm btn-outline-primary px-3 d-flex align-items-center gap-1";
        btnIcon.className = "bi bi-cup-hot";
        btnTexto.textContent = "Preparar";
        btn.onclick = () => cambiarEstado(index, "En Preparación");
      } else if (p.estado === "En Preparación") {
        badge.textContent = "En Preparación";
        badge.className = "badge px-2 py-1 bg-info-subtle text-info";

        btn.className = "btn btn-sm btn-outline-success px-3 d-flex align-items-center gap-1";
        btnIcon.className = "bi bi-check-circle";
        btnTexto.textContent = "Marcar Listo";
        btn.onclick = () => cambiarEstado(index, "Listo");
      } else if (p.estado === "En Camino") {
        badge.textContent = "En Camino";
        badge.className = "badge px-2 py-1 bg-primary-subtle text-primary";

        if (repartidorWrapper) {
          repartidorWrapper.classList.remove("d-none");
          clon.querySelector(".data-repartidor").textContent = p.repartidor;
        }

        btn.className = "btn btn-sm text-white px-3 d-flex align-items-center gap-1";
        btn.style.backgroundColor = "#8b5cf6";
        btnIcon.className = "bi bi-truck";
        btnTexto.textContent = "Confirmar Entrega";
        btn.onclick = () => cambiarEstado(index, "Entregado");
      }

      contenedor.appendChild(clon);
    }
  });
}

// 4. VISTA PESTAÑA COMANDAS
function renderizarComandas() {
  const contenedor = document.getElementById("contenedorComandas");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplComanda = document.getElementById("tpl-comanda-card");
  const comandas = pedidos.filter(p => p.estado === "En Preparación" || p.estado === "Listo");

  if (comandas.length === 0) {
    contenedor.innerHTML = `<div class="col-12"><p class="text-center text-muted py-4">No hay comandas activas en cocina.</p></div>`;
    return;
  }

  comandas.forEach(p => {
    const clon = tplComanda.content.cloneNode(true);
    clon.querySelector(".data-id").textContent = p.id;
    
    const badge = clon.querySelector(".data-badge");
    badge.textContent = p.estado;
    badge.className = `badge ${p.estado === 'En Preparación' ? 'bg-info-subtle text-info' : 'bg-success-subtle text-success'}`;

    clon.querySelector(".data-hora").textContent = p.hora;
    clon.querySelector(".data-productos").textContent = `📦 ${p.productos}`;
    clon.querySelector(".data-observaciones").textContent = p.observaciones ? `📝 ${p.observaciones}` : '';

    contenedor.appendChild(clon);
  });
}

// 5. VISTA PESTAÑA SEGUIMIENTO
function renderizarSeguimiento() {
  const contenedor = document.getElementById("contenedorSeguimiento");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplSeguimiento = document.getElementById("tpl-seguimiento-row");
  const enRuta = pedidos.filter(p => p.estado === "En Camino");

  if (enRuta.length === 0) {
    contenedor.innerHTML = `<p class="text-center text-muted py-4">No hay pedidos en ruta actualmente.</p>`;
    return;
  }

  enRuta.forEach(p => {
    const clon = tplSeguimiento.content.cloneNode(true);
    clon.querySelector(".data-id").textContent = p.id;
    clon.querySelector(".data-cliente").textContent = p.cliente;
    clon.querySelector(".data-direccion").textContent = p.direccion;
    clon.querySelector(".data-estado").textContent = p.estado;
    clon.querySelector(".data-repartidor").textContent = p.repartidor;

    contenedor.appendChild(clon);
  });
}

// 6. VISTA PESTAÑA DOMICILIARIOS
function renderizarDomiciliarios() {
  const contenedor = document.getElementById("contenedorDomiciliarios");
  if (!contenedor) return;

  contenedor.innerHTML = "";

  const tplDomiciliario = document.getElementById("tpl-domiciliario-card");

  domiciliarios.forEach(d => {
    const clon = tplDomiciliario.content.cloneNode(true);
    clon.querySelector(".data-nombre").textContent = d.nombre;
    
    const badge = clon.querySelector(".data-estado");
    badge.textContent = d.disponible ? "Disponible" : "Ocupado";
    badge.className = `badge ${d.disponible ? 'bg-success' : 'bg-secondary'}`;

    const totalEnRuta = pedidos.filter(p => p.repartidor === d.nombre && p.estado === "En Camino").length;
    clon.querySelector(".data-pedidos").textContent = totalEnRuta;

    contenedor.appendChild(clon);
  });
}

// 7. TRANSICIÓN DE ESTADOS Y CONTROL DE FLUJO
function cambiarEstado(index, nuevoEstado, repartidor = "") {
  pedidos[index].estado = nuevoEstado;

  if (repartidor) {
    pedidos[index].repartidor = repartidor;
  }

  actualizarTodo();
}

function actualizarContadores() {
  document.getElementById("cantTotal").textContent = pedidos.length;
  document.getElementById("cantPendientes").textContent = pedidos.filter(p => p.estado === "Pendiente").length;
  document.getElementById("cantPreparacion").textContent = pedidos.filter(p => p.estado === "En Preparación").length;
  document.getElementById("cantEnCamino").textContent = pedidos.filter(p => p.estado === "En Camino").length;
  document.getElementById("cantEntregados").textContent = pedidos.filter(p => p.estado === "Entregado").length;
}

function actualizarTodo() {
  actualizarContadores();
  renderizarPedidos();
  renderizarComandas();
  renderizarSeguimiento();
  renderizarDomiciliarios();
}