#definicion  funcion ganancia para nuestro problema

ganancia <- function( probs, clases ){
  suma = 0 ;
  largo = length( clases ) ;

  for( i in 1:largo )
  {
    if( probs[ i, "BAJA+2\r"]  > ( 250/8000)   ){ suma <- suma + if( clases[i]=="BAJA+2\r" ) { 7750 } else { -250 }  
     } ;
  }

  return( suma )
}



#funcion para ganancia de clase binaria tipo 1
ganancia_cbin <- function( probs, clases ){
  suma = 0 ;
  largo = length( clases ) ;

  for( i in 1:largo )
  {
    if( probs[ i, "POS"]  > ( 250/8000)   ){ suma <- suma + if( clases[i]=="POS" ) { 7750 } else { -250 }  
     } ;
  }

  return( suma )
}


# #funcion para ganancia de clase binaria tipo 2
# ganancia_cbin2 <- function( probs, clases ){
#   suma = 0 ;
#   largo = length( clases ) ;
# 
#   for( i in 1:largo )
#   {
#     if( probs[ i, "POS"]  > ( 250/8000)   ){ suma <- suma + if( clases[i]=="POS") { 7750 } else { -250 }  
#      } ;
#   }
# 
#   return( suma )
# }