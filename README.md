[![Netlify Status](https://api.netlify.com/api/v1/badges/54022ee4-ae84-48c5-915c-20b85ccb6e08/deploy-status)](https://app.netlify.com/sites/fundamentos/deploys)


Notas del curso *Fundamentos de Estadística con Remuestreo* del programa de
maestría en Ciencia de Datos del ITAM sitio: https://fundamentos-est.netlify.app

---

# Instrucciones para generar las notas por medio de `Docker`.

Puedes generar las notas por medio de un contenedor de `Docker`. Para esto debes
de tener instalado el [`Docker Desktop`](https://docs.docker.com/desktop/) si tu
sistema operativo es `MacOS` o `Windows`; o alternativamente, [`Docker
Engine`](https://docs.docker.com/engine/), si estás corriendo alguna
distribución de `Linux`.

Con `Docker` listo en tu máquina necesitas descargar la imagen del contenedor
de la clase:
```{bash}
docker pull agarbuno/notas-fundamentos
```

Para ejecutar la imagen en tu computadora copia y pega lo siguiente en la
terminal, modificando como se sugiere mas adelante,
```{bash}
docker run -d -p 8787:8787 -e PASSWORD=<escribeunacontraseña> -m 4g agarbuno/notas-fundamentos
```
En general se necesita correr la imagen con 4Gb de memoria (`-m 4g`).  La opción
`-d` es opcional, y sirve para dejar corriendo el contenedor en el *background*
de tu sesión de terminal. Cuidado con esta opción por que si no tienes cuidado
podrías estar levantando múltiples contenedores en tu máquina.

Esta imagen leventará una sesión de `Rstudio Server` a la cual podrás acceder en
tu navegador de internet de preferencia por medio de
```{bash}
localhost:8787/
```
el cual te pedirá un usuario y contraseña. La contraseña es la misma que deberás
de cambiar en las líneas de arriba: *escribeunacontraseña*. El usuario es, por
*default*,
`rstudio`.

Una vez en la pantalla de `Rstudio` puedes empezar con cargar las notas como un
proyecto.

**NOTA.** Esta imagen se actualizará constantemente. Pero nada garantizará que
esté en sincronía con la última versión de las notas en el repositorio. Para
garantizar la sincronía proponemos dos alternativas.

**La primera opción** te funcionará bien si sólo te interesa compilar la última versión de
las notas. Para esto necesitas:

- Hacer *pull* del repositorio. Con `git pull` en terminal o usando la interfaz gráfica.  
- Sincronizar las librerías del ambiente. Con `renv::init()` usando la opción 1.  

**La segunda opción** es generar la imagen del contenedor tú mismo. Esta opción también te
la recomendamos si quieres hacer cambios en tu `fork` del repositorio. Para esto
puedes utilizar el dockerfile con el que estamos generando el contenedor de las
notas. Este lo encuentras
[`agarbuno/dockerfiles`](https://github.com/agarbuno/dockerfiles/tree/master/notas-fundamentos). Sigue las instrucciones en el `README.md` en el repositorio.

# Instrucciones para generar las notas de manera local.

**Importante.** Si tienes una computadora `Mac` échale un ojo a la siguiente
sección antes de instalar `R`. Esto garantizará que tienes todas las dependencias
instaladas que necesita `R` en tu máquina.

1. Asegúrate de tener instalados tanto [`R`](https://cloud.r-project.org/) como
[`Rstudio`](https://rstudio.com/products/rstudio/download/) en tu máquina (en
este orden). Y también asegúrate de tener clonado el repositorio del curso en tu máquina.
```{bash}
git clone https://github.com/tereom/fundamentos.git
```

2. Inicia `Rstudio` e instala los siguientes paquetes de `R`.
```{r}
install.packages("renv")
install.packages("rmarkdown")
```

`renv` nos permitirá sincronizar la paquetería necesaria para correr las notas
de manera local. `rmarkdown` es el compilador de las notas.

3. Una vez instalados, reinicia `Rstudio` y abre el repositorio como un projecto.
![rstudio-project](images/rstudio-project.png)

4. Una vez que estés en el proyecto de las notas, sincroniza tú colección de librerías con las que utilizamos para generar el documento. Esto lo hacemos (la primera vez) con:
```{r}
renv::init()
```
dónde se te pedirá confirmación para descargar todos los paquetes en su versión
correcta.  

**Nota:** esto sólo lo tienes que hacer la primera vez.

# Consideraciones adicionales para `MacOS`.

De preferencia antes de instalar `R` considera las siguientes pasos. Esto es por
que en `MacOS` necesitamos compiladores de `fortran`, `c++`, etc., para algunas librerías.

1. Habilita las herramientas de línea de comandos de `xcode`:
```{bash}
xcode-select --install
```

2. Instala el manejador de paquetes `homebrew`:
```{bash}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

3. Con homebrew instalado, ahora instala la última versión disponible de la colección de compiladores GNU (al día 12-Sep-2020, ésta es la versión `10`):
```{bash}
brew install gcc
```

4. Instala [`XQuartz`](https://www.xquartz.org/).

5. Habilita la ruta donde `R` tiene que buscar los compiladores que instalaste en el paso 3. Primero prepara el archivo:
```{bash}
mkdir ~/.R/
touch ~/.R/Makevars
```
luego en algún editor de texto incluye las líneas en el archivo `Makevars`. Por ejemplo, escribe en terminal:
```{bash}
open ~/.R/Makevars
```
y una vez en el editor de texto escribe:
```{bash}
VER=-10
CC=gcc$(VER)
CXX=g++$(VER)
CXX11=g++$(VER)
CXX14=g++$(VER)
CXX17=g++$(VER)
CFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
CXXFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
FLIBS=-L/usr/local/Cellar/gcc/10.2.0/lib/gcc/10
```
y guarda el archivo.

Ahora si, regresa a la sección anterior e instala `R` y `Rstudio`.
