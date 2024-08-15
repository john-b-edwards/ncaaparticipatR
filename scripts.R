# load packages ------

devtools::load_all()

# pull dates to scrape ------
dates <- hoopR::load_mbb_schedule(2019:2023) |>
  dplyr::pull(start_date) |>
  lubridate::ymd_hm() |>
  lubridate::as_date() |>
  unique()

# filter broken dates

# obtain scoreboards ----

scrape_mbb_scoreboard_possibly <- purrr::possibly(scrape_mbb_scoreboard, data.frame())

progressr::with_progress({
  p <- progressr::progressor(steps = length(dates))

  games <- purrr::map_dfr(
    dates,
    \(x) {
      Sys.sleep(2)
      games <- scrape_mbb_scoreboard_possibly(x)
      p()
      return(games)
    }
  )
})

# filter broken dates ----
games <- games |>
  dplyr::filter(!(start_date %in% c("11-09-2018","11-09-2013","11-09-2019")))

# obtain pbp -----
scrape_pbp_possibly <- purrr::possibly(scrape_pbp, data.frame())
parse_pbp_possibly <- purrr::possibly(parse_pbp, data.frame())

progressr::with_progress({
  p <- progressr::progressor(steps = nrow(games))

  pbp <- purrr::map_dfr(
    games$url,
    \(x) {
      game <- gsub("/game/","",x)
      # print(game)
      pbp <- scrape_pbp_possibly(game)
      if(nrow(pbp)) {
        pbp <- parse_pbp(pbp)
        if(nrow(pbp)) {
          pbp$game_id <- game
        } else {
          Sys.sleep(2)
          pbp <- data.frame()
        }
      } else {
        Sys.sleep(2)
      }
      p()
      return(pbp)
    }
  )
})
