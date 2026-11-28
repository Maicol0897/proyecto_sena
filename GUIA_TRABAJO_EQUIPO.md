# Guía de trabajo en equipo con Git — BakeAdmin

Proyecto SENA ADSO ficha 3388489. Equipo: Duberney, Maicol y Santiago.
Repositorio: `https://github.com/Maicol0897/proyecto_sena`

Esta guía dice cómo trabajamos para **no pisarnos**, qué hacer antes, durante y después de trabajar, y cómo arreglar los errores que ya nos pasaron. Está escrita para leerla de arriba abajo la primera vez, y después usarla como consulta.

Todos los comandos se escriben en **Git Bash**, dentro de la carpeta del proyecto (la que tiene `_docs_`, `frontend_web`, etc.), salvo los que digan `npm`, que van en la terminal de VS Code dentro de `frontend_web`.

---

## 0. Conceptos mínimos (si algo suena raro, empieza aquí)

| Palabra | Qué es, en simple |
|---|---|
| **Repositorio** | La carpeta del proyecto con todo su historial de cambios |
| **Rama (branch)** | Una línea de trabajo propia. Lo que haces en tu rama no afecta a los demás hasta que lo juntas |
| **Commit** | Una "foto" guardada de tus cambios, con un mensaje que dice qué hiciste |
| **Push** | Subir tus commits de tu computador a GitHub |
| **Fetch** | Preguntarle a GitHub qué hay de nuevo, sin cambiar tus archivos |
| **Merge** | Juntar los cambios de una rama dentro de otra |
| **Pull Request (PR)** | Una petición en GitHub que dice "estos cambios de mi rama quieren entrar a `development`". Otra persona los revisa y los acepta |
| **Conflicto** | Dos personas cambiaron las mismas líneas del mismo archivo y Git no sabe cuál dejar. Lo decide una persona |
| **`origin`** | El nombre que Git le da a GitHub. `origin/development` es la copia de GitHub de la rama `development` |
| **`HEAD`** | "Donde estoy parado ahora" (la rama y el commit actuales) |

**Cómo saber en qué rama estás:** Git Bash la muestra entre paréntesis al final de la ruta: `(duberney_)`. Si dice `(duberney_|MERGING)` quiere decir que estás **en medio de un merge sin terminar** (ver sección 5).

---

## 1. Las ramas

```
duberney_  ─┐
maicol_    ─┼──►  development  ──►  main
santiago_  ─┘      (pruebas)       (entrega final)
```

| Rama | Para qué sirve | ¿Quién escribe ahí? |
|---|---|---|
| `duberney_`, `maicol_`, `santiago_` | Rama personal. Aquí se trabaja | Solo su dueño |
| `development` | Se juntan los trabajos de todos y se prueba | Nadie directo: solo por Pull Request |
| `main` | Versión final que se entrega | Nadie directo: solo por Pull Request desde `development` |

**Flujo acordado con el instructor:** cada uno trabaja y sube a su rama → todo pasa a `development` para pruebas → si todo está bien, pasa a `main` para la entrega final.

**Regla:** las ramas personales **no se borran** (se siguen usando todo el trimestre). Solo se borran las ramas temporales de emergencia (por ejemplo `fix_conflictos`), y cuando el equipo ya confirmó que no hacen falta.

---

## 2. Regla de oro y dueños de cada parte

> **Cada persona edita SOLO sus archivos.**

Tener en tu computador los archivos de otros es normal. Lo que se evita es **modificarlos**: los conflictos nacen cuando dos personas cambian el mismo archivo.

### Prototipo navegable

Ruta base: `_docs_/trim03/06_prototipo_navegable/public/`

| Vista / módulo | Archivos | Responsable |
|---|---|---|
| Recuperar contraseña (3 pantallas) | `auth/recuperar*.html`, `css/auth/recuperar.css` | Duberney |
| Compras a proveedores | `admin/compras.html`, `css/admin/compras.css`, `js/admin/compras.js` | Duberney |
| Usuarios: marco del módulo (menú lateral y barra superior) y pestaña **Usuarios** | `admin/usuarios.html`, `css/admin/usuarios.css`, `js/admin/usuarios.js` | Duberney |
| Usuarios: pestaña **Roles y permisos** | mismo `usuarios.html` (solo su pestaña) | Maicol |
| Dashboard (Inicio) | `admin/dashboard.admin.html`, `css/admin/dashboard.admin.css` | Maicol |
| Usuarios: pestaña **Sedes** | mismo `usuarios.html` (solo su pestaña) | Santiago |
| Domicilios | `admin/domicilios.html`, `css/admin/domicilios.css` | Santiago |
| Producción | `admin/produccion.html`, `css/admin/produccion.css` | _confirmar en el grupo_ |

