library(dplyr)
library(stringr)
library(gtools)
library(rvest)
library(xml2)
library(data.table)


offerLinks<-c()



createLink <- function(minArea, maxArea){
  return(paste0('https://www.morizon.pl/mieszkania/?ps%5Bliving_area_from%5D=', minArea, '&ps%5Bliving_area_to%5D=', maxArea, '&page='))
}

getPage <- function(link){
  download.file(link, destfile = 'scrapedpage.html', quiet = TRUE)
  read_html('scrapedpage.html', encoding = "UTF-8")
}

maxArea <- 210
lowerBound <- 10
higherBound <- 19
defaultStep <- 10

allOffersLinks <- c()

offerLinks <- c()
while (higherBound < maxArea){
  
  currSearchLink <- createLink(lowerBound, higherBound)
  
  page <- getPage(paste0(currSearchLink, 1))
  
  
  number <- page %>% html_nodes(xpath = "//ul[@class='nav nav-pills mz-pagination-number']/li") %>% html_children()
  maxPageNumber <- number[length(number)-1] %>% html_text() %>% as.integer()
  
  maxPageNumber <- if (length(maxPageNumber) == 0) 1 else maxPageNumber
  
  if (maxPageNumber==200){
    higherBound <- as.integer((higherBound+lowerBound)*0.5)
    next
  }
  
  result <- c()
  for (pageNumber in 1:maxPageNumber){
    page <- getPage(paste0(currSearchLink, pageNumber))
    sub_result <- page %>% html_nodes(xpath = "//a[@class='property_link property-url']") %>% html_attr('href')
    result <- unique(append(result,  sub_result))
  }
  offerLinks <- append(offerLinks, result)
  
  print(cat(lowerBound, ': ', higherBound, ' maxPage: ', maxPageNumber, '\n'))
  lowerBound <- higherBound+1
  higherBound <- higherBound+defaultStep
  
}

write.table(as.list(offerLinks), file ="offers", row.names=FALSE, col.names=FALSE, sep=",")


offerLinks <- fread('offersv', head=FALSE)


  # Pobieranie danych ogloszenia
  allApartments <- data.frame()
  for (currOfferLink in offerLinks){

    page <- getPage(currOfferLink)
    
    v<-page %>% xml_find_all(xpath = "//section[@class='params clearfix']/table/tr") %>% html_text()
    
    col <- c()
    val <- c()
    for (item in v){
      item <- toString(str_trim(item))
      col <- rbind(col, str_trim(strsplit(item, '[:]')[[1]][1]))
      val <- rbind(val, str_trim(strsplit(item, '[:]')[[1]][2]))
    }
    
    cena <- page %>% xml_find_all(xpath = "//li[@class='paramIconPrice']/em") %>% html_text() %>% str_replace(" ", "") %>% strsplit('[ zE]')
    
    tryCatch(
      { cena <- str_trim(cena[[1]][1])},error=function(e){1})
    m2 <- page %>% xml_find_all(xpath = "//li[@class='paramIconLivingArea']/em") %>% html_text()
    
    tryCatch(
      { pokoje <- page %>% xml_find_all(xpath = "//li[@class='paramIconNumberOfRooms']/em") %>% html_text()},error=function(e){pokoje <<- 0})
    
    lokalizacja <- page %>% xml_find_all(xpath = "//span[@itemtype='http://data-vocabulary.org/Breadcrumb']") %>% html_text()
    i=1
    for (item in lokalizacja){
      col <- rbind(col, paste0('lok', i))
      val <- rbind(val, str_trim(item))
      i <- i+1}
    
    tryCatch(
      {
        df1<- data.frame (matrix(val,nrow = 1,ncol=length(val)) )
        names(df1) <- col
        df1<- cbind(df1, cena)
        df1<- cbind(df1, m2)
        tryCatch(
          { df1<- cbind(df1, pokoje)},error=function(e){pokoje <<- 0})
        allApartments <- smartbind(allApartments, df1)
      },error=function(e){print(currOfferLink)})
  }
  
  
  write.csv2(allApartments, file = "morizon_take2_4.csv")

  

#match(currOfferLink, offerLinks)
