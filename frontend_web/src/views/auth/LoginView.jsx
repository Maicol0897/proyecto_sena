import { useState } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'
import { useAuth } from '../../hooks/useAuth'
import { ROUTES } from '../../config/routes'
import '../../styles/login.css'

function LoginView() {
    const [correo, setCorreo] = useState('')
    const [clave, setClave] = useState('')
    const [error, setError] = useState('')
    const { login, estaAutenticado } = useAuth()
    const navigate = useNavigate()

    const manejarEnvio = (e) => {
        e.preventDefault()
        const resultado = login(correo, clave)

        if (resultado.ok) {
            navigate(ROUTES.DASHBOARD)
        } else {
            setError(resultado.mensaje)
        }
    }

    if (estaAutenticado) {
        return <Navigate to={ROUTES.DASHBOARD} replace />
    }

    return (
        <div className="container-fluid vh-100 p-0">
            <div className="row h-100 g-0">
                {/* columna izquierda */}
                <div className="col-12 col-lg-6 hero-panel p-5 d-flex flex-column justify-content-between position-relative overflow-hidden">
                    <div className="position-absolute rounded-circle circulo-1"></div>
                    <div className="position-absolute rounded-circle circulo-2"></div>
                    <div className="position-absolute rounded-circle circulo-3"></div>
                    <div className="position-absolute linea-inclinada"></div>

                    <div className="d-flex justify-content-between align-items-start position-relative" style={{ zIndex: 10 }}>
                        <div className="d-flex align-items-center gap-3">
                            <img src="/img/logo.png" alt="logo BakeAdmin" className="logo-bake-img rounded-4" />
                            <div>
                                <h5 className="mb-0 text-white fw-bold" style={{ fontSize: 20 }}>BakeAdmin</h5>
                                <small className="texto-rosa" style={{ fontSize: 12 }}>Sistema de Gestión</small>
                            </div>
                        </div>

                        <div className="badge-version d-flex align-items-center gap-1 rounded-pill">
                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z" />
                            </svg>
                            <span>v2.0 — 2026</span>
                        </div>
                    </div>

                    <div className="my-auto position-relative" style={{ zIndex: 10 }}>
                        <p className="hero-subtitulo">GESTIÓN OPERATIVA</p>
                        <h1 className="hero-titulo">TU PANADERÍA,<br /><span>TU CONTROL.</span></h1>
                        <p className="hero-texto">Gestiona producción, pedidos, domicilios y compras desde un solo lugar.</p>
                    </div>
                </div>

                {/* columna derecha */}
                <div className="col-12 col-lg-6 d-flex align-items-center justify-content-center p-4 bg-fondo">
                    <div className="login-grid-container">
                        <header className="login-header">
                            <h2>Inicia sesión</h2>
                            <p>Accede a tu panel de control</p>
                        </header>

                        <form className="login-form" onSubmit={manejarEnvio}>
                            <div className="field-group">
                                <label htmlFor="email">Correo Electrónico</label>
                                <input
                                    type="email"
                                    id="email"
                                    className="form-control-custom"
                                    placeholder="correo@bakeadmin.com"
                                    value={correo}
                                    onChange={(e) => setCorreo(e.target.value)}
                                    required
                                />
                            </div>

                            <div className="field-group">
                                <div className="label-row">
                                    <label htmlFor="password">Contraseña</label>
                                    <a href="#" className="forgot-link">¿Olvidaste tu contraseña?</a>
                                </div>
                                <input
                                    type="password"
                                    id="password"
                                    className="form-control-custom"
                                    placeholder="••••••••"
                                    value={clave}
                                    onChange={(e) => setClave(e.target.value)}
                                    required
                                />
                            </div>

                            {error && <div className="alert alert-danger py-2 mb-0">{error}</div>}

                            <button type="submit" className="btn-primary-custom">
                                Ingresar <span>&rarr;</span>
                            </button>
                        </form>

                        <footer className="login-footer">
                            <p className="m-0 texto-gris">¿Eres cliente nuevo? <Link to={ROUTES.REGISTER} className="btn-secundary-custom">Regístrate aquí</Link></p>

                            <div className="divider">
                                <span>o continúa sin cuenta</span>
                            </div>

                            <Link to={ROUTES.MENU} className="btn-secondary-custom">
                                <span>☕</span> Ver menú y Realizar Pedidos (sin cuenta)
                            </Link>
                        </footer>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default LoginView