> `usuarios.html` lo tocan tres personas, cada una **solo dentro de su pestaña**. Para eso se acordó un orden de merges (ver sección 4.3). Si alguien necesita cambiar algo fuera de su pestaña, lo pide en el grupo.

### Frontend en React (`frontend_web/`)

| Parte | Archivos | Responsable |
|---|---|---|
| Base del proyecto y configuración | `package.json`, `vite.config.js`, `eslint.config.js`, `index.html`, `main.jsx` | Duberney |
| Rutas y estructura compartida | `src/App.jsx`, `src/config/routes.js`, `src/config/constants.js`, `src/views/layouts/PanelLayout.jsx` | Duberney |
| Autenticación simulada | `models/AuthModel.js`, `controllers/AuthController.js`, `hooks/`, `services/` | Duberney |
| Cada pantalla migrada | `src/views/...` | La persona que hizo esa vista en el prototipo |

**Archivos compartidos:** son los que usan todos (`App.jsx`, `routes.js`, `constants.js`, `PanelLayout.jsx`, `package.json`). Los toca **una sola persona**. Si necesitas una ruta nueva o un texto nuevo ahí, **pídelo en el grupo** con el nombre de tu pantalla y la ruta que quieres (por ejemplo "UsersView, `/usuarios`").

---

## 3. ANTES de empezar a trabajar (siempre, cada día)

Hazlo en este orden, sin saltarte pasos:

**1. Mira en qué rama estás y que no tengas cosas a medias**
```bash
git status
```
Debe decir `nothing to commit, working tree clean`, o mostrar solo trabajo tuyo. Si hay cambios a medias de ayer, primero haz commit (sección 4) o guárdalos con `git stash` (sección 7).

**2. Cámbiate a tu rama**
```bash
git switch duberney_      # o maicol_ / santiago_
```

**3. Pregunta qué hay de nuevo en GitHub**
```bash
git fetch origin
```

**4. Trae lo nuevo de `development` a tu rama**
```bash
git merge origin/development
```
Posibles resultados:

| Qué dice | Qué significa | Qué haces |
|---|---|---|
| `Already up to date.` | No había nada nuevo | Nada, a trabajar |
| `Merge made by the 'ort' strategy` y una lista de archivos | Se juntó solo, sin problema | Sigue (en un merge se abre vim para el mensaje: déjalo y escribe `:wq` + Enter) |
| `CONFLICT (content): Merge conflict in ...` | Hay conflicto | Ve a la sección 5 |

**5. Si cambió `package.json` (frontend), instala lo nuevo**
```bash
cd frontend_web
npm install
```

**6. Comprueba que no haya marcadores de conflicto olvidados en el proyecto**
```bash
git grep -n -E "^(<<<<<<<|>>>>>>>)"
```
No debe salir nada. Si sale una línea, alguien subió un conflicto sin resolver: avisa en el grupo antes de tocar ese archivo.

---

## 4. MIENTRAS trabajas

### 4.1 Commits pequeños y frecuentes

Un commit por cada cosa terminada (una pestaña, un formulario, un arreglo). Es más fácil de revisar y de deshacer.

```bash
git status                                  # qué cambié
git add ruta/de/tu/archivo.html             # agrega SOLO tus archivos
git status                                  # ¿en verde solo lo mío?
git commit -m "feat: pestana usuarios"
git push origin duberney_
```

**Evita `git add .` y `git add -A`** salvo que `git status` te muestre únicamente archivos tuyos. Si los usas sin mirar, subes sin querer archivos de otros, `.env`, `node_modules` o basura.

### 4.2 Antes de cada commit, revisa

- [ ] `git status` muestra solo archivos míos.
- [ ] No aparecen archivos de otra persona.
- [ ] No hay `.env`, `node_modules/`, claves ni contraseñas reales.
- [ ] Si tocaste React: `npm run lint` (en `frontend_web`) termina **sin escribir nada**. Si escribe líneas en rojo, arréglalas antes del commit.
- [ ] Abriste tu pantalla en el navegador y se ve bien.

### 4.3 Archivos que tocan varias personas (`usuarios.html`)

1. Cada uno edita **solo su pestaña**, dentro de su propio comentario/bloque.
2. No muevas ni reformatees el archivo completo (por ejemplo con "Format Document"): cambia la sangría de todas las líneas y genera conflictos falsos para todos.
3. Los merges de ese archivo entran **uno por uno**, en el orden que acordó el grupo, y quien entra después trae primero `development` a su rama (sección 3).

