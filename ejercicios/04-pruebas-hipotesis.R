library(tidyverse)
library(nullabor)

propinas <- read_csv("propinas.csv")

# Prueba de sospechosos (prueba de hipótesis visual)
# ¿Las propinas son diferentes entre cena y comida (momento)

# 1. Crea permutaciones
# ¿Cómo se ve la tabla perms_momento?
perms_momento <- lineup(null_permute("momento"), propinas, n = 25)
decrypt("bknL 2qJq PZ 0sSPJPsZ 67")
perms_momento %>%
  count(.sample)

# Haz una grafica de caja y brazo de momento contra propinas
# separando en páneles las permutaciones
ggplot(perms_momento, aes(x = momento, y = propina)) +
  geom_boxplot() +
  facet_wrap(~.sample)

# puedes identificar los datos verdaderos?
# usa el comando decrypt que salió arriba para averiguar
# dónde están los datos


# qué tanta evidencia crees que aporta este análisis
# en contra de la hipótesis que las propinas son similares
# en niveles en comida y cena)

#------------------

# 2. Relaciones lineales
# ¿Está relacionado el tamaño de la cuenta con el tamaño de la propina?
perms_momento <- lineup(null_permute("cuenta_total"), propinas, n = 12)


# Haz una grafica de puntos de tamaño de cuenta vs propina
# separando en páneles las permutaciones
ggplot(perms_momento, aes(x = cuenta_total, y = propina)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~.sample)

# cuánta evidencia tienes en contra de que no están relacionados?

