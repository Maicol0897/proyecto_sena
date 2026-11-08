# BakeAdmin — Guía de estilos

Referencia única para que todos los módulos (Usuarios, Compras, Producción y Domicilios) se vean igual.
Fuente: prototipo de Figma de BakeAdmin (Coffee Park). Si algo de esta guía contradice el prototipo, manda el prototipo y hay que actualizar este archivo.

**Cómo usarla:** copia el bloque `:root` de la sección 1 en tu CSS, usa siempre las variables (`var(--vino)`) y reutiliza los componentes de la sección 11. No escribas colores a mano ni inventes estilos nuevos.

## Índice
1. Colores
2. Colores de estado
3. Tipografía
4. Espaciado
5. Botones y campos (medidas)
6. Radios de borde
7. Sombras
8. Iconos
9. Layout principal
10. Responsive
11. Componentes reutilizables (tarjeta de indicador, chip, tabla, modal, formulario)
12. Estados de botones y campos
13. Reglas para quien diseñe un módulo
14. Puntos por decidir

---

## 1. Colores

```css
:root {
  --vino-oscuro: #350b1a;
  --vino-profundo: #4a1027;
  --vino: #741b3d;
  --vino-medio: #96244f;
  --coral: #f27c86;
  --rosa: #f6b4b8;

  --fondo: #fcf8f9;
  --campo: #f2eef1;
  --blanco: #ffffff;

  --texto: #321525;
  --texto-secundario: #7a6873;

  --borde: rgba(116, 27, 61, 0.14);
  --foco: #96244f;
  --destructivo: #d4183d;
}
```

| Color | Uso |
|---|---|
| `#350B1A` vino-oscuro | Barra lateral, encabezados oscuros, superficies de máxima jerarquía, panel izquierdo de autenticación. |
| `#4A1027` vino-profundo | Hover o superficie secundaria sobre la barra lateral; decoración sobre fondos vino. |
| `#741B3D` vino | Botones principales, precios, enlaces e iconos activos, categoría seleccionada. |
| `#96244F` vino-medio | Etiquetas superiores, títulos pequeños, subtítulo del módulo, anillo de foco. |
| `#F27C86` coral | Elemento activo de navegación, acentos, indicadores, pasos completados. |
| `#F6B4B8` rosa | Textos secundarios sobre fondos vino. |
| `#FCF8F9` fondo | Fondo general de todas las vistas. |
| `#F2EEF1` campo | Campos, buscadores, fondos secundarios. |
| `#321525` texto | Texto principal. |
| `#7A6873` texto-secundario | Descripciones, ayudas, fechas, metadatos. |
| `#FFFFFF` blanco | Tarjetas, tablas, encabezado superior, texto sobre botones vino. |
| `rgba(116,27,61,.14)` borde | Bordes generales. |

### Uso por zonas

**Barra lateral:** fondo `#350B1A` · texto principal blanco · texto secundario `#F6B4B8` · opción activa fondo `#F27C86` con texto `#350B1A` · separadores blanco con baja opacidad.

**Encabezado superior:** fondo blanco · título del módulo `#96244F` · nombre de usuario `#321525` · información secundaria `#7A6873` · botón "Cerrar sesión" con borde y texto `#741B3D`.

**Contenido:** fondo `#FCF8F9` · tarjetas blancas · títulos `#350B1A` o `#321525` · botones principales `#741B3D` · acentos `#F27C86`.

**Autenticación (iniciar sesión, registrarse, recuperar contraseña):** panel izquierdo `#350B1A` · titular blanco y `#F27C86` · eslogan `#F6B4B8` · panel del formulario `#FCF8F9` · campos `#F2EEF1` · botón principal `#741B3D`. Las tres vistas usan el mismo diseño.

**Menú del cliente:** encabezado promocional `#350B1A` · categoría seleccionada, precio y botones de agregar `#741B3D` · etiquetas en coral y rosados suaves · tarjetas de producto blancas sobre `#FCF8F9`.

---

## 2. Colores de estado

Solo para comunicar estados. **No usarlos como decoración.**

| Estado | Fondo suave | Texto | Borde opcional |
|---|---|---|---|
| Verde / correcto | `#F0FDF4` | `#15803D` | `#BBF7D0` |
| Ámbar / advertencia | `#FFFBEB` | `#92400E` | `#FDE68A` |
| Rojo / error | `#FEF2F2` | `#B91C1C` | `#FECACA` |
| Azul / informativo | `#EFF6FF` | `#1D4ED8` | `#BFDBFE` |
| Morado / despacho | `#FAF5FF` | `#7E22CE` | `#E9D5FF` |


### Correspondencia en pedidos

