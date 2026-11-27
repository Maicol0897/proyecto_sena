import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../../hooks/useAuth'
import { ROUTES } from '../../config/routes'
import { ROLES } from '../../config/constants'
import '../../styles/panel.css'

const MENU = [
    {
        ruta: ROUTES.DASHBOARD,
        texto: 'Inicio',
        icono: (
            <>
                <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8" />
                <path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
            </>
        ),
    },
    {
        ruta: ROUTES.USERS,
        texto: 'Usuarios',
        icono: (
            <>
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                <path d="M16 3.128a4 4 0 0 1 0 7.744" />
                <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                <circle cx="9" cy="7" r="4" />
            </>
        ),
    },
    {
        ruta: ROUTES.PURCHASES,
        texto: 'Compras',
        icono: (
            <>
                <circle cx="8" cy="21" r="1" />
                <circle cx="19" cy="21" r="1" />
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12" />
            </>
        ),
    },
    {
        ruta: ROUTES.PRODUCTION,
        texto: 'Producción',
        icono: (
            <>
                <path d="M17 21a1 1 0 0 0 1-1v-5.35c0-.457.316-.844.727-1.041a4 4 0 0 0-2.134-7.589 5 5 0 0 0-9.186 0 4 4 0 0 0-2.134 7.588c.411.198.727.585.727 1.041V20a1 1 0 0 0 1 1Z" />
                <path d="M6 17h12" />
            </>
        ),
    },
    {
        ruta: ROUTES.DELIVERIES,
        texto: 'Domicilios',
        icono: (
            <>
                <path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2" />
                <path d="M15 18H9" />
                <path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14" />
                <circle cx="17" cy="18" r="2" />
                <circle cx="7" cy="18" r="2" />
            </>
        ),
    },
]

function PanelLayout() {
    const { usuario, logout } = useAuth()
    const navigate = useNavigate()
    const { pathname } = useLocation()
    const seccion = MENU.find((item) => item.ruta === pathname)

    const cerrarSesion = () => {
        logout()
        navigate(ROUTES.LOGIN)
    }

    return (
        <div className="d-flex min-vh-100">
            <aside className="panel-menu position-fixed top-0 bottom-0 start-0 d-none d-lg-flex flex-column text-white">
                <div className="panel-marca d-flex align-items-center">
                    <img src="/img/logo.png" alt="Coffee Park" className="panel-logo flex-shrink-0 rounded-4" />
                    <div>
                        <p className="panel-marca-nombre mb-0">BakeAdmin</p>
                        <p className="panel-marca-sub mb-0">Coffee Park</p>
                    </div>
                </div>

                <nav className="panel-nav flex-grow-1 d-flex flex-column gap-1">
                    {MENU.map((item) => (
                        <NavLink
                            key={item.ruta}
                            to={item.ruta}
                            className={({ isActive }) =>
                                'panel-enlace d-flex align-items-center rounded-4 text-decoration-none' +
                                (isActive ? ' panel-enlace-activo' : '')
                            }
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0">
                                {item.icono}
                            </svg>
                            {item.texto}
                        </NavLink>
                    ))}
                </nav>

                <div className="panel-pie">
                    <p className="panel-version mt-2 mb-0">BakeAdmin v2.0 · 2026</p>
                </div>
            </aside>

            <div className="panel-colum d-flex flex-column flex-grow-1">
                <header className="panel-barra sticky-top d-flex align-items-center">
                    <div className="d-flex flex-column">
                        <p className="panel-seccion mb-0 fw-semibold text-uppercase">{seccion?.texto}</p>
                        <p className="panel-sede mb-0">
                            {usuario.rol === ROLES.ADMIN ? 'Todas las sedes' : usuario.sede}
                        </p>
                    </div>

                    <div className="panel-acciones ms-auto d-flex align-items-center">
                        <span className="pastilla-sincronizado d-inline-flex align-items-center gap-2">Sincronizado</span>

                        <button className="btn-campana position-relative d-flex align-items-center justify-content-center flex-shrink-0" aria-label="Notificaciones">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M10.268 21a2 2 0 0 0 3.464 0" />
                                <path d="M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326" />
                            </svg>
                        </button>

                        <div className="text-end d-none d-md-block">
                            <p className="panel-usuario mb-0">{usuario.nombre}</p>
                            <p className="panel-rol mb-0 text-capitalize">{usuario.rol.replace('_', ' ')}</p>
                        </div>

                        <button className="btn-cerrar-sesion d-flex align-items-center gap-2" onClick={cerrarSesion}>
                            <span className="d-none d-sm-inline">Cerrar sesión</span>
                        </button>
                    </div>
                </header>

                <main className="flex-grow-1">
                    <Outlet />
                </main>
            </div>
        </div>
    )
}

export default PanelLayout