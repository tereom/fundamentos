FROM rocker/tidyverse
MAINTAINER Alfredo Garbuno Iñigo "alfredo.garbuno@gmail.com"

# Declaramos al usuario, y las
ENV RSTUDIO_USER rstudio
ENV TARGET_DIR cursos

RUN adduser $RSTUDIO_USER sudo

# Declaramos ruta de trabajo
WORKDIR /home/$RSTUDIO_USER/

# Instalamos herramientas: htop (monitoreo) y librerias que necesita R para
# compilar paquetes
RUN apt-get update \
    && apt-get install -y libmagick++-dev htop

# Clonamos e inicializamos el ambiente
RUN mkdir /home/$RSTUDIO_USER/$TARGET_DIR \
    && chown -R $RSTUDIO_USER:$RSTUDIO_USER /home/$RSTUDIO_USER/

VOLUME [ "/home/$RSTUDIO_USER/$TARGET_DIR" ]

RUN chmod -R 775 /home/$RSTUDIO_USER/$TARGET_DIR \
    && chmod -R g+s /home/$RSTUDIO_USER/$TARGET_DIR

CMD ["/init"]
