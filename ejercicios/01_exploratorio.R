library(tidyverse)
library(patchwork)
## Lee los datos
tips <- read_csv("tips.csv")
glimpse(tips)

## Recodificar nombres y niveles
propinas <- tips %>% 
  rename(cuenta_total = total_bill, 
         propina = tip, sexo = sex, 
         fumador = smoker,
         dia = day, momento = time, 
         num_personas = size) %>% 
  mutate(sexo = recode(sexo, Female = "Mujer", Male = "Hombre"), 
         fumador = recode(fumador, No = "No", Si = "Si"),
         dia = recode(dia, Sun = "Dom", Sat = "Sab", Thur = "Jue", Fri = "Vie"),
         momento = recode(momento, Dinner = "Cena", Lunch = "Comida")) %>% 
  select(-sexo) %>% 
  mutate(dia  = fct_relevel(dia, c("Jue", "Vie", "Sab", "Dom")))
propinas


## 1. Calcula percentiles de la variable propina
## junto con mínimo y máximo
quantile(propinas$propina)
  
## 2. Haz una gráfica de cuantiles de la variable propina
propinas <- propinas %>% 
  mutate(orden_propina = rank(propina, ties.method = "first"), 
         f = orden_propina / n()) 
## aquí tu código
ggplot(propinas, aes(x = f, y = propina)) +
  geom_point()

## 3. Haz un histograma de la variable propinas
## Ajusta distintos anchos de banda
ggplot(propinas, aes(x = propina)) +
  geom_histogram(binwidth = 0.6)  


## 4. Haz una gráfica de cuenta total contra propina
ggplot(propinas, aes(x = cuenta_total, y = propina)) +
  geom_point() +
  geom_smooth()


## 5. Calcula propina en porcentaje de la cuenta total
## calcula algunos cuantiles de propina en porcentaje
propinas <- propinas %>% 
  mutate(pct_propina = 100 * propina / cuenta_total)
           
quantile(propinas$pct_propina)
  
  
## 6. Haz un histograma de la propina en porcentaje. Prueba con
##  distintos anchos de banda. 
ggplot(propinas, aes(x = pct_propina)) +
  geom_histogram(binwidth = 2.5)

## 7. Describe la distribución de propina en pct. ¿Hay datos atípicos?


##8. Filtra los casos con porcentaje de propina muy altos. 
## ¿Qué tipos de cuentas son? ¿Son cuentas grandes o chicas?
filter(propinas, pct_propina > 20)


## 9. Haz una diagrama de caja y brazos para 
## propina en dolares dependiendo del momento (comida o cena)
## ¿Cuál parece más grande? ¿Por qué? Haz otras gráficas si es necesario.
ggplot(propinas, aes(x = momento, y = propina)) +
  geom_boxplot()


