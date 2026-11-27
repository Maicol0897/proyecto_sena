import { useState } from 'react'
import { AuthContext } from './authContext'
import { AuthController } from '../controllers/AuthController'

export function AuthProvider({ children }) {
    const [usuario, setUsuario] = useState(() => AuthController.usuarioActual())

    const login = (correo, clave) => {
        const resultado = AuthController.login(correo, clave)
        if (resultado.ok) {
            setUsuario(resultado.usuario)
        }
        return resultado
    }

    const logout = () => {
        AuthController.logout()
        setUsuario(null)
    }

    const valor = {
        usuario,
        estaAutenticado: usuario !== null,
        login,
        logout,
    }

    return <AuthContext.Provider value={valor}>{children}</AuthContext.Provider>
}