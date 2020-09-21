
escape_table_salida <- function() {
  if (knitr::is_latex_output())
    T else F
}

format_table_salida <- function() {
  if (knitr::is_latex_output())
    "latex" else "html"
}

formatear_tabla <- function(x_tbl, scroll = FALSE){
  tabla <- knitr::kable(x_tbl, booktabs = T) %>%
    kableExtra::kable_styling(latex_options = c("striped"),
                              bootstrap_options = c("striped", "hover", "condensed", "responsive"),
                              full_width = FALSE, fixed_thead = TRUE)
  if(scroll) tabla <- tabla %>% scroll_box(width = "780px")
  tabla
}

cuantil <- function(x, probs = c(0,0.25, 0.5, 0.75,1), ...){
  x_quo <- enquo(x)
  valores <- quantile(x, probs = probs, names = FALSE, ...)
  cuantil_nom <- probs
  tibble(cuantil = cuantil_nom, valor = valores)
}

grafica_cuantiles <- function(datos, grupo, valor){
  if(!(".sample" %in% names(datos))){
    datos$.sample <- 1
  }

  cuantiles_tbl <- datos %>% group_by({{ grupo }}, .sample) %>%
    summarise(
      num = n(),
      cuantiles = list(cuantil({{ valor }}, c(0.1, 0.25, 0.5, 0.75, 0.9)))) %>%
    unnest(cols = c(cuantiles))

  grafica <- ggplot(cuantiles_tbl  %>% spread(cuantil, valor),
                    aes(x = {{ grupo }}, y = `0.5`)) +
    geom_linerange(aes(ymin= `0.1`, ymax = `0.9`), colour = "gray40") +
    geom_linerange(aes(ymin= `0.25`, ymax = `0.75`), size = 2, colour = "gray") +
    geom_point(colour = "salmon", size = 2)
  grafica
}



marcar_tabla_fun <- function(corte, color_1 = "darkgreen", color_2 = "red"){
  fun_marcar <- function(x){
    kableExtra::cell_spec(x, format_table_salida(),
                          color = ifelse(x <= -corte, color_1, ifelse(x>= corte, color_2, "lightgray")))
  }
  fun_marcar
}

marcar_tabla_fun_doble <- function(corte_1, corte_2, color_1 = "darkgreen", color_2 = "red"){
  fun_marcar <- function(x){
    kableExtra::cell_spec(x, format_table_salida(),
                          color = ifelse(x <= corte_1, color_1, ifelse(x>= corte_2, color_2, "lightgray")),
                          bold = ifelse(x <= 3*corte_1, TRUE, ifelse(x>= 3*corte_2, TRUE, FALSE)))
  }
  fun_marcar
}
