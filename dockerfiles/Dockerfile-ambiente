FROM rocker/verse:4.0.2
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

RUN apt-get install -y --no-install-recommends \
        texlive-base \
        texlive-full \
        texlive-bibtex-extra

RUN tlmgr update --self &&\
    tlmgr init-usertree &&\
    tlmgr update --all &&\
# delete Tex Live sources and other potentially useless stuff
    echo "Delete TeX Live sources and other useless stuff." &&\
    (rm -rf /usr/share/texmf/source || true) &&\
    (rm -rf /usr/share/texlive/texmf-dist/source || true) &&\
    find /usr/share/texlive -type f -name "readme*.*" -delete &&\
    find /usr/share/texlive -type f -name "README*.*" -delete &&\
    (rm -rf /usr/share/texlive/release-texlive.txt || true) &&\
    (rm -rf /usr/share/texlive/doc.html || true) &&\
    (rm -rf /usr/share/texlive/index.html || true) &&\
# update font cache
    echo "Update font cache." &&\
    fc-cache -fv &&\
# clean up all temporary files
    echo "Clean up all temporary files." &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -f /etc/ssh/ssh_host_* &&\
# delete man pages and documentation
    echo "Delete man pages and documentation." &&\
    rm -rf /usr/share/man &&\
    mkdir -p /usr/share/man &&\
    find /usr/share/doc -depth -type f ! -name copyright -delete &&\
    find /usr/share/doc -type f -name "*.pdf" -delete &&\
    find /usr/share/doc -type f -name "*.gz" -delete &&\
    find /usr/share/doc -type f -name "*.tex" -delete &&\
    (find /usr/share/doc -type d -empty -delete || true) &&\
    mkdir -p /usr/share/doc &&\
    rm -rf /var/cache/apt/archives &&\
    mkdir -p /var/cache/apt/archives &&\
    rm -rf /tmp/* /var/tmp/* &&\
    (find /usr/share/ -type f -empty -delete || true) &&\
    (find /usr/share/ -type d -empty -delete || true) &&\
    mkdir -p /usr/share/texmf/source &&\
    mkdir -p /usr/share/texlive/texmf-dist/source &&\
    echo "All done."

# Clonamos e inicializamos el ambiente
RUN mkdir /home/$RSTUDIO_USER/$TARGET_DIR \
    && chown -R $RSTUDIO_USER:staff /home/$RSTUDIO_USER/

VOLUME [ "/home/$RSTUDIO_USER/$TARGET_DIR" ]

RUN chmod -R 775 /home/$RSTUDIO_USER/$TARGET_DIR \
    && chmod -R g+s /home/$RSTUDIO_USER/$TARGET_DIR

CMD ["/init"]
