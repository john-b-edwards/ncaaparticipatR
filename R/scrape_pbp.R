#' Scrape play by play data
#'
#' @description For a given game, obtain the play by play data from data.ncaa.com.
#'
#' @param game_id A unique identifier for an NCAA basketball game, as obtained from `scrape_*bb_scoreboard()` or ncaa.com.
#'
#' @return a dataframe of plays for a given game.
#' @export
#'
#' @examples scrape_pbp()
scrape_pbp <- function(game_id = 6048478) {
  json <-
    paste0("https://data.ncaa.com/casablanca/game/",
           game_id,
           "/pbp.json") |>
    jsonlite::fromJSON(flatten = T)
  teams <- json |>
    purrr::pluck("meta") |>
    purrr::pluck("teams") |>
    dplyr::select(-c(color)) |>
    tidyr::pivot_wider(
      names_from = homeTeam,
      values_from = c(id, shortName, seoName, sixCharAbbr, shortName, nickName)
    ) |>
    dplyr::rename_with(\(x) gsub("_true", "_home", x), dplyr::ends_with("_true")) |>
    dplyr::rename_with(\(x) gsub("_false", "_visitor", x), dplyr::ends_with("_false"))
  pbp <- json |>
    purrr::pluck("periods") |>
    tidyr::unnest(playStats) |>
    dplyr::mutate(game_id = game_id) |>
    dplyr::bind_cols(teams)
  return(pbp)
}
