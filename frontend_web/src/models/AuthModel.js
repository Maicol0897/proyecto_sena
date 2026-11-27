import { USUARIOS_PRUEBA } from './UserModel'
import { STORAGE_KEYS } from '../config/constants'
import { storageService } from '../services/storageService'

export const AuthModel = {
    iniciarSesion(correo, clave) {
        const usuario = USUARIOS_PRUEBA.find(
            (u) => u.correo === correo && u.clave === clave
        )

        if (!usuario) {
            return null
        }

        const sesion = {
            id: usuario.id,
            nombre: usuario.nombre,
            correo: usuario.correo,
            rol: usuario.rol,
            sede: usuario.sede,
        }

        storageService.guardar(STORAGE_KEYS.USER, sesion)
        return sesion
    },

    obtenerSesion() {
        return storageService.leer(STORAGE_KEYS.USER)
    },

    cerrarSesion() {
        storageService.borrar(STORAGE_KEYS.USER)
    },
}