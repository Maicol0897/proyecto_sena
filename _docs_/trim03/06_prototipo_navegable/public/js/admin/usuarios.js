document.addEventListener('DOMContentLoaded', () => {

    /* ========================================================
       1. LÓGICA DEL MENÚ DE PERFIL
    ======================================================== */
    const btnAvatar = document.getElementById('btnAvatar');
    const menuPerfil = document.getElementById('menuPerfil');

    if (btnAvatar && menuPerfil) {
        // Abrir/Cerrar desplegable al hacer clic en el avatar
        btnAvatar.addEventListener('click', (e) => {
            e.stopPropagation();
            menuPerfil.classList.toggle('show');
        });

        // Evitar que el clic dentro del desplegable lo cierre automáticamente
        menuPerfil.addEventListener('click', (e) => {
            e.stopPropagation();
        });

        // Cerrar cuando se hace clic fuera del menú
        document.addEventListener('click', () => {
            menuPerfil.classList.remove('show');
        });
    }

    // Acciones para las opciones del menú
    document.getElementById('opcionMiPerfil')?.addEventListener('click', () => {
        alert('Redirigiendo a Mi Perfil...');
        menuPerfil?.classList.remove('show');
    });

    document.getElementById('opcionAjustes')?.addEventListener('click', () => {
        alert('Abriendo Ajustes...');
        menuPerfil?.classList.remove('show');
    });

    document.getElementById('opcionCerrarSesion')?.addEventListener('click', () => {
        if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
            alert('Sesión cerrada.');
            // window.location.href = '../login.html';
        }
    });

    /* ========================================================
       2. LÓGICA DEL FORMULARIO Y MODAL DE CLIENTES
    ======================================================== */
    const formCliente = document.getElementById('formCliente');
    let filaEditando = null;

    if (formCliente) {
        formCliente.addEventListener('submit', (e) => {
            e.preventDefault();

            if (!formCliente.checkValidity()) {
                e.stopPropagation();
                formCliente.classList.add('was-validated');
                return;
            }

            const nombre = document.getElementById('clienteNombre').value;
            const telefono = document.getElementById('clienteTelefono').value;
            const email = document.getElementById('clienteEmail').value;
            const direccion = document.getElementById('clienteDireccion').value;

            if (filaEditando) {
                // Editar fila existente
                filaEditando.cells[0].textContent = nombre;
                filaEditando.cells[1].textContent = telefono;
                filaEditando.cells[2].textContent = email;
                filaEditando.cells[3].textContent = direccion;
                filaEditando = null;
            } else {
                // Crear fila nueva
                const tbody = document.getElementById('tablaClientesBody');
                const nuevaFila = document.createElement('tr');

                nuevaFila.innerHTML = `
                    <td class="fw-medium">${nombre}</td>
                    <td>${telefono}</td>
                    <td>${email}</td>
                    <td>${direccion}</td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <div class="form-check form-switch mb-0">
                                <input class="form-check-input switch-estado" type="checkbox" role="switch" checked onchange="toggleEstado(this)">
                            </div>
                            <span class="badge badge-estado bg-success-subtle text-success rounded-pill px-3 py-1">Activo</span>
                        </div>
                    </td>
                    <td>
                        <button class="btn btn-link text-dark p-1 me-1" title="Editar" onclick="editarCliente(this)">
                            <i class="bi bi-pencil-square fs-5"></i>
                        </button>
                    </td>
                `;
                tbody.appendChild(nuevaFila);
            }

            // Ocultar modal mediante la API oficial de Bootstrap
            const modalElement = document.getElementById('modalCliente');
            const modalInstance = bootstrap.Modal.getInstance(modalElement);
            if (modalInstance) {
                modalInstance.hide();
            }

            formCliente.reset();
            formCliente.classList.remove('was-validated');
        });
    }

    // Funciones globales expuestas para los eventos `onclick` / `onchange`
    window.prepararCreacion = function () {
        filaEditando = null;
        document.getElementById('modalClienteLabel').textContent = 'Nuevo Cliente';
        document.getElementById('btnGuardar').textContent = 'Guardar';
        const form = document.getElementById('formCliente');
        if (form) {
            form.reset();
            form.classList.remove('was-validated');
        }
    };

    window.editarCliente = function (btn) {
        filaEditando = btn.closest('tr');
        const celdas = filaEditando.cells;

        document.getElementById('clienteNombre').value = celdas[0].textContent;
        document.getElementById('clienteTelefono').value = celdas[1].textContent;
        document.getElementById('clienteEmail').value = celdas[2].textContent;
        document.getElementById('clienteDireccion').value = celdas[3].textContent;

        document.getElementById('modalClienteLabel').textContent = 'Editar Cliente';
        document.getElementById('btnGuardar').textContent = 'Actualizar';

        const modalElement = document.getElementById('modalCliente');
        const modalInstance = bootstrap.Modal.getOrCreateInstance(modalElement);
        modalInstance.show();
    };

    window.toggleEstado = function (checkbox) {
        const badge = checkbox.closest('td').querySelector('.badge-estado');
        if (checkbox.checked) {
            badge.textContent = 'Activo';
            badge.className = 'badge badge-estado bg-success-subtle text-success rounded-pill px-3 py-1';
        } else {
            badge.textContent = 'Inactivo';
            badge.className = 'badge badge-estado bg-secondary-subtle text-secondary rounded-pill px-3 py-1';
        }
    };

});