### 4.4 Mensajes de commit

Formato: `tipo: qué hiciste` (corto, en minúscula, sin tildes si no quieres problemas).

| Tipo | Cuándo | Ejemplo |
|---|---|---|
| `feat:` | Algo nuevo | `feat: vista recuperar contrasena` |
| `fix:` | Corregir un error | `fix: boton guardar en compras` |
| `style:` | Solo diseño/CSS | `style: espaciado de tarjetas` |
| `docs:` | Documentación | `docs: guia de equipo` |
| `refactor:` | Reorganizar sin cambiar lo que hace | `refactor: separar AuthModel` |

### 4.5 Reglas del frontend en React

- Una pantalla = un archivo `.jsx` dentro de `src/views/`.
- No copies `node_modules`: es enorme y está en `.gitignore`. Cada quien lo genera con `npm install`.
- No instales librerías nuevas sin avisar: cambian `package.json` y `package-lock.json` y esos archivos chocan fácilmente.
- Usa los textos de `config/constants.js` y las rutas de `config/routes.js`; no escribas `'/dashboard'` a mano en las pantallas.

---

## 5. DESPUÉS de trabajar (subir y juntar)

### 5.1 Al terminar el día

```bash
git status                        # debe estar limpio
git push origin duberney_         # sube tu rama (cambia el nombre por el tuyo)
```
Cuando `git push` termina bien, la última línea se ve así: `duberney_ -> duberney_`.

### 5.2 Cuando una parte está terminada y probada: Pull Request

1. Antes de abrir el PR, **trae `development` a tu rama** (sección 3, pasos 2 a 4) y sube:
   ```bash
   git push origin duberney_
   ```
   Así el PR no sale con conflictos.
2. En GitHub: pestaña **Pull requests** → **New pull request**.
3. Pon **base: `development`** y **compare: tu rama**. Verifica esto con cuidado: `base` nunca debe ser `main`.
4. Debe decir **"Able to merge"** (en verde). Si dice **"Can't automatically merge"**, tu rama está desactualizada: vuelve al paso 1.
5. Título claro: `Duberney: pestaña Usuarios`. **Create pull request**.
6. **Otra persona del equipo** lo revisa (pestaña *Files changed*) y presiona **Merge pull request** → **Confirm merge**.
7. Los PR se aceptan **uno por uno**, no todos a la vez.

### 5.3 Después de que se acepta un PR

Todos los demás actualizan su rama (sección 3). Quien aceptó el PR avisa en el grupo.

### 5.4 Pasar a `main` (entrega final)

Solo cuando las tres ramas ya entraron a `development` y todo el proyecto se probó junto:

1. En GitHub, PR de **`development` hacia `main`**.
2. Se acuerda en el grupo y lo acepta una sola persona.
3. Al aceptarlo, `main` queda con la versión de entrega.

**Nadie hace `push` directo a `development` ni a `main`.**

---

## 6. Si aparece un conflicto

Un conflicto es normal y tiene arreglo. Pasa cuando dos personas cambiaron las mismas líneas. Git marca el archivo así (en el archivo real van pegadas al borde izquierdo):

```
    <<<<<<< HEAD
    lo que tenías tú
    =======
    lo que trae la otra rama
    >>>>>>> origin/development
```

### 6.1 Cómo saber que estás en un conflicto

- Al hacer `git merge` sale `CONFLICT (content): Merge conflict in archivo`.
- Git Bash muestra `(duberney_|MERGING)`.
- `git status` dice `You have unmerged paths` y lista los archivos en rojo (`both modified`).

### 6.2 Paso a paso para resolverlo

**1. No entres en pánico ni borres nada.** Un merge a medias se puede cancelar sin perder trabajo (ver 6.5).

**2. Mira qué archivos tienen conflicto**
```bash
git status
```
Todos los que digan `both modified` son los que hay que arreglar.

**3. Abre el archivo en VS Code.** Verás colores y arriba de cada conflicto cuatro opciones:

| Botón de VS Code | Qué hace | Cuándo usarlo |
|---|---|---|
| **Aceptar cambio actual** (Accept Current) | Deja lo de tu rama (`HEAD`) | Cuando lo tuyo es lo correcto |
| **Aceptar cambio entrante** (Accept Incoming) | Deja lo que trae la otra rama | Cuando lo del otro es lo correcto |
| **Aceptar ambos cambios** (Accept Both) | Deja las dos versiones, una debajo de la otra | Cuando son cosas distintas que deben quedar juntas (por ejemplo, la pestaña de Maicol y la tuya) |
| **Comparar cambios** | Muestra las dos versiones lado a lado | Cuando no entiendes qué cambió |

