#' Scrape box scores for a given game.
#'
#' @description Obtain the box scores for a specified game.
#'
#' @param game_id A unique identifier for an NCAA basketball game, as obtained from `scrape_*bb_scoreboard()` or ncaa.com.
#'
#' @return A dataframe containing the box score for the specified `game_id`.
#' @export
#'
#' @examples (scrape_boxscore)
scrape_boxscore <- function(game_id = 6048478) {
  json <-
    paste0("https://data.ncaa.com/casablanca/game/",
           game_id,
           "/boxscore.json") |>
    jsonlite::fromJSON(flatten = T)
  teams <- json |>
    purrr::pluck("meta") |>
    purrr::pluck("teams")
  box <- json |>
    purrr::pluck("teams") |>
    tidyr::unnest(cols = c(playerStats)) |>
    dplyr::select(-starts_with("player")) |>
    tidyr::separate(fieldGoalsMade,
                    c("fieldGoalsMade", "fieldGoalsAttempted"),
                    sep = '-') |>
    tidyr::separate(threePointsMade,
                    c("threePointsMade", "threePointsAttempted"),
                    sep = '-') |>
    tidyr::separate(freeThrowsMade,
                    c("freeThrowsMade", "freeThrowsAttempted"),
                    sep = '-') |>
    dplyr::mutate(
      dplyr::across(minutesPlayed:steals, \(x) as.numeric(x)),
      teamId = as.character(teamId),
      game_id = game_id
    ) |>
    dplyr::left_join(teams, by = c("teamId" = "id"))
  return(box)
}
