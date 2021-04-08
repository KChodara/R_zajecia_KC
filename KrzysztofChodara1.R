zadanie1 <- function(counter, factor){
  #' This function checks divisibility rule
  return(counter %% factor == 0)
}


zadanie2 <- function(first_speed=120, second_speed=70){
  #' This function calculates average speed if the route was equally divided between two speeds
  return(2*first_speed*second_speed / (first_speed+second_speed))
}


zadanie3 <- function(v1, v2){
  #' Calculates Pearson correlation factor between two vectors
  return(cov(v1, v2) / (sd(v1) * sd(v2)))
}

zadanie3b <- function(){
  #' The rest of the third exercise
  data <- read.csv2('dane.csv')
  weight <- as.vector(unlist(data['waga']))
  height <- as.vector(unlist(data['wzrost']))
  return(zadanie3(weight, height))
  
  #' Wynik 0.9793459
  #' Wynik ten oznacza bardzo mocną liniową zależność pomiędzy wagą a wzrostem. 
  #' Czyli wraz ze wzrostem wagi należy spodziewać się większej wartości wzrostu.
  #' Ten współczynnik mówi jedynie o sile korelacji, nie mówi o tym w jakich proporcjach zachodzi zmiana
}

zadanie4 <- function(ile=1){
  #' This function creates dataframe from user input in the console
  result <- NULL
  while (TRUE){
    col_name <- readline('Specify the column name. Type exit to exit. \n \n')
    if (col_name == 'exit') break
    
    i <- 1
    vec <- c()
    for (i in i:ile){
      new_val = readline('Specify value: ')
      vec <- append(vec, new_val)
    }
    vec <- data.frame(col_name = vec)
    colnames(vec)[1] <- col_name
    if (is.null(result))  {result <- vec}
    else {result <- cbind(result, vec)}
  }
  row.names(result) <- NULL
  return(result)
}

zadanie5 <-function(sciezkaKatalogu, nazwaKolumny, jakaFunkcja, dlaIluPlikow){
  #' This function combines single column values from multiple files into one aggregated value
  files <- list.files(sciezkaKatalogu)[1:dlaIluPlikow]
  
  vec <- c()
  for (file in files){
    data <- read.csv(paste(sciezkaKatalogu, file, sep='/'))
    data <- data[nazwaKolumny]
    data <- na.omit(data)
    data <- unlist(data)
    vec <- append(vec, data)
  }
  
  result <- get(jakaFunkcja)(vec)
  return(result)
}

#zadanie5('smogKrakow', 'X196_pm1', "mean", 6)
