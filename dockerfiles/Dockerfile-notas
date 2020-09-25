FROM rocker/tidyverse
MAINTAINER Alfredo Garbuno Iñigo "alfredo.garbuno@gmail.com"

# Declaramos al usuario, y las
ENV RSTUDIO_USER rstudio
ENV GITHUB_HOST tereom
ENV GITHUB_REPO fundamentos
ENV GIT_BRANCH 'ag/docker-image'
ENV CONTAINER_TARGET notas-fundamentos

# Declaramos ruta de trabajo
WORKDIR /home/$RSTUDIO_USER/

# Instalamos herramientas: htop (monitoreo) y librerias que necesita R para
# compilar paquetes
RUN apt update \
    && apt install -y libmagick++-dev htop

# Cambiamos de usuario para garantizar el cache de renv
USER $RSTUDIO_USER

# Clonamos e inicializamos el ambiente
RUN R -e "install.packages('renv', repos = 'http://cran.us.r-project.org', type = 'source')" \
    && git clone https://github.com/$GITHUB_HOST/$GITHUB_REPO.git $CONTAINER_TARGET \
    && cd $CONTAINER_TARGET \
    && git checkout $GIT_BRANCH \
    && git pull \
    && R -e "renv::restore(project = '/home/$RSTUDIO_USER/$CONTAINER_TARGET/')" \
    && chown -R rstudio:rstudio /home/$RSTUDIO_USER/$CONTAINER_TARGET/

# Cambiamos de regreso a root para lanzar `Rstudio`
USER root

CMD ["/init"]
