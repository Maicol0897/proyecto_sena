document.addEventListener('DOMContentLoaded', () => {

  /* ==========================================================================
     1. NAVEGADOR Y MENÚ DE PERFIL DE USUARIO
     ========================================================================== */

  const btnAvatar = document.getElementById("btnAvatar");
  const menuPerfil = document.getElementById("menuPerfil");

  // Abrir / Cerrar Menú del Perfil
  if (btnAvatar && menuPerfil) {
    btnAvatar.addEventListener("click", (e) => {
      e.stopPropagation();
      menuPerfil.classList.toggle("d-none");
      menuPerfil.classList.toggle("show");
    });

    // Cerrar menú al hacer clic fuera
    document.addEventListener("click", (e) => {
      if (!menuPerfil.contains(e.target) && !btnAvatar.contains(e.target)) {
        menuPerfil.classList.add("d-none");
        menuPerfil.classList.remove("show");
      }
    });
  }

  // Función auxiliar para ocultar el menú
  const ocultarMenuPerfil = () => {
    if (menuPerfil) {
      menuPerfil.classList.add("d-none");
      menuPerfil.classList.remove("show");
    }
  };

  // Apertura de Offcanvas Mi Perfil
  const opcionMiPerfil = document.getElementById("opcionMiPerfil");
  if (opcionMiPerfil) {
    opcionMiPerfil.addEventListener("click", () => {
      const el = document.getElementById("panelMiPerfil");
      if (el) {
        const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(el);
        bsOffcanvas.show();
      }
      ocultarMenuPerfil();
    });
  }

  // Apertura de Offcanvas Ajustes
  const opcionAjustes = document.getElementById("opcionAjustes");
  if (opcionAjustes) {
    opcionAjustes.addEventListener("click", () => {
      const el = document.getElementById("panelAjustes");
      if (el) {
        const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(el);
        bsOffcanvas.show();
      }
      ocultarMenuPerfil();
    });
  }

  // Cerrar Sesión
  const opcionCerrarSesion = document.getElementById("opcionCerrarSesion");
  if (opcionCerrarSesion) {
    opcionCerrarSesion.addEventListener("click", () => {
      if (confirm("¿Estás seguro de que deseas cerrar sesión?")) {
        ocultarMenuPerfil();
        window.location.href = "login.html";
      }
    });
  }


  /* ==========================================================================
     2. GESTIÓN DEL FORMULARIO Y MODAL DE CLIENTES
     ========================================================================== */

  const form = document.getElementById('formCliente');
  if (form) {
    form.addEventListener('submit', event => {
      event.preventDefault();

      if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
      }

      const nombre = document.getElementById('clienteNombre').value.trim();
      const telefono = document.getElementById('clienteTelefono').value.trim();
      const email = document.getElementById('clienteEmail').value.trim();
      const direccion = document.getElementById('clienteDireccion').value.trim();

      if (filaEnEdicion) {
        // MODO EDITAR
        const celdas = filaEnEdicion.querySelectorAll('td');
        celdas[0].textContent = nombre;
        celdas[1].textContent = telefono;
        celdas[2].textContent = email;
        celdas[3].textContent = direccion;
      } else {
        // MODO CREAR
        const tbody = document.getElementById('tablaClientesBody');
        const nuevaFila = document.createElement('tr');

        nuevaFila.innerHTML = `
          <td class="fw-medium"></td>
          <td></td>
          <td></td>
          <td></td>
          <td>
            <div class="d-flex align-items-center gap-2">
              <div class="form-check form-switch mb-0">
                <input class="form-check-input switch-estado" type="checkbox" role="switch" checked onchange="toggleEstado(this)">
              </div>
              <span class="badge badge-estado bg-success-subtle text-success rounded-pill px-3 py-1">
                Activo
              </span>
            </div>
          </td>
          <td>
            <button class="btn btn-link text-dark p-1 me-1" title="Editar" onclick="editarCliente(this)">
              <i class="bi bi-pencil-square fs-5"></i>
            </button>
          </td>
        `;

        const celdas = nuevaFila.querySelectorAll('td');
        celdas[0].textContent = nombre;
        celdas[1].textContent = telefono;
        celdas[2].textContent = email;
        celdas[3].textContent = direccion;

        tbody.appendChild(nuevaFila);
      }

      // Cerrar Modal
      const modalEl = document.getElementById('modalCliente');
      const modal = bootstrap.Modal.getInstance(modalEl);
      if (modal) {
        modal.hide();
      }

      form.reset();
      form.classList.remove('was-validated');
      filaEnEdicion = null;
    }, false);
  }
});


/* ==========================================================================
   3. FUNCIONES GLOBALES
   ========================================================================== */

let filaEnEdicion = null;

function toggleEstado(checkbox) {
  const contenedor = checkbox.closest('td');
  const badge = contenedor.querySelector('.badge-estado');

  if (checkbox.checked) {
    badge.textContent = 'Activo';
    badge.className = 'badge badge-estado bg-success-subtle text-success rounded-pill px-3 py-1';
  } else {
    badge.textContent = 'Inactivo';
    badge.className = 'badge badge-estado bg-secondary-subtle text-secondary rounded-pill px-3 py-1';
  }
}

function prepararCreacion() {
  filaEnEdicion = null;
  document.getElementById('modalClienteLabel').innerText = 'Nuevo Cliente';
  const form = document.getElementById('formCliente');
  form.reset();
  form.classList.remove('was-validated');
  
  const campoId = document.getElementById('clienteId');
  if (campoId) campoId.value = '';
}

function editarCliente(boton) {
  filaEnEdicion = boton.closest('tr');

  const celdas = filaEnEdicion.querySelectorAll('td');

  document.getElementById('modalClienteLabel').innerText = 'Editar Cliente';
  document.getElementById('clienteNombre').value = celdas[0].textContent.trim();
  document.getElementById('clienteTelefono').value = celdas[1].textContent.trim();
  document.getElementById('clienteEmail').value = celdas[2].textContent.trim();
  document.getElementById('clienteDireccion').value = celdas[3].textContent.trim();

  document.getElementById('formCliente').classList.remove('was-validated');

  const modalEl = document.getElementById('modalCliente');
  const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
  modal.show();
}