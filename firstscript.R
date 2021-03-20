x <- 'hello'

print(x)


#install.packages("httr")
#install.packages("jsonlite")


#wynik1 <- library(httr) #zwara błąd
#wynik2 <- require(jsonlite) # zwraca true/false


library(httr)
require(jsonlite)


endpoint <- "https://api.openweathermap.org/data/2.5/weather?q=Warszawa&appid=1765994b51ed366c506d5dc0d0b07b77"
getWeather <- GET(endpoint)
weatherText <- content(getWeather, as="text")
weatherJSON <- fromJSON(weatherText, flatten=FALSE)
weatherDF <- as.data.frame(weatherJSON)
View(weatherDF)


x <- 125.6
x <- "123"
class(x)
x<-c(1,2,3,4,5)
x
class(x)

x <- as.integer(x)
class(x)
y <- 2
class(x+y)


v1<-as.integer(v1)
v2<-as.vector(c(2,4),mode="integer")

wynik<- v1-v2
class(wynik)
wynik<- v1*v2
class(wynik)
wynik<- v1+v2
class(wynik)
wynik<- v2/v1
class(wynik)

wynik<- v1%%v2
wynik<- v1%/%v2

vecto<-(c(v2,TRUE,FALSE, -1, 0))
vectolo <- as.logical(vecto)
v1;v2


l <- list(1,3, vecto)
l[1]
lista <- list(1,2,3,4)
lista[[1]][lista[[1]]>1]

piec <- c("kocioł", "gaz","kocioł", "gaz")
piecf <- as.factor(piec)
str(piecf)
as.character(piecf)

df<- data.frame(index=1:3, imie=c("jan","alina","bartek"),plec=c(21,12,37), stringsAsFactors = FALSE)
str(df)
View(df)


df2 <- read.csv('dane.csv', sep=';')
df2 <- read.table('dane.csv', sep=';', header = TRUE)
View(df2)

for (i in 1:10){
  if (i==2){
    print(i)
  }
  else
  {print(i**2)}
}

