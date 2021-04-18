# main
library(RSelenium)
library(seleniumPipes)
library(dplyr)
library(stringr)
library(gtools)
library(rvest)
library(xml2)
library(V8)


remDr<- remoteDr(remoteServerAddr = "http://localhost",
                 port=4445,
                 browserName = "chrome",
                 newSession = TRUE)

offerLinks<-c()

# Nie da się wyświetlić wszystkich mieszkań na raz. Dlatego linki zostaną zebrane "na raty".

createLink <- function(minArea, maxArea){
  return(paste0('https://www.morizon.pl/mieszkania/?ps%5Bliving_area_from%5D=', minArea, '&ps%5Bliving_area_to%5D=', maxArea, '&page='))
}

maxArea <- 500
lowerBound <- 10
higherBound <- 20
defaultStep <- 10
allOffersLinks <- c()




while (higherBound < maxArea){
  
  currentLink <- createLink(lowerBound, higherBound)
  i = 1
  page <- read_html( paste0(currentLink, i))
  
  maxPageNumber <- page %>% html_nodes(xpath='/html/body/div[1]/div[5]/div[1]/div/div/div/footer/div/nav/div/ul/li[*]') %>% html_text()
  maxPageNumber
  
  tryCatch(
  if (is.na(maxPageNumber) == FALSE & maxPageNumber == 200){
    higherBound <- floor(mean(lowerBound, higherBound))
    next
  }, error=function(e) {maxPageNumber<<-NULL}
  )
  
  
  print(cat(lowerBound, ': ', higherBound, '\n'))
  lowerBound <- higherBound+1
  higherBound <- higherBound+defaultStep
  
  
  
}
