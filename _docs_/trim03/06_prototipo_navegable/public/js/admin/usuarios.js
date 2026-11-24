// =========================================================
// VARIABLES GLOBALES
// =========================================================
let filaEditando = null;

// =========================================================
// SISTEMA DE NOTIFICACIONES (TOAST)
// =========================================================
function mostrarToast(mensaje) {
    const toastEl = document.getElementById('liveToast');
    const toastMsg = document.getElementById('toastMessage');
    if (toastEl && toastMsg) {
        toastMsg.textContent = mensaje;
        const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
        toast.show();
    }
}

// =========================================================
// PREPARAR MODAL PARA CREACIÓN
// =========================================================
function prepararCreacion() {
    filaEditando = null;
    document.getElementById('editRowIndex').value = "-1";
    document.getElementById('modalUsuarioLabel').innerText = "Registrar Nuevo Empleado";
    document.getElementById('modalUsuarioSub').innerText = "Completa la información del nuevo empleado";
    document.getElementById('btnSubmitModal').innerText = "Crear Usuario";

    const contenedorPass = document.getElementById('contenedorPassword');
    if (contenedorPass) contenedorPass.style.display = 'block';

    const form = document.getElementById('formUsuario');
    form.reset();
    form.classList.remove('was-validated');
}

// =========================================================
// PREPARAR MODAL PARA EDICIÓN
// =========================================================
function editarUsuario(btn) {
    const fila = btn.closest('tr');
    filaEditando = fila;

    const nombre = fila.querySelector('.col-nombre').innerText.trim();
    const email = fila.querySelector('.col-email').innerText.trim();
    const rol = fila.querySelector('.col-rol').innerText.trim();

    document.getElementById('usuarioNombre').value = nombre;
    document.getElementById('usuarioEmail').value = email;
    document.getElementById('usuarioRol').value = rol;

    document.getElementById('modalUsuarioLabel').innerText = "Editar Empleado";
    document.getElementById('modalUsuarioSub').innerText = "Modifica los datos del empleado";
    document.getElementById('btnSubmitModal').innerText = "Guardar Cambios";

    const contenedorPass = document.getElementById('contenedorPassword');
    if (contenedorPass) contenedorPass.style.display = 'none';

    const form = document.getElementById('formUsuario');
    form.classList.remove('was-validated');

    const modalElement = document.getElementById('modalUsuario');
    const modalInstance = bootstrap.Modal.getOrCreateInstance(modalElement);
    modalInstance.show();
}

// =========================================================
// GUARDAR / ACTUALIZAR USUARIO
// =========================================================
function guardarUsuario(event) {
    event.preventDefault();
    const form = document.getElementById('formUsuario');

    if (!form.checkValidity()) {
        form.classList.add('was-validated');
        return;
    }

    const nombre = document.getElementById('usuarioNombre').value.trim();
    const email = document.getElementById('usuarioEmail').value.trim();
    const rol = document.getElementById('usuarioRol').value;

    if (filaEditando) {
        filaEditando.querySelector('.col-nombre').innerText = nombre;
        filaEditando.querySelector('.col-email').innerText = email;
        filaEditando.querySelector('.col-rol').innerHTML = `<span class="badge badge-rol">${rol}</span>`;
        mostrarToast(`Usuario ${nombre} actualizado correctamente.`);
    } else {
        const hoy = new Date().toISOString().split('T')[0];
        const tbody = document.querySelector('#tablaUsuarios tbody');
        const nuevaFila = document.createElement('tr');

        nuevaFila.innerHTML = `
                    <td class="fw-bold text-dark col-nombre">${nombre}</td>
                    <td class="text-muted col-email">${email}</td>
                    <td class="col-rol"><span class="badge badge-rol">${rol}</span></td>
                    <td class="text-secondary">${hoy}</td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <div class="form-check form-switch mb-0">
                                <input class="form-check-input switch-estado" type="checkbox" role="switch" checked onchange="toggleEstado(this)">
                            </div>
                            <span class="badge badge-estado badge-activo-custom">Activo</span>
                        </div>
                    </td>
                    <td>
                        <button class="btn btn-action-icon" title="Editar" onclick="editarUsuario(this)"><i class="bi bi-pencil-square"></i></button>
                        <button class="btn btn-action-icon" title="Bloquear / Desbloquear" onclick="toggleBloqueo(this)"><i class="bi bi-lock"></i></button>
                    </td>
                `;

        tbody.appendChild(nuevaFila);
        mostrarToast(`Nuevo usuario ${nombre} registrado con éxito.`);
        actualizarContadorTotal();
    }

    const modalElement = document.getElementById('modalUsuario');
    const modalInstance = bootstrap.Modal.getInstance(modalElement);
    if (modalInstance) modalInstance.hide();
}

