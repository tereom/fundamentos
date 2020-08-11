
library(tidyverse)
library(foreign)
library(lubridate)

# ruta a archivos zip bajados de inegi
archivos <- list.files(path = "./datos_zip/", full.names = TRUE)

walk(archivos, function(archivo){
    unzip(archivo, exdir = "./datos/", overwrite = TRUE)
})
archivos_dbf <- list.files(path = "./datos/", full.names = FALSE) %>% 
    keep( ~ str_detect(.x, "NACIM"))
# guardar como rds
archivos_dbf %>% walk(function(archivo){
    print(archivo)
    dat <- read.dbf(paste0("./datos/", archivo))
    nombre <- str_split(archivo, "\\.")[[1]][1] %>% paste0(".rds")
    write_rds(dat, paste0("./datos/", nombre))
})


archivos_rds <- list.files(path = "./datos", full.names = TRUE) %>% 
    keep( ~ str_detect(.x, "NACIM99|NACIM[0-1]")) %>% keep( ~ str_detect(.x, "rds"))
datos <- map(archivos_rds, function(archivo){
    print(archivo)
    dat <- read_rds(archivo) %>% 
        select(ENT_OCURR, DIA_NAC, contains("MES_NAC"), ANO_NAC, TIPO_NAC) %>%
        rename_all(~sub('NACIM', 'NAC', .x)) %>% 
        group_by(DIA_NAC, MES_NAC, ANO_NAC) %>% 
        tally()
    dat            
}) %>% bind_rows


# filtrar años de nacimiento registrados tardíamente, y faltantes
datos_dia <- datos %>% 
    filter(ANO_NAC > 1998) %>% 
    filter(ANO_NAC != 9999, MES_NAC != 99, DIA_NAC!= 99) %>% 
    unite(fecha_str, ANO_NAC, MES_NAC, DIA_NAC, sep="-") %>%
    mutate(fecha = lubridate::ymd(fecha_str)) %>% 
    filter(!is.na(fecha)) %>% 
    group_by(fecha, fecha_str) %>% summarise(n = sum(n)) %>% 
    filter(year(fecha) < 2017)

# crear variables adicionales
datos_dia <- datos_dia %>%
    mutate(dia = day(fecha), mes = month(fecha),
           año = year(fecha), wd = weekdays(fecha)) %>% 
    mutate(dia_año = yday(fecha))