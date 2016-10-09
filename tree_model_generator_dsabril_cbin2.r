#Library
source("fun_ganancia.R")
library(rpart)
library(RMySQL)

#Variables iniciales
path <- "~/Documents/master/datamining_economia/R_projects/models/basic_treem_cbin2/"
model_name <- "treem_dsapril_cbin2_"

seed_values <- c( 178238923, 0969538963, 547245, 5565754, 0364385962 )
vcp <- 0 ;
cp_values <- c(0, 0.0001, 0.005, 0.01, 0.05, 0.1)

#No toma estos valores, solo los default
vminsplit <- "default" 
vminbucket <- "default" 
vmaxdepth <- "default"




#Carga de datos y modificaciones de variables
mydb = dbConnect(MySQL(), user='root', password='bajocero', dbname='dm_eco', host='localhost')

rs = dbSendQuery(mydb, "
              SELECT\ 
                 numero_de_cliente,\
                 foto_mes,\
                 marketing_activo_ultimos90dias,\
                 cliente_vip,\
                 cliente_sucursal,\
                 cliente_edad,\
                 cliente_antiguedad,\
                 mrentabilidad,\
                 mrentabilidad_annual,\
                 mcomisiones,\
                 mactivos_margen,\
                 mpasivos_margen,\
                 marketing_coss_selling,\
                 tpaquete_premium,\
                 tpaquete2,\
                 tpaquete3,\
                 tpaquete4,\
                 tpaquete5,\
                 tpaquete6,\
                 tpaquete7,\
                 tpaquete8,\
                 tpaquete9,\
                 tcuentas,\
                 tcuenta_corriente,\
                 mcuenta_corriente_Nopaquete,\
                 mcuenta_corriente_Paquete,\
                 mcuenta_corriente_dolares,\
                 tcaja_ahorro,\
                 mcaja_ahorro_Paquete,\
                 mcaja_ahorro_Nopaquete,\
                 mcaja_ahorro_dolares,\
                 mdescubierto_preacordado,\
                 mcuentas_saldo,\
                 ttarjeta_debito,\
                 ctarjeta_debito_transacciones,\
                 mautoservicio,\
                 ttarjeta_visa,\
                 ctarjeta_visa_transacciones,\
                 mtarjeta_visa_consumo,\
                 ttarjeta_master,\
                 ctarjeta_master_transacciones,\
                 mtarjeta_master_consumo,\
                 cprestamos_personales,\
                 mprestamos_personales,\
                 cprestamos_prendarios,\
                 mprestamos_prendarios,\
                 cprestamos_hipotecarios,\
                 mprestamos_hipotecarios,\
                 tplazo_fijo,\
                 mplazo_fijo_dolares,\
                 mplazo_fijo_pesos,\
                 tfondos_comunes_inversion,\
                 mfondos_comunes_inversion_pesos,\
                 mfondos_comunes_inversion_dolares,\
                 ttitulos,\
                 mtitulos,\
                 tseguro_vida_mercado_abierto,\
                 tseguro_auto,\
                 tseguro_vivienda,\
                 tseguro_accidentes_personales,\
                 tcaja_seguridad,\
                 mbonos_gobierno,\
                 mmonedas_extranjeras,\
                 minversiones_otras,\
                 tplan_sueldo,\
                 mplan_sueldo,\
                 mplan_sueldo_manual,\
                 cplan_sueldo_transaccion,\
                 tcuenta_debitos_automaticos,\
                 mcuenta_debitos_automaticos,\
                 ttarjeta_visa_debitos_automaticos,\
                 mttarjeta_visa_debitos_automaticos,\
                 ttarjeta_master_debitos_automaticos,\
                 mttarjeta_master_debitos_automaticos,\
                 tpagodeservicios,\
                 mpagodeservicios,\
                 tpagomiscuentas,\
                 mpagomiscuentas,\
                 ccajeros_propios_descuentos,\
                 mcajeros_propios_descuentos,\
                 ctarjeta_visa_descuentos,\
                 mtarjeta_visa_descuentos,\
                 ctarjeta_master_descuentos,\
                 mtarjeta_master_descuentos,\
                 ccuenta_descuentos,\
                 mcuenta_descuentos,\
                 ccomisiones_mantenimiento,\
                 mcomisiones_mantenimiento,\
                 ccomisiones_otras,\
                 mcomisiones_otras,\
                 tcambio_monedas,\
                 ccambio_monedas_compra,\
                 mcambio_monedas_compra,\
                 ccambio_monedas_venta,\
                 mcambio_monedas_venta,\
                 ctransferencias_recibidas,\
                 mtransferencias_recibidas,\
                 ctransferencias_emitidas,\
                 mtransferencias_emitidas,\
                 cextraccion_autoservicio,\
                 mextraccion_autoservicio,\
                 ccheques_depositados,\
                 mcheques_depositados,\
                 ccheques_emitidos,\
                 mcheques_emitidos,\
                 ccheques_depositados_rechazados,\
                 mcheques_depositados_rechazados,\
                 ccheques_emitidos_rechazados,\
                 mcheques_emitidos_rechazados,\
                 tcallcenter,\
                 ccallcenter_transacciones,\
                 thomebanking,\
                 chomebanking_transacciones,\
                 tautoservicio,\
                 cautoservicio_transacciones,\
                 tcajas,\
                 tcajas_consultas,\
                 tcajas_depositos,\
                 tcajas_extracciones,\
                 tcajas_otras,\
                 ccajeros_propio_transacciones,\
                 mcajeros_propio,\
                 ccajeros_ajenos_transacciones,\
                 mcajeros_ajenos,\
                 tmovimientos_ultimos90dias,\
                 Master_marca_atraso,\
                 Master_cuenta_estado,\
                 Master_mfinanciacion_limite,\
                 Master_Fvencimiento_num AS Master_Fvencimiento,\
                 Master_Finiciomora_num AS Master_Finiciomora,\
                 Master_msaldototal,\
                 Master_msaldopesos,\
                 Master_msaldodolares,\
                 Master_mconsumospesos,\
                 Master_mconsumosdolares,\
                 Master_mlimitecompra,\
                 Master_madelantopesos,\
                 Master_madelantodolares,\
                 Master_fultimo_cierre_num AS Master_fultimo_cierre,\
                 Master_mpagado,\
                 Master_mpagospesos,\
                 Master_mpagosdolares,\
                 Master_fechaalta_num AS Master_fechaalta,\
                 Master_mconsumototal,\
                 Master_tconsumos,\
                 Master_tadelantosefectivo,\
                 Master_mpagominimo,\
                 Visa_marca_atraso,\
                 Visa_cuenta_estado,\
                 Visa_mfinanciacion_limite,\
                 Visa_Fvencimiento_num AS Visa_Fvencimiento,\
                 Visa_Finiciomora_num AS Visa_Finiciomora,\
                 Visa_msaldototal,\
                 Visa_msaldopesos,\
                 Visa_msaldodolares,\
                 Visa_mconsumospesos,\
                 Visa_mconsumosdolares,\
                 Visa_mlimitecompra,\
                 Visa_madelantopesos,\
                 Visa_madelantodolares,\
                 Visa_fultimo_cierre_num AS Visa_fultimo_cierre,\
                 Visa_mpagado,\
                 Visa_mpagospesos,\
                 Visa_mpagosdolares,\
                 Visa_fechaalta_num AS Visa_fechaalta,\
                 Visa_mconsumototal,\
                 Visa_tconsumos,\
                 Visa_tadelantosefectivo,\
                 Visa_mpagominimo,\
                 participa,\
                 clase
            FROM cliente_premium_abril_cbin2;")

ds_cliente_premium <- fetch(rs, n=-1)


#Convertimos las variables en su tipo de dato correspondiente

#Date
# ds_cliente_premium$foto_mes <- as.Date(ds_cliente_premium$foto_mes)
# ds_cliente_premium$Master_Fvencimiento <- as.Date(ds_cliente_premium$Master_Fvencimiento)              
# ds_cliente_premium$Master_Finiciomora <- as.Date(ds_cliente_premium$Master_Finiciomora)      
# ds_cliente_premium$Master_fultimo_cierre <- as.Date(ds_cliente_premium$Master_fultimo_cierre)              
# ds_cliente_premium$Master_fechaalta <- as.Date(ds_cliente_premium$Master_fechaalta )                   
# ds_cliente_premium$Visa_Fvencimiento <- as.Date(ds_cliente_premium$Visa_Fvencimiento)                   
# ds_cliente_premium$Visa_Finiciomora <- as.Date(ds_cliente_premium$Visa_Finiciomora)
# ds_cliente_premium$Visa_fultimo_cierre <- as.Date(ds_cliente_premium$Visa_fultimo_cierre )
# ds_cliente_premium$Visa_fechaalta <- as.Date(ds_cliente_premium$Visa_fechaalta)  

#Factor
ds_cliente_premium$Visa_marca_atraso <- as.factor(ds_cliente_premium$Visa_marca_atraso)                  
ds_cliente_premium$Visa_cuenta_estado <- as.factor(ds_cliente_premium$Visa_cuenta_estado)  

ds_cliente_premium$participa <- as.factor(ds_cliente_premium$participa)
ds_cliente_premium$clase <- as.factor(ds_cliente_premium$clase)



# impresion basica del arbol
#plot( tree_model, uniform=TRUE, main="Arbol para Abril")
#text( tree_model, use.n=TRUE, all=TRUE, cex=.8, digits=10)

print('===========================================================================================================================')
print(format(Sys.time(), "%Y%m%d %H%M%S"))
print('')




cat( "fecha", "archivo", "algoritmo", "cp" , "minsplit", "minbucket", "maxdepth", "ganancia_promedio", "tiempo_promedio", "ganancias" , "\n", sep="\t", 
        file="/home/guille/Documents/master/datamining_economia/R_projects/results/salida_varcp_cbin2", fill=FALSE, append=FALSE )

for( vcp  in  cp_values )
{
  ganancias <- c() 
  tiempos <- c()
  
  for( s in  1:5 )
  {
    # Genero training y testing con 70% , 30%
    set.seed( seed_values[s] )
    train.regs <- sample(nrow(ds_cliente_premium), size = 0.7*nrow(ds_cliente_premium))
    ds_cliente_premium_training <- ds_cliente_premium[ train.regs,]
    ds_cliente_premium_testing  <- ds_cliente_premium[-train.regs,]
    
    
    # generacion del modelo sobre los datos de training
    t0 =  Sys.time()
    tree_model  <- rpart( clase ~ .   ,   data = ds_cliente_premium_training,   cp=vcp)  
    t1 = Sys.time()
    tiempos[s] <-  as.numeric(  t1 - t0, units = "secs" )
    
    
    #guardamos el modelo
    vcp_and_seed_str <-paste("CP_", as.character(vcp),"-SEED_", as.character(s),'-CB2',sep = '')
    path_model_final <- paste(path, model_name, vcp_and_seed_str,".rds",sep = '')
    saveRDS(tree_model,path_model_final)
    
    #probamos el modelo
    abril_testing_prediccion  <- predict(  tree_model, ds_cliente_premium_testing , type = "prob")
    
    
    # calculo la ganancia normalizada  en testing
    ganancias[s] <- ganancia_cbin( abril_testing_prediccion,  ds_cliente_premium_testing$clase ) / 0.30
    
    #imprimimos salida por pantalla
    print('')
    output <- paste("Seed: ",s, "CP: ", vcp,  "Tiempo: ", as.numeric(  t1 - t0, units = "secs" ), sep = ' ')
    print(output)
    print('')

    cat( format(Sys.time(), "%Y%m%d %H%M%S"), "prodprem_201604", "rpart",
       vcp , vminsplit, vminbucket, vmaxdepth, mean(ganancias), mean(tiempos), ganancias , "\n", sep="\t", file="/home/guille/Documents/master/datamining_economia/R_projects/results/salida_varcp_cbin2", fill=FALSE, append=TRUE )
  
    
  }
  
  print('===========================================================================================================================')
  
    
}


