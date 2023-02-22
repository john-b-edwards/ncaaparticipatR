#' scrape NCAA MBB Scoreboard
#'
#' @description Obtains all the MBB games that are taking place on a given date
#'
#' @param date The date to obtain games from, in YYYY-MM-DD format. Defaults to the current date.
#'
#' @return a dataframe of the MBB games taking place on `date`.
#' @export
#'
#' @examples scrape_mbb_scoreboard("2023-02-21")
scrape_mbb_scoreboard <- function(date = Sys.Date()) {
  scoreboard <- paste(
    "https://data.ncaa.com/casablanca/scoreboard/basketball-men/d1/",
    gsub('-', '/', date),
    "scoreboard.json",
    sep = "/"
  ) |>
    jsonlite::fromJSON(flatten = T) |>
    purrr::pluck("games") |>
    tibble::as_tibble() |>
    janitor::clean_names() |>
    dplyr::rename_with(\(x) gsub("game_", "", x)) |>
    dplyr::mutate(dplyr::across(c(home_winner, away_winner), \(x) as.logical(x)))
  return(scoreboard)
}

#' scrape NCAA WBB Scoreboard
#'
#' @description Obtains all the WBB games that are taking place on a given date
#'
#' @param date The date to obtain games from, in YYYY-MM-DD format. Defaults to the current date.
#'
#' @return a dataframe of the WBB games taking place on `date`.
#' @export
#'
#' @examples scrape_wbb_scoreboard("2023-02-21")

scrape_wbb_scoreboard <- function(date = Sys.Date()) {
  paste("https://data.ncaa.com/casablanca/scoreboard/basketball-women/d1/",gsub('-', '/',date), "scoreboard.json", sep = "/") |>
    jsonlite::fromJSON(flatten=T) |>
    purrr::pluck("games") |>
    tibble::as_tibble() |>
    janitor::clean_names() |>
    dplyr::rename_with(\(x) gsub("game_","",x))
}
