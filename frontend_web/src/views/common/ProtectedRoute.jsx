import { Navigate } from 'react-router-dom'
import { useAuth } from '../../hooks/useAuth'
import { ROUTES } from '../../config/routes'

function ProtectedRoute({ children }) {
    const { estaAutenticado } = useAuth()

    if (!estaAutenticado) {
        return <Navigate to={ROUTES.LOGIN} replace />
    }

    return children
}

export default ProtectedRoute