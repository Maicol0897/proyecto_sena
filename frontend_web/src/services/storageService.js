export const storageService = {
    guardar(clave, valor) {
        sessionStorage.setItem(clave, JSON.stringify(valor))
    },

    leer(clave) {
        const dato = sessionStorage.getItem(clave)
        return dato ? JSON.parse(dato) : null
    },

    borrar(clave) {
        sessionStorage.removeItem(clave)
    },
}