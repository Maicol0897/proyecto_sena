import { useAuth } from '../../hooks/useAuth'

function DashboardView() {
    const { usuario } = useAuth()

    return (
        <div className="container-fluid">
            <h1>Buenos días, {usuario.nombre}</h1>
            <p>Resumen general de la operación de Coffee Park.</p>
        </div>
    )
}

export default DashboardView