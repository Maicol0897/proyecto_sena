import { ROLES } from '../config/constants'

export const USUARIOS_PRUEBA = [
    { id: 1, nombre: 'Duberney Soto Vera', correo: 'admin@coffeepark.com', clave: 'Admin123*', rol: ROLES.ADMIN, sede: 'Planta' },
    { id: 2, nombre: 'Carlos Andres Mejia', correo: 'gerente.planta@coffeepark.com', clave: 'Gerente123*', rol: ROLES.GERENTE, sede: 'Planta' },
    { id: 3, nombre: 'Laura Camila Gomez', correo: 'cocina.planta@coffeepark.com', clave: 'Cocina123*', rol: ROLES.COCINERO, sede: 'Planta' },
    { id: 4, nombre: 'Santiago Alfonso Romero', correo: 'gerente.140@coffeepark.com', clave: 'Gerente123*', rol: ROLES.GERENTE, sede: 'Coffee Park 140' },
]