**Cuidado con "Aceptar ambos":** en HTML puede dejar **etiquetas duplicadas o sin cerrar** (por ejemplo dos `<a ...>` seguidas con un solo `</a>`). Esto ya nos pasó en el menú lateral. Después de elegir, **lee el resultado**: cada etiqueta que se abre debe cerrarse una sola vez.

**4. Verifica que no quede ningún marcador**
```bash
git grep -n -E "^(<<<<<<<|=======|>>>>>>>)" -- archivo_que_arreglaste
```
No debe salir nada. (Si el archivo es la propia guía de equipo, los marcadores del ejemplo están sangrados y no aparecen.)

**5. Prueba el archivo.** Si es HTML, ábrelo en el navegador. Si es React, `npm run lint` y `npm run dev`.

**6. Marca el archivo como resuelto**
```bash
git add archivo_arreglado
```

**7. Termina el merge** (cuando ya no queden archivos en rojo en `git status`)
```bash
git commit
```
Sin `-m`: Git abre **vim** con el mensaje listo. Presiona `Esc`, escribe `:wq` y Enter.

**8. Sube**
```bash
git push origin duberney_
```

**9. Si el archivo es de otra persona o no estás seguro de cuál versión es la buena, pregunta en el grupo antes de decidir.**

### 6.3 Elegir una versión completa de un archivo (solo si estás seguro)

Durante un `git merge origin/development` en tu rama personal: **`--ours` es tu rama** y **`--theirs` es `development`**.

```bash
git checkout --theirs ruta/archivo     # me quedo con la versión de development
git checkout --ours ruta/archivo       # me quedo con la mía
git add ruta/archivo
```
Descarta por completo la otra versión de ese archivo. No lo uses en archivos donde ambos tengan trabajo valioso.

### 6.4 Conflictos que no son reales: finales de línea (CRLF)

En Windows, Git avisa `LF will be replaced by CRLF the next time Git touches it`. Es **solo un aviso** sobre cómo se guardan los saltos de línea; no es un error y se ignora.

Si `git status` marca archivos como modificados que **no tocaste**, puede ser solo ese cambio invisible. Compruébalo:
```bash
git diff --ignore-cr-at-eol --stat
```
Si no sale nada, los archivos no tienen cambios reales. Para descartarlos: `git restore ruta/archivo` (esto borra cambios locales de ese archivo, úsalo solo con archivos que sí confirmaste que no tocaste).

### 6.5 Salir de un merge a medias

```bash
git merge --abort
```
Vuelve todo a como estaba antes de empezar el merge. Es lo más seguro si te enredaste.

### 6.6 Conflicto al recuperar con `git stash pop`

`git stash` guarda tus cambios sin commit para que puedas cambiar de rama; `git stash pop` los devuelve. Si al devolverlos chocan con lo nuevo, sale un conflicto igual que en un merge: se arregla con los pasos 6.2 (pasos 2 a 6) y después `git stash drop` para borrar la copia guardada.

---

## 7. Errores que ya nos pasaron (y cómo salir)

