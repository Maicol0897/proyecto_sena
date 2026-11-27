import { AuthModel } from '../models/AuthModel'

export const AuthController = {
    login(correo, clave) {
        if (!correo.trim() || !clave) {
            return { ok: false, mensaje: 'Escribe el correo y la contraseña' }
        }

        const usuario = AuthModel.iniciarSesion(correo.trim(), clave)

        if (!usuario) {
            return { ok: false, mensaje: 'Correo o contraseña incorrectos' }
        }

        return { ok: true, usuario }
    },

    logout() {
        AuthModel.cerrarSesion()
    },

    usuarioActual() {
        return AuthModel.obtenerSesion()
    },
}