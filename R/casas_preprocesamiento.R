library(tidyverse)
## Seleccionar variables para curso y poner nombres en español
casas_f <- read_csv("data/housing/data_train.csv") %>%
    select(id = Id, tipo_zona = MSZoning, frente_lote = LotFrontage,
           area_lote = LotArea,
           calle = Street, forma_lote = LotShape,
           nombre_zona = Neighborhood,
           tipo_edificio = BldgType, estilo = HouseStyle,
           calidad_gral = OverallQual,
           condicion_gral = OverallCond,
           año_construccion = YearBuilt,
           calidad_exteriores = ExterQual,
           material_exteriores = Exterior1st,
           condicion_exteriores = ExterCond,
           calidad_sotano = BsmtQual,
           condicion_sotano = BsmtCond,
           tipo_sotano = BsmtFinType1,
           area_sotano = TotalBsmtSF,
           calefaccion = Heating,
           calidad_calefaccion = HeatingQC,
           aire_acondicionado = CentralAir,
           area_1er_piso = `1stFlrSF`,
           area_2o_piso = `2ndFlrSF`,
           area_habitable_sup = GrLivArea,
           baños_completos = FullBath,
           baños_medios = HalfBath,
           recamaras_sup = BedroomAbvGr,
           calidad_cocina = KitchenQual,
           cuartos_sup = TotRmsAbvGrd,
           tipo_garage = GarageType,
           terminado_garage = GarageFinish,
           num_coches = GarageCars,
           area_garage = GarageArea,
           calidad_garage = GarageQual,
           condicion_garage = GarageCond,
           valor_misc = MiscVal,
           año_venta = YrSold,
           mes_venta = MoSold,
           tipo_venta = SaleType,
           condicion_venta = SaleCondition,
           precio = SalePrice)
pos <- read_csv("data/housing/geo_neighborhoods.csv") %>%
    rename(nombre_zona = Neighborhood)
casas_f <- left_join(casas_f, pos, by = "nombre_zona")
# metros cuadrados y miles de dólares
m2 <- 0.092903
casas_f <- casas_f %>% mutate(area_sotano_m2 = area_sotano * m2,
                          area_1er_piso_m2 = area_1er_piso * m2,
                          area_2o_piso_m2 = area_2o_piso * m2,
                          area_habitable_sup_m2 = area_habitable_sup * m2,
                          area_garage_m2 = area_garage * m2,
                          area_lote_m2 = area_lote * m2) %>%
    select(-area_sotano, -area_1er_piso, -area_2o_piso, -area_habitable_sup,
           -area_garage, -area_lote) %>%
    mutate(precio_miles = precio / 1000, valor_misc_miles = valor_misc / 1000) %>%
    select(-precio, -valor_misc) %>%
    mutate(precio_m2_miles = precio_miles / area_habitable_sup_m2)

casas <- casas_f %>% group_by(nombre_zona) %>%
    mutate(n_casos = n()) %>%
    filter(n_casos > 20) %>% select(-n_casos) %>% ungroup