// =========================================================
// CAMBIAR ESTADO (ACTIVO / INACTIVO)
// =========================================================
function toggleEstado(switchElem) {
    const badge = switchElem.closest('td').querySelector('.badge-estado');
    if (switchElem.checked) {
        badge.className = "badge badge-estado badge-activo-custom";
        badge.textContent = "Activo";
        mostrarToast("Estado cambiado a Activo.");
    } else {
        badge.className = "badge badge-estado badge-inactivo-custom";
        badge.textContent = "Inactivo";
        mostrarToast("Estado cambiado a Inactivo.");
    }
}

// =========================================================
// BLOQUEAR / DESBLOQUEAR USUARIO
// =========================================================
function toggleBloqueo(btn) {
    const fila = btn.closest('tr');
    const badge = fila.querySelector('.badge-estado');
    const switchInput = fila.querySelector('.switch-estado');
    const icon = btn.querySelector('i');

    if (badge.textContent === "Bloqueado") {
        badge.className = "badge badge-estado badge-activo-custom";
        badge.textContent = "Activo";
        switchInput.checked = true;
        switchInput.disabled = false;
        icon.className = "bi bi-lock";
        mostrarToast("Usuario desbloqueado.");
    } else {
        badge.className = "badge badge-estado badge-bloqueado-custom";
        badge.textContent = "Bloqueado";
        switchInput.checked = false;
        switchInput.disabled = true;
        icon.className = "bi bi-unlock";
        mostrarToast("Usuario bloqueado.");
    }
}

// =========================================================
// FILTRAR / BUSCAR USUARIOS
// =========================================================
function filtrarUsuarios() {
    const query = document.getElementById('inputBuscar').value.toLowerCase();
    const filas = document.querySelectorAll('#tablaUsuarios tbody tr');

    filas.forEach(fila => {
        const nombre = fila.querySelector('.col-nombre').innerText.toLowerCase();
        const email = fila.querySelector('.col-email').innerText.toLowerCase();
        const rol = fila.querySelector('.col-rol').innerText.toLowerCase();

        if (nombre.includes(query) || email.includes(query) || rol.includes(query)) {
            fila.style.display = '';
        } else {
            fila.style.display = 'none';
        }
    });
}

// =========================================================
// ACTUALIZAR CONTADOR DE EMPLEADOS
// =========================================================
function actualizarContadorTotal() {
    const total = document.querySelectorAll('#tablaUsuarios tbody tr').length;
    const counter = document.getElementById('totalCount');
    if (counter) counter.textContent = `${total} empleados en total`;
}

// =========================================================
// INICIALIZACIÓN Y EVENT LISTENERS DE LA PÁGINA
// =========================================================
document.addEventListener('DOMContentLoaded', () => {
    const btnAvatar = document.getElementById('btnAvatar');
    const menuPerfil = document.getElementById('menuPerfil');

    if (btnAvatar && menuPerfil) {
        btnAvatar.addEventListener('click', (e) => {
            e.stopPropagation();
            menuPerfil.classList.toggle('show');
        });

        document.addEventListener('click', (e) => {
            if (!menuPerfil.contains(e.target) && e.target !== btnAvatar) {
                menuPerfil.classList.remove('show');
            }
        });
    }

    document.getElementById('opcionMiPerfil')?.addEventListener('click', () => {
        mostrarToast("Navegando a Mi Perfil...");
        menuPerfil.classList.remove('show');
    });

    document.getElementById('opcionAjustes')?.addEventListener('click', () => {
        mostrarToast("Navegando a Ajustes...");
        menuPerfil.classList.remove('show');
    });

    document.getElementById('opcionCerrarSesion')?.addEventListener('click', () => {
        mostrarToast("Cerrando sesión...");
        menuPerfil.classList.remove('show');
    });

    // Exponer funciones globales
    window.prepararCreacion = prepararCreacion;
    window.editarUsuario = editarUsuario;
    window.toggleEstado = toggleEstado;
    window.toggleBloqueo = toggleBloqueo;
    window.filtrarUsuarios = filtrarUsuarios;
    window.guardarUsuario = guardarUsuario;
});