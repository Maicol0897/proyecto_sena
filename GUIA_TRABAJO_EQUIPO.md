# Guía de trabajo en equipo con Git — BakeAdmin

Proyecto SENA ADSO ficha 3388489. Esta guía dice cómo trabajamos todos para **no pisarnos** y que el día de juntar todo no haya conflictos.

---

## 1. Las ramas

```
duberney_   ─┐
maicol_     ─┤
santiago_   ─┼─►  development  ─►  main
miguel_     ─┘    (pruebas)       (entrega final)
```

| Rama | Para qué sirve | ¿Quién escribe ahí? |
|---|---|---|
| `duberney_`, `maicol_`, `santiago_`, `miguel_` | Rama personal. Aquí se trabaja. | Solo su dueño |
| `development` | Se juntan los trabajos de todos y se prueba. | Nadie directamente, solo por Pull Request |
| `main` | Versión final que se entrega. | Nadie directamente, solo por Pull Request desde `development` |

**Flujo acordado con el instructor:** cada uno trabaja y sube a su rama → se pasa todo a `development` para pruebas → si todo está bien, se sube a `main` para la entrega final.

---

## 2. Regla de oro

> **Cada persona edita SOLO sus archivos.**

Tener en tu computador los archivos de otros es normal y no es problema. Lo que se evita es **modificarlos**. Los conflictos nacen cuando dos personas cambian el mismo archivo.

### Quién es dueño de qué

Ruta base: `_docs_/trim03/06_prototipo_navegable/public/`

| Módulo / vista | Archivos | Responsable |
|---|---|---|
| Recuperar contraseña | `auth/recuperar.html`, `css/auth/recuperar.css` | Duberney |
| Compras a proveedores | `admin/compras.html`, `css/admin/compras.css`, `js/admin/compras.js` | Duberney |
| _Completar_ | _Completar_ | _Completar_ |
| _Completar_ | _Completar_ | _Completar_ |

> Cada integrante completa sus filas. Si una vista no tiene dueño, se asigna en el grupo **antes** de empezar.

### Archivos compartidos (los toca UNA sola persona)

Son los que usan todos: variables de color, estilos base, barra lateral, encabezado, `bootstrap`, `index.html`.

- Responsable de archivos compartidos: **_______________** (definir en el grupo).
- Si necesitas un cambio ahí, **pídelo en el grupo**; no lo edites tú.
- Quien los cambie avisa al equipo para que todos traigan la versión nueva.

---

## 3. Rutina de cada día

### Al empezar

```bash
git checkout nombre_de_tu_rama
git fetch origin
git merge origin/development
```

Si `development` no tiene cambios nuevos, no pasa nada: sigues igual.

### Mientras trabajas

Haz commits pequeños y frecuentes:

```bash
git status                       # mira qué cambiaste
git add ruta/de/tu/archivo.html  # agrega SOLO tus archivos
git commit -m "feat: formulario de nueva compra"
git push origin nombre_de_tu_rama
```

**Evita `git add -A` y `git add .`** salvo que `git status` te muestre únicamente tus archivos.

### Antes de cada commit, revisa

- [ ] `git status` muestra solo archivos míos.
- [ ] No aparecen archivos de otra persona.
- [ ] No hay archivos como `.env`, `node_modules/` ni claves.

---

## 4. Mensajes de commit

Formato: `tipo: qué hiciste` (corto y claro).

| Tipo | Cuándo |
|---|---|
| `feat:` | Algo nuevo (una vista, un módulo) |
| `fix:` | Corregir un error |
| `style:` | Cambios solo de diseño/CSS |
| `docs:` | Documentación |
| `refactor:` | Reorganizar sin cambiar lo que hace |

Ejemplos: `feat: vista recuperar contraseña`, `fix: botón guardar en compras`, `docs: guía de estilos`.

---

## 5. Cómo se junta todo (Pull Requests)

1. Tienes algo terminado y probado en tu rama → `git push origin tu_rama`.
2. En GitHub: **Pull Request** de `tu_rama` hacia `development`.
3. Otra persona del equipo lo revisa y lo acepta.
4. Se aceptan **uno por uno**, no todos a la vez.
5. Cuando todas las ramas entraron a `development`, se prueba el proyecto completo.
6. Si todo funciona: **Pull Request** de `development` hacia `main` para la entrega final.

**Nadie hace `push` directo a `development` ni a `main`.**

---

## 6. Si aparece un conflicto

Un conflicto es normal y se puede arreglar. Pasa cuando dos personas cambiaron las mismas líneas del mismo archivo. Git marca así:

```
<<<<<<< HEAD
tu versión
=======
la versión del otro
>>>>>>> origin/development
```

Pasos:

1. **No entres en pánico ni borres nada.**
2. Abre el archivo marcado y decide qué se queda (a veces las dos partes).
3. Borra las líneas `<<<<<<<`, `=======` y `>>>>>>>`.
4. Guarda, y luego:

```bash
git add archivo_arreglado
git commit -m "fix: resolver conflicto en archivo"
```

5. **Si el archivo es de otra persona o no estás seguro, pregunta en el grupo** antes de decidir.

Si todo se enreda y no hay nada importante sin guardar, `git reset --hard HEAD` deshace los cambios locales sin commit. **Úsalo con cuidado:** borra lo que no hayas guardado.

---

## 7. Los 7 hábitos

1. Actualiza tu rama **cada día antes de tocar nada**.
2. Trabaja **solo en tu rama**, nunca en `main` ni en `development`.
3. Edita **solo tus archivos**.
4. Haz commits pequeños y frecuentes, con mensaje claro.
5. Revisa `git status` antes de cada commit.
6. Avisa en el grupo antes de tocar un archivo compartido.
7. Ante la duda con un conflicto, **pregunta antes de resolver**.

---

## 8. Dónde va cada cosa en el repositorio

| Parte | Carpeta |
|---|---|
| Documentación y prototipo por trimestre | `_docs_/trimXX/` |
| Front-end web funcional | `frontend_web/` |
| Backend y API | `backend/` |
| Base de datos | `database/` |
| App móvil | `frontend_mob/` |