| Estado del pedido | Fondo | Texto |
|---|---|---|
| Pendiente | `#FFFBEB` | `#92400E` |
| Aceptado | `#EFF6FF` | `#1D4ED8` |
| En preparación | `#FDF2F8` | `#741B3D` |
| Despachado | `#FAF5FF` | `#7E22CE` |
| Entregado | `#F0FDF4` | `#15803D` |
| Cancelado | `#FEF2F2` | `#B91C1C` |

Verde: entregados, facturados, stock suficiente, confirmaciones · Ámbar: pendientes, stock bajo · Rojo: errores, cancelaciones, sin stock · Azul: órdenes enviadas, aceptados, en tránsito · Morado: pedidos despachados, repartidores asignados.

---

## 3. Tipografía

```css
font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

**Importante:** Inter no viene incluida. Sin importarla, Windows muestra Segoe UI y macOS/iOS la fuente del sistema, y los módulos se verán distintos. Agregar en el `<head>` de cada página:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
```

### Escala tipográfica

| Uso | Tamaño | Interlineado | Peso |
|---|---|---|---|
| Título de módulo | 30px / 1.875rem | 36px | 900 |
| Título grande de sección | 24px / 1.5rem | 32px | 800–900 |
| Título de tarjeta | 16px / 1rem | 16px | 600–700 |
| Título de modal | 18px / 1.125rem | 18px | 600 |
| Subtítulo o descripción | 14px / 0.875rem | 20px | 400 |
| Cuerpo general | 16px / 1rem | 24px | 400 |
| Cuerpo compacto y tablas | 14px / 0.875rem | 20px | 400–500 |
| Etiqueta de formulario | 16px / 1rem | 24px | 500–600 |
| Etiqueta compacta | 12px / 0.75rem | 16px | 600 |
| Texto pequeño | 12px / 0.75rem | 16px | 400–500 |
| Texto mínimo de versión | 10px / 0.625rem | 14px | 400 |
| Número grande de indicador | 30px / 1.875rem | 36px | 900 |
| Indicador extra grande | 36px / 2.25rem | 40px | 900 |

```css
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
--font-extrabold: 800;
--font-black: 900;
```

### Fuente monoespaciada
Solo para identificadores: números de pedido, de orden de compra, de traslado y de prefactura.

```css
.codigo { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace; }
```

---

## 4. Espaciado

Escala en múltiplos de 4px.

```css
--space-1: 4px;  --space-2: 8px;  --space-3: 12px; --space-4: 16px;
--space-5: 20px; --space-6: 24px; --space-8: 32px;
```

| Elemento | Valor |
|---|---|
| Separación vertical entre secciones | 24px |
| Separación entre tarjetas | 16px |
| Separación grande entre bloques | 20px |
| Espacio entre icono y texto | 8px o 12px |
| Padding de tarjeta estándar | 24px |
| Padding de tarjeta compacta | 16px o 20px |
| Padding de modal | 24px |
| Padding horizontal del contenido | 32px escritorio · 16px móvil |
| Padding vertical del contenido | 24px |
| Padding de fila de tabla | 8px |
| Separación entre campos | 16px |
| Separación label–campo | 6px–8px |

---

## 5. Botones y campos (medidas)

| Elemento | Alto | Padding | Notas |
|---|---|---|---|
| Botón estándar | 36px | 8px 16px | gap 8px; con icono `padding-inline: 12px` |
| Botón pequeño | 32px | 6px 12px | gap 6px |
| Botón grande | 40px | inline 24px | |
| Botón principal del dashboard | 44px | | |
| Botón de formularios y checkout | 48px | | |
| Campo base | 36px | 4px 12px | |
| Campo de formularios de módulo | 44px | inline 12px | |
| Campo de autenticación y checkout | 48px | | |

---

## 6. Radios de borde

```css
--radius: 12px;
--radius-sm: 8px;
--radius-md: 10px;
--radius-lg: 12px;
--radius-xl: 16px;
--radius-pill: 9999px;
```

| Componente | Radio |
|---|---|
| Tarjeta estándar | 16px |
| Tarjeta compacta | 12px |
| Botón estándar | 10px |
| Campo / Select | 10px |
| Chip estándar | 10px |
| Chip tipo píldora | 9999px |
| Modal estándar | 12px |
| Modal móvil especial | 24px |
| Opción activa del sidebar | 16px |
| Contenedor de tabla | 12px |
| Avatar o botón circular | 50% |

---

## 7. Sombras

**Tarjeta base:** sin sombra, con borde.
```css
box-shadow: none;
border: 1px solid rgba(116, 27, 61, 0.14);
```
**Tarjeta con elevación:**
```css
box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.10), 0 1px 2px -1px rgb(0 0 0 / 0.10);
```
**Modal:**
```css
box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.10), 0 4px 6px -4px rgb(0 0 0 / 0.10);
/* overlay */ background: rgb(0 0 0 / 0.50);
```
**Encabezado superior:** sin sombra, separado por borde.
```css
box-shadow: none;
border-bottom: 1px solid rgba(116, 27, 61, 0.14);
background: rgb(255 255 255 / 0.95);
backdrop-filter: blur(8px);
```
**Navegación activa:** igual a la tarjeta con elevación.
**Carrito flotante:**
```css
box-shadow: 0 10px 35px rgba(53, 11, 26, 0.28);
```