| Lo que ves | Qué pasó | Cómo se arregla |
|---|---|---|
| `error: ... reference broken` / `bad object refs/remotes/origin/santiago_` al hacer fetch | Quedó dañada la copia local de una rama remota | `rm .git/refs/remotes/origin/santiago_` (con el nombre de la rama que diga el error) y luego `git fetch origin` |
| Git Bash muestra `(rama\|MERGING)` | Empezaste un merge y no lo terminaste | Resuelve los conflictos y haz `git commit` (6.2), o cancela con `git merge --abort` |
| Se abrió una pantalla rara con texto y `~` por todos lados | Es **vim**, el editor del mensaje de commit | `Esc`, luego `:wq` y Enter (guardar y salir). Para salir sin guardar: `Esc`, `:q!` y Enter |
| `error: Your local changes to the following files would be overwritten by merge` | Tienes cambios sin guardar que el merge pisaría | Haz commit de tus cambios, o `git stash`, luego repite el merge y al final `git stash pop` |
| `Can't automatically merge` en el PR de GitHub | Tu rama está desactualizada respecto a `development` | `git fetch origin`, `git merge origin/development`, arregla conflictos, `git push` y recarga el PR |
| `! [rejected] ... (non-fast-forward)` al hacer push | En GitHub hay commits que tú no tienes | `git fetch origin`, `git merge origin/duberney_` (tu rama), resuelve, y `git push` otra vez. **Nunca `push --force`** |
| `git status` muestra archivos modificados que no tocaste | Casi siempre es solo CRLF | Ver 6.4 |
| Una pantalla del prototipo "se dañó" después de un merge (diseños distintos, botones que no funcionan) | Se quedaron marcadores `=======` o bloques duplicados dentro de un HTML | Busca con `git grep -n -E "^(<<<<<<<|=======|>>>>>>>)"`, abre el archivo, deja un solo bloque correcto, verifica que cada etiqueta se cierre una vez, prueba en el navegador y haz commit |
| Marcadores de conflicto subidos a `development` | Alguien hizo commit sin resolver | Avisa en el grupo. Se corrige en una rama aparte (por ejemplo `fix_conflictos`), se prueba y entra por PR |
| `git checkout`/`switch` dice que no puede cambiar de rama por cambios locales | Tienes trabajo sin guardar | `git stash`, cambia de rama, haz lo que necesites y vuelve con `git stash pop` |
| En el frontend sale una pantalla en blanco | Un error de React. La terminal no lo muestra, el navegador sí | `F12` → pestaña **Console** → lee el error en rojo. Causas típicas: falta `export default` en el componente, un `import` con la ruta mal escrita, o un archivo sin guardar |
| `npm` dice que no encuentra un paquete / `Cannot find module` | Falta instalar dependencias | `npm install` dentro de `frontend_web` |

### Comandos que borran trabajo (úsalos con cuidado)

| Comando | Qué hace | Regla |
|---|---|---|
| `git reset --hard HEAD` | Borra **todos** los cambios sin commit | Solo si no hay nada importante sin guardar |
| `git restore archivo` | Descarta los cambios sin commit de ese archivo | Solo con archivos que confirmaste que no te importan |
| `git push --force` | Reescribe la historia en GitHub | **Prohibido** en este proyecto |
| `git branch -D rama` | Borra una rama local sin preguntar | Solo ramas temporales; **nunca** `main`, `development` ni las personales |

### Cómo recuperarte de casi cualquier cosa

```bash
git reflog
```
Muestra el historial de todo lo que Git hizo en tu computador, incluso commits que "desaparecieron". Con el código del commit (los 7 caracteres de la izquierda) puedes volver: `git switch -c rama_rescate CODIGO`. Si llegas aquí, pide ayuda en el grupo antes de seguir.

---

## 8. Los 8 hábitos

1. Actualiza tu rama **cada día antes de tocar nada** (sección 3).
2. Trabaja **solo en tu rama**, nunca en `main` ni en `development`.
3. Edita **solo tus archivos** (y solo tu pestaña en `usuarios.html`).
4. Haz commits pequeños y frecuentes, con mensaje claro.
5. Revisa `git status` antes de cada `add` y cada `commit`.
6. Avisa en el grupo antes de tocar un archivo compartido o de aceptar un PR.
7. Después de resolver un conflicto, **busca marcadores y prueba la pantalla** antes de subir.
8. Ante la duda con un conflicto, **pregunta antes de resolver**. Nunca `push --force`.

---

## 9. Dónde va cada cosa en el repositorio

| Parte | Carpeta |
|---|---|
| Documentación y prototipo por trimestre | `_docs_/trimXX/` |
| Evidencia y entregables de la base de datos (trim 4) | `_docs_/trim04/01_base_datos` a `04_seguridad_db` |
| Evidencia del frontend (capturas, README) | `_docs_/trim04/05_frontend_web/` |
| Frontend web funcional (React + Vite) | `frontend_web/` |
| Backend y API | `backend/` |
| Base de datos | `database/` |
| App móvil | `frontend_mob/` |

> El proyecto React vive en `frontend_web/` (en la raíz). La carpeta `_docs_/trim04/05_frontend_web/` es **solo documentación y evidencia**, no va el código ahí.

---

## 10. Resumen en una hoja

```
ANTES      git status → git switch mi_rama → git fetch origin → git merge origin/development
DURANTE    editar solo lo mío → git status → git add archivo → git commit -m "tipo: algo" → git push origin mi_rama
DESPUÉS    PR de mi_rama a development (base = development) → otro lo revisa y lo acepta → todos actualizan
CONFLICTO  git status → abrir archivo → elegir versión → verificar etiquetas → git add → git commit → git push
SE ENREDÓ  git merge --abort  (o git reflog y pedir ayuda)
```
