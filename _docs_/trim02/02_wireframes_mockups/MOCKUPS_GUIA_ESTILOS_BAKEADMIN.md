<<<<<<< HEAD
<<<<<<< HEAD
# GUÍA DE CONSTRUCCIÓN DE LAS VISTAS — BakeAdmin (Coffee Park)

**Proyecto SENA · ADSO ficha 3388489 · Inversiones SECAM SAS**
Guía para construir, pieza por pieza, las 11 vistas del prototipo de Figma, en **HTML + CSS** y, si quieres, con **Bootstrap 5.3**.

> Cómo leer cada pieza: primero **qué es**, luego una tabla con tres columnas: **qué propiedad es**, **CSS** y **Bootstrap**.
> Signos en la columna Bootstrap: **✔** = Bootstrap da la medida exacta · **≈** = se parece pero no es exacta (te digo la diferencia) · **✖** = Bootstrap no lo trae: escribe el CSS de la columna izquierda (o un `style="…"`).

---

## ÍNDICE (haz clic en una vista para ir a su explicación)

**Antes de construir**
- [0. Antes de empezar (conexión de Bootstrap, colores, letra, medidas)](#antes)
- [0.1 Piezas que se repiten (botón, campo, tarjeta, tabla, etiqueta de estado, pestañas, ventana, avisos)](#piezas)

**Vistas de entrada (sin menú)**
1. [Vista iniciar sesión](#vista-1)
2. [Vista de recuperar contraseña](#vista-2)
3. [Vista registrarse](#vista-3)

**El panel (con menú lateral y barra de arriba)**
- [Marco del panel (menú lateral + barra de arriba + pie) — se hace una sola vez](#marco)
- [Piezas de página que se repiten en el panel (encabezado con botón, filtros, tarjetas de color)](#patrones)

4. [Vista inicio](#vista-4)
5. [Vista usuarios y seguridad](#vista-5)
6. [Vista compras a proveedores](#vista-6)
7. [Vista producción y traslados](#vista-7)
8. [Vista domicilios](#vista-8)
9. [Vista menú del cliente](#vista-9)
10. [Vista mis pedidos](#vista-10)
11. [Vista mis domicilios (repartidor)](#vista-11)

**Cierre**
- [Lista final de revisión y orden recomendado](#revision)

---

<a id="antes"></a>
## 0. ANTES DE EMPEZAR

### 0.0 Conectar Bootstrap (una sola vez por página)
| Paso | CSS (a mano) | Bootstrap |
|---|---|---|
| En el `<head>` | `<link rel="stylesheet" href="css/estilos.css">` | primero el CSS de Bootstrap 5.3 (`https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css`) y **después** tu `estilos.css` (así tus reglas ganan) |
| Al final del `<body>` | — | `<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>` — con esto las **pestañas, ventanas (modales) y el menú de celular funcionan solo con atributos HTML** (`data-bs-toggle`, `data-bs-target`); no escribes JavaScript |
| Primera regla de tu CSS | `*{box-sizing:border-box;margin:0}` · `body{font-family:Inter,system-ui,sans-serif;font-size:16px;color:#321525;background:#FCF8F9}` | Bootstrap ya trae `box-sizing` y reinicio. Solo cambia sus colores en `:root` (ver 0.3) |

### 0.2 La letra
| | CSS | Bootstrap |
|---|---|---|
| Familia | `font-family: Inter, system-ui, sans-serif` (Inter se pide a Google Fonts con `<link>`) | `--bs-body-font-family: Inter, system-ui, sans-serif` en `:root` |
| Tamaños que existen en el proyecto | 10 · 11 · 12 · 14 · 16 · 18 · 20 · 24 · 30 · 36 · 48 · 60 · 72 px | `fs-6`=16 ✔ · `fs-5`=20 ✔ · `fs-4`=24 ✔ · `fs-3`=28 · `fs-2`=32 · `fs-1`=40 · `small`≈14 · **12, 11, 10, 18, 30, 36, 48, 60, 72 ✖** → `style="font-size:30px"` o clase propia |
| Grosores | 400 · 500 · 600 · 700 · 900 | `fw-normal` ✔ · `fw-medium` ✔ · `fw-semibold` ✔ · `fw-bold` ✔ · **900 ✖** → clase propia `.fw-black{font-weight:900}` |
| Alto de línea | 12→16 · 14→20 · 16→24 · 18→28 · 20→28 · 24→32 · 30→36 | `lh-1`=1 · `lh-sm`=1.25 · `lh-base`=1.5 · `lh-lg`=2 (otros valores ✖ propios) |

### 0.3 Los colores (se declaran una vez y se usan en todas las vistas)
| Nombre | Valor | Dónde se usa | Clase propia que debes crear (Bootstrap no la trae) |
|---|---|---|---|
| Vino profundo | `#4A1027` | bola 3 del login | `.bg-vino-profundo` |
| **Vino oscuro** | `#350B1A` | caja izquierda de la entrada, menú lateral, títulos grandes | `.bg-vino-oscuro` `.text-vino-oscuro` |
| **Vino** | `#741B3D` | botones principales, enlaces, precios | `.bg-vino` `.text-vino` (y `--bs-primary`) |
| Vino medio | `#96244F` | letra pequeña de sección, "¿Olvidaste…?" | `.text-vino-medio` |
| **Coral** | `#F27C86` | enlace activo del menú, bolas, etiquetas sobre oscuro | `.bg-coral` `.text-coral` `.border-coral` |
| Rosa | `#F6B4B8` | subtítulos sobre fondo oscuro | `.text-rosa` `.bg-rosa` |
| **Fondo de página** | `#FCF8F9` | fondo de todas las pantallas | `.bg-fondo` `.text-fondo` (= `--bs-body-bg`) |
| **Campo** | `#F2EEF1` | fondo de campos y cajas grises | `.bg-campo` |
| **Acento** | `#FCE8EA` | cajas de icono, pestaña elegida | `.bg-acento` |
| **Texto** | `#321525` | letra normal | `--bs-body-color` |
| Texto secundario | `#7A6873` | descripciones, etiquetas pequeñas | `.text-gris` |
| Borde | `rgba(116,27,61,.14)` | todos los bordes finos | `--bs-border-color` |
| Foco | `rgba(150,36,79,.5)` | resplandor de 3 px al hacer clic en un campo | `--bs-focus-ring-color` |
| Error | `#E7000B` | mensajes de error | `.text-danger` ≈ (Bootstrap `#DC3545`) |

**Colores de estado (etiquetas):**
| Estado | Fondo | Letra | Borde | Bootstrap más parecido (≈) |
|---|---|---|---|---|
| Verde | `#F0FDF4` | `#008236` | `#B9F8CF` | `bg-success-subtle text-success-emphasis border-success-subtle` |
| Ámbar | `#FFFBEB` | `#973C00` | `#FEE685` | `bg-warning-subtle text-warning-emphasis border-warning-subtle` |
| Azul | `#EFF6FF` | `#1447E6` | `#BEDBFF` | `bg-primary-subtle …` (con tu primario vino sale rosado: mejor clase propia) |
| Rojo | `#FEF2F2` | `#C10007` | `#FFC9C9` | `bg-danger-subtle text-danger-emphasis border-danger-subtle` |
| Rojo fuerte | `#FFE2E2` | `#9F0712` | — | ✖ propio |
| Gris | `#F1F5F9` | `#314158` | `#E2E8F0` | `bg-secondary-subtle text-secondary-emphasis border` |
| Morado | `#FAF5FF` | `#8200DB` | `#E9D4FF` | ✖ propio |
| Rosa (en preparación) | `#FDF2F8` | `#741B3D` | `#FBCFE8` | ✖ propio |

**Para que Bootstrap use tus colores**, en tu `estilos.css` (después de Bootstrap):
`:root{--bs-primary:#741B3D; --bs-primary-rgb:116,27,61; --bs-body-bg:#FCF8F9; --bs-body-color:#321525; --bs-border-color:rgba(116,27,61,.14); --bs-body-font-family:Inter,system-ui,sans-serif;}`
y cada clase propia de la tabla: por ejemplo `.bg-vino-oscuro{background:#350B1A}`, `.text-coral{color:#F27C86}`, `.fw-black{font-weight:900}`.

### 0.4 Medidas de separación (padding, margen, gap)
Todo el diseño está en múltiplos de 4 px. Bootstrap solo trae 6 valores:
| Medida | CSS | Bootstrap |
|---|---|---|
| 0 | `0` | `p-0` `m-0` `gap-0` ✔ |
| 4 px | `padding:4px` | `p-1` ✔ |
| 8 px | `padding:8px` | `p-2` ✔ |
| 16 px | `padding:16px` | `p-3` ✔ |
| 24 px | `padding:24px` | `p-4` ✔ |
| 48 px | `padding:48px` | `p-5` ✔ |
| **6, 10, 12, 20, 28, 32, 40, 56, 80 px** | `padding:12px`… | **✖ no existen** → `style="padding:12px"` o usa el vecino (`p-2`=8 o `p-3`=16) |

Prefijos: `p`=todos los lados · `px`=izq+der · `py`=arriba+abajo · `pt` `pb` `ps`(izq) `pe`(der) · igual con `m` (margen) · `gap-N` = separación entre hijos de flex/grid. Ejemplo: `padding:8px 16px` → `py-2 px-3`. Centrar caja: `margin-inline:auto` → `mx-auto`. Empujar a la derecha: `margin-left:auto` → `ms-auto`.

### 0.5 Esquinas, sombras, transparencia
| CSS | Bootstrap |
|---|---|
| `border-radius: 8px` | `rounded-3` ✔ |
| `border-radius: 16px` | `rounded-4` ✔ |
| `border-radius: 12px` / `24px` | ✖ propio (`style="border-radius:12px"`) |
| `border-radius: 50%` | `rounded-circle` ✔ |
| `border-radius: 9999px` (píldora) | `rounded-pill` ✔ |
| sombra pequeña `0 1px 3px rgba(0,0,0,.1)` | `shadow-sm` ≈ |
| sombra grande `0 10px 15px -3px rgba(0,0,0,.1)` | `shadow-lg` ≈ |
| `opacity:.25 / .5 / .75` | `opacity-25` / `opacity-50` / `opacity-75` ✔ · otros (.2, .4…) ✖ |

### 0.6 Tamaños de pantalla (puntos de quiebre)
| El diseño usa | Bootstrap más cercano | Diferencia |
|---|---|---|
| 640 px | `sm` = 576 | ≈ |
| **768 px** | **`md` = 768** | ✔ exacto |
| **1024 px** | **`lg` = 992** | ≈ 32 px menos |
| 1280 px | `xl` = 1200 | ≈ 80 px menos |

En Bootstrap se usa como prefijo: `d-none d-lg-flex` = "escondido, desde 992 px en fila". Para que se vea **exactamente** como el diseño usa tu propio `@media (min-width:1024px){…}`.

### 0.7 Cómo se logra cada efecto (los únicos trucos que usa todo el proyecto)
| Quiero… | CSS | Bootstrap |
|---|---|---|
| Hijos uno al lado del otro | `display:flex` | `d-flex` |
| Uno debajo del otro | `display:flex; flex-direction:column` | `d-flex flex-column` |
| Centrar en el otro eje | `align-items:center` | `align-items-center` |
| Un hijo a cada extremo | `justify-content:space-between` | `justify-content-between` |
| Un hijo ocupa lo que sobra | `flex:1` | `flex-grow-1` |
| Separación entre hijos | `gap:12px` | `gap-2` (8) / `gap-3` (16) / `gap-4` (24) |
| Columnas iguales | `display:grid; grid-template-columns:repeat(4,1fr); gap:16px` | `row g-3` + hijos `col-md-3` |
| Columnas desiguales (`116px 1fr`) | `grid-template-columns:116px 1fr` | ✖ propio |
| Un hijo "sale" de su caja (bolas) | padre `position:relative; overflow:hidden` · hijo `position:absolute; top:-96px; left:-96px` | padre `position-relative overflow-hidden` · hijo `position-absolute` (los valores negativos ✖ propios) |
| Círculo | `width:48px; height:48px; border-radius:50%` | `rounded-circle` + `style="width:48px;height:48px"` |
| Pegado a la pantalla | `position:fixed` | `position-fixed` |
| Pegado arriba al bajar | `position:sticky; top:0` | `sticky-top` |
| Si no cabe, deslizar | `overflow-x:auto` | `overflow-x-auto` |
| Esconder / mostrar desde 1024 | `display:none` / `@media(min-width:1024px){display:flex}` | `d-none d-lg-flex` ≈ |
| MAYÚSCULAS | `text-transform:uppercase` | `text-uppercase` |
| Separar letras | `letter-spacing:.1em` | ✖ propio |
| Texto con "…" | `overflow:hidden; text-overflow:ellipsis; white-space:nowrap` | `text-truncate` |
| Máximo 2 renglones | `display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden` | ✖ propio |
| Imagen que llena su caja | `width:100%; height:100%; object-fit:cover` | `w-100 h-100 object-fit-cover` |
| Inclinar | `transform:rotate(12deg)` | ✖ propio |
| Letra de máquina de escribir | `font-family:ui-monospace,monospace` | `font-monospace` |

---

<a id="piezas"></a>
## 0.1 PIEZAS QUE SE REPITEN (se construyen una vez; las vistas dicen "botón principal", "tarjeta", etc.)

### Botón
**Etiqueta:** `<button>` (o `<a>` si lleva a otra página).
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo interno | `display:inline-flex; align-items:center; justify-content:center; gap:8px` | `d-inline-flex align-items-center justify-content-center gap-2` |
| Alto normal **36 px**, relleno lateral 16 px | `height:36px; padding:0 16px` | `btn` = 38 px ≈ (relleno `px-3` ✔) |
| Alto pequeño **32 px**, relleno 12 px | `height:32px; padding:0 12px` | `btn btn-sm` = 31 px ≈ |
| Alto mediano **44 px** | `height:44px` | ✖ `style="height:44px"` |
| Alto grande **48 px** | `height:48px` | `btn btn-lg` = 48 px ✔ (pero su letra es 20 px: agrega `fs-6` para 16) |
| Esquinas | `border-radius:8px` | `rounded-3` ✔ |
| Letra | `font-size:14px; font-weight:500` | `small fw-medium` |
| **Principal** | fondo `#741B3D`, letra blanca, sin borde; hover fondo `#350B1A` | `btn btn-primary` (hover ≈; para `#350B1A` escribe `.btn-primary:hover{background:#350B1A}`) |
| **Contorno** | fondo blanco, letra `#321525`, borde 1 px `rgba(116,27,61,.14)`; hover fondo `#FCE8EA` | `btn btn-outline-secondary` ≈ (o `btn btn-light border`) |
| **Fantasma** | transparente, letra `#321525`; hover `#FCE8EA` | `btn btn-link text-decoration-none` ≈ |
| **Peligro (texto)** | letra `#C10007` | `btn btn-link text-danger` ≈ |
| **Ancho completo** | `width:100%` | `w-100` ✔ |

### Etiqueta + campo para escribir
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Etiqueta (`<label for="id">`) | `font-size:14px; font-weight:500; line-height:1; display:block; margin-bottom:4px` | `form-label fw-medium small mb-1` ✔ |
| Campo (`input`, `select`, `textarea`) ancho | `width:100%` | `form-control` / `form-select` ✔ |
| Alto del campo | **48 px**, o **44** o **40** según la vista | `form-control-lg` = 48 ✔ · normal = 38 ≈ · `form-control-sm` = 31 ≈ · **44 y 40 ✖** `style="height:44px"` |
| Fondo / borde / esquinas | `background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px` | `bg-campo` (propia) + `form-control` ya trae borde; esquinas `rounded-3` ✔ |
| Texto de ejemplo | `::placeholder{color:#7A6873}` | ✖ propio |
| Foco | `outline:none; box-shadow:0 0 0 3px rgba(150,36,79,.5)` | con `--bs-focus-ring-color` ≈ |
| Mensaje de error | `font-size:12px; line-height:16px; color:#E7000B; margin-top:4px` (escondido hasta que haga falta) | `text-danger small mt-1 d-none` (para mostrarlo quita `d-none`) ≈ |

### Tarjeta
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px; padding:24px 0; display:flex; flex-direction:column; gap:24px` | `card` (esquinas 6 px, 12 ✖ propio) |
| Encabezado (relleno lateral 24 px) | hijos **uno debajo del otro**, 6 px entre ellos: título → subtítulo → botón | `card-header bg-transparent border-0` o `card-body` |
| Título | `font-size:16px; font-weight:500; line-height:1` | `h6 fw-medium mb-1` ≈ |
| Subtítulo | `font-size:14px; color:#7A6873` | `small text-gris` |
| Cuerpo (relleno lateral 24 px) | `padding:0 24px; display:flex; flex-direction:column; gap:16px` | `card-body p-4` ✔ (24 px) |
| ⚠ Regla del diseño | el **botón va DEBAJO del título**, no a su derecha | igual |

### Tabla
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Envoltura | `border:1px solid rgba(116,27,61,.14); border-radius:16px; overflow-x:auto` | `table-responsive border rounded-4` ✔ |
| Tabla | `width:100%; font-size:14px; border-collapse:collapse` | `table table-hover align-middle mb-0` |
| Celda de título `th` | `height:40px; padding:0 8px; text-align:left; font-weight:500; white-space:nowrap; border-bottom:1px solid …` | alto 40 ✖ (`style="height:40px"`); relleno 8 `px-2` ✔ |
| Celda de dato `td` | `padding:8px; vertical-align:middle; white-space:nowrap; border-bottom:1px solid …` (la última fila sin línea) | `p-2` ✔ |
| Fila con el mouse encima | `background:rgba(242,238,241,.5)` | `table-hover` ≈ |
| Texto secundario en celda | `display:block; font-size:12px; color:#7A6873` | `small d-block text-gris` |
| Número en monoespaciada | `font-family:monospace; font-weight:700` | `font-monospace fw-bold` ✔ |

### Etiqueta de estado (insignia)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Forma | `display:inline-block; padding:2px 8px; border:1px solid; border-radius:8px; font-size:12px; line-height:16px; font-weight:500; white-space:nowrap` | `badge border fw-medium rounded-3` (relleno propio de Bootstrap ≈ `.35em .65em`) |
| Colores | de la tabla de estados (0.3) | clases `*-subtle` ≈ o propias |
| Qué color para cada texto | Verde: Activo · OK · Recibido · Entregado · Facturada · Disponible — Ámbar: Bajo mínimo · Pendiente · Pendiente de factura — Azul: Enviada · En tránsito · Aceptado · Sobre máximo — Rojo: Sin stock · Cancelada · No disponible — Rojo fuerte: Rechazada — Gris: Borrador · Inactivo — Morado: Despachado — Rosa: En preparación | igual |

### Pestañas
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Barra | `display:flex; background:#fff; padding:4px; border-radius:16px; box-shadow:0 1px 3px rgba(0,0,0,.1); overflow-x:auto` | `nav nav-pills nav-fill bg-white rounded-4 shadow-sm p-1 flex-nowrap overflow-x-auto` ✔ |
| Cada pestaña | `flex:1; height:36px; border-radius:12px; padding:0 12px; font-size:14px; font-weight:500; text-align:center` | `nav-link` (esquinas 12 ✖ propio) |
| Pestaña elegida | fondo `#FCE8EA`, letra `#741B3D` | `nav-link active` con `--bs-nav-pills-link-active-bg:#FCE8EA; --bs-nav-pills-link-active-color:#741B3D` |
| Al pasar el mouse | fondo `#F2EEF1` | ≈ |
| Contenido | separado **20 px** de la barra; solo se ve el panel de la pestaña elegida (con CSS sin JS: radios ocultos + `:checked`) | `tab-content mt-4` ≈ (24) con `tab-pane fade show active` / `tab-pane fade`; botón `data-bs-toggle="pill" data-bs-target="#panel1"` — **sin JS tuyo** |

### Ventana emergente (diálogo / modal)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo oscuro | `position:fixed; inset:0; background:rgba(0,0,0,.5)` | `modal` (lo trae) |
| Caja | centrada, `width:100%; max-width:512px` (cambia por ventana), `max-height:92vh; overflow-y:auto; background:#fff; border:1px solid …; border-radius:12px; padding:24px; box-shadow:0 10px 15px -3px rgba(0,0,0,.1)` | `modal-dialog modal-dialog-centered modal-dialog-scrollable` + `style="max-width:512px"` (Bootstrap trae 300 `modal-sm`, 500 normal, 800 `modal-lg`, 1140 `modal-xl`) |
| Título | `font-size:18px; font-weight:600; line-height:1` | `modal-title fs-5 fw-semibold` ≈ |
| Cuerpo | columna, 12 px entre bloques (20 px en las grandes), margen arriba 16 px | `modal-body d-flex flex-column gap-3` |
| Pie | `display:flex; justify-content:flex-end; gap:8px; margin-top:24px` | `modal-footer` |
| Cómo se abre | botón con `href="#ventana"` y la caja con `:target{display:flex}` | botón `data-bs-toggle="modal" data-bs-target="#ventana"` |

### Avisos
| Aviso | CSS | Bootstrap |
|---|---|---|
| **Ámbar** (info en ventanas) | fondo `#FFFBEB`, borde 1 px `#FEE685`, letra `#7B3306`, esquinas 16 px, relleno 12 px, 14 px | `alert alert-warning rounded-4` ≈ |
| **Rojo** | fila (gap 8 px), fondo `#FEF2F2`, borde `#FFC9C9`, letra `#C10007`, esquinas 16 px, relleno 12 px, 14 px, icono advertencia 20 px | `alert alert-danger d-flex gap-2 rounded-4` ≈ |

---
<a id="vista-1"></a>
# 1. VISTA INICIAR SESIÓN

**Qué es:** la primera pantalla. Está **dividida en 2 partes verticales**: la **izquierda** es vino oscuro con adornos (3 bolas, una línea inclinada, logo y letras grandes) y la **derecha** es clara con el formulario. En celular las dos partes se **apilan** (la oscura arriba).
**Se llega desde:** abrir la página, "Cerrar sesión", "← Volver" de Registro / Recuperar. **Lleva a:** Inicio, Registro, Recuperar contraseña, Menú del cliente.

```
┌──────────────────────────────────┬───────────────────────┐
│ PARTE IZQUIERDA 792 px (55 %)    │ PARTE DERECHA 648 px  │
│ fondo #350B1A                    │ fondo #FCF8F9         │
│ ○ bola 1            [✦ v2.0]     │                       │
│ [logo] BakeAdmin                 │    Inicia sesión      │
│                                  │    Correo [_______]   │
│ GESTIÓN OPERATIVA                │    Clave  [_______]   │
│ TU PANADERÍA,                    │    [ Ingresar → ]     │
│ TU CONTROL.                      │    ¿Eres cliente nuevo│
│            ○ bola 2              │    ── o continúa ──   │
│     ○ bola 3                     │    [☕ sin cuenta]    │
└──────────────────────────────────┴───────────────────────┘
```
(medidas a 1440 px de ancho de pantalla)

## 1.1 La pantalla completa (el contenedor de las 2 partes)
**Etiqueta:** `<div class="login">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Alto | `min-height:100vh` (toda la pantalla) | `min-vh-100` ✔ |
| Fondo | `background:#FCF8F9` | `bg-fondo` (propia) |
| Cómo se acomoda | celular: `display:flex; flex-direction:column`; desde 1024 px: `flex-direction:row` (izquierda y derecha lado a lado) | `d-flex flex-column flex-lg-row` (lg = 992 ≈ 1024) |

## 1.2 PARTE IZQUIERDA (caja vino)
**Etiqueta:** `<section class="login__izq">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Ancho | celular `100%`; desde 1024 px **`width:55%`** (= **792 px** a 1440) | celular `w-100`; 55 % ✖ → CSS propio `@media(min-width:1024px){.login__izq{width:55%}}` (≈ `col-lg-7` = 58.3 %) |
| Alto | celular `min-height:340px`; desde 1024 px `min-height:100vh` | `min-vh-100` en lg; 340 ✖ `style="min-height:340px"` |
| Color de fondo | `background:#350B1A` | `bg-vino-oscuro` (clase propia, ver 0.3) |
| Relleno | `padding:32px` (desde 1024 px `padding:48px`) | `p-5` (48 ✔); 32 ✖ → `style="padding:32px"` |
| Acomodo de lo de adentro | `display:flex; flex-direction:column; justify-content:space-between` (marca arriba, texto grande al medio) | `d-flex flex-column justify-content-between` ✔ |
| Para colocar las bolas dentro | **`position:relative; overflow:hidden`** (lo que sobresale se corta) | `position-relative overflow-hidden` ✔ |

### 1.2.1 Capa de adornos (caja invisible que cubre toda la parte izquierda)
**Etiqueta:** `<div class="login__adornos">` — es el "lienzo" donde se ubican las bolas.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Cómo ponerla | `position:absolute; top:0; right:0; bottom:0; left:0; overflow:hidden; pointer-events:none` (cubre todo y no estorba los clics) | `position-absolute top-0 bottom-0 start-0 end-0 overflow-hidden pe-none` ✔ |

### 1.2.2 Bola 1 — arriba a la izquierda (grande, vino)
**Etiqueta:** `<div class="bola bola-1">` (dentro de la capa de adornos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla en esa posición** | `position:absolute; top:-128px; left:-128px;` → queda "metida" en la esquina superior izquierda y se corta 128 px por arriba y por la izquierda | `position-absolute` ✔ + los valores negativos ✖ propios (`style="top:-128px;left:-128px"`) |
| Tamaño | `width:384px; height:384px` | ✖ `style="width:384px;height:384px"` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#741B3D; opacity:.4` | `bg-vino` (propia) + opacidad 40 % ✖ → `style="opacity:.4"` |

### 1.2.3 Bola 2 — en el medio, pegada al borde derecho (coral)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:50%; right:-96px;` → su borde superior queda en la mitad de la altura y se sale 96 px por la derecha | `position-absolute top-50` ✔ + `right:-96px` ✖ propio |
| Tamaño | `width:288px; height:288px` | ✖ `style` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#F27C86; opacity:.2` | `bg-coral` (propia) + opacidad 20 % ✖ |

### 1.2.4 Bola 3 — abajo (vino profundo)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; bottom:-80px; left:25%;` → sale 80 px por abajo y su borde izquierdo está a un cuarto del ancho | `position-absolute` ✔ + `bottom:-80px; left:25%` ✖ (existe `start-50`, `start-0`, `start-100`, pero no 25 %) |
| Tamaño | `width:256px; height:256px` | ✖ `style` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#4A1027; opacity:.25` | `bg-vino-profundo` (propia) + `opacity-25` ✔ |

### 1.2.5 Línea inclinada (adorno)
**Etiqueta:** `<div class="linea">` (vacío)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:0; right:96px;` y se **inclina** con `transform:rotate(12deg); transform-origin:top;` (gira desde su punta de arriba) | `position-absolute top-0` ✔ + `right:96px` ✖ + `rotate` ✖ propios |
| Tamaño | `width:1px; height:100%` | `h-100` ✔ + ancho 1 px ✖ |
| Color | `background:#F6B4B8; opacity:.2` | `bg-rosa` (propia) + opacidad ✖ |

### 1.2.6 Etiqueta "✦ v2.0 — 2026" (píldora arriba a la derecha)
**Etiqueta:** `<div class="version">` con un icono de chispa de 12 px + `<span>v2.0 — 2026</span>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:32px; right:32px` | `position-absolute` ✔ + `top:32px; right:32px` ✖ (`top-0 end-0 m-4` da 24 px ≈) |
| Forma | `border-radius:9999px; padding:4px 12px` | `rounded-pill ✔ py-1 px-3` (4 y 16 ≈; 12 ✖) |
| Fondo y borde | `background:rgba(242,124,134,.133); border:1px solid rgba(242,124,134,.333)` | `border` + colores con transparencia ✖ propios |
| Letra | `font-size:12px; line-height:16px; font-weight:500; color:#F6B4B8` | `small fw-medium text-rosa` |
| Icono + texto | `display:flex; align-items:center; gap:6px` | `d-flex align-items-center` + gap 6 ✖ (`gap-1`=4 / `gap-2`=8 ≈) |

### 1.2.7 Marca: logo + "BakeAdmin" (arriba a la izquierda)
**Etiqueta:** `<div class="marca">` con `<img>` y un `<div>` de dos textos.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Dónde queda** | primer hijo de la parte izquierda → arriba a la izquierda (por el `space-between` de 1.2). Debe quedar **encima** de las bolas: `position:relative; z-index:10` | `position-relative` ✔; `z-index:10` ✖ (`z-3` es lo más alto) |
| Acomodo | `display:flex; align-items:center; gap:12px` (logo a la izquierda, textos a la derecha) | `d-flex align-items-center gap-3` (16 ≈ 12) |
| **Logo** — tamaño | `width:48px; height:48px; object-fit:contain` | `style="width:48px;height:48px"` ✖ + `object-fit-contain` ✔ |
| **Logo** — esquinas | `border-radius:16px` | `rounded-4` ✔ |
| **"BakeAdmin"** — letra | `font-size:20px; line-height:1; font-weight:700; color:#FCF8F9` | `fs-5` (20 ✔) `fw-bold` ✔ `lh-1` ✔ + color `text-fondo` (propia) |
| **"Sistema de Gestión"** (debajo) | `font-size:12px; line-height:16px; color:#F6B4B8` | `small text-rosa` (≈ 14; para 12 ✖ `style="font-size:12px"`) |

### 1.2.8 Bloque de texto grande (al centro de la parte izquierda)
**Etiqueta:** `<div class="hero">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarlo entre la marca y el fondo** | `position:relative; z-index:10; margin-block:auto; padding-block:32px` (desde 1024 px `padding-block:0`) | `position-relative my-auto py-lg-0` ✔ + `py-4` (24 ≈ 32) |

**a) Etiqueta "GESTIÓN OPERATIVA"** (`<p>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Letra | `font-size:14px; line-height:20px; font-weight:600; text-transform:uppercase; letter-spacing:.1em; color:#F27C86` | `small fw-semibold text-uppercase text-coral` + `letter-spacing` ✖ |
| Espacio abajo | `margin-bottom:12px` | ✖ (`mb-2`=8 / `mb-3`=16 ≈) |

**b) Título "TU PANADERÍA," y "TU CONTROL."** (dos `<h1>` o un `<h1>` con `<br>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `font-size:48px` (celular); `@media(min-width:1024px){60px}`; `@media(min-width:1280px){72px}` | ✖ propio (Bootstrap llega a 40 px con `fs-1`) |
| Grosor | `font-weight:900` | `fw-black` (propia) |
| Alto de línea | `line-height:1` (renglones pegados) | `lh-1` ✔ |
| Color | línea 1 `#FCF8F9`; línea 2 **`#F27C86`** | `text-fondo` / `text-coral` (propias) |
| Espacio | margen abajo 8 px (línea 1) y 24 px (línea 2) | `mb-2` ✔ / `mb-4` ✔ |

**c) Descripción** "Gestiona producción, pedidos, domicilios y compras desde un solo lugar." (`<p>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Letra | `font-size:16px` (desde 1024 px `18px`); `line-height:1.625` | `fs-6` ✔ · 18 ✖ · 1.625 ✖ |
| Color | `color:#F6B4B8; opacity:.8` | `text-rosa` + opacidad 80 % ✖ (`opacity-75` ≈) |
| Ancho máximo | `max-width:384px` | ✖ `style="max-width:384px"` |

## 1.3 PARTE DERECHA (formulario)
**Etiqueta:** `<section class="login__der">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Ancho | `flex:1; min-width:0` (ocupa lo que sobra = **648 px** a 1440) | `flex-grow-1` ✔ |
| Fondo | `background:#FCF8F9` | `bg-fondo` |
| **Cómo centrar el formulario verticalmente** | `display:flex; flex-direction:column; justify-content:center` | `d-flex flex-column justify-content-center` ✔ |
| Relleno | `padding:40px 24px`; desde 1024 px lados `56px`; desde 1280 px lados `80px` | `px-4` (24 ✔) · `py-5` (48 ≈ 40) · lados 56/80 ✖ propios |

### 1.3.1 Caja interna del formulario
**Etiqueta:** `<div class="login__caja">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarla horizontalmente** | `width:100%; max-width:448px; margin-inline:auto` | `w-100 mx-auto` ✔ + `style="max-width:448px"` ✖ |

### 1.3.2 Marca pequeña (SOLO se ve en celular)
**Etiqueta:** `<div class="marca-mini">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; align-items:center; gap:8px; margin-bottom:32px` | `d-flex align-items-center gap-2 mb-4` (24 ≈ 32) |
| Cuándo se ve | `@media(min-width:1024px){display:none}` | `d-lg-none` ✔ |
| Logo | `width:36px; height:36px` | `style` ✖ |
| "BakeAdmin" | `font-weight:700; color:#321525` | `fw-bold` ✔ |

### 1.3.3 Título "Inicia sesión" y subtítulo
| Pieza | Propiedad | CSS | Bootstrap |
|---|---|---|---|
| "Inicia sesión" (`<h2>`) | Letra | `font-size:30px; line-height:36px; font-weight:900; color:#321525; margin-bottom:4px` | `h2 fw-black mb-1` ✔ + 30 px ✖ |
| "Accede a tu panel de control" (`<p>`) | Letra | `font-size:14px; line-height:20px; color:#7A6873; margin-bottom:32px` | `small text-gris mb-4` (24 ≈ 32) |

### 1.3.4 Aviso de error (escondido; solo aparece si fallan correo o clave)
**Etiqueta:** `<div class="login__error" hidden>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:grid; grid-template-columns:16px 1fr; gap:12px; align-items:start` (icono + texto) | `d-flex gap-3` ≈ |
| Aspecto | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px; padding:12px 16px; font-size:14px; line-height:20px; color:#D4183D; margin-bottom:20px` | `alert d-none` + esquinas 12 ✖; color `#D4183D` ✖ propio |

### 1.3.5 El formulario
**Etiqueta:** `<form>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; flex-direction:column; gap:20px` | `d-flex flex-column gap-3` (16 ≈ 20; exacto ✖ `style="gap:20px"`) |

**a) Grupo "Correo Electrónico"** (columna, 6 px entre etiqueta y campo)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Etiqueta | `font-size:14px; line-height:1; font-weight:600; color:#321525` (`<label for="correo">`) | `form-label fw-semibold small mb-1` ✔ |
| Campo `<input type="email" id="correo" placeholder="correo@bakeadmin.com">` | `height:44px; background:#F2EEF1; border:1px solid rgba(116,27,61,.2); border-radius:8px; padding:0 12px; font-size:14px; width:100%` | `form-control` (38 px) → alto 44 ✖ `style="height:44px"`; fondo `bg-campo` |

**b) Grupo "Contraseña"**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Fila de arriba (etiqueta izquierda, enlace derecha) | `display:flex; justify-content:space-between; align-items:center` | `d-flex justify-content-between align-items-center` ✔ |
| Etiqueta "Contraseña" | igual que la de correo | igual |
| Enlace "¿Olvidaste tu contraseña?" → lleva a Recuperar | `font-size:12px; line-height:16px; font-weight:500; color:#96244F; text-decoration:none` y `:hover{text-decoration:underline}` | `fw-medium text-vino-medio link-underline-opacity-0 link-underline-opacity-100-hover` (12 px ✖) |
| Campo `<input type="password" placeholder="••••••••">` | igual que el de correo | igual |

**c) Botón "Ingresar →"**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `width:100%; height:48px` | `btn btn-primary btn-lg w-100` ✔ (48 px) |
| Letra | `font-size:16px; line-height:24px; font-weight:700` | `fs-6 fw-bold` ✔ |
| Colores | fondo `#741B3D`, letra blanca. ⚠ En el prototipo **no cambia al pasar el mouse** | `btn-primary` ✔ (con `--bs-primary` vino); para que no cambie: `.btn-primary:hover{background:#741B3D}` |
| Contenido | texto "Ingresar" + flecha → de 16 px, `gap:8px` | `d-flex align-items-center justify-content-center gap-2` |

### 1.3.6 Enlace de registro
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Texto | "¿Eres cliente nuevo? **Regístrate aquí**" (`<p>` centrado) | `text-center` ✔ |
| Letra | `font-size:14px; line-height:20px; color:#7A6873; margin-top:16px` | `small text-gris mt-3` ✔ |
| El enlace | `font-weight:600; color:#741B3D; text-decoration:none` y subrayado en `:hover` | `fw-semibold text-vino link-underline-opacity-0 link-underline-opacity-100-hover` |

### 1.3.7 Separador "o continúa sin cuenta"
**Etiqueta:** `<div class="separador">` con una línea y un `<span>`.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `position:relative; text-align:center; margin-top:32px` | `position-relative text-center mt-4` (24 ≈ 32) |
| **Cómo hacer la línea que cruza detrás del texto** | `<div class="linea">` con `position:absolute; top:50%; left:0; right:0; border-top:1px solid rgba(116,27,61,.133)` | `position-absolute top-50 start-0 end-0 border-top` ✔ |
| El texto "o continúa sin cuenta" va **encima** | `position:relative; padding:0 12px; background:#FCF8F9` (el fondo "borra" la línea detrás del texto) | `position-relative bg-fondo px-3` (16 ≈ 12) |
| Letra | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |

### 1.3.8 Botón "Ver menú y Realizar Pedidos (sin cuenta)"
**Etiqueta:** `<a href="menu.html" class="btn-sin-cuenta">` (parece botón, lleva al Menú del cliente)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `display:flex; align-items:center; justify-content:center; gap:8px; width:100%; height:48px; margin-top:16px` | `btn btn-lg w-100 mt-3 d-flex align-items-center justify-content-center gap-2` ✔ |
| Borde y fondo | `border:1px solid #F27C86; background:rgba(242,124,134,.082); border-radius:8px` | `border border-coral rounded-3` + fondo con transparencia ✖ |
| Letra | `font-size:14px; font-weight:700; color:#321525` | `small fw-bold` |
| Icono taza ☕ | 16 px, color `#F27C86`, a la izquierda del texto | `text-coral` |
| Al pasar el mouse | no cambia | — |

**Comportamiento que se agrega después (JS/backend):** entrar con éxito → Inicio · error → mostrar 1.3.4 · "sin cuenta" → entra como invitado.

**Revisión Login:** [ ] 1440 px: izquierda 792 / derecha 648 · [ ] título 72 px (60 a 1100 px; 48 en celular) · [ ] campos 44, botones 48 · [ ] 3 bolas + línea inclinada + etiqueta v2.0 · [ ] en celular la oscura arriba y aparece la marca pequeña · [ ] sin barra horizontal.

---
<a id="vista-2"></a>
# 2. VISTA DE RECUPERAR CONTRASEÑA

**Qué es:** pantalla dividida en **2 partes** (la misma caja vino de la izquierda que usa Registrarse) y en la derecha **un solo cuadrito que cambia en 3 etapas**: (1) pide el correo → (2) pide la contraseña nueva → (3) dice "Contraseña actualizada". Se construyen 3 páginas (`recuperar.html`, `recuperar-2.html`, `recuperar-3.html`) o 1 que cambia con JS más adelante.
**Se llega desde:** el enlace "¿Olvidaste tu contraseña?" del login. **Lleva a:** Login.

> ⚠ **Ojo:** este login NO es igual al de la Vista 1. Esta parte izquierda mide **52.5 %** (756 px a 1440), no 55 %. **No copies una para la otra.**

```
┌──────────────────────────────┬──────────────────────────┐
│ IZQUIERDA 756 px (52.5 %)    │ DERECHA 684 px           │
│ fondo #350B1A                │ fondo #FCF8F9            │
│ ○ bola A (arriba-izq)        │ ← Volver al inicio       │
│ [logo] BakeAdmin             │ [✉]                      │
│        Coffee Park           │ Recuperar contraseña     │
│ ✦ GESTIÓN OPERATIVA          │ Correo de acceso [____]  │
│ TU PANADERÍA, TU CONTROL.    │ [ Enviar enlace ]        │
│              ○ bola B        │                          │
│ Coffee Park · Colombia       │                          │
└──────────────────────────────┴──────────────────────────┘
```

<a id="molde"></a>
## 2.A EL MOLDE DE LAS DOS PARTES (se hace una vez y sirve para Recuperar y para [Registrarse](#vista-3))

### 2.A.1 La pantalla completa
**Etiqueta:** `<div class="auth">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Alto | `min-height:100vh` | `min-vh-100` ✔ |
| Cómo se divide | desde 1024 px: `display:grid; grid-template-columns:1.05fr .95fr` → **756 px** y **684 px** a 1440 | ✖ propio (`row g-0` + `col-lg-6` da 50/50 ≈) |
| Menos de 1024 px | la parte izquierda **no se muestra** y la derecha ocupa todo | `d-none d-lg-flex` en la izquierda ≈ |

### 2.A.2 PARTE IZQUIERDA
**Etiqueta:** `<section class="auth__izq">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo y letra | `background:#350B1A; color:#fff` | `bg-vino-oscuro text-white` |
| Relleno | `padding:48px` | `p-5` ✔ |
| Acomodo | `display:flex; flex-direction:column` (marca arriba, mensaje al centro, pie abajo) | `d-flex flex-column` ✔ |
| Para colocar las bolas | `position:relative; overflow:hidden` | `position-relative overflow-hidden` ✔ |
| Escondida en celular | `display:none` y desde 1024 px `display:flex` | `d-none d-lg-flex` ≈ |

**Bola A (arriba a la izquierda, vino)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:-96px; left:-96px` (sale 96 px por arriba y por la izquierda) | `position-absolute` ✔ + valores negativos ✖ |
| Tamaño y forma | `width:320px; height:320px; border-radius:50%` | `rounded-circle` ✔ + tamaño ✖ |
| Color | `background:rgba(116,27,61,.5)` (vino al 50 %) | ✖ propio |

**Bola B (a la derecha, a un tercio de la altura, coral)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:33.333%; right:-80px` | `position-absolute` ✔ + `top:33.333%` y `right:-80px` ✖ |
| Tamaño y forma | `width:288px; height:288px; border-radius:50%` | `rounded-circle` ✔ + tamaño ✖ |
| Color | `background:rgba(242,124,134,.2)` (coral al 20 %) | ✖ propio |

**Marca (arriba): logo + "BakeAdmin" + "Coffee Park"**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Dónde queda** | primer hijo de la columna → arriba a la izquierda; `position:relative` para quedar sobre las bolas | `position-relative` ✔ |
| Acomodo | `display:flex; align-items:center; gap:12px` | `d-flex align-items-center gap-3` (16 ≈ 12) |
| Logo | `width:48px; height:48px; border-radius:16px; object-fit:contain` | `rounded-4 object-fit-contain` ✔ + tamaño ✖ |
| "BakeAdmin" | `font-size:20px; line-height:28px; font-weight:900; color:#fff` | `fs-5 fw-black text-white` |
| **"Coffee Park"** debajo | `font-size:12px; line-height:16px; color:#F6B4B8` | `small text-rosa` (12 ✖) |

**Mensaje (centro)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarlo verticalmente** | `margin-block:auto; position:relative; max-width:576px` | `my-auto position-relative` ✔ + `max-width:576px` ✖ |
| Etiqueta "✦ Gestión operativa" | chispa 16 px + texto con `gap:8px`; `font-size:14px; line-height:20px; font-weight:700; text-transform:uppercase; letter-spacing:.25em; color:#F27C86; margin-bottom:16px` | `d-flex gap-2 small fw-bold text-uppercase text-coral mb-3` ✔ + `letter-spacing` ✖ |
| Título "TU PANADERÍA, / **TU CONTROL.**" | `font-size:60px; font-weight:900; line-height:.95` (renglones muy pegados); 1.ª línea blanca, 2.ª `#F27C86` | `fw-black` + 60 px ✖ + `.95` ✖ |
| Texto "Gestiona producción, pedidos, domicilios y compras desde un solo lugar." | `font-size:18px; line-height:1.625; color:rgba(246,180,184,.8); max-width:448px; margin-top:24px` | `mt-4` ✔ + resto ✖ |

**Pie**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| "Coffee Park · Colombia" (abajo) | `font-size:12px; line-height:16px; color:rgba(255,255,255,.4); position:relative` | `small text-white opacity-50 position-relative` ≈ |

### 2.A.3 PARTE DERECHA
**Etiqueta:** `<section class="auth__der">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo | `background:#FCF8F9` | `bg-fondo` |
| Alto y centrado | `min-height:100vh; display:flex; align-items:center` (el contenido queda en el centro vertical) | `d-flex align-items-center min-vh-100` ✔ |
| Relleno | `padding:40px 20px`; desde 640 px lados `40px` | `py-5` (48 ≈ 40) `px-3` (16 ≈ 20) |
| **Caja interna** (donde va todo) | `width:100%; max-width:576px; margin-inline:auto` | `w-100 mx-auto` ✔ + `max-width:576px` ✖ |

### 2.A.4 Piezas comunes de la parte derecha
| Pieza | CSS | Bootstrap |
|---|---|---|
| **"← Volver…"** (enlace) | `display:inline-flex; align-items:center; gap:8px; min-height:44px; font-size:14px; line-height:20px; font-weight:600; color:#741B3D; text-decoration:none;` margen abajo: **24 px** (Registro) / **32 px** (Recuperar); flecha de 16 px | `d-inline-flex align-items-center gap-2 fw-semibold small text-vino text-decoration-none mb-4` (24 ✔; 32 ✖) |
| **Título de vista** `<h2>` | `font-size:30px; line-height:36px; font-weight:900` | `h2 fw-black` + 30 ✖ |
| **Descripción** `<p>` | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |
| **Círculo de éxito** | `width:80px; height:80px; border-radius:50%; background:#DBFCE7; display:flex; align-items:center; justify-content:center; margin-inline:auto`; símbolo ✓ de 40 px color `#008236` | `rounded-circle d-flex align-items-center justify-content-center mx-auto` ✔ + 80 px ✖ + color ✖ |

## 2.1 ETAPA 1 — Pedir el correo (`recuperar.html`)
Dentro de la caja interna (2.A.3), de arriba hacia abajo:

**2.1.1 Enlace "← Volver al inicio"** → pieza común (2.A.4), **margen abajo 32 px**. Lleva a Login.

**2.1.2 Caja del icono (sobre ✉)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `width:56px; height:56px` | ✖ `style` |
| Fondo y esquinas | `background:#FCE8EA; border-radius:16px` | `bg-acento rounded-4` ✔ |
| **Cómo centrar el sobre dentro** | `display:flex; align-items:center; justify-content:center` | `d-flex align-items-center justify-content-center` ✔ |
| Sobre | icono de 24 px, color `#741B3D` | `text-vino` |

**2.1.3 Título "Recuperar contraseña"** (`<h2>`) → `font-size:30px; line-height:36px; font-weight:900; margin-top:20px` · Bootstrap: `h2 fw-black mt-3` (16 ≈ 20) + 30 ✖.

**2.1.4 Descripción "Enviaremos el enlace a tu correo de recuperación."** → `font-size:14px; color:#7A6873; margin-top:8px` · Bootstrap: `small text-gris mt-2` ✔.

**2.1.5 Formulario**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; flex-direction:column; gap:20px; margin-top:28px` | `d-flex flex-column gap-3 mt-4` (≈; 20 y 28 ✖) |

**2.1.6 Grupo "Correo de acceso"**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Etiqueta | `font-size:14px; line-height:1; font-weight:500` | `form-label fw-medium small mb-1` ✔ |
| Campo `<input type="email" placeholder="correo@ejemplo.com">` | `height:48px; width:100%; background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px; margin-top:4px` | `form-control form-control-lg fs-6` ✔ (48 px) + `bg-campo` |
| Mensaje de error (escondido; sale si falta la `@`) "Ingrese un correo válido." | `font-size:12px; line-height:16px; color:#E7000B; margin-top:4px` | `text-danger small mt-1 d-none` ≈ |

**2.1.7 Botón "Enviar enlace"** → `width:100%; height:48px; font-size:14px; font-weight:500; background:#741B3D; color:#fff; border-radius:8px` · Bootstrap: `btn btn-primary btn-lg w-100` + `small fw-medium` ✔ (48 px).
Al enviar (después, con JS): aviso "Enlace enviado al correo de recuperación" y pasa a la etapa 2.

## 2.2 ETAPA 2 — Contraseña nueva (`recuperar-2.html`)
Misma pantalla y molde; cambia el contenido de la caja interna:
| Pieza | CSS | Bootstrap |
|---|---|---|
| "← Volver al inicio" | igual que etapa 1 | igual |
| Mini-etiqueta **"PASO 2 DE 2"** | `font-size:12px; line-height:16px; font-weight:700; text-transform:uppercase; letter-spacing:.1em; color:#96244F` | `text-uppercase fw-bold text-vino-medio` + 12 px ✖ + espaciado ✖ |
| Título "Nueva contraseña" | `30px/36px; 900; margin-top:8px` | `h2 fw-black mt-2` ✔ |
| Descripción "Crea una nueva contraseña para **{el correo escrito}**." | `14px; #7A6873; margin-top:8px` | `small text-gris mt-2` ✔ |
| Formulario | `display:flex; flex-direction:column; gap:16px; margin-top:28px` (aquí son **16**, no 20) | `d-flex flex-column gap-3 mt-4` ✔ (gap) |
| Campo 1: etiqueta "Nueva contraseña" + `<input type="password">` | alto 48 px, fondo `#F2EEF1`, **sin texto de ejemplo** | `form-control form-control-lg fs-6` ✔ |
| Campo 2: "Confirmar contraseña" | igual; **debajo** va el único mensaje de error (12 px, `#E7000B`): "La contraseña debe tener mínimo 8 caracteres." o "Las contraseñas no coinciden." | `text-danger small mt-1 d-none` ≈ |
| Botón "Actualizar contraseña" | principal, 48 px, ancho completo | `btn btn-primary btn-lg w-100` ✔ |

## 2.3 ETAPA 3 — Éxito (`recuperar-3.html`, todo centrado)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Círculo de éxito (✓ verde) | 80 × 80, fondo **`#DBFCE7`**, ✓ de 40 px `#008236` (pieza común 2.A.4) | `rounded-circle … mx-auto` |
| Título "Contraseña actualizada" | `30px/36px; 900; text-align:center; margin-top:20px` | `h2 fw-black text-center mt-3` ≈ |
| Texto "Ya puedes ingresar con tu nueva contraseña." | `font-size:16px; color:#7A6873; text-align:center; margin-top:8px` | `fs-6 text-gris text-center mt-2` ✔ |
| Botón "Iniciar sesión" → Login | `width:100%; height:48px; margin-top:24px`, principal | `btn btn-primary btn-lg w-100 mt-4` ✔ |

> ⚠ **Lo que NO debes copiar de la indicación de la IA de Figma** (tiene medidas distintas al diseño real; esta guía manda): nombre bajo el logo = **"Coffee Park"** (no "Sistema de Gestión") · pie izquierdo = **"Coffee Park · Colombia"** · descripción etapa 1 = **"Enviaremos el enlace a tu correo de recuperación."** · etiqueta = **"Correo de acceso"** · botón = **"Enviar enlace"** · etapa 2 sin textos de ejemplo · círculo de éxito **`#DBFCE7`** · dos bolas (320 vino 50 % arriba-izq y 288 coral 20 % a la derecha).

**Revisión Recuperar:** [ ] 1440 px: 756 / 684 · [ ] caja del icono 56 × 56, campos 48, botones 48 · [ ] etapa 2 "PASO 2 DE 2" en `#96244F` y un solo error · [ ] etapa 3 círculo 80 px verde claro.

---

<a id="vista-3"></a>
# 3. VISTA REGISTRARSE (crear cuenta)

**Qué es:** el mismo molde de 2 partes de la [Vista 2 (sección 2.A)](#molde). Solo cambia lo que va en la **parte derecha**: un formulario largo dividido en **dos cajas blancas** ("Acceso" e "Información personal"). Al terminar se muestra "Cuenta creada".
**Se llega desde:** "Regístrate aquí" del login. **Lleva a:** Login.
> Parte izquierda, bolas, marca, mensaje y pie: **idénticos a 2.A** (756 / 684 px a 1440, bolas 320 y 288, "Coffee Park").

```
← Volver
Crear cuenta
Regístrate como cliente de Coffee Park.
┌─ Acceso ───────────────────────────────┐
│ Correo            │ Contraseña         │
│ Correo de recuperación                 │
└────────────────────────────────────────┘
┌─ Información personal ─────────────────┐
│ Nombres           │ Apellidos          │
│ Tipo de documento │ Número documento   │
│ Teléfono          │                    │
│ Dirección (ancho completo)             │
└────────────────────────────────────────┘
[         Crear cuenta         ]
¿Ya tienes cuenta? Iniciar sesión
```

## 3.1 "← Volver", título y descripción (de arriba a abajo)
| Pieza | CSS | Bootstrap |
|---|---|---|
| "← Volver" → Login | pieza común 2.A.4, **margen abajo 24 px** | `… mb-4` ✔ |
| Título "Crear cuenta" | `font-size:30px; line-height:36px; font-weight:900` | `h2 fw-black` + 30 ✖ |
| Descripción "Regístrate como cliente de Coffee Park." | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px; margin-bottom:24px` | `small text-gris mt-1 mb-4` ✔ |

## 3.2 El formulario
**Etiqueta:** `<form>` → CSS: `display:flex; flex-direction:column; gap:20px` · Bootstrap: `d-flex flex-column gap-4` (24 ≈ 20).

## 3.3 Caja blanca "Acceso"
**Etiqueta:** `<section>` con `<h3>` y una grilla de campos.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:16px; padding:20px` | `bg-white border rounded-4 p-4` (24 ≈ 20) |
| Título "Acceso" (`<h3>`) | `font-size:18px; line-height:27px; font-weight:900; margin-bottom:16px` | `h3 fw-black mb-3` ✔ + 18 ✖ |
| **Grilla de campos** | celular 1 columna; desde 640 px **2 columnas iguales**: `display:grid; grid-template-columns:1fr; gap:16px` → `@media(min-width:640px){grid-template-columns:1fr 1fr}` | `row g-3` y cada campo `col-12 col-sm-6` (sm = 576 ≈ 640) |
| Campos, en orden | 1) **Correo** (`type="email"`) · 2) **Contraseña** (`type="password"`) · 3) **Correo de recuperación** (`type="email"`) | — |

**Cada campo** (etiqueta + campo + error escondido):
| Pieza | CSS | Bootstrap |
|---|---|---|
| Grupo | `display:flex; flex-direction:column; gap:6px` | `d-flex flex-column` + `gap` 6 ✖ (`mb-1` ≈) |
| Etiqueta | `font-size:14px; font-weight:500; line-height:1` | `form-label fw-medium small mb-1` |
| Campo | `height:44px; background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px` | `form-control bg-campo` + alto 44 ✖ |
| Error | `font-size:12px; color:#E7000B; margin-top:4px` (escondido) | `text-danger small mt-1 d-none` |
| Mensajes posibles | "Ingrese un correo válido." · "Debe tener mínimo 8 caracteres." · "Ingrese un correo de recuperación válido." · "Debe ser distinto al correo de acceso." | |

## 3.4 Caja blanca "Información personal"
Misma caja (3.3) y mismo título (18 px, 900, "Información personal"), con 6 campos, **en este orden**:
| N.º | Campo | Tipo | Ocupa |
|---|---|---|---|
| 1 | Nombres | texto | 1 columna |
| 2 | Apellidos | texto | 1 columna |
| 3 | Tipo de documento | lista `<select>` con CC, CE, TI, PP, NIT | 1 columna (`form-select` en Bootstrap) |
| 4 | Número de documento | texto | 1 columna |
| 5 | Teléfono | texto | 1 columna |
| 6 | **Dirección** | texto | **las 2 columnas**: CSS `grid-column:1 / -1` · Bootstrap `col-12` |

Errores posibles: "Los nombres son obligatorios." · "Los apellidos son obligatorios." · "El documento es obligatorio y debe ser único."

## 3.5 Botón "Crear cuenta"
CSS: principal, `width:100%; height:48px` · Bootstrap: `btn btn-primary btn-lg w-100 fs-6` ✔ (48 px).

## 3.6 Pie "¿Ya tienes cuenta? **Iniciar sesión**"
CSS: `text-align:center; font-size:14px; line-height:20px; color:#7A6873`; el enlace `font-weight:700; color:#741B3D; text-decoration:none` → Login · Bootstrap: `text-center small text-gris` + enlace `fw-bold text-vino text-decoration-none`.

## 3.7 Pantalla de éxito (reemplaza todo lo anterior en la parte derecha)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Círculo verde ✓ | 80 × 80, `#DBFCE7`, ✓ 40 px `#008236`, centrado | `rounded-circle … mx-auto` |
| "Cuenta creada" | `30px/36px; 900; text-align:center; margin-top:20px` | `h2 fw-black text-center mt-3` |
| "Ya puedes iniciar sesión y pedir a domicilio." | `16px; #7A6873; margin-top:8px` | `fs-6 text-gris text-center mt-2` |
| Botón "Ir a iniciar sesión" | principal, 48 px, ancho completo, `margin-top:24px` | `btn btn-primary btn-lg w-100 mt-4` ✔ |

**Revisión Registro:** [ ] 756 / 684 · [ ] 2 cajas blancas con relleno 20, esquinas 16, título 18 px · [ ] 2 columnas desde 640 px y "Dirección" ocupa las 2 · [ ] campos 44, botón 48 · [ ] en menos de 1024 px desaparece la caja oscura.

---
<a id="marco"></a>
# MARCO DEL PANEL (menú lateral + barra de arriba + contenido + pie)

**Qué es:** el "edificio" donde viven las vistas 4 a 11. Se construye **una sola vez** y se copia en cada vista; en cada una solo cambian 6 cosas: (1) título de la pestaña del navegador, (2) qué enlace del menú está activo, (3) texto de sección de la barra, (4) sede de la barra, (5) migas de pan, (6) el contenido.

```
┌─────────┬──────────────────────────────────────────────┐
│ MENÚ    │ BARRA DE ARRIBA (alto 80 px)                 │
│ 256 px  │ COMPRAS · Coffee Park Centro  [Sinc] Laura [Cerrar sesión]
│ #350B1A ├──────────────────────────────────────────────┤
│ logo    │ CONTENIDO  (migas: Inicio / Compras)         │
│ Inicio  │   AQUÍ VA LA VISTA                           │
│ Usuarios├──────────────────────────────────────────────┤
│ v2.0    │ PIE: BakeAdmin v2.0 · Coffee Park · …        │
└─────────┴──────────────────────────────────────────────┘
```

## M.1 Contenedor de toda la pantalla
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; min-height:100vh; background:#FCF8F9` | `d-flex min-vh-100 bg-fondo` ✔ |

## M.2 MENÚ LATERAL (izquierda)
**Etiqueta:** `<aside>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo ponerlo pegado a la izquierda** | `position:fixed; top:0; bottom:0; left:0; z-index:50` | `position-fixed top-0 bottom-0 start-0` ✔ (`z-index:50` ✖; en Bootstrap lo resuelve `offcanvas-lg`) |
| Ancho y alto | `width:256px; height:100vh` | ✖ `style="width:256px"` (con offcanvas: `--bs-offcanvas-width:256px`) |
| Colores | `background:#350B1A; color:#fff` | `bg-vino-oscuro text-white` |
| Acomodo | `display:flex; flex-direction:column` (logo arriba, enlaces al medio que crecen, pie abajo) | `d-flex flex-column` ✔ |
| Celular (< 1024 px) | no se ve (`display:none`); se abre como cajón de 288 px con botón ☰ | `offcanvas-lg offcanvas-start` + botón `data-bs-toggle="offcanvas" data-bs-target="#menu"` (sin JS tuyo) |

**M.2.a Bloque del logo (arriba)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `height:80px; padding:0 16px; display:flex; align-items:center; gap:12px; border-bottom:1px solid rgba(255,255,255,.1)` | `d-flex align-items-center gap-3 px-3 border-bottom` + `style="height:80px"` ✖ |
| Logo | `width:44px; height:44px; border-radius:16px; object-fit:contain; flex-shrink:0` | `rounded-4 object-fit-contain flex-shrink-0` ✔ + tamaño ✖ |
| "BakeAdmin" | `font-size:16px; font-weight:900; line-height:1.25` | `fs-6 fw-black lh-sm` ✔ |
| "Coffee Park" debajo | `font-size:11px; color:#F6B4B8` | `text-rosa` + 11 px ✖ |

**M.2.b Lista de enlaces**
**Etiqueta:** `<nav>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `flex:1; display:flex; flex-direction:column; gap:4px; padding:12px` | `nav flex-column gap-1 p-3 flex-grow-1` (16 ≈ 12) |
| **Cada enlace** `<a>` — acomodo | `display:flex; align-items:center; gap:12px; min-height:44px; padding:0 12px; border-radius:16px` | `nav-link d-flex align-items-center gap-3 rounded-4` ✔ + alto 44 ✖ |
| Letra | `font-size:14px; line-height:20px; font-weight:600; color:rgba(255,255,255,.75)` | `small fw-semibold text-white` + 75 % ✖ |
| Icono | 20 px | — |
| Al pasar el mouse | `background:rgba(255,255,255,.1); color:#fff` | ✖ propio |
| **Activo** (página actual; solo uno) | `background:#F27C86; color:#350B1A; box-shadow:0 1px 3px rgba(0,0,0,.1)` | `nav-link active` con `--bs-nav-pills-link-active-bg:#F27C86; --bs-nav-pills-link-active-color:#350B1A` |

**Qué enlaces ve cada rol:** Inicio (todos) · Usuarios (administrador) · Compras (administrador, gerente, cajera, auxiliar) · Producción (administrador, gerente, cocinero) · Domicilios (administrador, gerente, cajera, mesero) · Mis domicilios (repartidor) · Menú (cliente) · Mis pedidos (cliente). El invitado solo ve "Menú".

**M.2.c Pie del menú**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `border-top:1px solid rgba(255,255,255,.1); padding:12px` | `border-top p-3` ✔ |
| "BakeAdmin v2.0 · 2026" | `font-size:10px; line-height:16px; color:rgba(255,255,255,.35); margin-top:8px; padding:0 12px` | `opacity-50 mt-2` + 10 px ✖ |

## M.3 COLUMNA DERECHA (todo lo que está a la derecha del menú)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `flex:1; min-width:0; display:flex; flex-direction:column`; **desde 1024 px `margin-left:256px`** (para no quedar debajo del menú fijo) | `d-flex flex-column flex-grow-1` ✔ + `margin-left:256px` ✖ propio |

## M.4 BARRA DE ARRIBA
**Etiqueta:** `<header>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo pegarla arriba al hacer scroll** | `position:sticky; top:0; z-index:40` | `sticky-top` ✔ |
| Alto | `height:80px` | ✖ `style="height:80px"` |
| Fondo y línea | `background:rgba(255,255,255,.95); border-bottom:1px solid rgba(116,27,61,.14)` | `bg-white border-bottom` ≈ |
| Relleno lateral | `padding:0 16px` (desde 768 px `0 32px`) | `px-3 px-md-4` (24 ≈ 32) |
| Acomodo | `display:flex; align-items:center` | `d-flex align-items-center` ✔ |

**Lado izquierdo (2 textos, uno sobre otro):**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Sección (ej. "COMPRAS") | `font-size:12px; line-height:16px; font-weight:600; text-transform:uppercase; letter-spacing:.05em; color:#96244F` | `text-uppercase fw-semibold text-vino-medio` + 12 px ✖ + espaciado ✖ |
| Sede (ej. "Coffee Park Centro") | `font-size:14px; line-height:20px; color:#7A6873` (Administrador: "Todas las sedes"; cliente: "Pedidos a domicilio") | `small text-gris` |

**Lado derecho** (caja con `margin-left:auto`; `display:flex; align-items:center; gap:12px`) → Bootstrap: `d-flex align-items-center gap-3 ms-auto` (16 ≈ 12):
| Pieza | CSS | Bootstrap |
|---|---|---|
| 1. Pastilla "Sincronizado" | `background:#00C950; color:#fff; font-size:12px; line-height:16px; font-weight:500; padding:2px 8px; border-radius:10px` | `badge rounded-pill` + fondo `#00C950` ✖ |
| 2. Usuario (solo desde 768 px, alineado a la derecha) | nombre `14px; 700`; debajo el rol `12px; #7A6873` | `d-none d-md-block text-end` + `fw-bold small` / `small text-gris` ✔ |
| 3. Botón "Cerrar sesión" → Login | contorno, `height:44px; border:1px solid #741B3D; color:#741B3D` | `btn btn-outline-primary` + alto 44 ✖ |

## M.5 CONTENIDO PRINCIPAL
**Etiqueta:** `<main>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `flex:1; width:100%; padding:24px 16px` (desde 768 px `24px 32px`) | `flex-grow-1 w-100 py-4 px-3 px-md-4` ✔ |
| Caja interna centrada | `max-width:1440px; margin-inline:auto` | `mx-auto` + `max-width:1440px` ✖ |
| Migas de pan "Inicio / **Compras**" | `font-size:12px; line-height:16px; color:#7A6873; margin-bottom:16px`; la "/" con 4 px de margen a cada lado | `breadcrumb small mb-3` ✔ |

## M.6 PIE
**Etiqueta:** `<footer>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `padding:16px 32px; border-top:1px solid rgba(116,27,61,.14); text-align:center` | `border-top py-3 px-4 text-center` ✔ |
| Texto "BakeAdmin v2.0 · Coffee Park · Operación offline habilitada" | `font-size:12px; line-height:16px; color:#7A6873` | `small text-gris` |

**Revisión del marco:** [ ] menú 256 px y no se mueve al hacer scroll · [ ] barra 80 px y se queda pegada arriba · [ ] solo un enlace del menú en coral · [ ] en celular el menú desaparece.

---

<a id="patrones"></a>
# PIEZAS DE PÁGINA QUE SE REPITEN EN EL PANEL

### Patrón A — Encabezado de página con botón (vistas 5, 6, 7, 10)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | celular columna con `gap:16px`; **desde 640 px fila**: `display:flex; justify-content:space-between; align-items:flex-end` (título a la izquierda, botón a la derecha, alineados abajo) | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-end gap-3` ✔ |
| Título `<h1>` | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción `<p>` | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px` | `small text-gris mt-1` ✔ |
| Botón | principal de **44 px** (en Producción de 36 px) | `btn btn-primary` + alto 44 ✖ |

### Patrón D — Barra de filtros
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px` (1 columna en celular; desde 768 px o 1024 px columnas tipo `1fr 220px 240px`, se dice en cada vista) | `row g-2` + `col-12 col-md` / `col-md-auto` (g-2 = 8 ≈ 12; anchos 220/240 ✖) |
| Campos | alto **40 px** | `form-control-sm` (31) ≈ o ✖ `style="height:40px"` |
| Textos | el buscador "Buscar…"; las listas empiezan con "Todos los…" | — |

### Patrón F — Tarjetas de color (alertas en número)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **4 columnas desde 768 px** | `row g-3` + `col-12 col-md-3` ✔ |
| Cada tarjeta | `padding:20px 20px 24px; border-radius:12px; border:1px solid` (colores de estado) | `rounded-3 p-4` ≈ (12 ✖) |
| Etiqueta | `font-size:12px; font-weight:600; text-transform:uppercase` | `small fw-semibold text-uppercase` |
| Valor | `font-size:24px; line-height:32px; font-weight:900; margin-top:4px` | `fs-4 fw-black mt-1` ✔ |

---

<a id="vista-4"></a>
# 4. VISTA INICIO

**Qué es:** la portada del panel: un saludo, **4 tarjetas con números grandes** y abajo **2 cajas lado a lado** (avisos y atajos). Usa el [Marco](#marco). **Quién entra:** todos (cambia el contenido según el rol). **Menú activo:** Inicio. **Barra:** "INICIO" / "Todas las sedes". **Migas:** Inicio.

```
Resumen general
Buenos días, Laura
Visión consolidada de la operación de Coffee Park. · 30/06/2026
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Usuarios│ │Alertas │ │Pedidos │ │Pendient│
│ 28   👥│ │ 4    ⚠│ │ 12   🚚│ │ 3    🕒│
└────────┘ └────────┘ └────────┘ └────────┘
┌─ Alertas y pendientes ─────┐ ┌─ Accesos rápidos ─┐
│ [aviso]            [Ir →]  │ │ [Usuarios      →] │
└────────────────────────────┘ └───────────────────┘
```
Todo en una columna con **24 px** entre bloques: CSS `display:flex; flex-direction:column; gap:24px` · Bootstrap `d-flex flex-column gap-4` ✔.

## 4.1 Encabezado (sin botón)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Módulo (ej. "Resumen general") | `font-size:14px; line-height:20px; font-weight:600; color:#96244F` | `small fw-semibold text-vino-medio` |
| Título "Buenos días, {nombre}" | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción "{texto del rol} · 30/06/2026" | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px` | `small text-gris mt-1` ✔ |

## 4.2 Cuatro tarjetas de números
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`: 1 columna en celular, **2 desde 640 px, 4 desde 1280 px** | `row g-3` + cada tarjeta `col-12 col-sm-6 col-xl-3` ✔ (xl = 1200 ≈ 1280) |
| **Cada tarjeta** | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px` | `card` (esquinas 12 ✖) |
| Interior | `display:flex; justify-content:space-between; align-items:flex-start; gap:12px; padding:20px 20px 24px` (texto a la izquierda, icono a la derecha) | `card-body d-flex justify-content-between align-items-start gap-3` ✔ |
| Etiqueta | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |
| Número | `font-size:30px; line-height:36px; font-weight:900; margin-top:8px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap` | `fw-black text-truncate mt-2` ✔ + 30 ✖ |
| **Caja del icono** | `width:44px; height:44px; border-radius:16px; background:#FCE8EA; color:#741B3D; display:flex; align-items:center; justify-content:center; flex-shrink:0`; icono 20 px | `d-flex align-items-center justify-content-center rounded-4 bg-acento text-vino flex-shrink-0` ✔ + 44 ✖ |

**Contenido por rol (etiqueta → número):**
| Rol | Módulo | Descripción | Las 4 tarjetas |
|---|---|---|---|
| administrador | Resumen general | Visión consolidada de la operación de Coffee Park. | Usuarios activos **28** · Alertas de inventario **4** · Pedidos en curso **12** · Pendientes de factura **3** |
| gerente | Operación de sede | Indicadores y pendientes de Coffee Park Centro. | Pedidos de hoy **47** · Producciones registradas **6** · Traslados en curso **2** · Alertas de inventario **4** |
| cajera | Recepción y pedidos | Órdenes por recibir y operación de domicilios de la sede. | Órdenes por recibir **3** · Pedidos pendientes **5** · En preparación **4** · Domicilios en camino **3** |
| cocinero | Producción | Consumo de insumos, producciones y traslados. | Producciones hoy **6** · Unidades producidas **284** · Traslados pendientes **2** · Insumos insuficientes **1** |
| auxiliar | Facturación de compras | Órdenes recibidas y pendientes contables. | Pendientes de factura **4** · Facturadas hoy **7** · Total recibido **$ 2.840.000** · Proveedores activos **12** |
| mesero | Pedidos de la sede | Seguimiento de pedidos y entregas de Coffee Park Centro. | Pedidos pendientes **5** · Aceptados **3** · En preparación **4** · Despachados **3** |
| repartidor | Mis domicilios | Entregas asignadas y estado de tu recorrido. | Asignados hoy **8** · En camino **2** · Entregados **6** · Pendientes **2** |
| cliente | Mis pedidos | Consulta tus pedidos recientes. | Pedidos activos **1** · En preparación **1** · En camino **0** · Entregados **4** |

Iconos en orden — admin: personas, advertencia, camión, reloj · gerente: carrito, gorro de cocinero, camión, advertencia · cajera: caja con check, carrito, gorro, camión · cocinero: gorro, caja, camión, advertencia · auxiliar: reloj, documento, carrito, personas · mesero: reloj, persona con check, gorro, camión · repartidor: caja, camión, círculo con check, reloj · cliente: carrito, gorro, camión, círculo con check.

## 4.3 Dos tarjetas lado a lado
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px dos columnas `1.2fr .8fr`** (la izquierda un poco más ancha) | `row g-4` + `col-12 col-lg-7` y `col-12 col-lg-5` ≈ (58/42 %; el diseño es 60/40) |

**Tarjeta izquierda "Alertas y pendientes"** (tarjeta estándar de 0.1; cuerpo con `gap:12px`)
| Pieza | CSS | Bootstrap |
|---|---|---|
| **Cada fila de aviso** | `border:1px solid rgba(116,27,61,.14); border-radius:16px; padding:16px; display:flex; flex-direction:column; gap:12px`; desde 640 px fila: `flex-direction:row; justify-content:space-between; align-items:center` (texto a la izquierda, botón a la derecha) | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 border rounded-4 p-3` ✔ |
| Texto | `font-size:14px; font-weight:600` con icono de 20 px `#741B3D` | `small fw-semibold` + `text-vino` |
| Botón | contorno **pequeño (32 px)**, texto de la acción + flecha → | `btn btn-outline-secondary btn-sm` ≈ |

**Tarjeta derecha "Accesos rápidos"** (cuerpo con `gap:8px`)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Cada botón | contorno, `height:48px; width:100%; display:flex; align-items:center; gap:8px`; icono 16 px + texto a la **izquierda**, flecha → empujada a la derecha (`margin-left:auto`) | `btn btn-outline-secondary btn-lg w-100 text-start fs-6 d-flex align-items-center gap-2` y flecha `ms-auto` ✔ (contenedor `d-grid gap-2`) |

**Revisión Inicio:** [ ] 1440 px: 4 tarjetas en fila; 1024: de 2 en 2; celular: una por una · [ ] número 30 px/900, caja de icono 44 × 44 · [ ] desde 1024 px las dos tarjetas de abajo lado a lado.

---

<a id="vista-5"></a>
# 5. VISTA USUARIOS Y SEGURIDAD

**Qué es:** la lista de personas que pueden entrar al sistema, con **3 pestañas**: Usuarios, Roles y permisos, Sedes. **Quién entra:** solo el administrador. **Menú activo:** Usuarios. **Barra:** "USUARIOS". Usa el [Marco](#marco).

```
Usuarios y seguridad                         [+ Nuevo usuario]
Administra accesos, permisos y sedes de Coffee Park.
[ Usuarios ][ Roles y permisos ][ Sedes ]
┌─ Lista de usuarios ────────────────────────────┐
│ [buscar…] [Rol▾] [Sede▾] [Estado▾]             │
│ ┌ tabla: Nombre|Correo|Rol|Sede|Estado|Acc. ┐  │
│ Mostrando 4 de 4                   [‹][1][›]  │
└────────────────────────────────────────────────┘
```

## 5.1 Encabezado (Patrón A)
Título "**Usuarios y seguridad**" · descripción "**Administra accesos, permisos y sedes de Coffee Park.**" · botón principal **44 px** "**+ Nuevo usuario**" (abre la ventana 5.6). Medidas: ver Patrón A.

## 5.2 Pestañas (ver pieza "Pestañas" de 0.1)
**Usuarios · Roles y permisos · Sedes.** Abierta: Usuarios. Si no caben, la barra se parte en varios renglones: CSS `flex-wrap:wrap` · Bootstrap `flex-wrap`. Contenido a 20 px debajo (`mt-4` ≈).

## 5.3 Pestaña USUARIOS — tarjeta "Lista de usuarios" (cuerpo en columna con `gap:16px`)
**a) Filtros**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px`; **desde 1024 px 4 columnas `1fr 190px 190px 160px`**; campos de **40 px** | `row g-2` + `col-12 col-lg` y `col-lg-auto` ✔ (anchos 190/160 ✖) |
| Buscador | placeholder "Buscar por nombre o correo…" | `form-control` |
| 3 listas | "Todos los roles" (Administrador, Gerente de sede, Cocinero, Mesero, Repartidor, Cliente) · "Todas las sedes" (Sin sede + sedes) · "Todos" (Activo, Inactivo) | `form-select` |

**b) Tabla** (pieza Tabla de 0.1). Columnas: **Nombre completo · Correo · Rol · Sede · Estado · Acciones**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-weight:600` | `fw-semibold` |
| Estado | **Activo** = insignia verde · **Inactivo** = insignia gris (fondo `#F1F5F9`, letra `#45556C`, borde `#E2E8F0`) | `badge border bg-success-subtle text-success-emphasis` / `bg-secondary-subtle text-secondary-emphasis` ≈ |
| Columna Acciones | alineada a la **derecha** (`text-align:right`); botones con `gap:4px`: "Editar" (fantasma pequeño) y "Desactivar" / "Activar" (fantasma pequeño, letra `#C10007`) | `text-end` ✔ + `btn btn-sm btn-link` / `btn-sm btn-link text-danger` |

| Nombre | Correo | Rol | Sede | Estado |
|---|---|---|---|---|
| Laura Martínez | admin@bakeadmin.com | Administrador | Sin sede | Activo |
| Andrés Rojas | gerente@bakeadmin.com | Gerente de sede | Coffee Park Centro | Activo |
| María Gómez | cajera@bakeadmin.com | Cajera | Coffee Park Centro | Activo |
| Carlos Pérez | domiciliario@bakeadmin.com | Repartidor | Coffee Park Centro | Inactivo |

**c) Pie de la tabla**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:center; font-size:14px; color:#7A6873` | `d-flex justify-content-between align-items-center small text-gris` ✔ |
| Izquierda | "Mostrando 4 de 4" | — |
| Derecha: 3 botones cuadrados (‹ desactivado, 1, › desactivado) | contorno, `width:36px; height:36px`, `gap:4px` | `pagination pagination-sm` + `page-item disabled` (36 × 36 ✖) |

## 5.4 Pestaña ROLES Y PERMISOS
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px `280px 1fr`** | `row g-4` + `col-12 col-lg-3` y `col-12 col-lg-9` ≈ |

**Tarjeta "Roles" (izquierda)** — lista en columna con `gap:4px`; cada rol es un botón:
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Botón de rol | `width:100%; min-height:44px; padding:0 12px; border-radius:16px; font-size:14px; font-weight:600; display:flex; justify-content:space-between; align-items:center` (texto a la izquierda; ✓ de 16 px a la derecha **si está elegido**) | `list-group-item list-group-item-action d-flex justify-content-between` ≈ |
| Elegido | fondo `#FCE8EA`, letra `#741B3D` | `active` con colores propios |
| Mouse encima | fondo `#F2EEF1` | ≈ |

**Tarjeta "Permisos de {rol}" (derecha)** — el título lleva un escudo con check (24 px, `#741B3D`) con 8 px de separación.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Grilla de casillas | `display:grid; gap:8px`; **2 columnas desde 768 px**; 12 casillas | `row g-2` + `col-12 col-md-6` ✔ |
| Cada casilla | `display:flex; align-items:center; gap:12px; min-height:48px; padding:12px; border:1px solid rgba(116,27,61,.14); border-radius:16px`; checkbox de 16 px + nombre en `<code>` | `form-check border rounded-4 p-3` ≈ |
| Botón "Guardar permisos del rol" | principal, margen arriba 20 px | `btn btn-primary mt-4` ≈ |

Los 12 permisos: `usuarios.gestionar` · `catalogo.consultar` · `productos.gestionar` · `compras.gestionar` · `compras.recibir` · `facturas.gestionar` · `inventario.consultar` · `produccion.registrar` · `traslados.gestionar` · `pedidos.crear` · `pedidos.gestionar` · `domicilios.entregar` (Administrador: todos marcados; Gerente: todos menos `usuarios.gestionar`).

## 5.5 Pestaña SEDES
Tarjeta "**Sedes**" con el botón "**+ Nueva sede**" **debajo del título** (regla de tarjeta). Tabla **Nombre · Dirección · Teléfono · Tipo · Estado** (Estado = insignia verde "Activo"):
| Nombre | Dirección | Teléfono | Tipo |
|---|---|---|---|
| Planta de producción | Zona Industrial, Bodega 14 | 601 555 1000 | Planta |
| Coffee Park Centro | Cra. 7 # 18-40 | 601 555 1001 | Punto de venta |
| Coffee Park Norte | Calle 127 # 19-20 | 601 555 1002 | Punto de venta |

## 5.6 Ventanas
**Nuevo / Editar usuario** (ancho máximo **768 px**, alto máximo 92 % con barra vertical; Bootstrap `modal-lg` ≈ 800 o `style="max-width:768px"`). Tres bloques con `gap:20px`:
| Bloque | Contenido |
|---|---|
| **"Acceso"** (caja con borde, esquinas 16, relleno 16; título 16 px/700 con margen abajo 16; grilla de 2 columnas desde 768 px, gap 16) | Correo (login) · Contraseña (al editar: "Nueva contraseña (opcional)") · Correo de recuperación · Rol · Sede (no aparece si el rol es Cliente o Administrador) · Estado |
| **"Información complementaria"** (misma caja) | Nombres · Apellidos · Tipo de documento (CC, CE, TI, PP, NIT) · Número de documento · Teléfono · Dirección |
| **Aviso ámbar** | "Un usuario con operaciones registradas no puede cambiar de sede; cree otro usuario para la nueva sede." |
Cada campo: etiqueta + campo separados 6 px; errores 12 px `#E7000B` (mismos textos de Registrarse + "Los nombres son obligatorios." etc.). Pie: **Cancelar** (contorno) y **Guardar** (principal).
**Nueva sede** (**512 px**): Nombre · Dirección · Teléfono · Tipo (Planta / Punto de venta) · Estado. Error: "El nombre es obligatorio".

**Revisión Usuarios:** [ ] menú "Usuarios" en coral · [ ] 3 pestañas · [ ] filtros en fila de 4 desde 1024 · [ ] Acciones a la derecha · [ ] paginación 36 × 36 · [ ] Roles: elegido en rosa con ✓ y 12 casillas en 2 columnas.

---
<a id="vista-6"></a>
# 6. VISTA COMPRAS A PROVEEDORES

**Qué es:** la "tienda de ingredientes". Arriba el título y el botón "Nueva orden"; debajo **6 pestañas** (Alertas, Proveedores, Insumos, Órdenes, Recepción, Facturación); cada una muestra una tarjeta blanca con tabla. Se ve **una a la vez**. Usa el [Marco](#marco).
**Quién entra:** administrador, gerente, cajera, auxiliar. **Menú activo:** Compras. **Barra:** "COMPRAS" / "Coffee Park Centro". **Migas:** Inicio / Compras.

```
Compras a proveedores                           [+ Nueva orden]
Controla inventario, órdenes, recepción y facturación.
[Alertas][Proveedores][Insumos][Órdenes][Recepción][Facturación]
┌ rojo ┐┌ ámbar ┐┌ azul ┐┌ vino ┐     ← 4 tarjetas de color
│Sin st││Bajo mí││En cam││Sede   │
┌─ Semáforo de inventario ───────────────────────────┐
│ Cantidades en g, ml o und.                         │
│ [🛒 Crear orden con lo sugerido]                   │
│ ┌ tabla ────────────────────────────────────────┐  │
└────────────────────────────────────────────────────┘
```

## 6.1 Encabezado (Patrón A)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | columna `gap:16px`; desde 640 px fila `justify-content:space-between; align-items:flex-end` | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-end gap-3` ✔ |
| Título "Compras a proveedores" | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción "Controla inventario, órdenes, recepción y facturación." | `14px/20px; #7A6873; margin-top:4px` | `small text-gris mt-1` |
| **Botón "+ Nueva orden"** (a la derecha del título) | principal, `height:44px`; el + es un icono de 16 px | `btn btn-primary` + alto 44 ✖ (`btn-lg` = 48) |

## 6.2 Pestañas (6)
Pieza "Pestañas" de 0.1. Textos: **Alertas · Proveedores · Insumos · Órdenes · Recepción · Facturación**. Abierta por defecto: **Alertas**. Si no caben, la barra se desliza en horizontal (`overflow-x:auto` · `overflow-x-auto flex-nowrap`). Contenido a **20 px** de la barra.
Bootstrap: `<ul class="nav nav-pills nav-fill bg-white rounded-4 shadow-sm p-1 overflow-x-auto flex-nowrap">`, cada `<button class="nav-link" data-bs-toggle="pill" data-bs-target="#p1">…`, y los 6 paneles dentro de `<div class="tab-content mt-4">` con `tab-pane fade show active` (el primero) y `tab-pane fade` (los demás).

## 6.3 PESTAÑA 1 — ALERTAS (bloques separados 16 px: CSS `gap:16px` · Bootstrap `d-flex flex-column gap-3` ✔)

### 6.3.1 Cuatro tarjetas de color (Patrón F)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **4 desde 768 px** | `row g-3` + `col-12 col-md-3` ✔ |
| Cada tarjeta | `padding:20px 20px 24px; border-radius:12px; border:1px solid …` | `rounded-3 p-4` ≈ |
| Etiqueta | `12px; font-weight:600; MAYÚSCULAS` | `small fw-semibold text-uppercase` |
| Valor | `24px/32px; font-weight:900; margin-top:4px` | `fs-4 fw-black mt-1` ✔ |

| Etiqueta | Valor | Fondo | Letra | Bootstrap ≈ |
|---|---|---|---|---|
| Sin stock | **1** | `#FEF2F2` | `#C10007` | `bg-danger-subtle text-danger-emphasis` |
| Bajo mínimo | **1** | `#FFFBEB` | `#973C00` | `bg-warning-subtle text-warning-emphasis` |
| En camino | **10.000 und.** | `#EFF6FF` | `#1447E6` | ✖ propio |
| Sede | **Coffee Park Centro** | `#FCE8EA` | `#741B3D` | `bg-acento text-vino` |

### 6.3.2 Tarjeta "Semáforo de inventario"
| Pieza | CSS | Bootstrap |
|---|---|---|
| Tarjeta | pieza Tarjeta (0.1): blanca, borde, esquinas 12, relleno 24, `gap:24px` | `card` > `card-body p-4` |
| Encabezado (3 cosas, **una debajo de otra**, `gap:6px`) | título "Semáforo de inventario" `16px/500`; subtítulo "Cantidades en g, ml o und." `14px; #7A6873`; botón principal **pequeño (32 px)** "🛒 Crear orden con lo sugerido" | `h6 fw-medium mb-1` · `small text-gris` · `btn btn-primary btn-sm mt-2` ✔ |

**Tabla** (pieza Tabla de 0.1). Columnas: **Insumo · Estado · Stock actual · En camino · Mínimo · Máximo · Sugerido**.
| Columna | CSS | Bootstrap |
|---|---|---|
| Insumo | nombre `font-weight:600` y **debajo** el proveedor `12px; #7A6873` | `fw-semibold` + `<small class="d-block text-gris">` |
| Estado | insignia **en MAYÚSCULAS** con borde | `badge text-uppercase border` + color |
| Sugerido | `font-weight:700; color:#741B3D` | `fw-bold text-vino` |

Regla del estado: stock = 0 → **SIN STOCK** (rojo) · stock < mínimo → **BAJO MÍNIMO** (ámbar) · stock > máximo → **SOBRE MÁXIMO** (azul) · si no → **OK** (verde). Sugerido = máximo − stock − en camino (mínimo 0).
| Insumo (proveedor) | Estado | Stock | En camino | Mín. | Máx. | Sugerido |
|---|---|---|---|---|---|---|
| Harina de trigo (Molinos Andinos S.A.S.) | BAJO MÍNIMO | 12.000 g | 0 g | 30.000 | 90.000 | **78.000 g** |
| Levadura (Molinos Andinos S.A.S.) | OK | 2.600 g | 0 g | 2.000 | 6.000 | **3.400 g** |
| Leche entera (Lácteos La Sabana) | SIN STOCK | 0 ml | 10.000 ml | 20.000 | 60.000 | **50.000 ml** |
| Huevos (Lácteos La Sabana) | SOBRE MÁXIMO | 410 und | 0 und | 120 | 360 | **0 und** |

## 6.4 PESTAÑA 2 — PROVEEDORES
Tarjeta "**Proveedores**" con botón principal "**+ Nuevo proveedor**" debajo del título. Tabla: **NIT · Nombre · Correo · Teléfono · Estado · Insumos que ofrece**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-weight:600` | `fw-semibold` |
| Correo vacío | texto "Sin correo" `12px; #7A6873` | `small text-gris` |
| Estado | Activo (verde) / Inactivo (gris) | `badge …` |
| Insumos que ofrece | `14px`, **uno por renglón**: "Harina de trigo · $ 4 / g" | `d-block` por línea |
| Dinero | pesos sin decimales con punto de miles: `$ 4.200` | — |
| NIT | Nombre | Correo | Teléfono | Estado | Insumos |
|---|---|---|---|---|---|
| 900.234.110-8 | Molinos Andinos S.A.S. | pedidos@molinosandinos.co | 601 555 0130 | Activo | Harina de trigo · $ 4 / g · Levadura · $ 18 / g |
| 901.880.221-2 | Lácteos La Sabana | *Sin correo* | 601 555 0220 | Activo | Leche entera · $ 5 / ml · Huevos · $ 620 / und |
| 800.115.900-4 | Empaques del Café | ventas@empaques.co | 601 555 0310 | Inactivo | — |

## 6.5 PESTAÑA 3 — INSUMOS
Tarjeta "**Catálogo de insumos**" + botón "**+ Nuevo insumo**". Tabla: **Nombre · Unidad · Stock mínimo · Stock máximo · 🔒 Costo de la última compra (calculado) · Estado**. El título de la 5.ª columna lleva un candado de 12 px con 4 px de separación (CSS `display:inline-flex; gap:4px` · Bootstrap `d-inline-flex gap-1`).
| Nombre | Unidad | Mínimo | Máximo | Costo | Estado |
|---|---|---|---|---|---|
| Harina de trigo | g | 30.000 | 90.000 | $ 4 / g | Activo |
| Levadura | g | 2.000 | 6.000 | $ 18 / g | Activo |
| Leche entera | ml | 20.000 | 60.000 | $ 5 / ml | Activo |
| Huevos | und | 120 | 360 | $ 620 / und | Activo |

## 6.6 PESTAÑA 4 — ÓRDENES
Tarjeta "**Órdenes de compra**", cuerpo en columna con `gap:16px`.
**a) Filtros (Patrón D)**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px; grid-template-columns:1fr` y desde 768 px `1fr 220px 240px`; campos 40 px | `row g-2` + `col-12 col-md` / `col-md-auto` (220/240 ✖) |
| Buscador | "Buscar número o proveedor…" | `form-control` |
| Lista 1 | "Todos los estados" (Borrador, Enviada, Pendiente de factura, Facturada, Cancelada, Rechazada) | `form-select` |
| Lista 2 | "Todos los proveedores" | `form-select` |

**b) Tabla:** **Número · Proveedor · Fecha · Estado · Total calculado · Acciones**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Número | monoespaciada, `font-weight:700` | `font-monospace fw-bold` ✔ |
| Total | `font-weight:700` | `fw-bold` |
| Acciones (solo si es Borrador) | `display:flex; gap:8px`: "Enviar orden" (principal pequeño) y "Cancelar orden" (contorno pequeño) | `d-flex gap-2` + `btn btn-primary btn-sm` / `btn btn-outline-secondary btn-sm` ✔ |
| Colores de estado | Borrador gris · Enviada azul · Pendiente de factura ámbar · Facturada verde · Cancelada rojo · Rechazada rojo fuerte | |
| Número | Proveedor | Fecha | Estado | Total |
|---|---|---|---|---|
| OC-2026-0041 | Molinos Andinos S.A.S. | 28/06/2026 | Borrador | $ 327.600 |
| OC-2026-0040 | Lácteos La Sabana | 27/06/2026 | Enviada | $ 314.400 |
| OC-2026-0039 | Molinos Andinos S.A.S. | 26/06/2026 | Pendiente de factura | $ 45.000 |

## 6.7 PESTAÑA 5 — RECEPCIÓN
Tarjeta "**Recepción de pedidos**", subtítulo "**Órdenes enviadas de Coffee Park Centro.**" Tabla: **Número · Proveedor · Fecha · Líneas · Estado · (sin título)**. Muestra órdenes Enviada, Pendiente de factura o Rechazada.
| Última celda | CSS | Bootstrap |
|---|---|---|
| Si la orden está **Enviada** | botón pequeño de contorno "📦 Revisar líneas" (abre la ventana Recepción) | `btn btn-outline-secondary btn-sm` + `data-bs-toggle="modal"` |
| Si no | texto `12px; #7A6873`: "{recibidoPor} · {fecha}" | `small text-gris` |
| Número | Proveedor | Fecha | Líneas | Estado | Última celda |
|---|---|---|---|---|---|
| OC-2026-0040 | Lácteos La Sabana | 27/06/2026 | 2 | Enviada | Revisar líneas |
| OC-2026-0039 | Molinos Andinos S.A.S. | 26/06/2026 | 1 | Pendiente de factura | María Gómez · 27/06/2026 09:42 |

## 6.8 PESTAÑA 6 — FACTURACIÓN
Tarjeta "**Órdenes pendientes de factura**". Tabla: **Número · Proveedor · Sede · Fecha de recepción · Total recibido · (botón)**. Fila: OC-2026-0039 · Molinos Andinos S.A.S. · Coffee Park Centro · 27/06/2026 09:42 · **$ 45.000** · botón pequeño de contorno "📄 Marcar como facturada". Si ya está facturada, el botón se cambia por una insignia verde "Facturada".

## 6.9 Ventanas de Compras
| Ventana | Título | Ancho máx. (desde 640 px) | CSS | Bootstrap |
|---|---|---|---|---|
| Crear orden | "Crear orden de compra" | **896 px** | `max-width:896px` | `modal-xl` ≈ (1140) → `style="max-width:896px"` |
| Enviar orden | "Enviar orden OC-2026-0041" | **672 px** | `max-width:672px` | `style="max-width:672px"` |
| Recepción | "Recepción OC-2026-0040" | **768 px** | `max-width:768px` | `modal-lg` ≈ (800) |
| Confirmar facturación | "Confirmar facturación" | **512 px** | `max-width:512px` | default ≈ (500) |
| Nuevo proveedor | "Nuevo proveedor" | **512 px** | | default ≈ |
| Nuevo insumo | "Nuevo insumo" | **512 px** | | default ≈ |

**Crear orden de compra** (de arriba a abajo):
1. **Tarjeta de datos:** relleno 16 px (24 abajo); grilla de **3 columnas desde 768 px**, gap 16: *Proveedor* (lista, solo activos) · *Creador 🔒* (campo desactivado "Laura Martínez") · *Sede 🔒* (campo desactivado "Coffee Park Centro"). Etiqueta con candado: fila, `gap:4px`. Bootstrap: `row g-3` + `col-12 col-md-4`; campo desactivado `form-control` con `disabled`.
2. **Líneas:** fila `space-between`: título "**Líneas**" (16 px/700) a la izquierda y botón pequeño de contorno "**+ Agregar línea**" a la derecha. **Cada línea** es una caja: borde, esquinas 16 px, relleno 12 px, `gap:12px`, con grilla de **4 columnas `1.2fr .8fr .8fr .8fr`** desde 768 px (Bootstrap `border rounded-4 p-3` + `row g-3` y `col-md-3`/`col-md`): *Insumo* (lista) · *Cantidad pedida* (número) · *Precio pactado* (número) · *Subtotal 🔒* (desactivado, en pesos).
   Si `stock + en camino + cantidad > máximo`: caja con borde `#FFA2A2` y fondo `rgba(254,242,242,.5)` y abajo (las 4 columnas) error `12px; font-weight:500; #E7000B`: "Supera el stock máximo de este insumo (stock + en camino + pedido)".
3. **Pie:** **Cancelar** (contorno) y **Guardar borrador** (principal).

**Enviar orden** — una **hoja de papel**: CSS `background:#fff; border:1px solid …; border-radius:16px; padding:24px; box-shadow:0 1px 3px rgba(0,0,0,.1)` · Bootstrap `border rounded-4 p-4 bg-white shadow-sm` ✔. Dentro: arriba-izquierda "**Coffee Park**" (`20px; 900; #741B3D`) y debajo "Orden de compra" (14 px); arriba-derecha el número en monoespaciada 700; línea inferior; "**Proveedor:** …" y "**Sede:** …" (14 px); tabla **Insumo · Cantidad · Precio · Subtotal**; abajo a la derecha "**Total: $ 327.600**" (`20px; 900`). Debajo, grilla de 2 columnas (desde 640 px) con dos botones de **48 px**: "✉ Enviar por correo automático" (principal; **desactivado** si el proveedor no tiene correo, con ayuda "El proveedor no tiene correo registrado") y "⬇ Descargar PDF para enviar manualmente" (contorno). Bootstrap: `row g-2` + `col-sm-6` + `btn btn-lg w-100 fs-6`.

**Recepción** — por cada línea una caja (borde, esquinas 16 px, relleno 16 px; ya revisada: fondo `rgba(240,253,244,.4)`). Fila `space-between`: izquierda nombre (700) y "Cantidad pedida: N" (14 px gris); derecha campo numérico de **144 px** de ancho (ejemplo "Recibida", desactivado hasta revisar). Debajo 3 botones pequeños con `gap:8px`: "**Llegó completo**" (principal), "**Llegó parcial**" (contorno), "**No llegó**" (contorno, letra `#C10007`). Si todas están revisadas aparece una franja `#EFF6FF`, esquinas 16, relleno 12, `14px; 600; #193CB8`: "Orden en Pendiente de factura" (o "Orden Rechazada: no llegó nada"). Pie: **Cerrar** y **Finalizar recepción** (desactivado hasta revisar todas).

**Confirmar facturación** — texto `14px; #7A6873`: "¿Desea marcar la orden **OC-2026-0039** como facturada? Este cambio quedará registrado." Pie: Cancelar / Confirmar.
**Nuevo proveedor** — `gap:12px` entre bloques: Nit · Nombre · Correo (opcional; ayuda `12px` gris "Sin correo, la orden solo puede enviarse como PDF manual.") · Teléfono · Estado (Activo/Inactivo). Pie: Cancelar / Guardar.
**Nuevo insumo** — Nombre · Unidad de medida (g / ml / und) · Stock mínimo · Stock máximo (si es menor que el mínimo: error `12px; #E7000B` "El máximo no puede ser menor que el mínimo." y se desactiva Guardar) · Estado.

**Revisión Compras:** [ ] menú "Compras" en coral · [ ] botón "Nueva orden" de 44 px a la derecha del título (desde 640 px) · [ ] 6 pestañas, la elegida se distingue · [ ] 4 tarjetas de color en 4 columnas desde 768 px · [ ] insignias con borde (BAJO MÍNIMO ámbar, SIN STOCK rojo, OK verde, SOBRE MÁXIMO azul) · [ ] en cada tarjeta el botón queda **debajo** del título · [ ] números de orden en monoespaciada, totales en negrita.

---

<a id="vista-7"></a>
# 7. VISTA PRODUCCIÓN Y TRASLADOS

**Qué es:** "la cocina": dices cuántos panes hiciste, el sistema calcula los ingredientes gastados y puedes enviar panes a otras sedes (traslados). **4 pestañas.** **Quién entra:** administrador, gerente, cocinero. **Menú activo:** Producción. **Barra:** "PRODUCCIÓN". Usa el [Marco](#marco).

```
Producción y traslados                         [+ Nuevo producto]
Recetas, consumos e inventario de producto terminado.
[Registrar producción][Productos y recetas][Inventario terminado][Traslados]
┌─ 👨‍🍳 Nueva producción ─┐ ┌─ Consumo de insumos (calculado en vivo) ─┐
│ Producto  [lista]      │ │ [Harina de trigo   850 g  ✔ Suficiente] │
│ Cantidad  [10]         │ │ [Mantequilla       320 g  ✔ Suficiente] │
│ [   Registrar   ]      │ └─────────────────────────────────────────┘
└────────────────────────┘
┌─ Histórico de producciones ────────────────────────────┐
```

## 7.1 Encabezado (Patrón A)
Igual que 6.1 con: título "**Producción y traslados**", descripción "**Recetas, consumos e inventario de producto terminado.**" y botón principal **de 36 px (tamaño normal)** "**+ Nuevo producto**" (aquí NO es de 44). Bootstrap: `btn btn-primary` ≈ (38 px).

## 7.2 Pestañas (4)
**Registrar producción · Productos y recetas · Inventario terminado · Traslados.** Abierta: la primera. Contenido a 20 px. (Pieza Pestañas de 0.1.)

## 7.3 PESTAÑA 1 — REGISTRAR PRODUCCIÓN (bloques con 20 px: `gap:20px` · `gap-4` ≈)

### 7.3.1 Fila de dos tarjetas
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px `.8fr 1.2fr`** (la derecha más ancha) | `row g-4` + `col-12 col-lg-5` y `col-12 col-lg-7` ≈ (40/60) |

**Tarjeta "Nueva producción"** — el título lleva un gorro de cocinero (24 px, `#741B3D`, `gap:8px`). Cuerpo con `gap:16px`:
| Pieza | CSS | Bootstrap |
|---|---|---|
| *Producto* | etiqueta + lista de **44 px** con los productos activos (etiqueta pegada, 6 px) | `form-label` + `form-select` (44 ✖) |
| *Cantidad producida* | campo numérico de **44 px**, mínimo 1, valor inicial **10** | `form-control` (44 ✖) |
| Aviso rojo (solo si no alcanza el stock) | aviso rojo de 0.1: "Stock insuficiente de insumos en la sede para esta producción" con icono de 20 px | `alert alert-danger d-flex gap-2` |
| Botón "Registrar" | principal, **48 px**, ancho completo; **desactivado** si no se puede producir | `btn btn-primary btn-lg w-100 fs-6` + `disabled` |
| Nota | `12px; #7A6873`: "Sede automática: Planta de producción" | `small text-gris` |

**Tarjeta "Consumo de insumos"** — título + "(calculado en vivo)" (`12px; font-weight:400; #7A6873; margin-left:4px`). Cuerpo con `gap:12px`. **Cada fila de insumo:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:center; border:1px solid; border-radius:16px; padding:16px` | `d-flex justify-content-between align-items-center border rounded-4 p-3` ✔ |
| Izquierda | nombre `font-weight:700` y debajo "Stock disponible: N unidad" `12px` gris | `fw-bold` + `small text-gris d-block` |
| Derecha (alineada a la derecha) | "N unidad" `font-weight:900` y debajo `12px; 600` con icono 16 px: **Suficiente** (círculo con check, `#008236`) o **Insuficiente** (círculo con X, `#C10007`) | `text-end fw-black` + `small fw-semibold` |
| Fila suficiente | borde `#B9F8CF`, fondo `rgba(240,253,244,.5)` | `border-success-subtle bg-success-subtle` ≈ |
| Fila insuficiente | borde `#FFC9C9`, fondo `#FEF2F2` | `border-danger-subtle bg-danger-subtle` ≈ |
Datos (Croissant × 10): Harina de trigo **850 g** (stock 42.000 g) · Mantequilla **320 g** (stock 12.500 g) · Leche entera **220 ml** (stock 32.000 ml): las tres suficientes.

### 7.3.2 Tarjeta "Histórico de producciones" (ancho completo)
Tabla **Producto · Cantidad · Usuario · Fecha**: *Pan de queso · 48 und · Juan Panadero · 30/06/2026 06:45*. Debajo (margen 12 px) nota `12px` gris: "*Las producciones registradas no se editan ni se eliminan.*"

## 7.4 PESTAÑA 2 — PRODUCTOS Y RECETAS
Tarjeta "**Productos**"; tabla **Nombre · Precio de venta · % IVA · 🔒 Costo de receta (calculado) · Estado · Receta**. Nombre en `700`. "Ver receta" = botón pequeño de contorno (abre la ventana de receta).
| Nombre | Precio | IVA | Costo | Estado | Receta |
|---|---|---|---|---|---|
| Croissant de mantequilla | $ 6.500 | 19% | $ 1.840 | Activo | Ver receta |
| Pan de queso | $ 4.800 | 0% | $ 1.420 | Activo | Ver receta |
| Torta de chocolate | $ 8.200 | 19% | $ 2.900 | Activo | Ver receta |

## 7.5 PESTAÑA 3 — INVENTARIO TERMINADO
Tarjeta "**Inventario de producto terminado**" + subtítulo "**Solo consulta. Se actualiza con producciones, traslados y pedidos.**" Tabla **Sede · Producto · Stock actual** (stock en `font-weight:900`, "128 und"): Planta de producción · Croissant de mantequilla · 128 — Planta de producción · Pan de queso · 94 — Coffee Park Centro · Croissant de mantequilla · 24 — Coffee Park Norte · Pan de queso · 18.

## 7.6 PESTAÑA 4 — TRASLADOS
Tarjeta "**Traslados**" + subtítulo "**Planta de producción hacia puntos de venta.**" + botón "**+ Crear traslado**". Tabla **Número · Origen · Destino · Estado · Envía / recibe · Fechas · Acciones**.
| Columna | CSS | Bootstrap |
|---|---|---|
| Número | monoespaciada 700 | `font-monospace fw-bold` |
| Estado | Pendiente ámbar · En tránsito azul · Recibido verde · Cancelado rojo | `badge …` |
| Envía / recibe | nombre y debajo (12 px gris) quien recibe o "Pendiente de recepción" | `small d-block text-gris` |
| Fechas | `12px`; "Sin despacho" si no hay | `small` |
| Acciones | Pendiente → "Despachar" (principal pequeño) + "Cancelar" (contorno pequeño); En tránsito → "Recibir" (contorno pequeño) | `btn btn-sm` |
| Número | Origen | Destino | Estado | Envía / recibe | Fechas |
|---|---|---|---|---|---|
| TR-2026-0088 | Planta de producción | Coffee Park Centro | En tránsito | Juan Panadero / Pendiente de recepción | 30/06/2026 08:20 |
| TR-2026-0087 | Planta de producción | Coffee Park Norte | Recibido | Juan Panadero / Diana Torres | 29/06/2026 07:55 · 29/06/2026 09:10 |

## 7.7 Ventanas de Producción
- **Nuevo producto** (512 px): Nombre · Precio de venta · Porcentaje de IVA (inicial 19) · Estado.
- **Receta · {producto}** (672 px): si ya se usó, aviso ámbar con candado "*Una receta que ya se usó en producciones no se modifica; cree otro producto o desactive este.*"; tabla **Insumo · Cantidad para 1 unidad · Unidad**; botón de contorno "**+ Agregar insumo**" (desactivado si ya se usó); pie: **Cerrar** (principal).
- **Crear traslado** (672 px): *Sede destino* (lista: Coffee Park Centro, Norte, Occidente, Sur) con nota `12px` "*Origen automático: Planta de producción*"; por cada producto una caja (borde, esquinas 16 px, relleno 12 px, 2 columnas desde 768 px) con *Producto* (+ "Disponible: N und" 12 px) y *Cantidad* (+ error `12px; #E7000B` "*Stock insuficiente en origen.*"); botón de contorno "**+ Agregar producto**"; pie: Cancelar / **Guardar traslado**.

**Revisión Producción:** [ ] botón "Nuevo producto" de 36 px · [ ] 4 pestañas · [ ] dos tarjetas lado a lado desde 1024 (la derecha más ancha) · [ ] campos 44, botón Registrar 48 · [ ] 3 filas de consumo con borde verde claro y "✔ Suficiente".

---
<a id="vista-8"></a>
# 8. VISTA DOMICILIOS

**Qué es:** un tablero con **5 cajones** (como un archivador): Pendiente → Aceptado → En preparación → Despachado → Entregado. Cada pedido es una tarjetita. Tiene 3 pestañas. **Quién entra:** administrador, gerente, cajera, mesero. **Menú activo:** Domicilios. **Barra:** "DOMICILIOS". Usa el [Marco](#marco).

```
Domicilios
Pedidos, asignación automática y prefacturación para ICG.
[Tablero de pedidos][Carga de repartidores][Ventas por día]
┌Pendiente─┐┌Aceptado──┐┌En prepar.┐┌Despachado┐┌Entregado─┐
│● 1       ││● 1       ││● 1       ││● 1       ││● 1       │
│ [tarjeta]││ [tarjeta]││ [tarjeta]││ [tarjeta]││ [tarjeta]│
└──────────┘└──────────┘└──────────┘└──────────┘└──────────┘
```

## 8.1 Encabezado (sin botón)
Título "**Domicilios**" (`30px/36px; 900; #350B1A`) · descripción "**Pedidos, asignación automática y prefacturación para ICG.**" (`14px; #7A6873; margin-top:4px`). Bootstrap: `h1 fw-black text-vino-oscuro` / `small text-gris mt-1`.

## 8.2 Pestañas (3)
**Tablero de pedidos · Carga de repartidores · Ventas por día.** Abierta: Tablero. Contenido a 20 px. Bootstrap: `nav nav-pills nav-fill` + `data-bs-toggle="pill"`.

## 8.3 PESTAÑA 1 — TABLERO DE PEDIDOS

### 8.3.1 Contenedor del tablero (deslizable)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `width:100%; overflow-x:auto; padding-bottom:16px` | `w-100 overflow-x-auto pb-3` ✔ |

### 8.3.2 El tablero (5 columnas)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Columnas | `display:grid; grid-template-columns:repeat(5,1fr); gap:12px; min-width:1160px` (si la pantalla es más angosta el tablero se desliza) | `row row-cols-5 g-2 flex-nowrap` + `style="min-width:1160px"` ≈ (g-2 = 8) |

### 8.3.3 Cada cajón (columna)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `min-height:520px; background:rgba(255,255,255,.65); border-radius:16px; padding:12px` | `col rounded-4 p-2` ≈ + `min-height:520px` ✖ + fondo ✖ |
| **Encabezado del cajón** — acomodo | `display:flex; align-items:center; gap:8px; margin-bottom:12px` | `d-flex align-items-center gap-2 mb-2` ✔ |
| Punto de color | `width:10px; height:10px; border-radius:50%` | `rounded-circle` + 10 px ✖ |
| Nombre | `font-size:14px; line-height:20px; font-weight:900; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; flex:1` | `fw-black small text-truncate flex-grow-1` ✔ |
| Contador (a la derecha) | etiqueta de contorno: `border:1px solid; background:transparent; color:#321525; font-size:12px` | `badge border text-body bg-transparent` |
| Tarjetas dentro | `display:flex; flex-direction:column; gap:12px` | `d-flex flex-column gap-2` ✔ |

**Colores de los puntos:** Pendiente `#FFB900` · Aceptado `#50A2FF` · En preparación `#F27C86` · Despachado `#C27AFF` · Entregado `#00C950`.

**Cajón vacío:**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `border:1px dashed rgba(116,27,61,.14); border-radius:16px; padding:24px; text-align:center; font-size:12px; color:#7A6873` — texto "Sin pedidos en este estado" | `border rounded-4 p-4 text-center small text-gris` + `style="border-style:dashed"` ✔ |

### 8.3.4 Cada tarjeta de pedido (de arriba a abajo)
**Caja de la tarjeta:** CSS `background:#fff; border:1px solid …; border-radius:12px; box-shadow:0 1px 3px rgba(0,0,0,.1); overflow:hidden; padding:16px 16px 24px` · Bootstrap `card shadow-sm` > `card-body p-3`.
| N.º | Pieza | CSS | Bootstrap |
|---|---|---|---|
| 1 | Número `#0047` | `font-family:monospace; font-size:14px; font-weight:900; color:#741B3D` | `font-monospace fw-black small text-vino` |
| 2 | Insignia de estado (debajo del número; columna con `gap:8px`) | pieza Insignia con los colores de abajo | `badge border` |
| 3 | Nombre del cliente | `margin-top:8px; font-size:14px; font-weight:700` | `mt-2 small fw-bold` |
| 4 | Dirección | `margin-top:4px; font-size:12px; color:#7A6873`; pin 📍 de 12 px; **máximo 2 renglones** (`-webkit-line-clamp:2`) | `mt-1 small text-gris` + line-clamp ✖ |
| 5 | Pie de la tarjeta | `margin-top:12px; border-top:1px solid …; padding-top:12px; display:flex; justify-content:space-between` — izquierda **hora** (12 px gris), derecha **total** (`$`, 14 px, 900) | `d-flex justify-content-between border-top pt-3 mt-3 small` |
| 6 | Repartidor (solo si ya tiene) | `margin-top:8px; background:#FAF5FF; border-radius:12px; padding:8px; font-size:12px; font-weight:600; color:#8200DB`; moto 🏍 de 12 px | `rounded-3 p-2 small fw-semibold mt-2` + colores ✖ (esquinas 12 ✖) |
| 7 | Botones | `margin-top:12px; display:flex; flex-direction:column; gap:8px`; **todos de 32 px y ancho 100 %** | `d-grid gap-2 mt-3` + `btn btn-sm` ✔ |

**Colores de la insignia de estado (fondo / letra):** Pendiente `#FFFBEB`/`#973C00` · Aceptado `#EFF6FF`/`#1447E6` · En preparación `#FDF2F8`/`#741B3D` · Despachado `#FAF5FF`/`#8200DB` · Entregado `#F0FDF4`/`#008236` · Cancelado `#FEF2F2`/`#C10007`.

**Botones de la tarjeta:**
1. **Botón de avance** (principal): Pendiente → "**Aceptar pedido**" · Aceptado → "**Pasar a preparación**" · En preparación → "**Despachar**" · Despachado → "**Marcar entregado**" · Entregado / Cancelado → ninguno.
2. "**Detalle**" (contorno, letra 12 px, centrado) y, si el estado es Aceptado, En preparación, Despachado o Entregado, "**Prefactura**" (igual), en columna con 8 px.
3. "**Cancelar**" (fantasma, letra `#C10007`, ancho 100 %) si el estado **no** es Entregado ni Cancelado.

**Pedidos cancelados** (solo si existe alguno): tarjeta con `margin-top:16px`; título "**Pedidos cancelados**" (16 px); cuerpo en fila con salto de línea y `gap:8px` con insignias rojas "{número} · {cliente}". Bootstrap: `d-flex flex-wrap gap-2` + `badge`.

> Datos de ejemplo (el prototipo trae 5–8 pedidos con este formato): `#0047 · Juan Pérez · Calle 10 #23-45, Apto 301 · 10:30 · $ 23.500` (invéntalos tú; no vienen en el diseño).

## 8.4 PESTAÑA 2 — CARGA DE REPARTIDORES
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **3 desde 768 px** | `row g-3` + `col-12 col-md-4` ✔ |
| Tarjeta | relleno 20 px (24 abajo) | `card` > `card-body` |

**Dentro de cada tarjeta de repartidor:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Fila de arriba | `display:flex; justify-content:space-between` | `d-flex justify-content-between` |
| Círculo con moto | `width:48px; height:48px; border-radius:50%; background:#FCE8EA`; moto de 24 px `#741B3D` | `rounded-circle bg-acento` + 48 ✖ |
| Insignia (derecha) | "Disponible" (verde) o "No disponible" (rojo) | `badge …` |
| Nombre | `margin-top:16px; font-size:18px; line-height:28px; font-weight:900` | `mt-3 fw-black` + 18 ✖ |
| "Pedidos en camino" | `14px; #7A6873` | `small text-gris` |
| Número | `margin-top:8px; font-size:36px; line-height:40px; font-weight:900; color:#741B3D` | `mt-2 fw-black text-vino` + 36 ✖ |
| Cajitas de pedidos (si tiene) | `background:#F2EEF1; border-radius:12px; padding:8px; font-size:12px; margin-top:8px`: "{número} · {cliente}" | `bg-campo rounded-3 p-2 small mt-2` |
| Datos | Carlos Pérez **0** · Luisa Moreno **1** · Mateo Ruiz **2** | |

## 8.5 PESTAÑA 3 — VENTAS POR DÍA
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:20px`; 1 columna en celular; desde 1024 px **`1fr 1.1fr`** | `row g-4` + `col-12 col-lg-5` y `col-12 col-lg-7` ≈ |

**Tarjeta "Total por día"** (título con icono de gráfico de 24 px `#741B3D`) — **gráfico de barras hecho con cajas:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Contenedor | `height:256px; display:flex; align-items:flex-end; gap:16px; padding:16px; border-left:1px solid …; border-bottom:1px solid …` | `d-flex align-items-end gap-3 p-3 border-start border-bottom` + `style="height:256px"` ✔ |
| Cada día | columna centrada abajo, `gap:8px`: arriba el total (10 px, 600), la **barra**, debajo la fecha `dd/mm` (10 px gris) | `d-flex flex-column align-items-center gap-2` |
| La barra | `width:100%; max-width:56px; border-radius:12px 12px 0 0; background:#741B3D; height:{total ÷ 12000}px` (redondeado) | `w-100 bg-vino` + `rounded-top-4` ≈ (16) + `style="height:66px;max-width:56px"` ✖ |

**Tarjeta "Detalle de ventas":** tabla **Fecha · Sede · N.º prefacturas · Subtotal · IVA · Total** (Total `font-weight:700`) y debajo (margen 12 px) nota `12px` gris "*Solo incluye pedidos no cancelados.*"
| Fecha | Sede | N.º | Subtotal | IVA | Total | Alto de barra |
|---|---|---|---|---|---|---|
| 24/06/2026 | Coffee Park Centro | 22 | $ 710.000 | $ 82.000 | $ 792.000 | 66 px |
| 25/06/2026 | Coffee Park Centro | 28 | $ 890.000 | $ 103.000 | $ 993.000 | 83 px |
| 26/06/2026 | Coffee Park Norte | 19 | $ 603.000 | $ 71.000 | $ 674.000 | 56 px |
| 27/06/2026 | Coffee Park Centro | 34 | $ 1.050.000 | $ 121.000 | $ 1.171.000 | 98 px |

## 8.6 Ventanas de Domicilios
- **Detalle del pedido {n}** (672 px, alto máx. 92 %), cuerpo `gap:20px`: (a) fila: insignia de estado a la izquierda y fecha (14 px gris) a la derecha; (b) caja `#F2EEF1`, esquinas 16, relleno 16, grilla de **2 columnas desde 640 px**, gap 12: **Cliente**, **Método de pago**, **Dirección** (ocupa 2); cada dato: etiqueta `12px` gris + valor `700`; (c) tabla **Producto · Cantidad · Precio · % IVA**; (d) línea superior, relleno 16, 2 columnas, 14 px: **Aceptó:** nombre + fecha · **Repartidor:** nombre, "Despacho: …", "Entrega: …" (o "Pendiente" / "Sin asignar"). Pie: **Cerrar**.
- **Prefactura para ICG** (768 px, alto máx. 94 %): una **hoja** (borde, esquinas 16, fondo blanco, relleno 24). Cabecera con línea inferior y relleno abajo 16: izquierda "**Coffee Park**" (`24px/32px; 900; #741B3D`) y "Prefactura" (14 px); derecha (alineada a la derecha) el número en monoespaciada 900 y "Coffee Park Centro · {fecha}" (12 px). Datos (2 columnas, gap 8, 14 px, relleno vertical 16): **Cliente**, **Documento:** CC 1.032.445.512, **Dirección**, **Método de pago**. Tabla **Producto · Cant. · Precio · Subtotal · IVA · Total** (precio base = precio ÷ 1,19). Resumen: caja de **256 px** de ancho alineada a la derecha (`margin-left:auto`), margen arriba 20, filas `space-between` (14 px): **Subtotal**, **IVA** y **Total** (con línea superior, relleno arriba 8, 18 px). Pie: "**Imprimir**" (contorno) y "**Exportar para ICG**" (principal).
- **Cancelar pedido** (512 px): texto `14px; #7A6873` "*Se liberará el stock reservado y se anulará la prefactura de {número}.*"; pie: **Volver** (contorno) y **Confirmar cancelación** (fondo `#D4183D`, letra blanca; Bootstrap `btn btn-danger` ≈).

**Revisión Domicilios:** [ ] 5 cajones con punto de color · [ ] el tablero se desliza si la pantalla es angosta · [ ] los botones cambian según el cajón · [ ] cajón vacío con borde punteado · [ ] barras del gráfico suben según el total.

---

<a id="vista-9"></a>
# 9. VISTA MENÚ DEL CLIENTE

**Qué es:** la vitrina de la panadería: un cartel vino "¿Qué quieres pedir hoy?", un buscador, botones redondos de categorías y **tarjetas con foto, nombre y precio**. Al elegir algo flota abajo un botón "Ver carrito". **Quién entra:** cliente (con o sin cuenta). **Marco:** el mismo, pero el menú lateral solo tiene "Menú" y "Mis pedidos" (el invitado solo "Menú"). **Menú activo:** Menú. **Barra:** "MENÚ" / "Pedidos a domicilio" (o "Explorando como invitado").

```
┌─ CARTEL vino ───────────────────────────────┐
│ COFFEE PARK                              ○  │
│ ¿Qué quieres pedir hoy?                     │
│ 🕒 Entrega estimada: 30–45 minutos          │
└─────────────────────────────────────────────┘
[🔍 Buscar productos…                          ]
(Todo)(Bebidas)(Panadería)(Almuerzos)(Ensaladas)(Postres)
Nuestro menú                                  ☕
8 productos disponibles
┌[foto]┬texto──────┐ ┌[foto]┬texto──────┐ ┌[foto]┬…
                                   [ 🛒 Ver carrito   $ 14.500 ] ← flotante
```
Todo en una columna: CSS `display:flex; flex-direction:column; gap:20px; padding-bottom:80px` (para que el botón flotante no tape nada) · Bootstrap `d-flex flex-column gap-4` ≈ + `padding-bottom:80px` ✖.

## 9.1 Cartel
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#350B1A; color:#fff; border-radius:24px; padding:20px; box-shadow:0 10px 15px -3px rgba(0,0,0,.1); position:relative; overflow:hidden` | `position-relative overflow-hidden text-white bg-vino-oscuro shadow-lg` + `p-4` (24 ≈ 20) + esquinas 24 ✖ `style="border-radius:24px"` |
| **Bola decorativa** (arriba a la derecha) | `position:absolute; top:-48px; right:-48px; width:144px; height:144px; border-radius:50%; background:rgba(242,124,134,.2)` | `position-absolute rounded-circle` + resto ✖ |
| "COFFEE PARK" | `font-size:12px; line-height:16px; font-weight:700; text-transform:uppercase; letter-spacing:.18em; color:#F27C86` | `small fw-bold text-uppercase text-coral` + espaciado ✖ |
| Título "¿Qué quieres pedir hoy?" | `font-size:30px; font-weight:900; line-height:1.25; margin-top:8px` | `fw-black lh-sm mt-2` + 30 ✖ |
| Línea de entrega | `margin-top:16px; display:flex; align-items:center; gap:8px; font-size:12px; color:rgba(255,255,255,.7)`; reloj 🕒 de 16 px + "Entrega estimada: 30–45 minutos" | `d-flex align-items-center gap-2 mt-3 small text-white opacity-75` |

## 9.2 Buscador
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `position:relative` | `position-relative` ✔ |
| **Lupa (cómo ponerla dentro del campo)** | `position:absolute; left:16px; top:50%; transform:translateY(-50%); width:16px; color:#7A6873; pointer-events:none` | `position-absolute top-50 translate-middle-y ms-3 pe-none text-gris` ✔ |
| Campo | `height:48px; width:100%; border-radius:16px; background:#fff; padding-left:44px; box-shadow:0 1px 3px rgba(0,0,0,.1)`; placeholder "Buscar productos..." | `form-control form-control-lg rounded-4 border-0 shadow-sm ps-5 fs-6` (ps-5 = 48 ≈ 44) |

## 9.3 Categorías (botones redondos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fila deslizable | `display:flex; gap:8px; overflow-x:auto; margin:0 -16px; padding:0 16px 4px` | `d-flex gap-2 overflow-x-auto pb-1` ✔ |
| Cada botón (píldora) | `min-height:44px; padding:0 16px; border-radius:9999px; font-size:14px; font-weight:700` | `btn rounded-pill fw-bold small` ✔ (44 ≈) |
| **Elegido** | fondo `#741B3D`, letra blanca, `box-shadow:0 1px 3px rgba(0,0,0,.1)` | `btn-primary shadow-sm` ✔ |
| Normal | fondo blanco, borde 1 px, letra `#7A6873` | `btn-light border text-gris` |
| Textos | **Todo · Bebidas · Panadería · Almuerzos · Ensaladas · Postres** | |

## 9.4 Título de la lista
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:flex-end` | `d-flex justify-content-between align-items-end` ✔ |
| Izquierda | "**Nuestro menú**" (o el nombre de la categoría) `20px/28px; 900` y debajo "**{n} productos disponibles**" `12px` gris | `h2 fw-black fs-5` ✔ + `small text-gris` |
| Derecha | icono de taza 20 px `#F27C86` | `text-coral` |

## 9.5 Tarjetas de producto
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; **1 columna**; **2 desde 768 px**; **3 desde 1280 px** | `row g-3` + `col-12 col-md-6 col-xl-4` ✔ (xl = 1200 ≈ 1280) |
| **Cada tarjeta** | `display:grid; grid-template-columns:116px 1fr; min-height:136px; overflow:hidden; background:#fff; border:1px solid …; border-radius:16px; box-shadow:0 1px 3px rgba(0,0,0,.1)`; no disponible: `opacity:.6` | `d-grid border rounded-4 shadow-sm bg-white overflow-hidden` + `style="grid-template-columns:116px 1fr;min-height:136px"` ✖; `opacity-75` ≈ |

**Columna de la foto (116 px):**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `position:relative` | `position-relative` |
| **Cómo hacer que la foto llene todo** | `<img>` con `position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover` | `position-absolute top-0 start-0 w-100 h-100 object-fit-cover` ✔ |
| Etiqueta "Popular" / "Recomendado" (opcional) | `position:absolute; top:8px; left:8px; background:rgba(255,255,255,.9); color:#741B3D; font-size:10px; box-shadow:…; border-radius:…` | `position-absolute top-0 start-0 m-2 badge bg-white text-vino shadow-sm` + 10 px ✖ |
| Capa "No disponible" (si no hay) | `position:absolute; inset:0; background:rgba(53,11,26,.55); color:#fff; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:700` | `position-absolute top-0 bottom-0 start-0 end-0 d-flex align-items-center justify-content-center text-white small fw-bold` + fondo ✖ |

**Columna de texto:** CSS `padding:12px; display:flex; flex-direction:column` · Bootstrap `d-flex flex-column p-2` (8 ≈ 12; `style="padding:12px"` exacto).
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-size:14px; font-weight:900; white-space:nowrap; overflow:hidden; text-overflow:ellipsis` | `fw-black small text-truncate` ✔ |
| Descripción | `margin-top:4px; font-size:12px; line-height:1.625; color:#7A6873; máximo 2 renglones` | `mt-1 small text-gris` + line-clamp ✖ |
| **Fila inferior (se va al fondo)** | `margin-top:auto; padding-top:8px; display:flex; justify-content:space-between; align-items:flex-end` | `mt-auto pt-2 d-flex justify-content-between align-items-end` ✔ |
| Precio | `font-size:16px; font-weight:900; color:#741B3D` y debajo "IVA incluido" `10px` gris | `fs-6 fw-black text-vino` + `small text-gris` |
| **Botón agregar (+)** | círculo `40px × 40px; border-radius:50%; background:#741B3D`; "+" de 16 px blanco | `btn btn-primary rounded-circle d-flex align-items-center justify-content-center` + `style="width:40px;height:40px"` ✖ |
| **Si ya está en el carrito** | cápsula (borde, fondo `#FCF8F9`, relleno 4 px, `gap:4px`, píldora) con **−** (círculo 32 px, icono 14), cantidad (20 px de ancho, centrada, 14 px, 900) y **+** (círculo 32 px, fondo `#741B3D`) | `d-flex align-items-center gap-1 border rounded-pill p-1 bg-fondo` + círculos ✖ |

| N.º | Nombre | Descripción | Precio | Categoría | Etiqueta | Disponible |
|---|---|---|---|---|---|---|
| 1 | Café americano | Espresso intenso con agua caliente. | $ 5.000 | Bebidas | Popular | sí |
| 2 | Capuchino | Espresso, leche vaporizada y espuma cremosa. | $ 6.500 | Bebidas | — | sí |
| 3 | Croissant | Hojaldrado artesanal de mantequilla. | $ 4.500 | Panadería | Recomendado | sí |
| 4 | Pan de queso | Pan suave relleno de queso doble crema. | $ 3.000 | Panadería | — | sí |
| 5 | Almuerzo ejecutivo | Sopa, plato principal y bebida del día. | $ 18.000 | Almuerzos | — | sí |
| 6 | Ensalada César | Lechuga, pollo, crutones y aderezo César. | $ 12.000 | Ensaladas | — | sí |
| 7 | Cheesecake de maracuyá | Cheesecake cremoso con fruta natural. | $ 8.000 | Postres | — | sí |
| 8 | Brownie con helado | Brownie tibio con helado de vainilla. | $ 9.500 | Postres | — | **no** |

**Fotos:** el prototipo usa fotos de Unsplash (700 × 500 px). Descárgalas tú desde unsplash.com y guárdalas en `img/menu/` (`cafe.jpg`, `panaderia.jpg`, `postre.jpg`, `hojaldre.jpg`, `almuerzo.jpg`): 1-2 → cafe · 3 → hojaldre · 4 → panaderia · 5-6 → almuerzo · 7-8 → postre.

**Sin resultados:** caja con borde punteado (`1px dashed`), esquinas 16, fondo blanco, `padding:56px 0`, centrada: lupa de 32 px gris; "**No encontramos productos**" (`14px; 700; margin-top:12px`); botón de texto "**Limpiar búsqueda**" (`min-height:44px; 14px; 700; #741B3D; margin-top:8px`).

## 9.6 Botón flotante "Ver carrito" (aparece si hay productos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo ponerlo flotando abajo** | `position:fixed; bottom:20px; left:16px; right:16px; z-index:40`; desde 1024 px: `left:auto; right:32px; width:360px` | `position-fixed bottom-0 start-0 end-0 m-3` ✔ (bottom 16 ≈ 20) + en lg `ms-lg-auto` + `style="max-width:360px"` |
| Botón | principal, `height:56px; width:100%; border-radius:16px; padding:0 16px; display:flex; justify-content:space-between; align-items:center; box-shadow:0 10px 35px rgba(53,11,26,.28)` | `btn btn-primary w-100 rounded-4 d-flex justify-content-between align-items-center` + alto 56 ✖ + sombra ✖ |
| Izquierda | burbuja `28px × 28px` (`rgba(255,255,255,.2)`, círculo, 12 px/900) con la cantidad + carrito de 20 px + "Ver carrito" (`gap:8px`) | `rounded-circle` + tamaño ✖ |
| Derecha | el total, `font-weight:900` | `fw-black` |

## 9.7 Ventana del carrito (3 pasos en la misma ventana)
Ancho `calc(100% - 24px)` hasta **366 px**, alto máx. 88 % con barra vertical, esquinas **24 px**, **relleno 0** (cada parte trae el suyo). Bootstrap: `modal-dialog modal-dialog-centered modal-dialog-scrollable` + `style="max-width:366px"` y `modal-content` con `border-radius:24px`.

**Paso 1 — "Tu carrito"**
- Cabecera: relleno 20 px (16 abajo), línea inferior; título con bolsa 🛍 de 20 px `#741B3D`.
- Cuerpo (relleno 20, `gap:12px`): **por cada producto**, fila con borde, esquinas 16, relleno 12, `gap:12px`: foto **56 × 56** (esquinas 16, `object-fit:cover`); nombre (14 px, 700, una línea) y subtotal (12 px, 600, `#741B3D`); controles (margen arriba 8, `gap:4px`): **−** círculo 32 px con borde, cantidad (28 px de ancho, 14 px, 900), **+** círculo 32 px fondo `#741B3D`, y a la derecha papelera (círculo 32 px, icono 16 px, `#E7000B`).
- Total: línea superior, relleno arriba 16, `space-between`: "Total" (12 px gris) y valor (`20px; 900`); a la derecha insignia verde "**Domicilio gratis**".
- Botón "**Continuar**" (48 px, ancho 100 %) con flecha ›.

**Paso 2 — "Datos de entrega":** cabecera con botón atrás (círculo **36 px**, flecha ← de 16 px, al pasar el mouse `#F2EEF1`) + título. Cuerpo (relleno 20, `gap:20px`):
- **Dirección de entrega:** etiqueta + área de texto (`min-height:96px; background:#F2EEF1`; valor inicial *Calle 10 #23-45, Apto 301*) + error `12px; #E7000B` "*La dirección de entrega es obligatoria.*" + ayuda `12px` gris "*Puedes cambiarla solo para este pedido.*" (`gap:6px`).
- **Método de pago:** lista (48 px, fondo `#F2EEF1`): Efectivo, Tarjeta, Nequi, Transferencia.
- Resumen: fondo `#FCE8EA`, esquinas 16, relleno 16: fila "{n} productos" y total en negrita (14 px); debajo "Los precios incluyen IVA." (12 px gris, margen arriba 4).
- Botón "**Confirmar pedido**" (48 px, con círculo-check de 16 px).

**Paso 3 — éxito:** relleno 24, centrado: círculo verde 80 px (`#DBFCE7`) con ✓ de 40 px `#008236`; "**Pedido confirmado**" (`24px; 900; margin-top:20px`); "*Recibimos tu pedido y pronto será aceptado por la sede.*" (14 px gris, margen arriba 8); caja `#FCE8EA`, esquinas **24 px**, relleno 16, margen vertical 20, con "**NÚMERO DE PEDIDO**" (`12px; 700; letter-spacing:.05em; #741B3D`) y el número en monoespaciada `30px/36px; 900; #350B1A`; botón "**Seguir mi pedido**" (48 px) y debajo "**Volver al menú**" (fantasma, 44 px, margen arriba 8). Para un invitado solo aparece "Volver al menú" como botón principal.

**Revisión Menú:** [ ] 3 columnas a 1440 px, 2 a 768, 1 en celular · [ ] foto de 116 px a la izquierda · [ ] "Brownie con helado" a 60 % con "No disponible" · [ ] botón flotante abajo a la derecha desde 1024 · [ ] categorías se deslizan en celular · [ ] botón "+" círculo de 40 px.

---

<a id="vista-10"></a>
# 10. VISTA MIS PEDIDOS

**Qué es:** tarjetitas de las compras del cliente. Cada una tiene arriba una **franja vino** con el número y una **fila de bolitas conectadas** que muestra por dónde va el pedido. **Quién entra:** cliente con cuenta. **Menú activo:** Mis pedidos. **Barra:** "MIS PEDIDOS" / "Pedidos a domicilio". Usa el [Marco](#marco).

```
Mis pedidos                                  [☕ Nuevo pedido]
Consulta el estado de tus pedidos y el historial de entregas.
┌───────────────────┐ ┌──────────────────┐
│▓ #0047  Despachado│ │▓ #0042 Entregado │
│ Tu pedido va en…  │ │ Pedido entregado │
│ ●──●──●──●──○     │ │ ●──●──●──●──●    │
│ 🏍 Repartidor: …  │ │                  │
│ 3 productos  Ver ›│ │                  │
└───────────────────┘ └──────────────────┘
```

## 10.1 Encabezado (Patrón A)
Título "**Mis pedidos**" · descripción "**Consulta el estado de tus pedidos y el historial de entregas.**" · botón principal **44 px** (taza + "**Nuevo pedido**") → Menú. Bootstrap: Patrón A + `btn btn-primary`.

## 10.2 Sin pedidos
Tarjeta con contenido centrado y `padding:56px 0`: bolsa de **56 × 56 px** `#F6B4B8`; "**Aún no tienes pedidos**" (`18px/28px; 900; margin-top:16px`); "*Cuando hagas tu primer pedido aparecerá aquí.*" (`14px` gris, `margin-top:4px`); botón "**Explorar menú**" (`margin-top:20px`). Bootstrap: `card text-center py-5` + `mt-3`, `small text-gris`, `btn btn-primary mt-4`.

## 10.3 Tarjetas de pedido
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; 1 columna; **2 desde 768 px**; **3 desde 1280 px** | `row g-3` + `col-12 col-md-6 col-xl-4` ✔ |
| **Cada tarjeta** | `background:#fff; border:1px solid …; border-radius:12px; overflow:hidden; padding:0` (la franja llega hasta las esquinas) | `card overflow-hidden` |

**Franja de arriba:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#350B1A; color:#fff; padding:16px; display:flex; justify-content:space-between; align-items:flex-start` | `d-flex justify-content-between align-items-start p-3 text-white bg-vino-oscuro` ✔ |
| Número (izquierda) | monoespaciada `18px/28px; 900` | `font-monospace fw-black` + 18 ✖ (`fs-5` = 20 ≈) |
| Fecha (debajo) | `12px; color:rgba(255,255,255,.6)` | `small text-white opacity-75` ≈ |
| Estado (derecha) | etiqueta: normal fondo `rgba(255,255,255,.15)` letra blanca; cancelado fondo `#FFE2E2` letra `#C10007` | `badge text-bg-light bg-opacity-25 text-white` ≈ |

**Cuerpo (relleno 16 px → `p-3` ✔):**
1. **Descripción del estado** (`14px; 700`): Pendiente → *Recibimos tu pedido* · Aceptado → *La sede confirmó el pedido* · En preparación → *Estamos preparando tus productos* · Despachado → *Tu pedido va en camino* · Entregado → *Pedido entregado* · Cancelado → *Este pedido fue cancelado*.
2. **Barra de progreso** (si no está cancelado; `margin-top:20px`; `display:flex; align-items:center`) — Bootstrap `d-flex align-items-center mt-4`:
| Pieza | CSS | Bootstrap |
|---|---|---|
| **5 círculos** (Pendiente, Aceptado, En preparación, Despachado, Entregado) | `width:28px; height:28px; border-radius:50%; border:2px solid; display:flex; align-items:center; justify-content:center` | `rounded-circle border border-2 d-flex align-items-center justify-content-center` + 28 ✖ |
| Alcanzado o actual | borde y fondo `#F27C86`, icono `#350B1A` | `border-coral bg-coral` |
| Por alcanzar | borde `#F2EEF1`, fondo blanco, icono `#7A6873` | ✖ propio |
| Iconos | pasos ya superados → ✓ (16 px); el actual o futuro → 1.º reloj (12 px), 4.º camión (12 px), los demás caja (12 px) | — |
| **Líneas entre círculos** | `flex:1; height:2px`; coral `#F27C86` si ese paso ya se superó, `#F2EEF1` si no; el último paso no lleva línea | `flex-grow-1` ✔ + `style="height:2px"` ✖ |

3. **Repartidor** (si hay): `margin-top:16px; background:#FAF5FF; border-radius:16px; padding:12px; font-size:14px; font-weight:600; color:#8200DB`; moto 16 px: "**Repartidor: {nombre}**" · Bootstrap `rounded-4 p-3 small fw-semibold mt-3` + colores ✖.
4. **Pie:** `margin-top:16px; border-top:1px solid …; padding-top:16px; display:flex; justify-content:space-between` · Bootstrap `d-flex justify-content-between align-items-center border-top pt-3 mt-3` ✔. Izquierda "{n} productos" (12 px gris) y debajo el total (`18px; 900; #741B3D`); derecha botón fantasma pequeño "**Ver detalle ›**".

## 10.4 Ventana "Pedido {número}"
Ancho máx. **360 px**, alto máx. 90 % (Bootstrap `modal-sm` ≈ 300 → `style="max-width:360px"`); cuerpo `gap:16px`: (a) caja `#F2EEF1`, esquinas 16, relleno 12: pin 📍 de 16 px + dirección (14 px) y debajo "**Pago:** método"; (b) una fila por producto (borde, esquinas 12, relleno 12, 14 px): "{cant} × {producto}" y a la derecha el subtotal en negrita; (c) línea superior, relleno arriba 12: "**Total**" y valor (`18px; 900`).

**Revisión Mis pedidos:** [ ] franja vino con número en monoespaciada · [ ] 5 bolitas de 28 px unidas por líneas de 2 px · [ ] alcanzadas en coral, las que faltan en gris claro · [ ] 3 columnas a 1440 px.

---

<a id="vista-11"></a>
# 11. VISTA MIS DOMICILIOS (repartidor)

**Qué es:** la lista de entregas del repartidor: tarjetitas con nombre del cliente, teléfono, dirección y botones grandes de "Salir a entregar" y "Confirmar entrega". **Quién entra:** repartidor. **Menú activo:** Mis domicilios. **Barra:** "MIS DOMICILIOS". Usa el [Marco](#marco).

> ⚠ **Dato importante:** esta vista **NO usa la paleta vino**; usa grises y ámbar: título en grosor 700 sin color propio y números en ámbar. Se explica **tal cual está en Figma**.

```
Mis Domicilios
Hola, Carlos — tus entregas asignadas
┌ Hoy ──────┐ ┌ Activas ──┐ ┌ Completadas ┐   ← 3 números (siempre en fila)
│ 3         │ │ 2 (ámbar) │ │ 1 (verde)   │
[ Activas (2) ][ Completadas (1) ]
┌─ #0047 ────────Asignado┐ ┌─ #0048 ─────En Camino┐
│ 👤 Juan Pérez          │
│ 📞 300 123 4567        │
│ 📍 Calle 10 #23-45     │
│ $23.500        📍1.2 km│
│ [Ver Detalle][Salir a Entregar]
```

## 11.1 Encabezado
| Pieza | CSS | Bootstrap |
|---|---|---|
| Título "Mis Domicilios" | `font-size:30px; line-height:36px; font-weight:700; color:#321525` (**grosor 700, no 900**) | `h1 fw-bold` + 30 ✖ (`fs-3` = 28 ≈) |
| "Hola, {nombre} — tus entregas asignadas" | `font-size:16px; color:#45556C; margin-top:4px` | `fs-6 mt-1` + color ✖ |

## 11.2 Tres tarjetas de números
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor (siempre 3 columnas, también en celular)** | `display:grid; grid-template-columns:repeat(3,1fr); gap:16px` | `row g-3` + `col-4` ✔ |
| Encabezado de cada tarjeta | relleno 24 px arriba/lados y 8 abajo; título `14px; #45556C`: **Hoy · Activas · Completadas** | `card-body` + `small` |
| Número | `font-size:30px; line-height:36px; font-weight:700`: Hoy `#321525` · Activas **`#BB4D00`** · Completadas **`#00A63E`** | `fw-bold` + `style="font-size:30px;color:#BB4D00"` ✖ |
| Texto debajo | `12px; #62748E`: "entregas totales" · "en curso" · "entregadas" | `small` + color ✖ |

## 11.3 Pestañas (variante gris)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Barra | `display:inline-flex; background:#F2EEF1; padding:3px; border-radius:16px; height:36px; width:fit-content` | `nav nav-pills bg-body-secondary rounded-4 p-1 w-auto` ≈ |
| Textos | "**Activas (2)**" y "**Completadas (1)**" | — |
| Elegida | fondo blanco | `--bs-nav-pills-link-active-bg:#fff; --bs-nav-pills-link-active-color:#321525` |
| Separación con el contenido | `margin-top:16px` | `tab-content mt-3` ✔ |

## 11.4 Tarjeta de entrega
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; 1 columna; **2 desde 768 px**; **3 desde 1024 px** | `row g-3` + `col-12 col-md-6 col-lg-4` ✔ |
| Tarjeta | estándar; al pasar el mouse la sombra crece (sombra grande) | `card shadow-sm` + `:hover{box-shadow:…}` |

**Encabezado de la tarjeta:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:flex-start` | `d-flex justify-content-between align-items-start` |
| Número `#0047` y hora debajo | número `18px/28px`; hora `16px; #7A6873` | `fw-semibold` + `text-gris` |
| **Etiqueta de estado** (derecha, letra blanca, icono 12 px con 4 px de margen) | **Asignado** → fondo `#2B7FFF` + caja · **En Camino** → `#AD46FF` + camión · **Entregado** → `#00C950` + círculo-check | `badge` + fondos propios ✖ |

**Cuerpo** (`gap:12px`):
1. **Tres filas** (`gap:8px`; cada una: icono 16 px `#62748E` + texto 14 px): persona + nombre (grosor 500) · teléfono 📞 como **enlace** `<a href="tel:3001234567">` (color `#BB4D00`, subrayado al pasar el mouse) · pin + dirección (12 px). Bootstrap: `d-flex gap-2 small`.
2. **Fila con línea superior** (`border-top; padding-top:8px; display:flex; justify-content:space-between`): izquierda el total (`20px/28px; 700; #BB4D00`, ej. `$23.500`) y debajo etiqueta de contorno con el método de pago (12 px, `margin-top:4px`); derecha etiqueta secundaria (fondo `#F8E9ED`, letra `#4A1027`, 12 px) "📍 1.2 km". Bootstrap: `d-flex justify-content-between border-top pt-2` + `fw-bold fs-5` + color ✖.
3. **Botones** (`display:flex; gap:8px; padding-top:8px`): "**Ver Detalle**" (contorno, 32 px) y según el estado: Asignado → "**Salir a Entregar**" (camión de 12 px, principal, ocupa el resto) · En camino → "**Confirmar Entrega**" (fondo `#00A63E`, hover `#008236`, check 12 px) · Entregado → etiqueta verde `#00C950` centrada "**Entregado**". Bootstrap: `d-flex gap-2` + `btn btn-outline-secondary btn-sm` + `btn btn-primary btn-sm flex-grow-1` / `btn btn-success btn-sm flex-grow-1` (verde ✖ `#00A63E`).

| N.º | Cliente | Teléfono | Dirección | Total | Pago | Estado | Hora | Distancia | Productos |
|---|---|---|---|---|---|---|---|---|---|
| #0047 | Juan Pérez | 300 123 4567 | Calle 10 #23-45, Apto 301 | $23.500 | Efectivo | Asignado | 10:30 | 1.2 km | Café Americano ×2, Croissant ×3 |
| #0048 | María López | 310 987 6543 | Carrera 15 #8-90 | $18.000 | QR Digital | En camino | 11:00 | 2.5 km | Almuerzo Ejecutivo ×1 |
| #0045 | Luis Torres | 315 222 3344 | Avenida 8 #45-10 | $12.000 | Tarjeta | Entregado | 09:15 | 0.8 km | Capuchino ×2 |

**Sin entregas activas:** tarjeta con contenido centrado y `padding:48px 0`: reloj de **48 px** `#CAD5E2`, margen abajo 12; texto `16px; #62748E` "*No tienes entregas activas en este momento*". Bootstrap: `card text-center py-5`.

## 11.5 Ventana "Detalle de Entrega {n}"
Ancho máx. **500 px** (= `modal-dialog` por defecto ✔). Cuerpo `gap:16px` y relleno vertical 8: (a) grilla de 2 columnas (gap 16): **Cliente** y **Teléfono** — etiqueta `12px; #62748E` + valor grosor 500; (b) **Dirección**; (c) **Productos**: etiqueta con margen abajo 8; filas (fondo `#F8FAFC`, esquinas **4 px**, relleno 8, 14 px, `space-between`): nombre y "x{cantidad}" (grosor 500) — Bootstrap `rounded-1` ✔ (4 px); (d) línea superior, relleno arriba 12, `space-between`: **Método de Pago** (etiqueta + valor) y a la derecha **Total a Cobrar** (etiqueta + `24px/32px; 700; #BB4D00`). Pie: **Cerrar** (contorno) y el botón de acción según el estado.

**Revisión Mis domicilios:** [ ] título en grosor 700 (no 900) y números ámbar `#BB4D00` / verde `#00A63E` · [ ] 3 tarjetas de números en **una fila** también en celular · [ ] barra de pestañas gris y la elegida blanca · [ ] "Confirmar Entrega" verde.

---

<a id="revision"></a>
# LISTA FINAL DE REVISIÓN

| # | Vista | Qué mirar primero |
|---|---|---|
| 1 | Iniciar sesión | izquierda 792 / derecha 648 · título 72 px · 3 bolas + línea inclinada |
| 2 | Recuperar contraseña | 756 / 684 · bola grande arriba-izq + bola coral · caja ✉ 56 px · círculo verde 80 px |
| 3 | Registrarse | 756 / 684 · dos cajas blancas con título 18 px · "Dirección" a ancho completo |
| 4 | Inicio | menú 256 px · barra 80 px · 4 tarjetas con icono de 44 px |
| 5 | Usuarios | 3 pestañas · filtros en una fila · paginación 36 × 36 |
| 6 | Compras | 6 pestañas · 4 tarjetas de color · insignias con borde · botón bajo el título |
| 7 | Producción | botón 36 px · 2 tarjetas (.8 / 1.2) · filas de consumo verdes |
| 8 | Domicilios | 5 cajones con punto de color · gráfico con cajas |
| 9 | Menú | cartel 24 px · píldoras · tarjetas 116 px + texto · botón flotante |
| 10 | Mis pedidos | franja vino · 5 bolitas de 28 px con líneas de 2 px |
| 11 | Mis domicilios | paleta gris/ámbar · 3 números en fila · botón verde |

**Orden recomendado para construir (de más fácil a más difícil):** Recuperar contraseña → Registrarse → Iniciar sesión → Marco + Inicio → Usuarios → Compras → Producción → Mis pedidos → Mis domicilios → Menú → Domicilios.

**Se deja para la segunda etapa (JavaScript / backend):** filtrar y buscar, mover un pedido de cajón, sumar el carrito, validar campos, mostrar/ocultar errores, contraer el menú, avisos temporales, notificaciones, guardar datos.
=======
# BakeAdmin — Guía de estilos
=======
# GUÍA DE CONSTRUCCIÓN DE LAS VISTAS — BakeAdmin (Coffee Park)
>>>>>>> origin/development

**Proyecto SENA · ADSO ficha 3388489 · Inversiones SECAM SAS**
Guía para construir, pieza por pieza, las 11 vistas del prototipo de Figma, en **HTML + CSS** y, si quieres, con **Bootstrap 5.3**.

> Cómo leer cada pieza: primero **qué es**, luego una tabla con tres columnas: **qué propiedad es**, **CSS** y **Bootstrap**.
> Signos en la columna Bootstrap: **✔** = Bootstrap da la medida exacta · **≈** = se parece pero no es exacta (te digo la diferencia) · **✖** = Bootstrap no lo trae: escribe el CSS de la columna izquierda (o un `style="…"`).

---

## ÍNDICE (haz clic en una vista para ir a su explicación)

**Antes de construir**
- [0. Antes de empezar (conexión de Bootstrap, colores, letra, medidas)](#antes)
- [0.1 Piezas que se repiten (botón, campo, tarjeta, tabla, etiqueta de estado, pestañas, ventana, avisos)](#piezas)

**Vistas de entrada (sin menú)**
1. [Vista iniciar sesión](#vista-1)
2. [Vista de recuperar contraseña](#vista-2)
3. [Vista registrarse](#vista-3)

**El panel (con menú lateral y barra de arriba)**
- [Marco del panel (menú lateral + barra de arriba + pie) — se hace una sola vez](#marco)
- [Piezas de página que se repiten en el panel (encabezado con botón, filtros, tarjetas de color)](#patrones)

4. [Vista inicio](#vista-4)
5. [Vista usuarios y seguridad](#vista-5)
6. [Vista compras a proveedores](#vista-6)
7. [Vista producción y traslados](#vista-7)
8. [Vista domicilios](#vista-8)
9. [Vista menú del cliente](#vista-9)
10. [Vista mis pedidos](#vista-10)
11. [Vista mis domicilios (repartidor)](#vista-11)

**Cierre**
- [Lista final de revisión y orden recomendado](#revision)

---

<a id="antes"></a>
## 0. ANTES DE EMPEZAR

### 0.0 Conectar Bootstrap (una sola vez por página)
| Paso | CSS (a mano) | Bootstrap |
|---|---|---|
| En el `<head>` | `<link rel="stylesheet" href="css/estilos.css">` | primero el CSS de Bootstrap 5.3 (`https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css`) y **después** tu `estilos.css` (así tus reglas ganan) |
| Al final del `<body>` | — | `<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>` — con esto las **pestañas, ventanas (modales) y el menú de celular funcionan solo con atributos HTML** (`data-bs-toggle`, `data-bs-target`); no escribes JavaScript |
| Primera regla de tu CSS | `*{box-sizing:border-box;margin:0}` · `body{font-family:Inter,system-ui,sans-serif;font-size:16px;color:#321525;background:#FCF8F9}` | Bootstrap ya trae `box-sizing` y reinicio. Solo cambia sus colores en `:root` (ver 0.3) |

### 0.2 La letra
| | CSS | Bootstrap |
|---|---|---|
| Familia | `font-family: Inter, system-ui, sans-serif` (Inter se pide a Google Fonts con `<link>`) | `--bs-body-font-family: Inter, system-ui, sans-serif` en `:root` |
| Tamaños que existen en el proyecto | 10 · 11 · 12 · 14 · 16 · 18 · 20 · 24 · 30 · 36 · 48 · 60 · 72 px | `fs-6`=16 ✔ · `fs-5`=20 ✔ · `fs-4`=24 ✔ · `fs-3`=28 · `fs-2`=32 · `fs-1`=40 · `small`≈14 · **12, 11, 10, 18, 30, 36, 48, 60, 72 ✖** → `style="font-size:30px"` o clase propia |
| Grosores | 400 · 500 · 600 · 700 · 900 | `fw-normal` ✔ · `fw-medium` ✔ · `fw-semibold` ✔ · `fw-bold` ✔ · **900 ✖** → clase propia `.fw-black{font-weight:900}` |
| Alto de línea | 12→16 · 14→20 · 16→24 · 18→28 · 20→28 · 24→32 · 30→36 | `lh-1`=1 · `lh-sm`=1.25 · `lh-base`=1.5 · `lh-lg`=2 (otros valores ✖ propios) |

### 0.3 Los colores (se declaran una vez y se usan en todas las vistas)
| Nombre | Valor | Dónde se usa | Clase propia que debes crear (Bootstrap no la trae) |
|---|---|---|---|
| Vino profundo | `#4A1027` | bola 3 del login | `.bg-vino-profundo` |
| **Vino oscuro** | `#350B1A` | caja izquierda de la entrada, menú lateral, títulos grandes | `.bg-vino-oscuro` `.text-vino-oscuro` |
| **Vino** | `#741B3D` | botones principales, enlaces, precios | `.bg-vino` `.text-vino` (y `--bs-primary`) |
| Vino medio | `#96244F` | letra pequeña de sección, "¿Olvidaste…?" | `.text-vino-medio` |
| **Coral** | `#F27C86` | enlace activo del menú, bolas, etiquetas sobre oscuro | `.bg-coral` `.text-coral` `.border-coral` |
| Rosa | `#F6B4B8` | subtítulos sobre fondo oscuro | `.text-rosa` `.bg-rosa` |
| **Fondo de página** | `#FCF8F9` | fondo de todas las pantallas | `.bg-fondo` `.text-fondo` (= `--bs-body-bg`) |
| **Campo** | `#F2EEF1` | fondo de campos y cajas grises | `.bg-campo` |
| **Acento** | `#FCE8EA` | cajas de icono, pestaña elegida | `.bg-acento` |
| **Texto** | `#321525` | letra normal | `--bs-body-color` |
| Texto secundario | `#7A6873` | descripciones, etiquetas pequeñas | `.text-gris` |
| Borde | `rgba(116,27,61,.14)` | todos los bordes finos | `--bs-border-color` |
| Foco | `rgba(150,36,79,.5)` | resplandor de 3 px al hacer clic en un campo | `--bs-focus-ring-color` |
| Error | `#E7000B` | mensajes de error | `.text-danger` ≈ (Bootstrap `#DC3545`) |

**Colores de estado (etiquetas):**
| Estado | Fondo | Letra | Borde | Bootstrap más parecido (≈) |
|---|---|---|---|---|
| Verde | `#F0FDF4` | `#008236` | `#B9F8CF` | `bg-success-subtle text-success-emphasis border-success-subtle` |
| Ámbar | `#FFFBEB` | `#973C00` | `#FEE685` | `bg-warning-subtle text-warning-emphasis border-warning-subtle` |
| Azul | `#EFF6FF` | `#1447E6` | `#BEDBFF` | `bg-primary-subtle …` (con tu primario vino sale rosado: mejor clase propia) |
| Rojo | `#FEF2F2` | `#C10007` | `#FFC9C9` | `bg-danger-subtle text-danger-emphasis border-danger-subtle` |
| Rojo fuerte | `#FFE2E2` | `#9F0712` | — | ✖ propio |
| Gris | `#F1F5F9` | `#314158` | `#E2E8F0` | `bg-secondary-subtle text-secondary-emphasis border` |
| Morado | `#FAF5FF` | `#8200DB` | `#E9D4FF` | ✖ propio |
| Rosa (en preparación) | `#FDF2F8` | `#741B3D` | `#FBCFE8` | ✖ propio |

**Para que Bootstrap use tus colores**, en tu `estilos.css` (después de Bootstrap):
`:root{--bs-primary:#741B3D; --bs-primary-rgb:116,27,61; --bs-body-bg:#FCF8F9; --bs-body-color:#321525; --bs-border-color:rgba(116,27,61,.14); --bs-body-font-family:Inter,system-ui,sans-serif;}`
y cada clase propia de la tabla: por ejemplo `.bg-vino-oscuro{background:#350B1A}`, `.text-coral{color:#F27C86}`, `.fw-black{font-weight:900}`.

### 0.4 Medidas de separación (padding, margen, gap)
Todo el diseño está en múltiplos de 4 px. Bootstrap solo trae 6 valores:
| Medida | CSS | Bootstrap |
|---|---|---|
| 0 | `0` | `p-0` `m-0` `gap-0` ✔ |
| 4 px | `padding:4px` | `p-1` ✔ |
| 8 px | `padding:8px` | `p-2` ✔ |
| 16 px | `padding:16px` | `p-3` ✔ |
| 24 px | `padding:24px` | `p-4` ✔ |
| 48 px | `padding:48px` | `p-5` ✔ |
| **6, 10, 12, 20, 28, 32, 40, 56, 80 px** | `padding:12px`… | **✖ no existen** → `style="padding:12px"` o usa el vecino (`p-2`=8 o `p-3`=16) |

Prefijos: `p`=todos los lados · `px`=izq+der · `py`=arriba+abajo · `pt` `pb` `ps`(izq) `pe`(der) · igual con `m` (margen) · `gap-N` = separación entre hijos de flex/grid. Ejemplo: `padding:8px 16px` → `py-2 px-3`. Centrar caja: `margin-inline:auto` → `mx-auto`. Empujar a la derecha: `margin-left:auto` → `ms-auto`.

### 0.5 Esquinas, sombras, transparencia
| CSS | Bootstrap |
|---|---|
| `border-radius: 8px` | `rounded-3` ✔ |
| `border-radius: 16px` | `rounded-4` ✔ |
| `border-radius: 12px` / `24px` | ✖ propio (`style="border-radius:12px"`) |
| `border-radius: 50%` | `rounded-circle` ✔ |
| `border-radius: 9999px` (píldora) | `rounded-pill` ✔ |
| sombra pequeña `0 1px 3px rgba(0,0,0,.1)` | `shadow-sm` ≈ |
| sombra grande `0 10px 15px -3px rgba(0,0,0,.1)` | `shadow-lg` ≈ |
| `opacity:.25 / .5 / .75` | `opacity-25` / `opacity-50` / `opacity-75` ✔ · otros (.2, .4…) ✖ |

### 0.6 Tamaños de pantalla (puntos de quiebre)
| El diseño usa | Bootstrap más cercano | Diferencia |
|---|---|---|
| 640 px | `sm` = 576 | ≈ |
| **768 px** | **`md` = 768** | ✔ exacto |
| **1024 px** | **`lg` = 992** | ≈ 32 px menos |
| 1280 px | `xl` = 1200 | ≈ 80 px menos |

En Bootstrap se usa como prefijo: `d-none d-lg-flex` = "escondido, desde 992 px en fila". Para que se vea **exactamente** como el diseño usa tu propio `@media (min-width:1024px){…}`.

### 0.7 Cómo se logra cada efecto (los únicos trucos que usa todo el proyecto)
| Quiero… | CSS | Bootstrap |
|---|---|---|
| Hijos uno al lado del otro | `display:flex` | `d-flex` |
| Uno debajo del otro | `display:flex; flex-direction:column` | `d-flex flex-column` |
| Centrar en el otro eje | `align-items:center` | `align-items-center` |
| Un hijo a cada extremo | `justify-content:space-between` | `justify-content-between` |
| Un hijo ocupa lo que sobra | `flex:1` | `flex-grow-1` |
| Separación entre hijos | `gap:12px` | `gap-2` (8) / `gap-3` (16) / `gap-4` (24) |
| Columnas iguales | `display:grid; grid-template-columns:repeat(4,1fr); gap:16px` | `row g-3` + hijos `col-md-3` |
| Columnas desiguales (`116px 1fr`) | `grid-template-columns:116px 1fr` | ✖ propio |
| Un hijo "sale" de su caja (bolas) | padre `position:relative; overflow:hidden` · hijo `position:absolute; top:-96px; left:-96px` | padre `position-relative overflow-hidden` · hijo `position-absolute` (los valores negativos ✖ propios) |
| Círculo | `width:48px; height:48px; border-radius:50%` | `rounded-circle` + `style="width:48px;height:48px"` |
| Pegado a la pantalla | `position:fixed` | `position-fixed` |
| Pegado arriba al bajar | `position:sticky; top:0` | `sticky-top` |
| Si no cabe, deslizar | `overflow-x:auto` | `overflow-x-auto` |
| Esconder / mostrar desde 1024 | `display:none` / `@media(min-width:1024px){display:flex}` | `d-none d-lg-flex` ≈ |
| MAYÚSCULAS | `text-transform:uppercase` | `text-uppercase` |
| Separar letras | `letter-spacing:.1em` | ✖ propio |
| Texto con "…" | `overflow:hidden; text-overflow:ellipsis; white-space:nowrap` | `text-truncate` |
| Máximo 2 renglones | `display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden` | ✖ propio |
| Imagen que llena su caja | `width:100%; height:100%; object-fit:cover` | `w-100 h-100 object-fit-cover` |
| Inclinar | `transform:rotate(12deg)` | ✖ propio |
| Letra de máquina de escribir | `font-family:ui-monospace,monospace` | `font-monospace` |

---

<a id="piezas"></a>
## 0.1 PIEZAS QUE SE REPITEN (se construyen una vez; las vistas dicen "botón principal", "tarjeta", etc.)

### Botón
**Etiqueta:** `<button>` (o `<a>` si lleva a otra página).
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo interno | `display:inline-flex; align-items:center; justify-content:center; gap:8px` | `d-inline-flex align-items-center justify-content-center gap-2` |
| Alto normal **36 px**, relleno lateral 16 px | `height:36px; padding:0 16px` | `btn` = 38 px ≈ (relleno `px-3` ✔) |
| Alto pequeño **32 px**, relleno 12 px | `height:32px; padding:0 12px` | `btn btn-sm` = 31 px ≈ |
| Alto mediano **44 px** | `height:44px` | ✖ `style="height:44px"` |
| Alto grande **48 px** | `height:48px` | `btn btn-lg` = 48 px ✔ (pero su letra es 20 px: agrega `fs-6` para 16) |
| Esquinas | `border-radius:8px` | `rounded-3` ✔ |
| Letra | `font-size:14px; font-weight:500` | `small fw-medium` |
| **Principal** | fondo `#741B3D`, letra blanca, sin borde; hover fondo `#350B1A` | `btn btn-primary` (hover ≈; para `#350B1A` escribe `.btn-primary:hover{background:#350B1A}`) |
| **Contorno** | fondo blanco, letra `#321525`, borde 1 px `rgba(116,27,61,.14)`; hover fondo `#FCE8EA` | `btn btn-outline-secondary` ≈ (o `btn btn-light border`) |
| **Fantasma** | transparente, letra `#321525`; hover `#FCE8EA` | `btn btn-link text-decoration-none` ≈ |
| **Peligro (texto)** | letra `#C10007` | `btn btn-link text-danger` ≈ |
| **Ancho completo** | `width:100%` | `w-100` ✔ |

### Etiqueta + campo para escribir
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Etiqueta (`<label for="id">`) | `font-size:14px; font-weight:500; line-height:1; display:block; margin-bottom:4px` | `form-label fw-medium small mb-1` ✔ |
| Campo (`input`, `select`, `textarea`) ancho | `width:100%` | `form-control` / `form-select` ✔ |
| Alto del campo | **48 px**, o **44** o **40** según la vista | `form-control-lg` = 48 ✔ · normal = 38 ≈ · `form-control-sm` = 31 ≈ · **44 y 40 ✖** `style="height:44px"` |
| Fondo / borde / esquinas | `background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px` | `bg-campo` (propia) + `form-control` ya trae borde; esquinas `rounded-3` ✔ |
| Texto de ejemplo | `::placeholder{color:#7A6873}` | ✖ propio |
| Foco | `outline:none; box-shadow:0 0 0 3px rgba(150,36,79,.5)` | con `--bs-focus-ring-color` ≈ |
| Mensaje de error | `font-size:12px; line-height:16px; color:#E7000B; margin-top:4px` (escondido hasta que haga falta) | `text-danger small mt-1 d-none` (para mostrarlo quita `d-none`) ≈ |

### Tarjeta
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px; padding:24px 0; display:flex; flex-direction:column; gap:24px` | `card` (esquinas 6 px, 12 ✖ propio) |
| Encabezado (relleno lateral 24 px) | hijos **uno debajo del otro**, 6 px entre ellos: título → subtítulo → botón | `card-header bg-transparent border-0` o `card-body` |
| Título | `font-size:16px; font-weight:500; line-height:1` | `h6 fw-medium mb-1` ≈ |
| Subtítulo | `font-size:14px; color:#7A6873` | `small text-gris` |
| Cuerpo (relleno lateral 24 px) | `padding:0 24px; display:flex; flex-direction:column; gap:16px` | `card-body p-4` ✔ (24 px) |
| ⚠ Regla del diseño | el **botón va DEBAJO del título**, no a su derecha | igual |

### Tabla
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Envoltura | `border:1px solid rgba(116,27,61,.14); border-radius:16px; overflow-x:auto` | `table-responsive border rounded-4` ✔ |
| Tabla | `width:100%; font-size:14px; border-collapse:collapse` | `table table-hover align-middle mb-0` |
| Celda de título `th` | `height:40px; padding:0 8px; text-align:left; font-weight:500; white-space:nowrap; border-bottom:1px solid …` | alto 40 ✖ (`style="height:40px"`); relleno 8 `px-2` ✔ |
| Celda de dato `td` | `padding:8px; vertical-align:middle; white-space:nowrap; border-bottom:1px solid …` (la última fila sin línea) | `p-2` ✔ |
| Fila con el mouse encima | `background:rgba(242,238,241,.5)` | `table-hover` ≈ |
| Texto secundario en celda | `display:block; font-size:12px; color:#7A6873` | `small d-block text-gris` |
| Número en monoespaciada | `font-family:monospace; font-weight:700` | `font-monospace fw-bold` ✔ |

### Etiqueta de estado (insignia)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Forma | `display:inline-block; padding:2px 8px; border:1px solid; border-radius:8px; font-size:12px; line-height:16px; font-weight:500; white-space:nowrap` | `badge border fw-medium rounded-3` (relleno propio de Bootstrap ≈ `.35em .65em`) |
| Colores | de la tabla de estados (0.3) | clases `*-subtle` ≈ o propias |
| Qué color para cada texto | Verde: Activo · OK · Recibido · Entregado · Facturada · Disponible — Ámbar: Bajo mínimo · Pendiente · Pendiente de factura — Azul: Enviada · En tránsito · Aceptado · Sobre máximo — Rojo: Sin stock · Cancelada · No disponible — Rojo fuerte: Rechazada — Gris: Borrador · Inactivo — Morado: Despachado — Rosa: En preparación | igual |

### Pestañas
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Barra | `display:flex; background:#fff; padding:4px; border-radius:16px; box-shadow:0 1px 3px rgba(0,0,0,.1); overflow-x:auto` | `nav nav-pills nav-fill bg-white rounded-4 shadow-sm p-1 flex-nowrap overflow-x-auto` ✔ |
| Cada pestaña | `flex:1; height:36px; border-radius:12px; padding:0 12px; font-size:14px; font-weight:500; text-align:center` | `nav-link` (esquinas 12 ✖ propio) |
| Pestaña elegida | fondo `#FCE8EA`, letra `#741B3D` | `nav-link active` con `--bs-nav-pills-link-active-bg:#FCE8EA; --bs-nav-pills-link-active-color:#741B3D` |
| Al pasar el mouse | fondo `#F2EEF1` | ≈ |
| Contenido | separado **20 px** de la barra; solo se ve el panel de la pestaña elegida (con CSS sin JS: radios ocultos + `:checked`) | `tab-content mt-4` ≈ (24) con `tab-pane fade show active` / `tab-pane fade`; botón `data-bs-toggle="pill" data-bs-target="#panel1"` — **sin JS tuyo** |

### Ventana emergente (diálogo / modal)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo oscuro | `position:fixed; inset:0; background:rgba(0,0,0,.5)` | `modal` (lo trae) |
| Caja | centrada, `width:100%; max-width:512px` (cambia por ventana), `max-height:92vh; overflow-y:auto; background:#fff; border:1px solid …; border-radius:12px; padding:24px; box-shadow:0 10px 15px -3px rgba(0,0,0,.1)` | `modal-dialog modal-dialog-centered modal-dialog-scrollable` + `style="max-width:512px"` (Bootstrap trae 300 `modal-sm`, 500 normal, 800 `modal-lg`, 1140 `modal-xl`) |
| Título | `font-size:18px; font-weight:600; line-height:1` | `modal-title fs-5 fw-semibold` ≈ |
| Cuerpo | columna, 12 px entre bloques (20 px en las grandes), margen arriba 16 px | `modal-body d-flex flex-column gap-3` |
| Pie | `display:flex; justify-content:flex-end; gap:8px; margin-top:24px` | `modal-footer` |
| Cómo se abre | botón con `href="#ventana"` y la caja con `:target{display:flex}` | botón `data-bs-toggle="modal" data-bs-target="#ventana"` |

### Avisos
| Aviso | CSS | Bootstrap |
|---|---|---|
| **Ámbar** (info en ventanas) | fondo `#FFFBEB`, borde 1 px `#FEE685`, letra `#7B3306`, esquinas 16 px, relleno 12 px, 14 px | `alert alert-warning rounded-4` ≈ |
| **Rojo** | fila (gap 8 px), fondo `#FEF2F2`, borde `#FFC9C9`, letra `#C10007`, esquinas 16 px, relleno 12 px, 14 px, icono advertencia 20 px | `alert alert-danger d-flex gap-2 rounded-4` ≈ |

---
<a id="vista-1"></a>
# 1. VISTA INICIAR SESIÓN

**Qué es:** la primera pantalla. Está **dividida en 2 partes verticales**: la **izquierda** es vino oscuro con adornos (3 bolas, una línea inclinada, logo y letras grandes) y la **derecha** es clara con el formulario. En celular las dos partes se **apilan** (la oscura arriba).
**Se llega desde:** abrir la página, "Cerrar sesión", "← Volver" de Registro / Recuperar. **Lleva a:** Inicio, Registro, Recuperar contraseña, Menú del cliente.

```
┌──────────────────────────────────┬───────────────────────┐
│ PARTE IZQUIERDA 792 px (55 %)    │ PARTE DERECHA 648 px  │
│ fondo #350B1A                    │ fondo #FCF8F9         │
│ ○ bola 1            [✦ v2.0]     │                       │
│ [logo] BakeAdmin                 │    Inicia sesión      │
│                                  │    Correo [_______]   │
│ GESTIÓN OPERATIVA                │    Clave  [_______]   │
│ TU PANADERÍA,                    │    [ Ingresar → ]     │
│ TU CONTROL.                      │    ¿Eres cliente nuevo│
│            ○ bola 2              │    ── o continúa ──   │
│     ○ bola 3                     │    [☕ sin cuenta]    │
└──────────────────────────────────┴───────────────────────┘
```
(medidas a 1440 px de ancho de pantalla)

## 1.1 La pantalla completa (el contenedor de las 2 partes)
**Etiqueta:** `<div class="login">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Alto | `min-height:100vh` (toda la pantalla) | `min-vh-100` ✔ |
| Fondo | `background:#FCF8F9` | `bg-fondo` (propia) |
| Cómo se acomoda | celular: `display:flex; flex-direction:column`; desde 1024 px: `flex-direction:row` (izquierda y derecha lado a lado) | `d-flex flex-column flex-lg-row` (lg = 992 ≈ 1024) |

## 1.2 PARTE IZQUIERDA (caja vino)
**Etiqueta:** `<section class="login__izq">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Ancho | celular `100%`; desde 1024 px **`width:55%`** (= **792 px** a 1440) | celular `w-100`; 55 % ✖ → CSS propio `@media(min-width:1024px){.login__izq{width:55%}}` (≈ `col-lg-7` = 58.3 %) |
| Alto | celular `min-height:340px`; desde 1024 px `min-height:100vh` | `min-vh-100` en lg; 340 ✖ `style="min-height:340px"` |
| Color de fondo | `background:#350B1A` | `bg-vino-oscuro` (clase propia, ver 0.3) |
| Relleno | `padding:32px` (desde 1024 px `padding:48px`) | `p-5` (48 ✔); 32 ✖ → `style="padding:32px"` |
| Acomodo de lo de adentro | `display:flex; flex-direction:column; justify-content:space-between` (marca arriba, texto grande al medio) | `d-flex flex-column justify-content-between` ✔ |
| Para colocar las bolas dentro | **`position:relative; overflow:hidden`** (lo que sobresale se corta) | `position-relative overflow-hidden` ✔ |

### 1.2.1 Capa de adornos (caja invisible que cubre toda la parte izquierda)
**Etiqueta:** `<div class="login__adornos">` — es el "lienzo" donde se ubican las bolas.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Cómo ponerla | `position:absolute; top:0; right:0; bottom:0; left:0; overflow:hidden; pointer-events:none` (cubre todo y no estorba los clics) | `position-absolute top-0 bottom-0 start-0 end-0 overflow-hidden pe-none` ✔ |

### 1.2.2 Bola 1 — arriba a la izquierda (grande, vino)
**Etiqueta:** `<div class="bola bola-1">` (dentro de la capa de adornos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla en esa posición** | `position:absolute; top:-128px; left:-128px;` → queda "metida" en la esquina superior izquierda y se corta 128 px por arriba y por la izquierda | `position-absolute` ✔ + los valores negativos ✖ propios (`style="top:-128px;left:-128px"`) |
| Tamaño | `width:384px; height:384px` | ✖ `style="width:384px;height:384px"` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#741B3D; opacity:.4` | `bg-vino` (propia) + opacidad 40 % ✖ → `style="opacity:.4"` |

### 1.2.3 Bola 2 — en el medio, pegada al borde derecho (coral)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:50%; right:-96px;` → su borde superior queda en la mitad de la altura y se sale 96 px por la derecha | `position-absolute top-50` ✔ + `right:-96px` ✖ propio |
| Tamaño | `width:288px; height:288px` | ✖ `style` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#F27C86; opacity:.2` | `bg-coral` (propia) + opacidad 20 % ✖ |

### 1.2.4 Bola 3 — abajo (vino profundo)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; bottom:-80px; left:25%;` → sale 80 px por abajo y su borde izquierdo está a un cuarto del ancho | `position-absolute` ✔ + `bottom:-80px; left:25%` ✖ (existe `start-50`, `start-0`, `start-100`, pero no 25 %) |
| Tamaño | `width:256px; height:256px` | ✖ `style` |
| Forma | `border-radius:50%` | `rounded-circle` ✔ |
| Color | `background:#4A1027; opacity:.25` | `bg-vino-profundo` (propia) + `opacity-25` ✔ |

### 1.2.5 Línea inclinada (adorno)
**Etiqueta:** `<div class="linea">` (vacío)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:0; right:96px;` y se **inclina** con `transform:rotate(12deg); transform-origin:top;` (gira desde su punta de arriba) | `position-absolute top-0` ✔ + `right:96px` ✖ + `rotate` ✖ propios |
| Tamaño | `width:1px; height:100%` | `h-100` ✔ + ancho 1 px ✖ |
| Color | `background:#F6B4B8; opacity:.2` | `bg-rosa` (propia) + opacidad ✖ |

### 1.2.6 Etiqueta "✦ v2.0 — 2026" (píldora arriba a la derecha)
**Etiqueta:** `<div class="version">` con un icono de chispa de 12 px + `<span>v2.0 — 2026</span>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:32px; right:32px` | `position-absolute` ✔ + `top:32px; right:32px` ✖ (`top-0 end-0 m-4` da 24 px ≈) |
| Forma | `border-radius:9999px; padding:4px 12px` | `rounded-pill ✔ py-1 px-3` (4 y 16 ≈; 12 ✖) |
| Fondo y borde | `background:rgba(242,124,134,.133); border:1px solid rgba(242,124,134,.333)` | `border` + colores con transparencia ✖ propios |
| Letra | `font-size:12px; line-height:16px; font-weight:500; color:#F6B4B8` | `small fw-medium text-rosa` |
| Icono + texto | `display:flex; align-items:center; gap:6px` | `d-flex align-items-center` + gap 6 ✖ (`gap-1`=4 / `gap-2`=8 ≈) |

### 1.2.7 Marca: logo + "BakeAdmin" (arriba a la izquierda)
**Etiqueta:** `<div class="marca">` con `<img>` y un `<div>` de dos textos.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Dónde queda** | primer hijo de la parte izquierda → arriba a la izquierda (por el `space-between` de 1.2). Debe quedar **encima** de las bolas: `position:relative; z-index:10` | `position-relative` ✔; `z-index:10` ✖ (`z-3` es lo más alto) |
| Acomodo | `display:flex; align-items:center; gap:12px` (logo a la izquierda, textos a la derecha) | `d-flex align-items-center gap-3` (16 ≈ 12) |
| **Logo** — tamaño | `width:48px; height:48px; object-fit:contain` | `style="width:48px;height:48px"` ✖ + `object-fit-contain` ✔ |
| **Logo** — esquinas | `border-radius:16px` | `rounded-4` ✔ |
| **"BakeAdmin"** — letra | `font-size:20px; line-height:1; font-weight:700; color:#FCF8F9` | `fs-5` (20 ✔) `fw-bold` ✔ `lh-1` ✔ + color `text-fondo` (propia) |
| **"Sistema de Gestión"** (debajo) | `font-size:12px; line-height:16px; color:#F6B4B8` | `small text-rosa` (≈ 14; para 12 ✖ `style="font-size:12px"`) |

### 1.2.8 Bloque de texto grande (al centro de la parte izquierda)
**Etiqueta:** `<div class="hero">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarlo entre la marca y el fondo** | `position:relative; z-index:10; margin-block:auto; padding-block:32px` (desde 1024 px `padding-block:0`) | `position-relative my-auto py-lg-0` ✔ + `py-4` (24 ≈ 32) |

**a) Etiqueta "GESTIÓN OPERATIVA"** (`<p>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Letra | `font-size:14px; line-height:20px; font-weight:600; text-transform:uppercase; letter-spacing:.1em; color:#F27C86` | `small fw-semibold text-uppercase text-coral` + `letter-spacing` ✖ |
| Espacio abajo | `margin-bottom:12px` | ✖ (`mb-2`=8 / `mb-3`=16 ≈) |

**b) Título "TU PANADERÍA," y "TU CONTROL."** (dos `<h1>` o un `<h1>` con `<br>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `font-size:48px` (celular); `@media(min-width:1024px){60px}`; `@media(min-width:1280px){72px}` | ✖ propio (Bootstrap llega a 40 px con `fs-1`) |
| Grosor | `font-weight:900` | `fw-black` (propia) |
| Alto de línea | `line-height:1` (renglones pegados) | `lh-1` ✔ |
| Color | línea 1 `#FCF8F9`; línea 2 **`#F27C86`** | `text-fondo` / `text-coral` (propias) |
| Espacio | margen abajo 8 px (línea 1) y 24 px (línea 2) | `mb-2` ✔ / `mb-4` ✔ |

**c) Descripción** "Gestiona producción, pedidos, domicilios y compras desde un solo lugar." (`<p>`)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Letra | `font-size:16px` (desde 1024 px `18px`); `line-height:1.625` | `fs-6` ✔ · 18 ✖ · 1.625 ✖ |
| Color | `color:#F6B4B8; opacity:.8` | `text-rosa` + opacidad 80 % ✖ (`opacity-75` ≈) |
| Ancho máximo | `max-width:384px` | ✖ `style="max-width:384px"` |

## 1.3 PARTE DERECHA (formulario)
**Etiqueta:** `<section class="login__der">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Ancho | `flex:1; min-width:0` (ocupa lo que sobra = **648 px** a 1440) | `flex-grow-1` ✔ |
| Fondo | `background:#FCF8F9` | `bg-fondo` |
| **Cómo centrar el formulario verticalmente** | `display:flex; flex-direction:column; justify-content:center` | `d-flex flex-column justify-content-center` ✔ |
| Relleno | `padding:40px 24px`; desde 1024 px lados `56px`; desde 1280 px lados `80px` | `px-4` (24 ✔) · `py-5` (48 ≈ 40) · lados 56/80 ✖ propios |

### 1.3.1 Caja interna del formulario
**Etiqueta:** `<div class="login__caja">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarla horizontalmente** | `width:100%; max-width:448px; margin-inline:auto` | `w-100 mx-auto` ✔ + `style="max-width:448px"` ✖ |

### 1.3.2 Marca pequeña (SOLO se ve en celular)
**Etiqueta:** `<div class="marca-mini">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; align-items:center; gap:8px; margin-bottom:32px` | `d-flex align-items-center gap-2 mb-4` (24 ≈ 32) |
| Cuándo se ve | `@media(min-width:1024px){display:none}` | `d-lg-none` ✔ |
| Logo | `width:36px; height:36px` | `style` ✖ |
| "BakeAdmin" | `font-weight:700; color:#321525` | `fw-bold` ✔ |

### 1.3.3 Título "Inicia sesión" y subtítulo
| Pieza | Propiedad | CSS | Bootstrap |
|---|---|---|---|
| "Inicia sesión" (`<h2>`) | Letra | `font-size:30px; line-height:36px; font-weight:900; color:#321525; margin-bottom:4px` | `h2 fw-black mb-1` ✔ + 30 px ✖ |
| "Accede a tu panel de control" (`<p>`) | Letra | `font-size:14px; line-height:20px; color:#7A6873; margin-bottom:32px` | `small text-gris mb-4` (24 ≈ 32) |

### 1.3.4 Aviso de error (escondido; solo aparece si fallan correo o clave)
**Etiqueta:** `<div class="login__error" hidden>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:grid; grid-template-columns:16px 1fr; gap:12px; align-items:start` (icono + texto) | `d-flex gap-3` ≈ |
| Aspecto | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px; padding:12px 16px; font-size:14px; line-height:20px; color:#D4183D; margin-bottom:20px` | `alert d-none` + esquinas 12 ✖; color `#D4183D` ✖ propio |

### 1.3.5 El formulario
**Etiqueta:** `<form>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; flex-direction:column; gap:20px` | `d-flex flex-column gap-3` (16 ≈ 20; exacto ✖ `style="gap:20px"`) |

**a) Grupo "Correo Electrónico"** (columna, 6 px entre etiqueta y campo)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Etiqueta | `font-size:14px; line-height:1; font-weight:600; color:#321525` (`<label for="correo">`) | `form-label fw-semibold small mb-1` ✔ |
| Campo `<input type="email" id="correo" placeholder="correo@bakeadmin.com">` | `height:44px; background:#F2EEF1; border:1px solid rgba(116,27,61,.2); border-radius:8px; padding:0 12px; font-size:14px; width:100%` | `form-control` (38 px) → alto 44 ✖ `style="height:44px"`; fondo `bg-campo` |

**b) Grupo "Contraseña"**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Fila de arriba (etiqueta izquierda, enlace derecha) | `display:flex; justify-content:space-between; align-items:center` | `d-flex justify-content-between align-items-center` ✔ |
| Etiqueta "Contraseña" | igual que la de correo | igual |
| Enlace "¿Olvidaste tu contraseña?" → lleva a Recuperar | `font-size:12px; line-height:16px; font-weight:500; color:#96244F; text-decoration:none` y `:hover{text-decoration:underline}` | `fw-medium text-vino-medio link-underline-opacity-0 link-underline-opacity-100-hover` (12 px ✖) |
| Campo `<input type="password" placeholder="••••••••">` | igual que el de correo | igual |

**c) Botón "Ingresar →"**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `width:100%; height:48px` | `btn btn-primary btn-lg w-100` ✔ (48 px) |
| Letra | `font-size:16px; line-height:24px; font-weight:700` | `fs-6 fw-bold` ✔ |
| Colores | fondo `#741B3D`, letra blanca. ⚠ En el prototipo **no cambia al pasar el mouse** | `btn-primary` ✔ (con `--bs-primary` vino); para que no cambie: `.btn-primary:hover{background:#741B3D}` |
| Contenido | texto "Ingresar" + flecha → de 16 px, `gap:8px` | `d-flex align-items-center justify-content-center gap-2` |

### 1.3.6 Enlace de registro
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Texto | "¿Eres cliente nuevo? **Regístrate aquí**" (`<p>` centrado) | `text-center` ✔ |
| Letra | `font-size:14px; line-height:20px; color:#7A6873; margin-top:16px` | `small text-gris mt-3` ✔ |
| El enlace | `font-weight:600; color:#741B3D; text-decoration:none` y subrayado en `:hover` | `fw-semibold text-vino link-underline-opacity-0 link-underline-opacity-100-hover` |

### 1.3.7 Separador "o continúa sin cuenta"
**Etiqueta:** `<div class="separador">` con una línea y un `<span>`.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `position:relative; text-align:center; margin-top:32px` | `position-relative text-center mt-4` (24 ≈ 32) |
| **Cómo hacer la línea que cruza detrás del texto** | `<div class="linea">` con `position:absolute; top:50%; left:0; right:0; border-top:1px solid rgba(116,27,61,.133)` | `position-absolute top-50 start-0 end-0 border-top` ✔ |
| El texto "o continúa sin cuenta" va **encima** | `position:relative; padding:0 12px; background:#FCF8F9` (el fondo "borra" la línea detrás del texto) | `position-relative bg-fondo px-3` (16 ≈ 12) |
| Letra | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |

### 1.3.8 Botón "Ver menú y Realizar Pedidos (sin cuenta)"
**Etiqueta:** `<a href="menu.html" class="btn-sin-cuenta">` (parece botón, lleva al Menú del cliente)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `display:flex; align-items:center; justify-content:center; gap:8px; width:100%; height:48px; margin-top:16px` | `btn btn-lg w-100 mt-3 d-flex align-items-center justify-content-center gap-2` ✔ |
| Borde y fondo | `border:1px solid #F27C86; background:rgba(242,124,134,.082); border-radius:8px` | `border border-coral rounded-3` + fondo con transparencia ✖ |
| Letra | `font-size:14px; font-weight:700; color:#321525` | `small fw-bold` |
| Icono taza ☕ | 16 px, color `#F27C86`, a la izquierda del texto | `text-coral` |
| Al pasar el mouse | no cambia | — |

**Comportamiento que se agrega después (JS/backend):** entrar con éxito → Inicio · error → mostrar 1.3.4 · "sin cuenta" → entra como invitado.

**Revisión Login:** [ ] 1440 px: izquierda 792 / derecha 648 · [ ] título 72 px (60 a 1100 px; 48 en celular) · [ ] campos 44, botones 48 · [ ] 3 bolas + línea inclinada + etiqueta v2.0 · [ ] en celular la oscura arriba y aparece la marca pequeña · [ ] sin barra horizontal.

---
<a id="vista-2"></a>
# 2. VISTA DE RECUPERAR CONTRASEÑA

**Qué es:** pantalla dividida en **2 partes** (la misma caja vino de la izquierda que usa Registrarse) y en la derecha **un solo cuadrito que cambia en 3 etapas**: (1) pide el correo → (2) pide la contraseña nueva → (3) dice "Contraseña actualizada". Se construyen 3 páginas (`recuperar.html`, `recuperar-2.html`, `recuperar-3.html`) o 1 que cambia con JS más adelante.
**Se llega desde:** el enlace "¿Olvidaste tu contraseña?" del login. **Lleva a:** Login.

> ⚠ **Ojo:** este login NO es igual al de la Vista 1. Esta parte izquierda mide **52.5 %** (756 px a 1440), no 55 %. **No copies una para la otra.**

```
┌──────────────────────────────┬──────────────────────────┐
│ IZQUIERDA 756 px (52.5 %)    │ DERECHA 684 px           │
│ fondo #350B1A                │ fondo #FCF8F9            │
│ ○ bola A (arriba-izq)        │ ← Volver al inicio       │
│ [logo] BakeAdmin             │ [✉]                      │
│        Coffee Park           │ Recuperar contraseña     │
│ ✦ GESTIÓN OPERATIVA          │ Correo de acceso [____]  │
│ TU PANADERÍA, TU CONTROL.    │ [ Enviar enlace ]        │
│              ○ bola B        │                          │
│ Coffee Park · Colombia       │                          │
└──────────────────────────────┴──────────────────────────┘
```

<a id="molde"></a>
## 2.A EL MOLDE DE LAS DOS PARTES (se hace una vez y sirve para Recuperar y para [Registrarse](#vista-3))

### 2.A.1 La pantalla completa
**Etiqueta:** `<div class="auth">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Alto | `min-height:100vh` | `min-vh-100` ✔ |
| Cómo se divide | desde 1024 px: `display:grid; grid-template-columns:1.05fr .95fr` → **756 px** y **684 px** a 1440 | ✖ propio (`row g-0` + `col-lg-6` da 50/50 ≈) |
| Menos de 1024 px | la parte izquierda **no se muestra** y la derecha ocupa todo | `d-none d-lg-flex` en la izquierda ≈ |

### 2.A.2 PARTE IZQUIERDA
**Etiqueta:** `<section class="auth__izq">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo y letra | `background:#350B1A; color:#fff` | `bg-vino-oscuro text-white` |
| Relleno | `padding:48px` | `p-5` ✔ |
| Acomodo | `display:flex; flex-direction:column` (marca arriba, mensaje al centro, pie abajo) | `d-flex flex-column` ✔ |
| Para colocar las bolas | `position:relative; overflow:hidden` | `position-relative overflow-hidden` ✔ |
| Escondida en celular | `display:none` y desde 1024 px `display:flex` | `d-none d-lg-flex` ≈ |

**Bola A (arriba a la izquierda, vino)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:-96px; left:-96px` (sale 96 px por arriba y por la izquierda) | `position-absolute` ✔ + valores negativos ✖ |
| Tamaño y forma | `width:320px; height:320px; border-radius:50%` | `rounded-circle` ✔ + tamaño ✖ |
| Color | `background:rgba(116,27,61,.5)` (vino al 50 %) | ✖ propio |

**Bola B (a la derecha, a un tercio de la altura, coral)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo acomodarla** | `position:absolute; top:33.333%; right:-80px` | `position-absolute` ✔ + `top:33.333%` y `right:-80px` ✖ |
| Tamaño y forma | `width:288px; height:288px; border-radius:50%` | `rounded-circle` ✔ + tamaño ✖ |
| Color | `background:rgba(242,124,134,.2)` (coral al 20 %) | ✖ propio |

**Marca (arriba): logo + "BakeAdmin" + "Coffee Park"**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Dónde queda** | primer hijo de la columna → arriba a la izquierda; `position:relative` para quedar sobre las bolas | `position-relative` ✔ |
| Acomodo | `display:flex; align-items:center; gap:12px` | `d-flex align-items-center gap-3` (16 ≈ 12) |
| Logo | `width:48px; height:48px; border-radius:16px; object-fit:contain` | `rounded-4 object-fit-contain` ✔ + tamaño ✖ |
| "BakeAdmin" | `font-size:20px; line-height:28px; font-weight:900; color:#fff` | `fs-5 fw-black text-white` |
| **"Coffee Park"** debajo | `font-size:12px; line-height:16px; color:#F6B4B8` | `small text-rosa` (12 ✖) |

**Mensaje (centro)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo centrarlo verticalmente** | `margin-block:auto; position:relative; max-width:576px` | `my-auto position-relative` ✔ + `max-width:576px` ✖ |
| Etiqueta "✦ Gestión operativa" | chispa 16 px + texto con `gap:8px`; `font-size:14px; line-height:20px; font-weight:700; text-transform:uppercase; letter-spacing:.25em; color:#F27C86; margin-bottom:16px` | `d-flex gap-2 small fw-bold text-uppercase text-coral mb-3` ✔ + `letter-spacing` ✖ |
| Título "TU PANADERÍA, / **TU CONTROL.**" | `font-size:60px; font-weight:900; line-height:.95` (renglones muy pegados); 1.ª línea blanca, 2.ª `#F27C86` | `fw-black` + 60 px ✖ + `.95` ✖ |
| Texto "Gestiona producción, pedidos, domicilios y compras desde un solo lugar." | `font-size:18px; line-height:1.625; color:rgba(246,180,184,.8); max-width:448px; margin-top:24px` | `mt-4` ✔ + resto ✖ |

**Pie**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| "Coffee Park · Colombia" (abajo) | `font-size:12px; line-height:16px; color:rgba(255,255,255,.4); position:relative` | `small text-white opacity-50 position-relative` ≈ |

### 2.A.3 PARTE DERECHA
**Etiqueta:** `<section class="auth__der">`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fondo | `background:#FCF8F9` | `bg-fondo` |
| Alto y centrado | `min-height:100vh; display:flex; align-items:center` (el contenido queda en el centro vertical) | `d-flex align-items-center min-vh-100` ✔ |
| Relleno | `padding:40px 20px`; desde 640 px lados `40px` | `py-5` (48 ≈ 40) `px-3` (16 ≈ 20) |
| **Caja interna** (donde va todo) | `width:100%; max-width:576px; margin-inline:auto` | `w-100 mx-auto` ✔ + `max-width:576px` ✖ |

### 2.A.4 Piezas comunes de la parte derecha
| Pieza | CSS | Bootstrap |
|---|---|---|
| **"← Volver…"** (enlace) | `display:inline-flex; align-items:center; gap:8px; min-height:44px; font-size:14px; line-height:20px; font-weight:600; color:#741B3D; text-decoration:none;` margen abajo: **24 px** (Registro) / **32 px** (Recuperar); flecha de 16 px | `d-inline-flex align-items-center gap-2 fw-semibold small text-vino text-decoration-none mb-4` (24 ✔; 32 ✖) |
| **Título de vista** `<h2>` | `font-size:30px; line-height:36px; font-weight:900` | `h2 fw-black` + 30 ✖ |
| **Descripción** `<p>` | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |
| **Círculo de éxito** | `width:80px; height:80px; border-radius:50%; background:#DBFCE7; display:flex; align-items:center; justify-content:center; margin-inline:auto`; símbolo ✓ de 40 px color `#008236` | `rounded-circle d-flex align-items-center justify-content-center mx-auto` ✔ + 80 px ✖ + color ✖ |

## 2.1 ETAPA 1 — Pedir el correo (`recuperar.html`)
Dentro de la caja interna (2.A.3), de arriba hacia abajo:

**2.1.1 Enlace "← Volver al inicio"** → pieza común (2.A.4), **margen abajo 32 px**. Lleva a Login.

**2.1.2 Caja del icono (sobre ✉)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Tamaño | `width:56px; height:56px` | ✖ `style` |
| Fondo y esquinas | `background:#FCE8EA; border-radius:16px` | `bg-acento rounded-4` ✔ |
| **Cómo centrar el sobre dentro** | `display:flex; align-items:center; justify-content:center` | `d-flex align-items-center justify-content-center` ✔ |
| Sobre | icono de 24 px, color `#741B3D` | `text-vino` |

**2.1.3 Título "Recuperar contraseña"** (`<h2>`) → `font-size:30px; line-height:36px; font-weight:900; margin-top:20px` · Bootstrap: `h2 fw-black mt-3` (16 ≈ 20) + 30 ✖.

**2.1.4 Descripción "Enviaremos el enlace a tu correo de recuperación."** → `font-size:14px; color:#7A6873; margin-top:8px` · Bootstrap: `small text-gris mt-2` ✔.

**2.1.5 Formulario**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; flex-direction:column; gap:20px; margin-top:28px` | `d-flex flex-column gap-3 mt-4` (≈; 20 y 28 ✖) |

**2.1.6 Grupo "Correo de acceso"**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Etiqueta | `font-size:14px; line-height:1; font-weight:500` | `form-label fw-medium small mb-1` ✔ |
| Campo `<input type="email" placeholder="correo@ejemplo.com">` | `height:48px; width:100%; background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px; margin-top:4px` | `form-control form-control-lg fs-6` ✔ (48 px) + `bg-campo` |
| Mensaje de error (escondido; sale si falta la `@`) "Ingrese un correo válido." | `font-size:12px; line-height:16px; color:#E7000B; margin-top:4px` | `text-danger small mt-1 d-none` ≈ |

**2.1.7 Botón "Enviar enlace"** → `width:100%; height:48px; font-size:14px; font-weight:500; background:#741B3D; color:#fff; border-radius:8px` · Bootstrap: `btn btn-primary btn-lg w-100` + `small fw-medium` ✔ (48 px).
Al enviar (después, con JS): aviso "Enlace enviado al correo de recuperación" y pasa a la etapa 2.

## 2.2 ETAPA 2 — Contraseña nueva (`recuperar-2.html`)
Misma pantalla y molde; cambia el contenido de la caja interna:
| Pieza | CSS | Bootstrap |
|---|---|---|
| "← Volver al inicio" | igual que etapa 1 | igual |
| Mini-etiqueta **"PASO 2 DE 2"** | `font-size:12px; line-height:16px; font-weight:700; text-transform:uppercase; letter-spacing:.1em; color:#96244F` | `text-uppercase fw-bold text-vino-medio` + 12 px ✖ + espaciado ✖ |
| Título "Nueva contraseña" | `30px/36px; 900; margin-top:8px` | `h2 fw-black mt-2` ✔ |
| Descripción "Crea una nueva contraseña para **{el correo escrito}**." | `14px; #7A6873; margin-top:8px` | `small text-gris mt-2` ✔ |
| Formulario | `display:flex; flex-direction:column; gap:16px; margin-top:28px` (aquí son **16**, no 20) | `d-flex flex-column gap-3 mt-4` ✔ (gap) |
| Campo 1: etiqueta "Nueva contraseña" + `<input type="password">` | alto 48 px, fondo `#F2EEF1`, **sin texto de ejemplo** | `form-control form-control-lg fs-6` ✔ |
| Campo 2: "Confirmar contraseña" | igual; **debajo** va el único mensaje de error (12 px, `#E7000B`): "La contraseña debe tener mínimo 8 caracteres." o "Las contraseñas no coinciden." | `text-danger small mt-1 d-none` ≈ |
| Botón "Actualizar contraseña" | principal, 48 px, ancho completo | `btn btn-primary btn-lg w-100` ✔ |

## 2.3 ETAPA 3 — Éxito (`recuperar-3.html`, todo centrado)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Círculo de éxito (✓ verde) | 80 × 80, fondo **`#DBFCE7`**, ✓ de 40 px `#008236` (pieza común 2.A.4) | `rounded-circle … mx-auto` |
| Título "Contraseña actualizada" | `30px/36px; 900; text-align:center; margin-top:20px` | `h2 fw-black text-center mt-3` ≈ |
| Texto "Ya puedes ingresar con tu nueva contraseña." | `font-size:16px; color:#7A6873; text-align:center; margin-top:8px` | `fs-6 text-gris text-center mt-2` ✔ |
| Botón "Iniciar sesión" → Login | `width:100%; height:48px; margin-top:24px`, principal | `btn btn-primary btn-lg w-100 mt-4` ✔ |

> ⚠ **Lo que NO debes copiar de la indicación de la IA de Figma** (tiene medidas distintas al diseño real; esta guía manda): nombre bajo el logo = **"Coffee Park"** (no "Sistema de Gestión") · pie izquierdo = **"Coffee Park · Colombia"** · descripción etapa 1 = **"Enviaremos el enlace a tu correo de recuperación."** · etiqueta = **"Correo de acceso"** · botón = **"Enviar enlace"** · etapa 2 sin textos de ejemplo · círculo de éxito **`#DBFCE7`** · dos bolas (320 vino 50 % arriba-izq y 288 coral 20 % a la derecha).

**Revisión Recuperar:** [ ] 1440 px: 756 / 684 · [ ] caja del icono 56 × 56, campos 48, botones 48 · [ ] etapa 2 "PASO 2 DE 2" en `#96244F` y un solo error · [ ] etapa 3 círculo 80 px verde claro.

---

<a id="vista-3"></a>
# 3. VISTA REGISTRARSE (crear cuenta)

**Qué es:** el mismo molde de 2 partes de la [Vista 2 (sección 2.A)](#molde). Solo cambia lo que va en la **parte derecha**: un formulario largo dividido en **dos cajas blancas** ("Acceso" e "Información personal"). Al terminar se muestra "Cuenta creada".
**Se llega desde:** "Regístrate aquí" del login. **Lleva a:** Login.
> Parte izquierda, bolas, marca, mensaje y pie: **idénticos a 2.A** (756 / 684 px a 1440, bolas 320 y 288, "Coffee Park").

```
← Volver
Crear cuenta
Regístrate como cliente de Coffee Park.
┌─ Acceso ───────────────────────────────┐
│ Correo            │ Contraseña         │
│ Correo de recuperación                 │
└────────────────────────────────────────┘
┌─ Información personal ─────────────────┐
│ Nombres           │ Apellidos          │
│ Tipo de documento │ Número documento   │
│ Teléfono          │                    │
│ Dirección (ancho completo)             │
└────────────────────────────────────────┘
[         Crear cuenta         ]
¿Ya tienes cuenta? Iniciar sesión
```

## 3.1 "← Volver", título y descripción (de arriba a abajo)
| Pieza | CSS | Bootstrap |
|---|---|---|
| "← Volver" → Login | pieza común 2.A.4, **margen abajo 24 px** | `… mb-4` ✔ |
| Título "Crear cuenta" | `font-size:30px; line-height:36px; font-weight:900` | `h2 fw-black` + 30 ✖ |
| Descripción "Regístrate como cliente de Coffee Park." | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px; margin-bottom:24px` | `small text-gris mt-1 mb-4` ✔ |

## 3.2 El formulario
**Etiqueta:** `<form>` → CSS: `display:flex; flex-direction:column; gap:20px` · Bootstrap: `d-flex flex-column gap-4` (24 ≈ 20).

## 3.3 Caja blanca "Acceso"
**Etiqueta:** `<section>` con `<h3>` y una grilla de campos.
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:16px; padding:20px` | `bg-white border rounded-4 p-4` (24 ≈ 20) |
| Título "Acceso" (`<h3>`) | `font-size:18px; line-height:27px; font-weight:900; margin-bottom:16px` | `h3 fw-black mb-3` ✔ + 18 ✖ |
| **Grilla de campos** | celular 1 columna; desde 640 px **2 columnas iguales**: `display:grid; grid-template-columns:1fr; gap:16px` → `@media(min-width:640px){grid-template-columns:1fr 1fr}` | `row g-3` y cada campo `col-12 col-sm-6` (sm = 576 ≈ 640) |
| Campos, en orden | 1) **Correo** (`type="email"`) · 2) **Contraseña** (`type="password"`) · 3) **Correo de recuperación** (`type="email"`) | — |

**Cada campo** (etiqueta + campo + error escondido):
| Pieza | CSS | Bootstrap |
|---|---|---|
| Grupo | `display:flex; flex-direction:column; gap:6px` | `d-flex flex-column` + `gap` 6 ✖ (`mb-1` ≈) |
| Etiqueta | `font-size:14px; font-weight:500; line-height:1` | `form-label fw-medium small mb-1` |
| Campo | `height:44px; background:#F2EEF1; border:1px solid rgba(116,27,61,.14); border-radius:8px; padding:0 12px; font-size:14px` | `form-control bg-campo` + alto 44 ✖ |
| Error | `font-size:12px; color:#E7000B; margin-top:4px` (escondido) | `text-danger small mt-1 d-none` |
| Mensajes posibles | "Ingrese un correo válido." · "Debe tener mínimo 8 caracteres." · "Ingrese un correo de recuperación válido." · "Debe ser distinto al correo de acceso." | |

## 3.4 Caja blanca "Información personal"
Misma caja (3.3) y mismo título (18 px, 900, "Información personal"), con 6 campos, **en este orden**:
| N.º | Campo | Tipo | Ocupa |
|---|---|---|---|
| 1 | Nombres | texto | 1 columna |
| 2 | Apellidos | texto | 1 columna |
| 3 | Tipo de documento | lista `<select>` con CC, CE, TI, PP, NIT | 1 columna (`form-select` en Bootstrap) |
| 4 | Número de documento | texto | 1 columna |
| 5 | Teléfono | texto | 1 columna |
| 6 | **Dirección** | texto | **las 2 columnas**: CSS `grid-column:1 / -1` · Bootstrap `col-12` |

Errores posibles: "Los nombres son obligatorios." · "Los apellidos son obligatorios." · "El documento es obligatorio y debe ser único."

## 3.5 Botón "Crear cuenta"
CSS: principal, `width:100%; height:48px` · Bootstrap: `btn btn-primary btn-lg w-100 fs-6` ✔ (48 px).

## 3.6 Pie "¿Ya tienes cuenta? **Iniciar sesión**"
CSS: `text-align:center; font-size:14px; line-height:20px; color:#7A6873`; el enlace `font-weight:700; color:#741B3D; text-decoration:none` → Login · Bootstrap: `text-center small text-gris` + enlace `fw-bold text-vino text-decoration-none`.

## 3.7 Pantalla de éxito (reemplaza todo lo anterior en la parte derecha)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Círculo verde ✓ | 80 × 80, `#DBFCE7`, ✓ 40 px `#008236`, centrado | `rounded-circle … mx-auto` |
| "Cuenta creada" | `30px/36px; 900; text-align:center; margin-top:20px` | `h2 fw-black text-center mt-3` |
| "Ya puedes iniciar sesión y pedir a domicilio." | `16px; #7A6873; margin-top:8px` | `fs-6 text-gris text-center mt-2` |
| Botón "Ir a iniciar sesión" | principal, 48 px, ancho completo, `margin-top:24px` | `btn btn-primary btn-lg w-100 mt-4` ✔ |

**Revisión Registro:** [ ] 756 / 684 · [ ] 2 cajas blancas con relleno 20, esquinas 16, título 18 px · [ ] 2 columnas desde 640 px y "Dirección" ocupa las 2 · [ ] campos 44, botón 48 · [ ] en menos de 1024 px desaparece la caja oscura.

---
<a id="marco"></a>
# MARCO DEL PANEL (menú lateral + barra de arriba + contenido + pie)

**Qué es:** el "edificio" donde viven las vistas 4 a 11. Se construye **una sola vez** y se copia en cada vista; en cada una solo cambian 6 cosas: (1) título de la pestaña del navegador, (2) qué enlace del menú está activo, (3) texto de sección de la barra, (4) sede de la barra, (5) migas de pan, (6) el contenido.

```
┌─────────┬──────────────────────────────────────────────┐
│ MENÚ    │ BARRA DE ARRIBA (alto 80 px)                 │
│ 256 px  │ COMPRAS · Coffee Park Centro  [Sinc] Laura [Cerrar sesión]
│ #350B1A ├──────────────────────────────────────────────┤
│ logo    │ CONTENIDO  (migas: Inicio / Compras)         │
│ Inicio  │   AQUÍ VA LA VISTA                           │
│ Usuarios├──────────────────────────────────────────────┤
│ v2.0    │ PIE: BakeAdmin v2.0 · Coffee Park · …        │
└─────────┴──────────────────────────────────────────────┘
```

## M.1 Contenedor de toda la pantalla
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `display:flex; min-height:100vh; background:#FCF8F9` | `d-flex min-vh-100 bg-fondo` ✔ |

## M.2 MENÚ LATERAL (izquierda)
**Etiqueta:** `<aside>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo ponerlo pegado a la izquierda** | `position:fixed; top:0; bottom:0; left:0; z-index:50` | `position-fixed top-0 bottom-0 start-0` ✔ (`z-index:50` ✖; en Bootstrap lo resuelve `offcanvas-lg`) |
| Ancho y alto | `width:256px; height:100vh` | ✖ `style="width:256px"` (con offcanvas: `--bs-offcanvas-width:256px`) |
| Colores | `background:#350B1A; color:#fff` | `bg-vino-oscuro text-white` |
| Acomodo | `display:flex; flex-direction:column` (logo arriba, enlaces al medio que crecen, pie abajo) | `d-flex flex-column` ✔ |
| Celular (< 1024 px) | no se ve (`display:none`); se abre como cajón de 288 px con botón ☰ | `offcanvas-lg offcanvas-start` + botón `data-bs-toggle="offcanvas" data-bs-target="#menu"` (sin JS tuyo) |

**M.2.a Bloque del logo (arriba)**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `height:80px; padding:0 16px; display:flex; align-items:center; gap:12px; border-bottom:1px solid rgba(255,255,255,.1)` | `d-flex align-items-center gap-3 px-3 border-bottom` + `style="height:80px"` ✖ |
| Logo | `width:44px; height:44px; border-radius:16px; object-fit:contain; flex-shrink:0` | `rounded-4 object-fit-contain flex-shrink-0` ✔ + tamaño ✖ |
| "BakeAdmin" | `font-size:16px; font-weight:900; line-height:1.25` | `fs-6 fw-black lh-sm` ✔ |
| "Coffee Park" debajo | `font-size:11px; color:#F6B4B8` | `text-rosa` + 11 px ✖ |

**M.2.b Lista de enlaces**
**Etiqueta:** `<nav>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `flex:1; display:flex; flex-direction:column; gap:4px; padding:12px` | `nav flex-column gap-1 p-3 flex-grow-1` (16 ≈ 12) |
| **Cada enlace** `<a>` — acomodo | `display:flex; align-items:center; gap:12px; min-height:44px; padding:0 12px; border-radius:16px` | `nav-link d-flex align-items-center gap-3 rounded-4` ✔ + alto 44 ✖ |
| Letra | `font-size:14px; line-height:20px; font-weight:600; color:rgba(255,255,255,.75)` | `small fw-semibold text-white` + 75 % ✖ |
| Icono | 20 px | — |
| Al pasar el mouse | `background:rgba(255,255,255,.1); color:#fff` | ✖ propio |
| **Activo** (página actual; solo uno) | `background:#F27C86; color:#350B1A; box-shadow:0 1px 3px rgba(0,0,0,.1)` | `nav-link active` con `--bs-nav-pills-link-active-bg:#F27C86; --bs-nav-pills-link-active-color:#350B1A` |

**Qué enlaces ve cada rol:** Inicio (todos) · Usuarios (administrador) · Compras (administrador, gerente, cajera, auxiliar) · Producción (administrador, gerente, cocinero) · Domicilios (administrador, gerente, cajera, mesero) · Mis domicilios (repartidor) · Menú (cliente) · Mis pedidos (cliente). El invitado solo ve "Menú".

**M.2.c Pie del menú**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `border-top:1px solid rgba(255,255,255,.1); padding:12px` | `border-top p-3` ✔ |
| "BakeAdmin v2.0 · 2026" | `font-size:10px; line-height:16px; color:rgba(255,255,255,.35); margin-top:8px; padding:0 12px` | `opacity-50 mt-2` + 10 px ✖ |

## M.3 COLUMNA DERECHA (todo lo que está a la derecha del menú)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Acomodo | `flex:1; min-width:0; display:flex; flex-direction:column`; **desde 1024 px `margin-left:256px`** (para no quedar debajo del menú fijo) | `d-flex flex-column flex-grow-1` ✔ + `margin-left:256px` ✖ propio |

## M.4 BARRA DE ARRIBA
**Etiqueta:** `<header>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo pegarla arriba al hacer scroll** | `position:sticky; top:0; z-index:40` | `sticky-top` ✔ |
| Alto | `height:80px` | ✖ `style="height:80px"` |
| Fondo y línea | `background:rgba(255,255,255,.95); border-bottom:1px solid rgba(116,27,61,.14)` | `bg-white border-bottom` ≈ |
| Relleno lateral | `padding:0 16px` (desde 768 px `0 32px`) | `px-3 px-md-4` (24 ≈ 32) |
| Acomodo | `display:flex; align-items:center` | `d-flex align-items-center` ✔ |

**Lado izquierdo (2 textos, uno sobre otro):**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Sección (ej. "COMPRAS") | `font-size:12px; line-height:16px; font-weight:600; text-transform:uppercase; letter-spacing:.05em; color:#96244F` | `text-uppercase fw-semibold text-vino-medio` + 12 px ✖ + espaciado ✖ |
| Sede (ej. "Coffee Park Centro") | `font-size:14px; line-height:20px; color:#7A6873` (Administrador: "Todas las sedes"; cliente: "Pedidos a domicilio") | `small text-gris` |

**Lado derecho** (caja con `margin-left:auto`; `display:flex; align-items:center; gap:12px`) → Bootstrap: `d-flex align-items-center gap-3 ms-auto` (16 ≈ 12):
| Pieza | CSS | Bootstrap |
|---|---|---|
| 1. Pastilla "Sincronizado" | `background:#00C950; color:#fff; font-size:12px; line-height:16px; font-weight:500; padding:2px 8px; border-radius:10px` | `badge rounded-pill` + fondo `#00C950` ✖ |
| 2. Usuario (solo desde 768 px, alineado a la derecha) | nombre `14px; 700`; debajo el rol `12px; #7A6873` | `d-none d-md-block text-end` + `fw-bold small` / `small text-gris` ✔ |
| 3. Botón "Cerrar sesión" → Login | contorno, `height:44px; border:1px solid #741B3D; color:#741B3D` | `btn btn-outline-primary` + alto 44 ✖ |

## M.5 CONTENIDO PRINCIPAL
**Etiqueta:** `<main>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `flex:1; width:100%; padding:24px 16px` (desde 768 px `24px 32px`) | `flex-grow-1 w-100 py-4 px-3 px-md-4` ✔ |
| Caja interna centrada | `max-width:1440px; margin-inline:auto` | `mx-auto` + `max-width:1440px` ✖ |
| Migas de pan "Inicio / **Compras**" | `font-size:12px; line-height:16px; color:#7A6873; margin-bottom:16px`; la "/" con 4 px de margen a cada lado | `breadcrumb small mb-3` ✔ |

## M.6 PIE
**Etiqueta:** `<footer>`
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `padding:16px 32px; border-top:1px solid rgba(116,27,61,.14); text-align:center` | `border-top py-3 px-4 text-center` ✔ |
| Texto "BakeAdmin v2.0 · Coffee Park · Operación offline habilitada" | `font-size:12px; line-height:16px; color:#7A6873` | `small text-gris` |

**Revisión del marco:** [ ] menú 256 px y no se mueve al hacer scroll · [ ] barra 80 px y se queda pegada arriba · [ ] solo un enlace del menú en coral · [ ] en celular el menú desaparece.

---

<a id="patrones"></a>
# PIEZAS DE PÁGINA QUE SE REPITEN EN EL PANEL

### Patrón A — Encabezado de página con botón (vistas 5, 6, 7, 10)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | celular columna con `gap:16px`; **desde 640 px fila**: `display:flex; justify-content:space-between; align-items:flex-end` (título a la izquierda, botón a la derecha, alineados abajo) | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-end gap-3` ✔ |
| Título `<h1>` | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción `<p>` | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px` | `small text-gris mt-1` ✔ |
| Botón | principal de **44 px** (en Producción de 36 px) | `btn btn-primary` + alto 44 ✖ |

### Patrón D — Barra de filtros
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px` (1 columna en celular; desde 768 px o 1024 px columnas tipo `1fr 220px 240px`, se dice en cada vista) | `row g-2` + `col-12 col-md` / `col-md-auto` (g-2 = 8 ≈ 12; anchos 220/240 ✖) |
| Campos | alto **40 px** | `form-control-sm` (31) ≈ o ✖ `style="height:40px"` |
| Textos | el buscador "Buscar…"; las listas empiezan con "Todos los…" | — |

### Patrón F — Tarjetas de color (alertas en número)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **4 columnas desde 768 px** | `row g-3` + `col-12 col-md-3` ✔ |
| Cada tarjeta | `padding:20px 20px 24px; border-radius:12px; border:1px solid` (colores de estado) | `rounded-3 p-4` ≈ (12 ✖) |
| Etiqueta | `font-size:12px; font-weight:600; text-transform:uppercase` | `small fw-semibold text-uppercase` |
| Valor | `font-size:24px; line-height:32px; font-weight:900; margin-top:4px` | `fs-4 fw-black mt-1` ✔ |

---

<a id="vista-4"></a>
# 4. VISTA INICIO

**Qué es:** la portada del panel: un saludo, **4 tarjetas con números grandes** y abajo **2 cajas lado a lado** (avisos y atajos). Usa el [Marco](#marco). **Quién entra:** todos (cambia el contenido según el rol). **Menú activo:** Inicio. **Barra:** "INICIO" / "Todas las sedes". **Migas:** Inicio.

```
Resumen general
Buenos días, Laura
Visión consolidada de la operación de Coffee Park. · 30/06/2026
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Usuarios│ │Alertas │ │Pedidos │ │Pendient│
│ 28   👥│ │ 4    ⚠│ │ 12   🚚│ │ 3    🕒│
└────────┘ └────────┘ └────────┘ └────────┘
┌─ Alertas y pendientes ─────┐ ┌─ Accesos rápidos ─┐
│ [aviso]            [Ir →]  │ │ [Usuarios      →] │
└────────────────────────────┘ └───────────────────┘
```
Todo en una columna con **24 px** entre bloques: CSS `display:flex; flex-direction:column; gap:24px` · Bootstrap `d-flex flex-column gap-4` ✔.

## 4.1 Encabezado (sin botón)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Módulo (ej. "Resumen general") | `font-size:14px; line-height:20px; font-weight:600; color:#96244F` | `small fw-semibold text-vino-medio` |
| Título "Buenos días, {nombre}" | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción "{texto del rol} · 30/06/2026" | `font-size:14px; line-height:20px; color:#7A6873; margin-top:4px` | `small text-gris mt-1` ✔ |

## 4.2 Cuatro tarjetas de números
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`: 1 columna en celular, **2 desde 640 px, 4 desde 1280 px** | `row g-3` + cada tarjeta `col-12 col-sm-6 col-xl-3` ✔ (xl = 1200 ≈ 1280) |
| **Cada tarjeta** | `background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px` | `card` (esquinas 12 ✖) |
| Interior | `display:flex; justify-content:space-between; align-items:flex-start; gap:12px; padding:20px 20px 24px` (texto a la izquierda, icono a la derecha) | `card-body d-flex justify-content-between align-items-start gap-3` ✔ |
| Etiqueta | `font-size:14px; line-height:20px; color:#7A6873` | `small text-gris` |
| Número | `font-size:30px; line-height:36px; font-weight:900; margin-top:8px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap` | `fw-black text-truncate mt-2` ✔ + 30 ✖ |
| **Caja del icono** | `width:44px; height:44px; border-radius:16px; background:#FCE8EA; color:#741B3D; display:flex; align-items:center; justify-content:center; flex-shrink:0`; icono 20 px | `d-flex align-items-center justify-content-center rounded-4 bg-acento text-vino flex-shrink-0` ✔ + 44 ✖ |

**Contenido por rol (etiqueta → número):**
| Rol | Módulo | Descripción | Las 4 tarjetas |
|---|---|---|---|
| administrador | Resumen general | Visión consolidada de la operación de Coffee Park. | Usuarios activos **28** · Alertas de inventario **4** · Pedidos en curso **12** · Pendientes de factura **3** |
| gerente | Operación de sede | Indicadores y pendientes de Coffee Park Centro. | Pedidos de hoy **47** · Producciones registradas **6** · Traslados en curso **2** · Alertas de inventario **4** |
| cajera | Recepción y pedidos | Órdenes por recibir y operación de domicilios de la sede. | Órdenes por recibir **3** · Pedidos pendientes **5** · En preparación **4** · Domicilios en camino **3** |
| cocinero | Producción | Consumo de insumos, producciones y traslados. | Producciones hoy **6** · Unidades producidas **284** · Traslados pendientes **2** · Insumos insuficientes **1** |
| auxiliar | Facturación de compras | Órdenes recibidas y pendientes contables. | Pendientes de factura **4** · Facturadas hoy **7** · Total recibido **$ 2.840.000** · Proveedores activos **12** |
| mesero | Pedidos de la sede | Seguimiento de pedidos y entregas de Coffee Park Centro. | Pedidos pendientes **5** · Aceptados **3** · En preparación **4** · Despachados **3** |
| repartidor | Mis domicilios | Entregas asignadas y estado de tu recorrido. | Asignados hoy **8** · En camino **2** · Entregados **6** · Pendientes **2** |
| cliente | Mis pedidos | Consulta tus pedidos recientes. | Pedidos activos **1** · En preparación **1** · En camino **0** · Entregados **4** |

Iconos en orden — admin: personas, advertencia, camión, reloj · gerente: carrito, gorro de cocinero, camión, advertencia · cajera: caja con check, carrito, gorro, camión · cocinero: gorro, caja, camión, advertencia · auxiliar: reloj, documento, carrito, personas · mesero: reloj, persona con check, gorro, camión · repartidor: caja, camión, círculo con check, reloj · cliente: carrito, gorro, camión, círculo con check.

## 4.3 Dos tarjetas lado a lado
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px dos columnas `1.2fr .8fr`** (la izquierda un poco más ancha) | `row g-4` + `col-12 col-lg-7` y `col-12 col-lg-5` ≈ (58/42 %; el diseño es 60/40) |

**Tarjeta izquierda "Alertas y pendientes"** (tarjeta estándar de 0.1; cuerpo con `gap:12px`)
| Pieza | CSS | Bootstrap |
|---|---|---|
| **Cada fila de aviso** | `border:1px solid rgba(116,27,61,.14); border-radius:16px; padding:16px; display:flex; flex-direction:column; gap:12px`; desde 640 px fila: `flex-direction:row; justify-content:space-between; align-items:center` (texto a la izquierda, botón a la derecha) | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 border rounded-4 p-3` ✔ |
| Texto | `font-size:14px; font-weight:600` con icono de 20 px `#741B3D` | `small fw-semibold` + `text-vino` |
| Botón | contorno **pequeño (32 px)**, texto de la acción + flecha → | `btn btn-outline-secondary btn-sm` ≈ |

**Tarjeta derecha "Accesos rápidos"** (cuerpo con `gap:8px`)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Cada botón | contorno, `height:48px; width:100%; display:flex; align-items:center; gap:8px`; icono 16 px + texto a la **izquierda**, flecha → empujada a la derecha (`margin-left:auto`) | `btn btn-outline-secondary btn-lg w-100 text-start fs-6 d-flex align-items-center gap-2` y flecha `ms-auto` ✔ (contenedor `d-grid gap-2`) |

**Revisión Inicio:** [ ] 1440 px: 4 tarjetas en fila; 1024: de 2 en 2; celular: una por una · [ ] número 30 px/900, caja de icono 44 × 44 · [ ] desde 1024 px las dos tarjetas de abajo lado a lado.

---

<a id="vista-5"></a>
# 5. VISTA USUARIOS Y SEGURIDAD

**Qué es:** la lista de personas que pueden entrar al sistema, con **3 pestañas**: Usuarios, Roles y permisos, Sedes. **Quién entra:** solo el administrador. **Menú activo:** Usuarios. **Barra:** "USUARIOS". Usa el [Marco](#marco).

```
Usuarios y seguridad                         [+ Nuevo usuario]
Administra accesos, permisos y sedes de Coffee Park.
[ Usuarios ][ Roles y permisos ][ Sedes ]
┌─ Lista de usuarios ────────────────────────────┐
│ [buscar…] [Rol▾] [Sede▾] [Estado▾]             │
│ ┌ tabla: Nombre|Correo|Rol|Sede|Estado|Acc. ┐  │
│ Mostrando 4 de 4                   [‹][1][›]  │
└────────────────────────────────────────────────┘
```

## 5.1 Encabezado (Patrón A)
Título "**Usuarios y seguridad**" · descripción "**Administra accesos, permisos y sedes de Coffee Park.**" · botón principal **44 px** "**+ Nuevo usuario**" (abre la ventana 5.6). Medidas: ver Patrón A.

## 5.2 Pestañas (ver pieza "Pestañas" de 0.1)
**Usuarios · Roles y permisos · Sedes.** Abierta: Usuarios. Si no caben, la barra se parte en varios renglones: CSS `flex-wrap:wrap` · Bootstrap `flex-wrap`. Contenido a 20 px debajo (`mt-4` ≈).

## 5.3 Pestaña USUARIOS — tarjeta "Lista de usuarios" (cuerpo en columna con `gap:16px`)
**a) Filtros**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px`; **desde 1024 px 4 columnas `1fr 190px 190px 160px`**; campos de **40 px** | `row g-2` + `col-12 col-lg` y `col-lg-auto` ✔ (anchos 190/160 ✖) |
| Buscador | placeholder "Buscar por nombre o correo…" | `form-control` |
| 3 listas | "Todos los roles" (Administrador, Gerente de sede, Cocinero, Mesero, Repartidor, Cliente) · "Todas las sedes" (Sin sede + sedes) · "Todos" (Activo, Inactivo) | `form-select` |

**b) Tabla** (pieza Tabla de 0.1). Columnas: **Nombre completo · Correo · Rol · Sede · Estado · Acciones**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-weight:600` | `fw-semibold` |
| Estado | **Activo** = insignia verde · **Inactivo** = insignia gris (fondo `#F1F5F9`, letra `#45556C`, borde `#E2E8F0`) | `badge border bg-success-subtle text-success-emphasis` / `bg-secondary-subtle text-secondary-emphasis` ≈ |
| Columna Acciones | alineada a la **derecha** (`text-align:right`); botones con `gap:4px`: "Editar" (fantasma pequeño) y "Desactivar" / "Activar" (fantasma pequeño, letra `#C10007`) | `text-end` ✔ + `btn btn-sm btn-link` / `btn-sm btn-link text-danger` |

| Nombre | Correo | Rol | Sede | Estado |
|---|---|---|---|---|
| Laura Martínez | admin@bakeadmin.com | Administrador | Sin sede | Activo |
| Andrés Rojas | gerente@bakeadmin.com | Gerente de sede | Coffee Park Centro | Activo |
| María Gómez | cajera@bakeadmin.com | Cajera | Coffee Park Centro | Activo |
| Carlos Pérez | domiciliario@bakeadmin.com | Repartidor | Coffee Park Centro | Inactivo |

**c) Pie de la tabla**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:center; font-size:14px; color:#7A6873` | `d-flex justify-content-between align-items-center small text-gris` ✔ |
| Izquierda | "Mostrando 4 de 4" | — |
| Derecha: 3 botones cuadrados (‹ desactivado, 1, › desactivado) | contorno, `width:36px; height:36px`, `gap:4px` | `pagination pagination-sm` + `page-item disabled` (36 × 36 ✖) |

## 5.4 Pestaña ROLES Y PERMISOS
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px `280px 1fr`** | `row g-4` + `col-12 col-lg-3` y `col-12 col-lg-9` ≈ |

**Tarjeta "Roles" (izquierda)** — lista en columna con `gap:4px`; cada rol es un botón:
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Botón de rol | `width:100%; min-height:44px; padding:0 12px; border-radius:16px; font-size:14px; font-weight:600; display:flex; justify-content:space-between; align-items:center` (texto a la izquierda; ✓ de 16 px a la derecha **si está elegido**) | `list-group-item list-group-item-action d-flex justify-content-between` ≈ |
| Elegido | fondo `#FCE8EA`, letra `#741B3D` | `active` con colores propios |
| Mouse encima | fondo `#F2EEF1` | ≈ |

**Tarjeta "Permisos de {rol}" (derecha)** — el título lleva un escudo con check (24 px, `#741B3D`) con 8 px de separación.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Grilla de casillas | `display:grid; gap:8px`; **2 columnas desde 768 px**; 12 casillas | `row g-2` + `col-12 col-md-6` ✔ |
| Cada casilla | `display:flex; align-items:center; gap:12px; min-height:48px; padding:12px; border:1px solid rgba(116,27,61,.14); border-radius:16px`; checkbox de 16 px + nombre en `<code>` | `form-check border rounded-4 p-3` ≈ |
| Botón "Guardar permisos del rol" | principal, margen arriba 20 px | `btn btn-primary mt-4` ≈ |

Los 12 permisos: `usuarios.gestionar` · `catalogo.consultar` · `productos.gestionar` · `compras.gestionar` · `compras.recibir` · `facturas.gestionar` · `inventario.consultar` · `produccion.registrar` · `traslados.gestionar` · `pedidos.crear` · `pedidos.gestionar` · `domicilios.entregar` (Administrador: todos marcados; Gerente: todos menos `usuarios.gestionar`).

## 5.5 Pestaña SEDES
Tarjeta "**Sedes**" con el botón "**+ Nueva sede**" **debajo del título** (regla de tarjeta). Tabla **Nombre · Dirección · Teléfono · Tipo · Estado** (Estado = insignia verde "Activo"):
| Nombre | Dirección | Teléfono | Tipo |
|---|---|---|---|
| Planta de producción | Zona Industrial, Bodega 14 | 601 555 1000 | Planta |
| Coffee Park Centro | Cra. 7 # 18-40 | 601 555 1001 | Punto de venta |
| Coffee Park Norte | Calle 127 # 19-20 | 601 555 1002 | Punto de venta |

## 5.6 Ventanas
**Nuevo / Editar usuario** (ancho máximo **768 px**, alto máximo 92 % con barra vertical; Bootstrap `modal-lg` ≈ 800 o `style="max-width:768px"`). Tres bloques con `gap:20px`:
| Bloque | Contenido |
|---|---|
| **"Acceso"** (caja con borde, esquinas 16, relleno 16; título 16 px/700 con margen abajo 16; grilla de 2 columnas desde 768 px, gap 16) | Correo (login) · Contraseña (al editar: "Nueva contraseña (opcional)") · Correo de recuperación · Rol · Sede (no aparece si el rol es Cliente o Administrador) · Estado |
| **"Información complementaria"** (misma caja) | Nombres · Apellidos · Tipo de documento (CC, CE, TI, PP, NIT) · Número de documento · Teléfono · Dirección |
| **Aviso ámbar** | "Un usuario con operaciones registradas no puede cambiar de sede; cree otro usuario para la nueva sede." |
Cada campo: etiqueta + campo separados 6 px; errores 12 px `#E7000B` (mismos textos de Registrarse + "Los nombres son obligatorios." etc.). Pie: **Cancelar** (contorno) y **Guardar** (principal).
**Nueva sede** (**512 px**): Nombre · Dirección · Teléfono · Tipo (Planta / Punto de venta) · Estado. Error: "El nombre es obligatorio".

**Revisión Usuarios:** [ ] menú "Usuarios" en coral · [ ] 3 pestañas · [ ] filtros en fila de 4 desde 1024 · [ ] Acciones a la derecha · [ ] paginación 36 × 36 · [ ] Roles: elegido en rosa con ✓ y 12 casillas en 2 columnas.

---
<a id="vista-6"></a>
# 6. VISTA COMPRAS A PROVEEDORES

**Qué es:** la "tienda de ingredientes". Arriba el título y el botón "Nueva orden"; debajo **6 pestañas** (Alertas, Proveedores, Insumos, Órdenes, Recepción, Facturación); cada una muestra una tarjeta blanca con tabla. Se ve **una a la vez**. Usa el [Marco](#marco).
**Quién entra:** administrador, gerente, cajera, auxiliar. **Menú activo:** Compras. **Barra:** "COMPRAS" / "Coffee Park Centro". **Migas:** Inicio / Compras.

```
Compras a proveedores                           [+ Nueva orden]
Controla inventario, órdenes, recepción y facturación.
[Alertas][Proveedores][Insumos][Órdenes][Recepción][Facturación]
┌ rojo ┐┌ ámbar ┐┌ azul ┐┌ vino ┐     ← 4 tarjetas de color
│Sin st││Bajo mí││En cam││Sede   │
┌─ Semáforo de inventario ───────────────────────────┐
│ Cantidades en g, ml o und.                         │
│ [🛒 Crear orden con lo sugerido]                   │
│ ┌ tabla ────────────────────────────────────────┐  │
└────────────────────────────────────────────────────┘
```

## 6.1 Encabezado (Patrón A)
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | columna `gap:16px`; desde 640 px fila `justify-content:space-between; align-items:flex-end` | `d-flex flex-column flex-sm-row justify-content-between align-items-sm-end gap-3` ✔ |
| Título "Compras a proveedores" | `font-size:30px; line-height:36px; font-weight:900; color:#350B1A` | `h1 fw-black text-vino-oscuro` + 30 ✖ |
| Descripción "Controla inventario, órdenes, recepción y facturación." | `14px/20px; #7A6873; margin-top:4px` | `small text-gris mt-1` |
| **Botón "+ Nueva orden"** (a la derecha del título) | principal, `height:44px`; el + es un icono de 16 px | `btn btn-primary` + alto 44 ✖ (`btn-lg` = 48) |

## 6.2 Pestañas (6)
Pieza "Pestañas" de 0.1. Textos: **Alertas · Proveedores · Insumos · Órdenes · Recepción · Facturación**. Abierta por defecto: **Alertas**. Si no caben, la barra se desliza en horizontal (`overflow-x:auto` · `overflow-x-auto flex-nowrap`). Contenido a **20 px** de la barra.
Bootstrap: `<ul class="nav nav-pills nav-fill bg-white rounded-4 shadow-sm p-1 overflow-x-auto flex-nowrap">`, cada `<button class="nav-link" data-bs-toggle="pill" data-bs-target="#p1">…`, y los 6 paneles dentro de `<div class="tab-content mt-4">` con `tab-pane fade show active` (el primero) y `tab-pane fade` (los demás).

## 6.3 PESTAÑA 1 — ALERTAS (bloques separados 16 px: CSS `gap:16px` · Bootstrap `d-flex flex-column gap-3` ✔)

### 6.3.1 Cuatro tarjetas de color (Patrón F)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **4 desde 768 px** | `row g-3` + `col-12 col-md-3` ✔ |
| Cada tarjeta | `padding:20px 20px 24px; border-radius:12px; border:1px solid …` | `rounded-3 p-4` ≈ |
| Etiqueta | `12px; font-weight:600; MAYÚSCULAS` | `small fw-semibold text-uppercase` |
| Valor | `24px/32px; font-weight:900; margin-top:4px` | `fs-4 fw-black mt-1` ✔ |

| Etiqueta | Valor | Fondo | Letra | Bootstrap ≈ |
|---|---|---|---|---|
| Sin stock | **1** | `#FEF2F2` | `#C10007` | `bg-danger-subtle text-danger-emphasis` |
| Bajo mínimo | **1** | `#FFFBEB` | `#973C00` | `bg-warning-subtle text-warning-emphasis` |
| En camino | **10.000 und.** | `#EFF6FF` | `#1447E6` | ✖ propio |
| Sede | **Coffee Park Centro** | `#FCE8EA` | `#741B3D` | `bg-acento text-vino` |

### 6.3.2 Tarjeta "Semáforo de inventario"
| Pieza | CSS | Bootstrap |
|---|---|---|
| Tarjeta | pieza Tarjeta (0.1): blanca, borde, esquinas 12, relleno 24, `gap:24px` | `card` > `card-body p-4` |
| Encabezado (3 cosas, **una debajo de otra**, `gap:6px`) | título "Semáforo de inventario" `16px/500`; subtítulo "Cantidades en g, ml o und." `14px; #7A6873`; botón principal **pequeño (32 px)** "🛒 Crear orden con lo sugerido" | `h6 fw-medium mb-1` · `small text-gris` · `btn btn-primary btn-sm mt-2` ✔ |

**Tabla** (pieza Tabla de 0.1). Columnas: **Insumo · Estado · Stock actual · En camino · Mínimo · Máximo · Sugerido**.
| Columna | CSS | Bootstrap |
|---|---|---|
| Insumo | nombre `font-weight:600` y **debajo** el proveedor `12px; #7A6873` | `fw-semibold` + `<small class="d-block text-gris">` |
| Estado | insignia **en MAYÚSCULAS** con borde | `badge text-uppercase border` + color |
| Sugerido | `font-weight:700; color:#741B3D` | `fw-bold text-vino` |

Regla del estado: stock = 0 → **SIN STOCK** (rojo) · stock < mínimo → **BAJO MÍNIMO** (ámbar) · stock > máximo → **SOBRE MÁXIMO** (azul) · si no → **OK** (verde). Sugerido = máximo − stock − en camino (mínimo 0).
| Insumo (proveedor) | Estado | Stock | En camino | Mín. | Máx. | Sugerido |
|---|---|---|---|---|---|---|
| Harina de trigo (Molinos Andinos S.A.S.) | BAJO MÍNIMO | 12.000 g | 0 g | 30.000 | 90.000 | **78.000 g** |
| Levadura (Molinos Andinos S.A.S.) | OK | 2.600 g | 0 g | 2.000 | 6.000 | **3.400 g** |
| Leche entera (Lácteos La Sabana) | SIN STOCK | 0 ml | 10.000 ml | 20.000 | 60.000 | **50.000 ml** |
| Huevos (Lácteos La Sabana) | SOBRE MÁXIMO | 410 und | 0 und | 120 | 360 | **0 und** |

## 6.4 PESTAÑA 2 — PROVEEDORES
Tarjeta "**Proveedores**" con botón principal "**+ Nuevo proveedor**" debajo del título. Tabla: **NIT · Nombre · Correo · Teléfono · Estado · Insumos que ofrece**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-weight:600` | `fw-semibold` |
| Correo vacío | texto "Sin correo" `12px; #7A6873` | `small text-gris` |
| Estado | Activo (verde) / Inactivo (gris) | `badge …` |
| Insumos que ofrece | `14px`, **uno por renglón**: "Harina de trigo · $ 4 / g" | `d-block` por línea |
| Dinero | pesos sin decimales con punto de miles: `$ 4.200` | — |
| NIT | Nombre | Correo | Teléfono | Estado | Insumos |
|---|---|---|---|---|---|
| 900.234.110-8 | Molinos Andinos S.A.S. | pedidos@molinosandinos.co | 601 555 0130 | Activo | Harina de trigo · $ 4 / g · Levadura · $ 18 / g |
| 901.880.221-2 | Lácteos La Sabana | *Sin correo* | 601 555 0220 | Activo | Leche entera · $ 5 / ml · Huevos · $ 620 / und |
| 800.115.900-4 | Empaques del Café | ventas@empaques.co | 601 555 0310 | Inactivo | — |

## 6.5 PESTAÑA 3 — INSUMOS
Tarjeta "**Catálogo de insumos**" + botón "**+ Nuevo insumo**". Tabla: **Nombre · Unidad · Stock mínimo · Stock máximo · 🔒 Costo de la última compra (calculado) · Estado**. El título de la 5.ª columna lleva un candado de 12 px con 4 px de separación (CSS `display:inline-flex; gap:4px` · Bootstrap `d-inline-flex gap-1`).
| Nombre | Unidad | Mínimo | Máximo | Costo | Estado |
|---|---|---|---|---|---|
| Harina de trigo | g | 30.000 | 90.000 | $ 4 / g | Activo |
| Levadura | g | 2.000 | 6.000 | $ 18 / g | Activo |
| Leche entera | ml | 20.000 | 60.000 | $ 5 / ml | Activo |
| Huevos | und | 120 | 360 | $ 620 / und | Activo |

## 6.6 PESTAÑA 4 — ÓRDENES
Tarjeta "**Órdenes de compra**", cuerpo en columna con `gap:16px`.
**a) Filtros (Patrón D)**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:grid; gap:12px; grid-template-columns:1fr` y desde 768 px `1fr 220px 240px`; campos 40 px | `row g-2` + `col-12 col-md` / `col-md-auto` (220/240 ✖) |
| Buscador | "Buscar número o proveedor…" | `form-control` |
| Lista 1 | "Todos los estados" (Borrador, Enviada, Pendiente de factura, Facturada, Cancelada, Rechazada) | `form-select` |
| Lista 2 | "Todos los proveedores" | `form-select` |

**b) Tabla:** **Número · Proveedor · Fecha · Estado · Total calculado · Acciones**.
| Pieza | CSS | Bootstrap |
|---|---|---|
| Número | monoespaciada, `font-weight:700` | `font-monospace fw-bold` ✔ |
| Total | `font-weight:700` | `fw-bold` |
| Acciones (solo si es Borrador) | `display:flex; gap:8px`: "Enviar orden" (principal pequeño) y "Cancelar orden" (contorno pequeño) | `d-flex gap-2` + `btn btn-primary btn-sm` / `btn btn-outline-secondary btn-sm` ✔ |
| Colores de estado | Borrador gris · Enviada azul · Pendiente de factura ámbar · Facturada verde · Cancelada rojo · Rechazada rojo fuerte | |
| Número | Proveedor | Fecha | Estado | Total |
|---|---|---|---|---|
| OC-2026-0041 | Molinos Andinos S.A.S. | 28/06/2026 | Borrador | $ 327.600 |
| OC-2026-0040 | Lácteos La Sabana | 27/06/2026 | Enviada | $ 314.400 |
| OC-2026-0039 | Molinos Andinos S.A.S. | 26/06/2026 | Pendiente de factura | $ 45.000 |

## 6.7 PESTAÑA 5 — RECEPCIÓN
Tarjeta "**Recepción de pedidos**", subtítulo "**Órdenes enviadas de Coffee Park Centro.**" Tabla: **Número · Proveedor · Fecha · Líneas · Estado · (sin título)**. Muestra órdenes Enviada, Pendiente de factura o Rechazada.
| Última celda | CSS | Bootstrap |
|---|---|---|
| Si la orden está **Enviada** | botón pequeño de contorno "📦 Revisar líneas" (abre la ventana Recepción) | `btn btn-outline-secondary btn-sm` + `data-bs-toggle="modal"` |
| Si no | texto `12px; #7A6873`: "{recibidoPor} · {fecha}" | `small text-gris` |
| Número | Proveedor | Fecha | Líneas | Estado | Última celda |
|---|---|---|---|---|---|
| OC-2026-0040 | Lácteos La Sabana | 27/06/2026 | 2 | Enviada | Revisar líneas |
| OC-2026-0039 | Molinos Andinos S.A.S. | 26/06/2026 | 1 | Pendiente de factura | María Gómez · 27/06/2026 09:42 |

## 6.8 PESTAÑA 6 — FACTURACIÓN
Tarjeta "**Órdenes pendientes de factura**". Tabla: **Número · Proveedor · Sede · Fecha de recepción · Total recibido · (botón)**. Fila: OC-2026-0039 · Molinos Andinos S.A.S. · Coffee Park Centro · 27/06/2026 09:42 · **$ 45.000** · botón pequeño de contorno "📄 Marcar como facturada". Si ya está facturada, el botón se cambia por una insignia verde "Facturada".

## 6.9 Ventanas de Compras
| Ventana | Título | Ancho máx. (desde 640 px) | CSS | Bootstrap |
|---|---|---|---|---|
| Crear orden | "Crear orden de compra" | **896 px** | `max-width:896px` | `modal-xl` ≈ (1140) → `style="max-width:896px"` |
| Enviar orden | "Enviar orden OC-2026-0041" | **672 px** | `max-width:672px` | `style="max-width:672px"` |
| Recepción | "Recepción OC-2026-0040" | **768 px** | `max-width:768px` | `modal-lg` ≈ (800) |
| Confirmar facturación | "Confirmar facturación" | **512 px** | `max-width:512px` | default ≈ (500) |
| Nuevo proveedor | "Nuevo proveedor" | **512 px** | | default ≈ |
| Nuevo insumo | "Nuevo insumo" | **512 px** | | default ≈ |

**Crear orden de compra** (de arriba a abajo):
1. **Tarjeta de datos:** relleno 16 px (24 abajo); grilla de **3 columnas desde 768 px**, gap 16: *Proveedor* (lista, solo activos) · *Creador 🔒* (campo desactivado "Laura Martínez") · *Sede 🔒* (campo desactivado "Coffee Park Centro"). Etiqueta con candado: fila, `gap:4px`. Bootstrap: `row g-3` + `col-12 col-md-4`; campo desactivado `form-control` con `disabled`.
2. **Líneas:** fila `space-between`: título "**Líneas**" (16 px/700) a la izquierda y botón pequeño de contorno "**+ Agregar línea**" a la derecha. **Cada línea** es una caja: borde, esquinas 16 px, relleno 12 px, `gap:12px`, con grilla de **4 columnas `1.2fr .8fr .8fr .8fr`** desde 768 px (Bootstrap `border rounded-4 p-3` + `row g-3` y `col-md-3`/`col-md`): *Insumo* (lista) · *Cantidad pedida* (número) · *Precio pactado* (número) · *Subtotal 🔒* (desactivado, en pesos).
   Si `stock + en camino + cantidad > máximo`: caja con borde `#FFA2A2` y fondo `rgba(254,242,242,.5)` y abajo (las 4 columnas) error `12px; font-weight:500; #E7000B`: "Supera el stock máximo de este insumo (stock + en camino + pedido)".
3. **Pie:** **Cancelar** (contorno) y **Guardar borrador** (principal).

**Enviar orden** — una **hoja de papel**: CSS `background:#fff; border:1px solid …; border-radius:16px; padding:24px; box-shadow:0 1px 3px rgba(0,0,0,.1)` · Bootstrap `border rounded-4 p-4 bg-white shadow-sm` ✔. Dentro: arriba-izquierda "**Coffee Park**" (`20px; 900; #741B3D`) y debajo "Orden de compra" (14 px); arriba-derecha el número en monoespaciada 700; línea inferior; "**Proveedor:** …" y "**Sede:** …" (14 px); tabla **Insumo · Cantidad · Precio · Subtotal**; abajo a la derecha "**Total: $ 327.600**" (`20px; 900`). Debajo, grilla de 2 columnas (desde 640 px) con dos botones de **48 px**: "✉ Enviar por correo automático" (principal; **desactivado** si el proveedor no tiene correo, con ayuda "El proveedor no tiene correo registrado") y "⬇ Descargar PDF para enviar manualmente" (contorno). Bootstrap: `row g-2` + `col-sm-6` + `btn btn-lg w-100 fs-6`.

**Recepción** — por cada línea una caja (borde, esquinas 16 px, relleno 16 px; ya revisada: fondo `rgba(240,253,244,.4)`). Fila `space-between`: izquierda nombre (700) y "Cantidad pedida: N" (14 px gris); derecha campo numérico de **144 px** de ancho (ejemplo "Recibida", desactivado hasta revisar). Debajo 3 botones pequeños con `gap:8px`: "**Llegó completo**" (principal), "**Llegó parcial**" (contorno), "**No llegó**" (contorno, letra `#C10007`). Si todas están revisadas aparece una franja `#EFF6FF`, esquinas 16, relleno 12, `14px; 600; #193CB8`: "Orden en Pendiente de factura" (o "Orden Rechazada: no llegó nada"). Pie: **Cerrar** y **Finalizar recepción** (desactivado hasta revisar todas).

**Confirmar facturación** — texto `14px; #7A6873`: "¿Desea marcar la orden **OC-2026-0039** como facturada? Este cambio quedará registrado." Pie: Cancelar / Confirmar.
**Nuevo proveedor** — `gap:12px` entre bloques: Nit · Nombre · Correo (opcional; ayuda `12px` gris "Sin correo, la orden solo puede enviarse como PDF manual.") · Teléfono · Estado (Activo/Inactivo). Pie: Cancelar / Guardar.
**Nuevo insumo** — Nombre · Unidad de medida (g / ml / und) · Stock mínimo · Stock máximo (si es menor que el mínimo: error `12px; #E7000B` "El máximo no puede ser menor que el mínimo." y se desactiva Guardar) · Estado.

**Revisión Compras:** [ ] menú "Compras" en coral · [ ] botón "Nueva orden" de 44 px a la derecha del título (desde 640 px) · [ ] 6 pestañas, la elegida se distingue · [ ] 4 tarjetas de color en 4 columnas desde 768 px · [ ] insignias con borde (BAJO MÍNIMO ámbar, SIN STOCK rojo, OK verde, SOBRE MÁXIMO azul) · [ ] en cada tarjeta el botón queda **debajo** del título · [ ] números de orden en monoespaciada, totales en negrita.

---

<a id="vista-7"></a>
# 7. VISTA PRODUCCIÓN Y TRASLADOS

**Qué es:** "la cocina": dices cuántos panes hiciste, el sistema calcula los ingredientes gastados y puedes enviar panes a otras sedes (traslados). **4 pestañas.** **Quién entra:** administrador, gerente, cocinero. **Menú activo:** Producción. **Barra:** "PRODUCCIÓN". Usa el [Marco](#marco).

```
Producción y traslados                         [+ Nuevo producto]
Recetas, consumos e inventario de producto terminado.
[Registrar producción][Productos y recetas][Inventario terminado][Traslados]
┌─ 👨‍🍳 Nueva producción ─┐ ┌─ Consumo de insumos (calculado en vivo) ─┐
│ Producto  [lista]      │ │ [Harina de trigo   850 g  ✔ Suficiente] │
│ Cantidad  [10]         │ │ [Mantequilla       320 g  ✔ Suficiente] │
│ [   Registrar   ]      │ └─────────────────────────────────────────┘
└────────────────────────┘
┌─ Histórico de producciones ────────────────────────────┐
```

## 7.1 Encabezado (Patrón A)
Igual que 6.1 con: título "**Producción y traslados**", descripción "**Recetas, consumos e inventario de producto terminado.**" y botón principal **de 36 px (tamaño normal)** "**+ Nuevo producto**" (aquí NO es de 44). Bootstrap: `btn btn-primary` ≈ (38 px).

## 7.2 Pestañas (4)
**Registrar producción · Productos y recetas · Inventario terminado · Traslados.** Abierta: la primera. Contenido a 20 px. (Pieza Pestañas de 0.1.)

## 7.3 PESTAÑA 1 — REGISTRAR PRODUCCIÓN (bloques con 20 px: `gap:20px` · `gap-4` ≈)

### 7.3.1 Fila de dos tarjetas
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:20px`; 1 columna en celular; **desde 1024 px `.8fr 1.2fr`** (la derecha más ancha) | `row g-4` + `col-12 col-lg-5` y `col-12 col-lg-7` ≈ (40/60) |

**Tarjeta "Nueva producción"** — el título lleva un gorro de cocinero (24 px, `#741B3D`, `gap:8px`). Cuerpo con `gap:16px`:
| Pieza | CSS | Bootstrap |
|---|---|---|
| *Producto* | etiqueta + lista de **44 px** con los productos activos (etiqueta pegada, 6 px) | `form-label` + `form-select` (44 ✖) |
| *Cantidad producida* | campo numérico de **44 px**, mínimo 1, valor inicial **10** | `form-control` (44 ✖) |
| Aviso rojo (solo si no alcanza el stock) | aviso rojo de 0.1: "Stock insuficiente de insumos en la sede para esta producción" con icono de 20 px | `alert alert-danger d-flex gap-2` |
| Botón "Registrar" | principal, **48 px**, ancho completo; **desactivado** si no se puede producir | `btn btn-primary btn-lg w-100 fs-6` + `disabled` |
| Nota | `12px; #7A6873`: "Sede automática: Planta de producción" | `small text-gris` |

**Tarjeta "Consumo de insumos"** — título + "(calculado en vivo)" (`12px; font-weight:400; #7A6873; margin-left:4px`). Cuerpo con `gap:12px`. **Cada fila de insumo:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:center; border:1px solid; border-radius:16px; padding:16px` | `d-flex justify-content-between align-items-center border rounded-4 p-3` ✔ |
| Izquierda | nombre `font-weight:700` y debajo "Stock disponible: N unidad" `12px` gris | `fw-bold` + `small text-gris d-block` |
| Derecha (alineada a la derecha) | "N unidad" `font-weight:900` y debajo `12px; 600` con icono 16 px: **Suficiente** (círculo con check, `#008236`) o **Insuficiente** (círculo con X, `#C10007`) | `text-end fw-black` + `small fw-semibold` |
| Fila suficiente | borde `#B9F8CF`, fondo `rgba(240,253,244,.5)` | `border-success-subtle bg-success-subtle` ≈ |
| Fila insuficiente | borde `#FFC9C9`, fondo `#FEF2F2` | `border-danger-subtle bg-danger-subtle` ≈ |
Datos (Croissant × 10): Harina de trigo **850 g** (stock 42.000 g) · Mantequilla **320 g** (stock 12.500 g) · Leche entera **220 ml** (stock 32.000 ml): las tres suficientes.

### 7.3.2 Tarjeta "Histórico de producciones" (ancho completo)
Tabla **Producto · Cantidad · Usuario · Fecha**: *Pan de queso · 48 und · Juan Panadero · 30/06/2026 06:45*. Debajo (margen 12 px) nota `12px` gris: "*Las producciones registradas no se editan ni se eliminan.*"

## 7.4 PESTAÑA 2 — PRODUCTOS Y RECETAS
Tarjeta "**Productos**"; tabla **Nombre · Precio de venta · % IVA · 🔒 Costo de receta (calculado) · Estado · Receta**. Nombre en `700`. "Ver receta" = botón pequeño de contorno (abre la ventana de receta).
| Nombre | Precio | IVA | Costo | Estado | Receta |
|---|---|---|---|---|---|
| Croissant de mantequilla | $ 6.500 | 19% | $ 1.840 | Activo | Ver receta |
| Pan de queso | $ 4.800 | 0% | $ 1.420 | Activo | Ver receta |
| Torta de chocolate | $ 8.200 | 19% | $ 2.900 | Activo | Ver receta |

## 7.5 PESTAÑA 3 — INVENTARIO TERMINADO
Tarjeta "**Inventario de producto terminado**" + subtítulo "**Solo consulta. Se actualiza con producciones, traslados y pedidos.**" Tabla **Sede · Producto · Stock actual** (stock en `font-weight:900`, "128 und"): Planta de producción · Croissant de mantequilla · 128 — Planta de producción · Pan de queso · 94 — Coffee Park Centro · Croissant de mantequilla · 24 — Coffee Park Norte · Pan de queso · 18.

## 7.6 PESTAÑA 4 — TRASLADOS
Tarjeta "**Traslados**" + subtítulo "**Planta de producción hacia puntos de venta.**" + botón "**+ Crear traslado**". Tabla **Número · Origen · Destino · Estado · Envía / recibe · Fechas · Acciones**.
| Columna | CSS | Bootstrap |
|---|---|---|
| Número | monoespaciada 700 | `font-monospace fw-bold` |
| Estado | Pendiente ámbar · En tránsito azul · Recibido verde · Cancelado rojo | `badge …` |
| Envía / recibe | nombre y debajo (12 px gris) quien recibe o "Pendiente de recepción" | `small d-block text-gris` |
| Fechas | `12px`; "Sin despacho" si no hay | `small` |
| Acciones | Pendiente → "Despachar" (principal pequeño) + "Cancelar" (contorno pequeño); En tránsito → "Recibir" (contorno pequeño) | `btn btn-sm` |
| Número | Origen | Destino | Estado | Envía / recibe | Fechas |
|---|---|---|---|---|---|
| TR-2026-0088 | Planta de producción | Coffee Park Centro | En tránsito | Juan Panadero / Pendiente de recepción | 30/06/2026 08:20 |
| TR-2026-0087 | Planta de producción | Coffee Park Norte | Recibido | Juan Panadero / Diana Torres | 29/06/2026 07:55 · 29/06/2026 09:10 |

## 7.7 Ventanas de Producción
- **Nuevo producto** (512 px): Nombre · Precio de venta · Porcentaje de IVA (inicial 19) · Estado.
- **Receta · {producto}** (672 px): si ya se usó, aviso ámbar con candado "*Una receta que ya se usó en producciones no se modifica; cree otro producto o desactive este.*"; tabla **Insumo · Cantidad para 1 unidad · Unidad**; botón de contorno "**+ Agregar insumo**" (desactivado si ya se usó); pie: **Cerrar** (principal).
- **Crear traslado** (672 px): *Sede destino* (lista: Coffee Park Centro, Norte, Occidente, Sur) con nota `12px` "*Origen automático: Planta de producción*"; por cada producto una caja (borde, esquinas 16 px, relleno 12 px, 2 columnas desde 768 px) con *Producto* (+ "Disponible: N und" 12 px) y *Cantidad* (+ error `12px; #E7000B` "*Stock insuficiente en origen.*"); botón de contorno "**+ Agregar producto**"; pie: Cancelar / **Guardar traslado**.

**Revisión Producción:** [ ] botón "Nuevo producto" de 36 px · [ ] 4 pestañas · [ ] dos tarjetas lado a lado desde 1024 (la derecha más ancha) · [ ] campos 44, botón Registrar 48 · [ ] 3 filas de consumo con borde verde claro y "✔ Suficiente".

---
<a id="vista-8"></a>
# 8. VISTA DOMICILIOS

**Qué es:** un tablero con **5 cajones** (como un archivador): Pendiente → Aceptado → En preparación → Despachado → Entregado. Cada pedido es una tarjetita. Tiene 3 pestañas. **Quién entra:** administrador, gerente, cajera, mesero. **Menú activo:** Domicilios. **Barra:** "DOMICILIOS". Usa el [Marco](#marco).

```
Domicilios
Pedidos, asignación automática y prefacturación para ICG.
[Tablero de pedidos][Carga de repartidores][Ventas por día]
┌Pendiente─┐┌Aceptado──┐┌En prepar.┐┌Despachado┐┌Entregado─┐
│● 1       ││● 1       ││● 1       ││● 1       ││● 1       │
│ [tarjeta]││ [tarjeta]││ [tarjeta]││ [tarjeta]││ [tarjeta]│
└──────────┘└──────────┘└──────────┘└──────────┘└──────────┘
```

## 8.1 Encabezado (sin botón)
Título "**Domicilios**" (`30px/36px; 900; #350B1A`) · descripción "**Pedidos, asignación automática y prefacturación para ICG.**" (`14px; #7A6873; margin-top:4px`). Bootstrap: `h1 fw-black text-vino-oscuro` / `small text-gris mt-1`.

## 8.2 Pestañas (3)
**Tablero de pedidos · Carga de repartidores · Ventas por día.** Abierta: Tablero. Contenido a 20 px. Bootstrap: `nav nav-pills nav-fill` + `data-bs-toggle="pill"`.

## 8.3 PESTAÑA 1 — TABLERO DE PEDIDOS

### 8.3.1 Contenedor del tablero (deslizable)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `width:100%; overflow-x:auto; padding-bottom:16px` | `w-100 overflow-x-auto pb-3` ✔ |

### 8.3.2 El tablero (5 columnas)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Columnas | `display:grid; grid-template-columns:repeat(5,1fr); gap:12px; min-width:1160px` (si la pantalla es más angosta el tablero se desliza) | `row row-cols-5 g-2 flex-nowrap` + `style="min-width:1160px"` ≈ (g-2 = 8) |

### 8.3.3 Cada cajón (columna)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `min-height:520px; background:rgba(255,255,255,.65); border-radius:16px; padding:12px` | `col rounded-4 p-2` ≈ + `min-height:520px` ✖ + fondo ✖ |
| **Encabezado del cajón** — acomodo | `display:flex; align-items:center; gap:8px; margin-bottom:12px` | `d-flex align-items-center gap-2 mb-2` ✔ |
| Punto de color | `width:10px; height:10px; border-radius:50%` | `rounded-circle` + 10 px ✖ |
| Nombre | `font-size:14px; line-height:20px; font-weight:900; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; flex:1` | `fw-black small text-truncate flex-grow-1` ✔ |
| Contador (a la derecha) | etiqueta de contorno: `border:1px solid; background:transparent; color:#321525; font-size:12px` | `badge border text-body bg-transparent` |
| Tarjetas dentro | `display:flex; flex-direction:column; gap:12px` | `d-flex flex-column gap-2` ✔ |

**Colores de los puntos:** Pendiente `#FFB900` · Aceptado `#50A2FF` · En preparación `#F27C86` · Despachado `#C27AFF` · Entregado `#00C950`.

**Cajón vacío:**
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `border:1px dashed rgba(116,27,61,.14); border-radius:16px; padding:24px; text-align:center; font-size:12px; color:#7A6873` — texto "Sin pedidos en este estado" | `border rounded-4 p-4 text-center small text-gris` + `style="border-style:dashed"` ✔ |

### 8.3.4 Cada tarjeta de pedido (de arriba a abajo)
**Caja de la tarjeta:** CSS `background:#fff; border:1px solid …; border-radius:12px; box-shadow:0 1px 3px rgba(0,0,0,.1); overflow:hidden; padding:16px 16px 24px` · Bootstrap `card shadow-sm` > `card-body p-3`.
| N.º | Pieza | CSS | Bootstrap |
|---|---|---|---|
| 1 | Número `#0047` | `font-family:monospace; font-size:14px; font-weight:900; color:#741B3D` | `font-monospace fw-black small text-vino` |
| 2 | Insignia de estado (debajo del número; columna con `gap:8px`) | pieza Insignia con los colores de abajo | `badge border` |
| 3 | Nombre del cliente | `margin-top:8px; font-size:14px; font-weight:700` | `mt-2 small fw-bold` |
| 4 | Dirección | `margin-top:4px; font-size:12px; color:#7A6873`; pin 📍 de 12 px; **máximo 2 renglones** (`-webkit-line-clamp:2`) | `mt-1 small text-gris` + line-clamp ✖ |
| 5 | Pie de la tarjeta | `margin-top:12px; border-top:1px solid …; padding-top:12px; display:flex; justify-content:space-between` — izquierda **hora** (12 px gris), derecha **total** (`$`, 14 px, 900) | `d-flex justify-content-between border-top pt-3 mt-3 small` |
| 6 | Repartidor (solo si ya tiene) | `margin-top:8px; background:#FAF5FF; border-radius:12px; padding:8px; font-size:12px; font-weight:600; color:#8200DB`; moto 🏍 de 12 px | `rounded-3 p-2 small fw-semibold mt-2` + colores ✖ (esquinas 12 ✖) |
| 7 | Botones | `margin-top:12px; display:flex; flex-direction:column; gap:8px`; **todos de 32 px y ancho 100 %** | `d-grid gap-2 mt-3` + `btn btn-sm` ✔ |

**Colores de la insignia de estado (fondo / letra):** Pendiente `#FFFBEB`/`#973C00` · Aceptado `#EFF6FF`/`#1447E6` · En preparación `#FDF2F8`/`#741B3D` · Despachado `#FAF5FF`/`#8200DB` · Entregado `#F0FDF4`/`#008236` · Cancelado `#FEF2F2`/`#C10007`.

**Botones de la tarjeta:**
1. **Botón de avance** (principal): Pendiente → "**Aceptar pedido**" · Aceptado → "**Pasar a preparación**" · En preparación → "**Despachar**" · Despachado → "**Marcar entregado**" · Entregado / Cancelado → ninguno.
2. "**Detalle**" (contorno, letra 12 px, centrado) y, si el estado es Aceptado, En preparación, Despachado o Entregado, "**Prefactura**" (igual), en columna con 8 px.
3. "**Cancelar**" (fantasma, letra `#C10007`, ancho 100 %) si el estado **no** es Entregado ni Cancelado.

**Pedidos cancelados** (solo si existe alguno): tarjeta con `margin-top:16px`; título "**Pedidos cancelados**" (16 px); cuerpo en fila con salto de línea y `gap:8px` con insignias rojas "{número} · {cliente}". Bootstrap: `d-flex flex-wrap gap-2` + `badge`.

> Datos de ejemplo (el prototipo trae 5–8 pedidos con este formato): `#0047 · Juan Pérez · Calle 10 #23-45, Apto 301 · 10:30 · $ 23.500` (invéntalos tú; no vienen en el diseño).

## 8.4 PESTAÑA 2 — CARGA DE REPARTIDORES
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:16px`; 1 columna en celular; **3 desde 768 px** | `row g-3` + `col-12 col-md-4` ✔ |
| Tarjeta | relleno 20 px (24 abajo) | `card` > `card-body` |

**Dentro de cada tarjeta de repartidor:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Fila de arriba | `display:flex; justify-content:space-between` | `d-flex justify-content-between` |
| Círculo con moto | `width:48px; height:48px; border-radius:50%; background:#FCE8EA`; moto de 24 px `#741B3D` | `rounded-circle bg-acento` + 48 ✖ |
| Insignia (derecha) | "Disponible" (verde) o "No disponible" (rojo) | `badge …` |
| Nombre | `margin-top:16px; font-size:18px; line-height:28px; font-weight:900` | `mt-3 fw-black` + 18 ✖ |
| "Pedidos en camino" | `14px; #7A6873` | `small text-gris` |
| Número | `margin-top:8px; font-size:36px; line-height:40px; font-weight:900; color:#741B3D` | `mt-2 fw-black text-vino` + 36 ✖ |
| Cajitas de pedidos (si tiene) | `background:#F2EEF1; border-radius:12px; padding:8px; font-size:12px; margin-top:8px`: "{número} · {cliente}" | `bg-campo rounded-3 p-2 small mt-2` |
| Datos | Carlos Pérez **0** · Luisa Moreno **1** · Mateo Ruiz **2** | |

## 8.5 PESTAÑA 3 — VENTAS POR DÍA
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `display:grid; gap:20px`; 1 columna en celular; desde 1024 px **`1fr 1.1fr`** | `row g-4` + `col-12 col-lg-5` y `col-12 col-lg-7` ≈ |

**Tarjeta "Total por día"** (título con icono de gráfico de 24 px `#741B3D`) — **gráfico de barras hecho con cajas:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Contenedor | `height:256px; display:flex; align-items:flex-end; gap:16px; padding:16px; border-left:1px solid …; border-bottom:1px solid …` | `d-flex align-items-end gap-3 p-3 border-start border-bottom` + `style="height:256px"` ✔ |
| Cada día | columna centrada abajo, `gap:8px`: arriba el total (10 px, 600), la **barra**, debajo la fecha `dd/mm` (10 px gris) | `d-flex flex-column align-items-center gap-2` |
| La barra | `width:100%; max-width:56px; border-radius:12px 12px 0 0; background:#741B3D; height:{total ÷ 12000}px` (redondeado) | `w-100 bg-vino` + `rounded-top-4` ≈ (16) + `style="height:66px;max-width:56px"` ✖ |

**Tarjeta "Detalle de ventas":** tabla **Fecha · Sede · N.º prefacturas · Subtotal · IVA · Total** (Total `font-weight:700`) y debajo (margen 12 px) nota `12px` gris "*Solo incluye pedidos no cancelados.*"
| Fecha | Sede | N.º | Subtotal | IVA | Total | Alto de barra |
|---|---|---|---|---|---|---|
| 24/06/2026 | Coffee Park Centro | 22 | $ 710.000 | $ 82.000 | $ 792.000 | 66 px |
| 25/06/2026 | Coffee Park Centro | 28 | $ 890.000 | $ 103.000 | $ 993.000 | 83 px |
| 26/06/2026 | Coffee Park Norte | 19 | $ 603.000 | $ 71.000 | $ 674.000 | 56 px |
| 27/06/2026 | Coffee Park Centro | 34 | $ 1.050.000 | $ 121.000 | $ 1.171.000 | 98 px |

## 8.6 Ventanas de Domicilios
- **Detalle del pedido {n}** (672 px, alto máx. 92 %), cuerpo `gap:20px`: (a) fila: insignia de estado a la izquierda y fecha (14 px gris) a la derecha; (b) caja `#F2EEF1`, esquinas 16, relleno 16, grilla de **2 columnas desde 640 px**, gap 12: **Cliente**, **Método de pago**, **Dirección** (ocupa 2); cada dato: etiqueta `12px` gris + valor `700`; (c) tabla **Producto · Cantidad · Precio · % IVA**; (d) línea superior, relleno 16, 2 columnas, 14 px: **Aceptó:** nombre + fecha · **Repartidor:** nombre, "Despacho: …", "Entrega: …" (o "Pendiente" / "Sin asignar"). Pie: **Cerrar**.
- **Prefactura para ICG** (768 px, alto máx. 94 %): una **hoja** (borde, esquinas 16, fondo blanco, relleno 24). Cabecera con línea inferior y relleno abajo 16: izquierda "**Coffee Park**" (`24px/32px; 900; #741B3D`) y "Prefactura" (14 px); derecha (alineada a la derecha) el número en monoespaciada 900 y "Coffee Park Centro · {fecha}" (12 px). Datos (2 columnas, gap 8, 14 px, relleno vertical 16): **Cliente**, **Documento:** CC 1.032.445.512, **Dirección**, **Método de pago**. Tabla **Producto · Cant. · Precio · Subtotal · IVA · Total** (precio base = precio ÷ 1,19). Resumen: caja de **256 px** de ancho alineada a la derecha (`margin-left:auto`), margen arriba 20, filas `space-between` (14 px): **Subtotal**, **IVA** y **Total** (con línea superior, relleno arriba 8, 18 px). Pie: "**Imprimir**" (contorno) y "**Exportar para ICG**" (principal).
- **Cancelar pedido** (512 px): texto `14px; #7A6873` "*Se liberará el stock reservado y se anulará la prefactura de {número}.*"; pie: **Volver** (contorno) y **Confirmar cancelación** (fondo `#D4183D`, letra blanca; Bootstrap `btn btn-danger` ≈).

**Revisión Domicilios:** [ ] 5 cajones con punto de color · [ ] el tablero se desliza si la pantalla es angosta · [ ] los botones cambian según el cajón · [ ] cajón vacío con borde punteado · [ ] barras del gráfico suben según el total.

---

<a id="vista-9"></a>
# 9. VISTA MENÚ DEL CLIENTE

**Qué es:** la vitrina de la panadería: un cartel vino "¿Qué quieres pedir hoy?", un buscador, botones redondos de categorías y **tarjetas con foto, nombre y precio**. Al elegir algo flota abajo un botón "Ver carrito". **Quién entra:** cliente (con o sin cuenta). **Marco:** el mismo, pero el menú lateral solo tiene "Menú" y "Mis pedidos" (el invitado solo "Menú"). **Menú activo:** Menú. **Barra:** "MENÚ" / "Pedidos a domicilio" (o "Explorando como invitado").

```
┌─ CARTEL vino ───────────────────────────────┐
│ COFFEE PARK                              ○  │
│ ¿Qué quieres pedir hoy?                     │
│ 🕒 Entrega estimada: 30–45 minutos          │
└─────────────────────────────────────────────┘
[🔍 Buscar productos…                          ]
(Todo)(Bebidas)(Panadería)(Almuerzos)(Ensaladas)(Postres)
Nuestro menú                                  ☕
8 productos disponibles
┌[foto]┬texto──────┐ ┌[foto]┬texto──────┐ ┌[foto]┬…
                                   [ 🛒 Ver carrito   $ 14.500 ] ← flotante
```
Todo en una columna: CSS `display:flex; flex-direction:column; gap:20px; padding-bottom:80px` (para que el botón flotante no tape nada) · Bootstrap `d-flex flex-column gap-4` ≈ + `padding-bottom:80px` ✖.

## 9.1 Cartel
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#350B1A; color:#fff; border-radius:24px; padding:20px; box-shadow:0 10px 15px -3px rgba(0,0,0,.1); position:relative; overflow:hidden` | `position-relative overflow-hidden text-white bg-vino-oscuro shadow-lg` + `p-4` (24 ≈ 20) + esquinas 24 ✖ `style="border-radius:24px"` |
| **Bola decorativa** (arriba a la derecha) | `position:absolute; top:-48px; right:-48px; width:144px; height:144px; border-radius:50%; background:rgba(242,124,134,.2)` | `position-absolute rounded-circle` + resto ✖ |
| "COFFEE PARK" | `font-size:12px; line-height:16px; font-weight:700; text-transform:uppercase; letter-spacing:.18em; color:#F27C86` | `small fw-bold text-uppercase text-coral` + espaciado ✖ |
| Título "¿Qué quieres pedir hoy?" | `font-size:30px; font-weight:900; line-height:1.25; margin-top:8px` | `fw-black lh-sm mt-2` + 30 ✖ |
| Línea de entrega | `margin-top:16px; display:flex; align-items:center; gap:8px; font-size:12px; color:rgba(255,255,255,.7)`; reloj 🕒 de 16 px + "Entrega estimada: 30–45 minutos" | `d-flex align-items-center gap-2 mt-3 small text-white opacity-75` |

## 9.2 Buscador
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Contenedor | `position:relative` | `position-relative` ✔ |
| **Lupa (cómo ponerla dentro del campo)** | `position:absolute; left:16px; top:50%; transform:translateY(-50%); width:16px; color:#7A6873; pointer-events:none` | `position-absolute top-50 translate-middle-y ms-3 pe-none text-gris` ✔ |
| Campo | `height:48px; width:100%; border-radius:16px; background:#fff; padding-left:44px; box-shadow:0 1px 3px rgba(0,0,0,.1)`; placeholder "Buscar productos..." | `form-control form-control-lg rounded-4 border-0 shadow-sm ps-5 fs-6` (ps-5 = 48 ≈ 44) |

## 9.3 Categorías (botones redondos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Fila deslizable | `display:flex; gap:8px; overflow-x:auto; margin:0 -16px; padding:0 16px 4px` | `d-flex gap-2 overflow-x-auto pb-1` ✔ |
| Cada botón (píldora) | `min-height:44px; padding:0 16px; border-radius:9999px; font-size:14px; font-weight:700` | `btn rounded-pill fw-bold small` ✔ (44 ≈) |
| **Elegido** | fondo `#741B3D`, letra blanca, `box-shadow:0 1px 3px rgba(0,0,0,.1)` | `btn-primary shadow-sm` ✔ |
| Normal | fondo blanco, borde 1 px, letra `#7A6873` | `btn-light border text-gris` |
| Textos | **Todo · Bebidas · Panadería · Almuerzos · Ensaladas · Postres** | |

## 9.4 Título de la lista
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:flex-end` | `d-flex justify-content-between align-items-end` ✔ |
| Izquierda | "**Nuestro menú**" (o el nombre de la categoría) `20px/28px; 900` y debajo "**{n} productos disponibles**" `12px` gris | `h2 fw-black fs-5` ✔ + `small text-gris` |
| Derecha | icono de taza 20 px `#F27C86` | `text-coral` |

## 9.5 Tarjetas de producto
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; **1 columna**; **2 desde 768 px**; **3 desde 1280 px** | `row g-3` + `col-12 col-md-6 col-xl-4` ✔ (xl = 1200 ≈ 1280) |
| **Cada tarjeta** | `display:grid; grid-template-columns:116px 1fr; min-height:136px; overflow:hidden; background:#fff; border:1px solid …; border-radius:16px; box-shadow:0 1px 3px rgba(0,0,0,.1)`; no disponible: `opacity:.6` | `d-grid border rounded-4 shadow-sm bg-white overflow-hidden` + `style="grid-template-columns:116px 1fr;min-height:136px"` ✖; `opacity-75` ≈ |

**Columna de la foto (116 px):**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `position:relative` | `position-relative` |
| **Cómo hacer que la foto llene todo** | `<img>` con `position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover` | `position-absolute top-0 start-0 w-100 h-100 object-fit-cover` ✔ |
| Etiqueta "Popular" / "Recomendado" (opcional) | `position:absolute; top:8px; left:8px; background:rgba(255,255,255,.9); color:#741B3D; font-size:10px; box-shadow:…; border-radius:…` | `position-absolute top-0 start-0 m-2 badge bg-white text-vino shadow-sm` + 10 px ✖ |
| Capa "No disponible" (si no hay) | `position:absolute; inset:0; background:rgba(53,11,26,.55); color:#fff; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:700` | `position-absolute top-0 bottom-0 start-0 end-0 d-flex align-items-center justify-content-center text-white small fw-bold` + fondo ✖ |

**Columna de texto:** CSS `padding:12px; display:flex; flex-direction:column` · Bootstrap `d-flex flex-column p-2` (8 ≈ 12; `style="padding:12px"` exacto).
| Pieza | CSS | Bootstrap |
|---|---|---|
| Nombre | `font-size:14px; font-weight:900; white-space:nowrap; overflow:hidden; text-overflow:ellipsis` | `fw-black small text-truncate` ✔ |
| Descripción | `margin-top:4px; font-size:12px; line-height:1.625; color:#7A6873; máximo 2 renglones` | `mt-1 small text-gris` + line-clamp ✖ |
| **Fila inferior (se va al fondo)** | `margin-top:auto; padding-top:8px; display:flex; justify-content:space-between; align-items:flex-end` | `mt-auto pt-2 d-flex justify-content-between align-items-end` ✔ |
| Precio | `font-size:16px; font-weight:900; color:#741B3D` y debajo "IVA incluido" `10px` gris | `fs-6 fw-black text-vino` + `small text-gris` |
| **Botón agregar (+)** | círculo `40px × 40px; border-radius:50%; background:#741B3D`; "+" de 16 px blanco | `btn btn-primary rounded-circle d-flex align-items-center justify-content-center` + `style="width:40px;height:40px"` ✖ |
| **Si ya está en el carrito** | cápsula (borde, fondo `#FCF8F9`, relleno 4 px, `gap:4px`, píldora) con **−** (círculo 32 px, icono 14), cantidad (20 px de ancho, centrada, 14 px, 900) y **+** (círculo 32 px, fondo `#741B3D`) | `d-flex align-items-center gap-1 border rounded-pill p-1 bg-fondo` + círculos ✖ |

| N.º | Nombre | Descripción | Precio | Categoría | Etiqueta | Disponible |
|---|---|---|---|---|---|---|
| 1 | Café americano | Espresso intenso con agua caliente. | $ 5.000 | Bebidas | Popular | sí |
| 2 | Capuchino | Espresso, leche vaporizada y espuma cremosa. | $ 6.500 | Bebidas | — | sí |
| 3 | Croissant | Hojaldrado artesanal de mantequilla. | $ 4.500 | Panadería | Recomendado | sí |
| 4 | Pan de queso | Pan suave relleno de queso doble crema. | $ 3.000 | Panadería | — | sí |
| 5 | Almuerzo ejecutivo | Sopa, plato principal y bebida del día. | $ 18.000 | Almuerzos | — | sí |
| 6 | Ensalada César | Lechuga, pollo, crutones y aderezo César. | $ 12.000 | Ensaladas | — | sí |
| 7 | Cheesecake de maracuyá | Cheesecake cremoso con fruta natural. | $ 8.000 | Postres | — | sí |
| 8 | Brownie con helado | Brownie tibio con helado de vainilla. | $ 9.500 | Postres | — | **no** |

**Fotos:** el prototipo usa fotos de Unsplash (700 × 500 px). Descárgalas tú desde unsplash.com y guárdalas en `img/menu/` (`cafe.jpg`, `panaderia.jpg`, `postre.jpg`, `hojaldre.jpg`, `almuerzo.jpg`): 1-2 → cafe · 3 → hojaldre · 4 → panaderia · 5-6 → almuerzo · 7-8 → postre.

**Sin resultados:** caja con borde punteado (`1px dashed`), esquinas 16, fondo blanco, `padding:56px 0`, centrada: lupa de 32 px gris; "**No encontramos productos**" (`14px; 700; margin-top:12px`); botón de texto "**Limpiar búsqueda**" (`min-height:44px; 14px; 700; #741B3D; margin-top:8px`).

## 9.6 Botón flotante "Ver carrito" (aparece si hay productos)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Cómo ponerlo flotando abajo** | `position:fixed; bottom:20px; left:16px; right:16px; z-index:40`; desde 1024 px: `left:auto; right:32px; width:360px` | `position-fixed bottom-0 start-0 end-0 m-3` ✔ (bottom 16 ≈ 20) + en lg `ms-lg-auto` + `style="max-width:360px"` |
| Botón | principal, `height:56px; width:100%; border-radius:16px; padding:0 16px; display:flex; justify-content:space-between; align-items:center; box-shadow:0 10px 35px rgba(53,11,26,.28)` | `btn btn-primary w-100 rounded-4 d-flex justify-content-between align-items-center` + alto 56 ✖ + sombra ✖ |
| Izquierda | burbuja `28px × 28px` (`rgba(255,255,255,.2)`, círculo, 12 px/900) con la cantidad + carrito de 20 px + "Ver carrito" (`gap:8px`) | `rounded-circle` + tamaño ✖ |
| Derecha | el total, `font-weight:900` | `fw-black` |

## 9.7 Ventana del carrito (3 pasos en la misma ventana)
Ancho `calc(100% - 24px)` hasta **366 px**, alto máx. 88 % con barra vertical, esquinas **24 px**, **relleno 0** (cada parte trae el suyo). Bootstrap: `modal-dialog modal-dialog-centered modal-dialog-scrollable` + `style="max-width:366px"` y `modal-content` con `border-radius:24px`.

**Paso 1 — "Tu carrito"**
- Cabecera: relleno 20 px (16 abajo), línea inferior; título con bolsa 🛍 de 20 px `#741B3D`.
- Cuerpo (relleno 20, `gap:12px`): **por cada producto**, fila con borde, esquinas 16, relleno 12, `gap:12px`: foto **56 × 56** (esquinas 16, `object-fit:cover`); nombre (14 px, 700, una línea) y subtotal (12 px, 600, `#741B3D`); controles (margen arriba 8, `gap:4px`): **−** círculo 32 px con borde, cantidad (28 px de ancho, 14 px, 900), **+** círculo 32 px fondo `#741B3D`, y a la derecha papelera (círculo 32 px, icono 16 px, `#E7000B`).
- Total: línea superior, relleno arriba 16, `space-between`: "Total" (12 px gris) y valor (`20px; 900`); a la derecha insignia verde "**Domicilio gratis**".
- Botón "**Continuar**" (48 px, ancho 100 %) con flecha ›.

**Paso 2 — "Datos de entrega":** cabecera con botón atrás (círculo **36 px**, flecha ← de 16 px, al pasar el mouse `#F2EEF1`) + título. Cuerpo (relleno 20, `gap:20px`):
- **Dirección de entrega:** etiqueta + área de texto (`min-height:96px; background:#F2EEF1`; valor inicial *Calle 10 #23-45, Apto 301*) + error `12px; #E7000B` "*La dirección de entrega es obligatoria.*" + ayuda `12px` gris "*Puedes cambiarla solo para este pedido.*" (`gap:6px`).
- **Método de pago:** lista (48 px, fondo `#F2EEF1`): Efectivo, Tarjeta, Nequi, Transferencia.
- Resumen: fondo `#FCE8EA`, esquinas 16, relleno 16: fila "{n} productos" y total en negrita (14 px); debajo "Los precios incluyen IVA." (12 px gris, margen arriba 4).
- Botón "**Confirmar pedido**" (48 px, con círculo-check de 16 px).

**Paso 3 — éxito:** relleno 24, centrado: círculo verde 80 px (`#DBFCE7`) con ✓ de 40 px `#008236`; "**Pedido confirmado**" (`24px; 900; margin-top:20px`); "*Recibimos tu pedido y pronto será aceptado por la sede.*" (14 px gris, margen arriba 8); caja `#FCE8EA`, esquinas **24 px**, relleno 16, margen vertical 20, con "**NÚMERO DE PEDIDO**" (`12px; 700; letter-spacing:.05em; #741B3D`) y el número en monoespaciada `30px/36px; 900; #350B1A`; botón "**Seguir mi pedido**" (48 px) y debajo "**Volver al menú**" (fantasma, 44 px, margen arriba 8). Para un invitado solo aparece "Volver al menú" como botón principal.

**Revisión Menú:** [ ] 3 columnas a 1440 px, 2 a 768, 1 en celular · [ ] foto de 116 px a la izquierda · [ ] "Brownie con helado" a 60 % con "No disponible" · [ ] botón flotante abajo a la derecha desde 1024 · [ ] categorías se deslizan en celular · [ ] botón "+" círculo de 40 px.

---

<a id="vista-10"></a>
# 10. VISTA MIS PEDIDOS

**Qué es:** tarjetitas de las compras del cliente. Cada una tiene arriba una **franja vino** con el número y una **fila de bolitas conectadas** que muestra por dónde va el pedido. **Quién entra:** cliente con cuenta. **Menú activo:** Mis pedidos. **Barra:** "MIS PEDIDOS" / "Pedidos a domicilio". Usa el [Marco](#marco).

```
Mis pedidos                                  [☕ Nuevo pedido]
Consulta el estado de tus pedidos y el historial de entregas.
┌───────────────────┐ ┌──────────────────┐
│▓ #0047  Despachado│ │▓ #0042 Entregado │
│ Tu pedido va en…  │ │ Pedido entregado │
│ ●──●──●──●──○     │ │ ●──●──●──●──●    │
│ 🏍 Repartidor: …  │ │                  │
│ 3 productos  Ver ›│ │                  │
└───────────────────┘ └──────────────────┘
```

## 10.1 Encabezado (Patrón A)
Título "**Mis pedidos**" · descripción "**Consulta el estado de tus pedidos y el historial de entregas.**" · botón principal **44 px** (taza + "**Nuevo pedido**") → Menú. Bootstrap: Patrón A + `btn btn-primary`.

## 10.2 Sin pedidos
Tarjeta con contenido centrado y `padding:56px 0`: bolsa de **56 × 56 px** `#F6B4B8`; "**Aún no tienes pedidos**" (`18px/28px; 900; margin-top:16px`); "*Cuando hagas tu primer pedido aparecerá aquí.*" (`14px` gris, `margin-top:4px`); botón "**Explorar menú**" (`margin-top:20px`). Bootstrap: `card text-center py-5` + `mt-3`, `small text-gris`, `btn btn-primary mt-4`.

## 10.3 Tarjetas de pedido
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; 1 columna; **2 desde 768 px**; **3 desde 1280 px** | `row g-3` + `col-12 col-md-6 col-xl-4` ✔ |
| **Cada tarjeta** | `background:#fff; border:1px solid …; border-radius:12px; overflow:hidden; padding:0` (la franja llega hasta las esquinas) | `card overflow-hidden` |

**Franja de arriba:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `background:#350B1A; color:#fff; padding:16px; display:flex; justify-content:space-between; align-items:flex-start` | `d-flex justify-content-between align-items-start p-3 text-white bg-vino-oscuro` ✔ |
| Número (izquierda) | monoespaciada `18px/28px; 900` | `font-monospace fw-black` + 18 ✖ (`fs-5` = 20 ≈) |
| Fecha (debajo) | `12px; color:rgba(255,255,255,.6)` | `small text-white opacity-75` ≈ |
| Estado (derecha) | etiqueta: normal fondo `rgba(255,255,255,.15)` letra blanca; cancelado fondo `#FFE2E2` letra `#C10007` | `badge text-bg-light bg-opacity-25 text-white` ≈ |

**Cuerpo (relleno 16 px → `p-3` ✔):**
1. **Descripción del estado** (`14px; 700`): Pendiente → *Recibimos tu pedido* · Aceptado → *La sede confirmó el pedido* · En preparación → *Estamos preparando tus productos* · Despachado → *Tu pedido va en camino* · Entregado → *Pedido entregado* · Cancelado → *Este pedido fue cancelado*.
2. **Barra de progreso** (si no está cancelado; `margin-top:20px`; `display:flex; align-items:center`) — Bootstrap `d-flex align-items-center mt-4`:
| Pieza | CSS | Bootstrap |
|---|---|---|
| **5 círculos** (Pendiente, Aceptado, En preparación, Despachado, Entregado) | `width:28px; height:28px; border-radius:50%; border:2px solid; display:flex; align-items:center; justify-content:center` | `rounded-circle border border-2 d-flex align-items-center justify-content-center` + 28 ✖ |
| Alcanzado o actual | borde y fondo `#F27C86`, icono `#350B1A` | `border-coral bg-coral` |
| Por alcanzar | borde `#F2EEF1`, fondo blanco, icono `#7A6873` | ✖ propio |
| Iconos | pasos ya superados → ✓ (16 px); el actual o futuro → 1.º reloj (12 px), 4.º camión (12 px), los demás caja (12 px) | — |
| **Líneas entre círculos** | `flex:1; height:2px`; coral `#F27C86` si ese paso ya se superó, `#F2EEF1` si no; el último paso no lleva línea | `flex-grow-1` ✔ + `style="height:2px"` ✖ |

3. **Repartidor** (si hay): `margin-top:16px; background:#FAF5FF; border-radius:16px; padding:12px; font-size:14px; font-weight:600; color:#8200DB`; moto 16 px: "**Repartidor: {nombre}**" · Bootstrap `rounded-4 p-3 small fw-semibold mt-3` + colores ✖.
4. **Pie:** `margin-top:16px; border-top:1px solid …; padding-top:16px; display:flex; justify-content:space-between` · Bootstrap `d-flex justify-content-between align-items-center border-top pt-3 mt-3` ✔. Izquierda "{n} productos" (12 px gris) y debajo el total (`18px; 900; #741B3D`); derecha botón fantasma pequeño "**Ver detalle ›**".

## 10.4 Ventana "Pedido {número}"
Ancho máx. **360 px**, alto máx. 90 % (Bootstrap `modal-sm` ≈ 300 → `style="max-width:360px"`); cuerpo `gap:16px`: (a) caja `#F2EEF1`, esquinas 16, relleno 12: pin 📍 de 16 px + dirección (14 px) y debajo "**Pago:** método"; (b) una fila por producto (borde, esquinas 12, relleno 12, 14 px): "{cant} × {producto}" y a la derecha el subtotal en negrita; (c) línea superior, relleno arriba 12: "**Total**" y valor (`18px; 900`).

**Revisión Mis pedidos:** [ ] franja vino con número en monoespaciada · [ ] 5 bolitas de 28 px unidas por líneas de 2 px · [ ] alcanzadas en coral, las que faltan en gris claro · [ ] 3 columnas a 1440 px.

---

<a id="vista-11"></a>
# 11. VISTA MIS DOMICILIOS (repartidor)

**Qué es:** la lista de entregas del repartidor: tarjetitas con nombre del cliente, teléfono, dirección y botones grandes de "Salir a entregar" y "Confirmar entrega". **Quién entra:** repartidor. **Menú activo:** Mis domicilios. **Barra:** "MIS DOMICILIOS". Usa el [Marco](#marco).

> ⚠ **Dato importante:** esta vista **NO usa la paleta vino**; usa grises y ámbar: título en grosor 700 sin color propio y números en ámbar. Se explica **tal cual está en Figma**.

```
Mis Domicilios
Hola, Carlos — tus entregas asignadas
┌ Hoy ──────┐ ┌ Activas ──┐ ┌ Completadas ┐   ← 3 números (siempre en fila)
│ 3         │ │ 2 (ámbar) │ │ 1 (verde)   │
[ Activas (2) ][ Completadas (1) ]
┌─ #0047 ────────Asignado┐ ┌─ #0048 ─────En Camino┐
│ 👤 Juan Pérez          │
│ 📞 300 123 4567        │
│ 📍 Calle 10 #23-45     │
│ $23.500        📍1.2 km│
│ [Ver Detalle][Salir a Entregar]
```

## 11.1 Encabezado
| Pieza | CSS | Bootstrap |
|---|---|---|
| Título "Mis Domicilios" | `font-size:30px; line-height:36px; font-weight:700; color:#321525` (**grosor 700, no 900**) | `h1 fw-bold` + 30 ✖ (`fs-3` = 28 ≈) |
| "Hola, {nombre} — tus entregas asignadas" | `font-size:16px; color:#45556C; margin-top:4px` | `fs-6 mt-1` + color ✖ |

## 11.2 Tres tarjetas de números
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor (siempre 3 columnas, también en celular)** | `display:grid; grid-template-columns:repeat(3,1fr); gap:16px` | `row g-3` + `col-4` ✔ |
| Encabezado de cada tarjeta | relleno 24 px arriba/lados y 8 abajo; título `14px; #45556C`: **Hoy · Activas · Completadas** | `card-body` + `small` |
| Número | `font-size:30px; line-height:36px; font-weight:700`: Hoy `#321525` · Activas **`#BB4D00`** · Completadas **`#00A63E`** | `fw-bold` + `style="font-size:30px;color:#BB4D00"` ✖ |
| Texto debajo | `12px; #62748E`: "entregas totales" · "en curso" · "entregadas" | `small` + color ✖ |

## 11.3 Pestañas (variante gris)
| Propiedad | CSS | Bootstrap |
|---|---|---|
| Barra | `display:inline-flex; background:#F2EEF1; padding:3px; border-radius:16px; height:36px; width:fit-content` | `nav nav-pills bg-body-secondary rounded-4 p-1 w-auto` ≈ |
| Textos | "**Activas (2)**" y "**Completadas (1)**" | — |
| Elegida | fondo blanco | `--bs-nav-pills-link-active-bg:#fff; --bs-nav-pills-link-active-color:#321525` |
| Separación con el contenido | `margin-top:16px` | `tab-content mt-3` ✔ |

## 11.4 Tarjeta de entrega
| Propiedad | CSS | Bootstrap |
|---|---|---|
| **Contenedor** | `display:grid; gap:16px`; 1 columna; **2 desde 768 px**; **3 desde 1024 px** | `row g-3` + `col-12 col-md-6 col-lg-4` ✔ |
| Tarjeta | estándar; al pasar el mouse la sombra crece (sombra grande) | `card shadow-sm` + `:hover{box-shadow:…}` |

**Encabezado de la tarjeta:**
| Pieza | CSS | Bootstrap |
|---|---|---|
| Caja | `display:flex; justify-content:space-between; align-items:flex-start` | `d-flex justify-content-between align-items-start` |
| Número `#0047` y hora debajo | número `18px/28px`; hora `16px; #7A6873` | `fw-semibold` + `text-gris` |
| **Etiqueta de estado** (derecha, letra blanca, icono 12 px con 4 px de margen) | **Asignado** → fondo `#2B7FFF` + caja · **En Camino** → `#AD46FF` + camión · **Entregado** → `#00C950` + círculo-check | `badge` + fondos propios ✖ |

**Cuerpo** (`gap:12px`):
1. **Tres filas** (`gap:8px`; cada una: icono 16 px `#62748E` + texto 14 px): persona + nombre (grosor 500) · teléfono 📞 como **enlace** `<a href="tel:3001234567">` (color `#BB4D00`, subrayado al pasar el mouse) · pin + dirección (12 px). Bootstrap: `d-flex gap-2 small`.
2. **Fila con línea superior** (`border-top; padding-top:8px; display:flex; justify-content:space-between`): izquierda el total (`20px/28px; 700; #BB4D00`, ej. `$23.500`) y debajo etiqueta de contorno con el método de pago (12 px, `margin-top:4px`); derecha etiqueta secundaria (fondo `#F8E9ED`, letra `#4A1027`, 12 px) "📍 1.2 km". Bootstrap: `d-flex justify-content-between border-top pt-2` + `fw-bold fs-5` + color ✖.
3. **Botones** (`display:flex; gap:8px; padding-top:8px`): "**Ver Detalle**" (contorno, 32 px) y según el estado: Asignado → "**Salir a Entregar**" (camión de 12 px, principal, ocupa el resto) · En camino → "**Confirmar Entrega**" (fondo `#00A63E`, hover `#008236`, check 12 px) · Entregado → etiqueta verde `#00C950` centrada "**Entregado**". Bootstrap: `d-flex gap-2` + `btn btn-outline-secondary btn-sm` + `btn btn-primary btn-sm flex-grow-1` / `btn btn-success btn-sm flex-grow-1` (verde ✖ `#00A63E`).

| N.º | Cliente | Teléfono | Dirección | Total | Pago | Estado | Hora | Distancia | Productos |
|---|---|---|---|---|---|---|---|---|---|
| #0047 | Juan Pérez | 300 123 4567 | Calle 10 #23-45, Apto 301 | $23.500 | Efectivo | Asignado | 10:30 | 1.2 km | Café Americano ×2, Croissant ×3 |
| #0048 | María López | 310 987 6543 | Carrera 15 #8-90 | $18.000 | QR Digital | En camino | 11:00 | 2.5 km | Almuerzo Ejecutivo ×1 |
| #0045 | Luis Torres | 315 222 3344 | Avenida 8 #45-10 | $12.000 | Tarjeta | Entregado | 09:15 | 0.8 km | Capuchino ×2 |

**Sin entregas activas:** tarjeta con contenido centrado y `padding:48px 0`: reloj de **48 px** `#CAD5E2`, margen abajo 12; texto `16px; #62748E` "*No tienes entregas activas en este momento*". Bootstrap: `card text-center py-5`.

## 11.5 Ventana "Detalle de Entrega {n}"
Ancho máx. **500 px** (= `modal-dialog` por defecto ✔). Cuerpo `gap:16px` y relleno vertical 8: (a) grilla de 2 columnas (gap 16): **Cliente** y **Teléfono** — etiqueta `12px; #62748E` + valor grosor 500; (b) **Dirección**; (c) **Productos**: etiqueta con margen abajo 8; filas (fondo `#F8FAFC`, esquinas **4 px**, relleno 8, 14 px, `space-between`): nombre y "x{cantidad}" (grosor 500) — Bootstrap `rounded-1` ✔ (4 px); (d) línea superior, relleno arriba 12, `space-between`: **Método de Pago** (etiqueta + valor) y a la derecha **Total a Cobrar** (etiqueta + `24px/32px; 700; #BB4D00`). Pie: **Cerrar** (contorno) y el botón de acción según el estado.

**Revisión Mis domicilios:** [ ] título en grosor 700 (no 900) y números ámbar `#BB4D00` / verde `#00A63E` · [ ] 3 tarjetas de números en **una fila** también en celular · [ ] barra de pestañas gris y la elegida blanca · [ ] "Confirmar Entrega" verde.

---

<a id="revision"></a>
# LISTA FINAL DE REVISIÓN

| # | Vista | Qué mirar primero |
|---|---|---|
| 1 | Iniciar sesión | izquierda 792 / derecha 648 · título 72 px · 3 bolas + línea inclinada |
| 2 | Recuperar contraseña | 756 / 684 · bola grande arriba-izq + bola coral · caja ✉ 56 px · círculo verde 80 px |
| 3 | Registrarse | 756 / 684 · dos cajas blancas con título 18 px · "Dirección" a ancho completo |
| 4 | Inicio | menú 256 px · barra 80 px · 4 tarjetas con icono de 44 px |
| 5 | Usuarios | 3 pestañas · filtros en una fila · paginación 36 × 36 |
| 6 | Compras | 6 pestañas · 4 tarjetas de color · insignias con borde · botón bajo el título |
| 7 | Producción | botón 36 px · 2 tarjetas (.8 / 1.2) · filas de consumo verdes |
| 8 | Domicilios | 5 cajones con punto de color · gráfico con cajas |
| 9 | Menú | cartel 24 px · píldoras · tarjetas 116 px + texto · botón flotante |
| 10 | Mis pedidos | franja vino · 5 bolitas de 28 px con líneas de 2 px |
| 11 | Mis domicilios | paleta gris/ámbar · 3 números en fila · botón verde |

**Orden recomendado para construir (de más fácil a más difícil):** Recuperar contraseña → Registrarse → Iniciar sesión → Marco + Inicio → Usuarios → Compras → Producción → Mis pedidos → Mis domicilios → Menú → Domicilios.

<<<<<<< HEAD
### C. Tabla
```html
<div class="bake-table-wrapper table-responsive">
  <table class="table bake-table align-middle mb-0">
    <thead><tr><th>Pedido</th><th>Cliente</th><th>Estado</th><th class="text-end">Acciones</th></tr></thead>
    <tbody>
      <tr>
        <td class="codigo">#0048</td><td>María López</td>
        <td><span class="status-chip status-info">Aceptado</span></td>
        <td class="text-end"><button class="btn btn-sm btn-bake-outline">Detalle</button></td>
      </tr>
    </tbody>
  </table>
</div>
```
```css
.bake-table-wrapper { overflow-x:auto; border:1px solid rgba(116,27,61,.14); border-radius:12px; }
.bake-table { width:100%; color:#321525; font-size:14px; line-height:20px; }
.bake-table th { height:40px; padding:8px; font-weight:500; text-align:left; white-space:nowrap; }
.bake-table td { padding:8px; vertical-align:middle; white-space:nowrap; }
.bake-table tr { border-bottom:1px solid rgba(116,27,61,.14); transition:background-color 150ms ease; }
.bake-table tbody tr:hover { background:rgb(242 238 241 / .50); }
```

### D. Modal
```html
<div class="modal fade" id="bakeModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content bake-modal">
      <div class="modal-header"><h2 class="modal-title">Confirmar acción</h2><button class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body">Contenido del modal</div>
      <div class="modal-footer"><button class="btn btn-bake-outline">Cancelar</button><button class="btn btn-bake-primary">Confirmar</button></div>
    </div>
  </div>
</div>
```
```css
.modal-backdrop.show { opacity:.50; }
.bake-modal { padding:24px; gap:16px; background:#fcf8f9; border:1px solid rgba(116,27,61,.14); border-radius:12px;
  box-shadow:0 10px 15px -3px rgb(0 0 0 / .10), 0 4px 6px -4px rgb(0 0 0 / .10); }
.bake-modal .modal-header, .bake-modal .modal-body, .bake-modal .modal-footer { padding:0; border:0; }
.bake-modal .modal-title { font-size:18px; line-height:18px; font-weight:600; }
.bake-modal .modal-footer { display:flex; gap:8px; justify-content:flex-end; }
```

### E. Formulario
```html
<form class="bake-form">
  <div class="bake-form-card">
    <h2 class="form-section-title">Información general</h2>
    <div class="row g-3">
      <div class="col-12 col-md-6">
        <label class="form-label" for="nombre">Nombre</label>
        <input class="form-control form-control-bake" id="nombre" type="text">
        <div class="invalid-feedback">El nombre es obligatorio.</div>
      </div>
      <div class="col-12 col-md-6">
        <label class="form-label" for="estado">Estado</label>
        <select class="form-select form-control-bake" id="estado"><option>Activo</option><option>Inactivo</option></select>
      </div>
    </div>
  </div>
  <div class="d-flex justify-content-end gap-2 mt-4">
    <button type="button" class="btn btn-bake-outline">Cancelar</button>
    <button type="submit" class="btn btn-bake-primary">Guardar</button>
  </div>
</form>
```
```css
.bake-form { display:flex; flex-direction:column; gap:20px; }
.bake-form-card { padding:16px; background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:12px; }
.form-section-title { margin-bottom:16px; color:#321525; font-size:16px; line-height:20px; font-weight:700; }
.form-label { margin-bottom:6px; color:#321525; font-size:14px; line-height:20px; font-weight:600; }
```

---

## 12. Estados de botones y campos

### Botones
```css
/* Principal */
.btn-bake-primary { color:#fff; background:#741b3d; border:1px solid transparent; }
.btn-bake-primary:hover { background:rgb(116 27 61 / .90); }          /* ≈ #823250 sobre blanco */
.btn-bake-primary:focus-visible { border-color:#96244f; box-shadow:0 0 0 3px rgb(150 36 79 / .50); outline:none; }
.btn-bake-primary:disabled { opacity:.50; pointer-events:none; }

/* Outline */
.btn-bake-outline { background:#fcf8f9; color:#321525; border:1px solid rgba(116,27,61,.14); }
.btn-bake-outline:hover { background:#fce8ea; color:#741b3d; }

/* Destructivo */
.btn-bake-danger { background:#d4183d; color:#fff; }
.btn-bake-danger:hover { background:rgb(212 24 61 / .90); }

/* Ghost */
.btn-bake-ghost { background:transparent; color:#321525; }
.btn-bake-ghost:hover { background:#fce8ea; color:#741b3d; }
```

### Campos
```css
.form-control-bake { min-height:36px; padding:4px 12px; color:#321525; background:#f3f3f5; border:1px solid transparent; border-radius:10px; }
/* en formularios de módulo: min-height:44px */
.form-control-bake::placeholder { color:#7a6873; }
/* hover: sin cambio fuerte, mantiene fondo y borde */
.form-control-bake:focus { border-color:#96244f; box-shadow:0 0 0 3px rgb(150 36 79 / .50); outline:none; }
.form-control-bake:disabled { opacity:.50; cursor:not-allowed; pointer-events:none; }
.form-control-bake.is-invalid { border-color:#d4183d; box-shadow:0 0 0 3px rgb(212 24 61 / .20); }
.invalid-feedback { display:block; margin-top:4px; color:#b91c1c; font-size:12px; line-height:16px; }
```

---

## 13. Reglas para quien diseñe un módulo

1. Usar las variables de la sección 1; no inventar colores.
2. Toda vista (excepto autenticación) lleva barra lateral `#350B1A`, encabezado blanco de 80px y contenido sobre `#FCF8F9`.
3. Autenticación usa el mismo diseño de dos paneles en iniciar sesión, registrarse y recuperar contraseña.
4. Botón principal siempre `#741B3D` con texto blanco; uno solo por zona.
5. Los estados se muestran como chips con los colores de la sección 2.
6. Importar Inter (sección 3) y respetar la escala tipográfica.
7. Los números de pedido, orden, traslado y prefactura van en fuente monoespaciada.
8. Tablas siempre dentro de `table-responsive`.
9. Antes de subir cambios, revisar la vista en escritorio y en móvil, y compararla con los demás módulos.

---

## 14. Puntos por decidir en el equipo

Estas diferencias vienen del prototipo y conviene resolverlas una sola vez para que todos los módulos queden iguales:

1. **Fondo de los campos:** la paleta dice `#F2EEF1` (`--campo`), pero el campo base del prototipo usa `#F3F3F5`. Propuesta: usar `--campo` en todos.
2. **Color `#FCE8EA`:** se usa en hover de botones y en el fondo de iconos de indicadores, pero no está en la paleta. Propuesta: agregar `--vino-suave: #fce8ea;` a `:root`.
3. **Lucide con `@latest`:** el enlace del CDN no fija versión; si Lucide cambia, los iconos pueden cambiar o romperse. Propuesta: fijar una versión concreta.
4. **Inter no está importada** en el prototipo de Figma (ver sección 3). En el HTML sí debe importarse.
>>>>>>> origin/development
=======
**Se deja para la segunda etapa (JavaScript / backend):** filtrar y buscar, mover un pedido de cajón, sumar el carrito, validar campos, mostrar/ocultar errores, contraer el menú, avisos temporales, notificaciones, guardar datos.
>>>>>>> origin/development