---

## 8. Iconos

Librería: **Lucide** (en el prototipo de Figma se usa `lucide-react`). Para HTML con Bootstrap:

```html
<script src="https://unpkg.com/lucide@latest"></script>
<script>lucide.createIcons();</script>
```
Uso: `<i data-lucide="truck"></i>`. Catálogo de iconos: https://lucide.dev/icons

| Ubicación | Tamaño |
|---|---|
| Navegación lateral | 20px |
| Botones | 16px |
| Indicadores | 20px |
| Notificaciones | 20px |
| Estado o alerta | 20px |
| Chips | 12px |
| Campos y buscadores | 16px |
| Logo del sidebar | 44px × 44px |

Trazo habitual: `stroke-width: 2; flex-shrink: 0;`

---

## 9. Layout principal

```css
/* Barra lateral */
width: 256px; height: 100vh; position: fixed; left: 0; top: 0;
/* contraída */ width: 76px;
/* drawer móvil */ width: 288px;

/* Encabezado */
height: 80px; position: sticky; top: 0; z-index: 40;

/* Contenido */
max-width: 1440px; margin-inline: auto; padding: 24px 32px;  /* móvil: 24px 16px */

/* Desplazamiento según sidebar */
margin-left: 256px;  /* abierta */
margin-left: 76px;   /* contraída */

/* Pie de página */
padding: 16px 32px; border-top: 1px solid rgba(116, 27, 61, 0.14);
font-size: 12px; text-align: center;
```

---

## 10. Responsive

```css
@media (min-width: 640px)  {} /* sm */
@media (min-width: 768px)  {} /* md */
@media (min-width: 1024px) {} /* lg */
@media (min-width: 1280px) {} /* xl */
```

**Barra lateral (menos de 1024px):** la barra fija desaparece, aparece un botón de menú en el encabezado, la navegación se abre como drawer de 288px y el resto de la pantalla recibe un overlay negro al 40%.
```css
.mobile-overlay { position: fixed; inset: 0; background: rgb(0 0 0 / 0.40); }
```

**Tablas:** nunca se reducen hasta ser ilegibles; van dentro de un contenedor con scroll horizontal.
```html
<div class="table-responsive"><table class="table">...</table></div>
```

**Tarjetas:** 1 columna en móvil, 2 desde 768px, 3 o 4 desde 1280px según el módulo.
```css
.module-grid { display: grid; grid-template-columns: 1fr; gap: 16px; }
@media (min-width: 768px)  { .module-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (min-width: 1280px) { .module-grid { grid-template-columns: repeat(4, minmax(0, 1fr)); } }
```

**Modales:** `width: calc(100% - 32px); max-width: 512px; max-height: 90vh; overflow-y: auto;`. Los botones del footer se apilan en móvil y se alinean horizontalmente desde 640px.

---

## 11. Componentes reutilizables

### A. Tarjeta de indicador
```html
<article class="card bake-card metric-card">
  <div class="card-body">
    <div class="d-flex align-items-start justify-content-between gap-3">
      <div class="min-width-0">
        <p class="metric-label mb-0">Pedidos en curso</p>
        <p class="metric-value mb-0">12</p>
      </div>
      <div class="metric-icon"><i data-lucide="truck"></i></div>
    </div>
  </div>
</article>
```
```css
.bake-card { background:#fff; border:1px solid rgba(116,27,61,.14); border-radius:16px; color:#321525; }
.bake-card .card-body { padding:20px; }
.metric-label { color:#7a6873; font-size:14px; line-height:20px; }
.metric-value { margin-top:8px; font-size:30px; line-height:36px; font-weight:900; }
.metric-icon { display:grid; width:44px; height:44px; place-items:center; border-radius:12px; color:#741b3d; background:#fce8ea; }
```

### B. Chip de estado
```html
<span class="status-chip status-success">Entregado</span>
```
```css
.status-chip { display:inline-flex; align-items:center; justify-content:center; width:max-content; padding:2px 8px; gap:4px;
  border:1px solid transparent; border-radius:10px; font-size:12px; line-height:16px; font-weight:500; white-space:nowrap; }
.status-success { color:#15803d; background:#f0fdf4; }
.status-warning { color:#92400e; background:#fffbeb; }
.status-danger  { color:#b91c1c; background:#fef2f2; }
.status-info    { color:#1d4ed8; background:#eff6ff; }
.status-purple  { color:#7e22ce; background:#faf5ff; }
/* "En preparación" */
.status-prep    { color:#741b3d; background:#fdf2f8; }
```

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
