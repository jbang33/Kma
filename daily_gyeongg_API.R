'

library(dplyr)
library(jsonlite)
library(httr)

# start_d : 불러올 시작일 ex) 20100101
# end_d : 불러올 종료일 ex) 20100102
# personal_key : 개인 API key

# 일간 자료 불러오기

get_daily_gyeonggi <- function(start_d, end_d, personal_key){
  
  # 시간을 일별로 묶기
  date_dat <- data.frame(date = seq.Date(lubridate::ymd(start_d), lubridate::ymd(end_d), by = "day"))
  date_dat$date <- format(date_dat$date, "%Y%m%d")
  weather_info <- list()

  # for문
  for(i in 1:nrow(date_dat)){
    # url_sub
    url_head <- "https://openapi.gg.go.kr/AWS1hourObser?KEY="
    url_back <- "&Type=json&pIndex=1&pSize=999&MESURE_DE="

    # 뽑아올 날짜
    date_dat_sub <- date_dat[i,1]
    
    # url
    url <- paste0(url_head, personal_key, url_back, date_dat_sub)
    
    # R로 불러오기
    result <- GET(url)
    json <- content(result, as = "text")
    processed_json <- jsonlite::fromJSON(json)
    weather_info[[i]] <- processed_json$AWS1hourObser$row
    weather_info[[i]]  <- weather_info[[i]][[2]]
   
  }
  weather_info
  weather_information<- data.table::rbindlist(weather_info, fill = TRUE)
}
  
Example <- get_daily_gyeonggi("20180512", "20180523", "cfc2d96fa958425babf9f916ba514615")
Example


'
