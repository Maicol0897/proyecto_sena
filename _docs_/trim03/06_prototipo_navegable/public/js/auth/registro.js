document.addEventListener('DOMContentLoaded', () => {
    // Referencias a los elementos del formulario
    const form = document.getElementById('formCrearCuenta');
    const inputNombre = document.getElementById('nombre');
    const inputCorreo = document.getElementById('correo');
    const inputTelefono = document.getElementById('telefono');
    const inputPassword = document.getElementById('password');
    const inputConfirm = document.getElementById('confirm_password');
    const btnSubmit = document.getElementById('btnCrearCuenta');

    // Inicializar el Toast de Bootstrap (alerta verde)
    const toastElement = document.getElementById('toastExito');
    const toastExito = new bootstrap.Toast(toastElement, { delay: 3000 });

    // Expresiones regulares para validación
    const regexNombre = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;
    const regexCorreo = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const regexTelefono = /^\d{7,10}$/;

    // Función auxiliar para aplicar clases de validación de Bootstrap
    const validarCampo = (input, esValido) => {
        if (esValido) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
        } else {
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
        }
        return esValido;
    };

    // Funciones de validación individuales
    const validarNombre = () => validarCampo(inputNombre, regexNombre.test(inputNombre.value.trim()));
    const validarCorreo = () => validarCampo(inputCorreo, regexCorreo.test(inputCorreo.value.trim()));
    const validarTelefono = () => validarCampo(inputTelefono, regexTelefono.test(inputTelefono.value.trim()));
    const validarPassword = () => validarCampo(inputPassword, inputPassword.value.length >= 8);
    const validarConfirmacion = () => {
        const coinciden = inputConfirm.value.trim() !== '' && inputConfirm.value === inputPassword.value;
        return validarCampo(inputConfirm, coinciden);
    };

    // Validación en tiempo real mientras el usuario escribe
    inputNombre.addEventListener('input', validarNombre);
    inputCorreo.addEventListener('input', validarCorreo);
    inputTelefono.addEventListener('input', validarTelefono);
    inputPassword.addEventListener('input', () => {
        validarPassword();
        if (inputConfirm.value.trim() !== '') validarConfirmacion();
    });
    inputConfirm.addEventListener('input', validarConfirmacion);

    // Evento al presionar "Crear Cuenta"
    form.addEventListener('submit', (e) => {
        e.preventDefault();

        const esNombreValido = validarNombre();
        const esCorreoValido = validarCorreo();
        const esTelefonoValido = validarTelefono();
        const esPasswordValido = validarPassword();
        const esConfirmValida = validarConfirmacion();

        // Si todos los campos cumplen la validación
        if (esNombreValido && esCorreoValido && esTelefonoValido && esPasswordValido && esConfirmValida) {
            // Deshabilitar botón para evitar envíos dobles
            btnSubmit.disabled = true;

            // Mostrar el Toast verde flotante
            toastExito.show();

            // Redirigir a login.html después de 1 segundo 
            setTimeout(() => {
                window.location.href = 'login.html';
            }, 1000);
        }
    });
});