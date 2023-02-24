#' Extract players on plays from NCAA V1 PBP data
#'
#' @description A helper function to identify which players are involved in plays and which team they belong to
#' @param text The description of events on a given play from the NCAA V1 PBP data.
#'
#' @return A dataframe of all the players involved in a play + which team they belong to
#'
extract_all_players <- function(text) {
  # extract pos player (first player on play)
  pos_1 <-
    stringr::str_extract(text, "^(.*) (misses|defensive|offensive|makes|turnover)")
  # extract def player (first player on play)
  def_1 <- stringr::str_extract(text, "^(.*) blocks")
  # extract pos player (second player on play)
  pos_2 <- stringr::str_extract(text, "\\(.* assists|blocks .*'s")
  # extract def player (second player on team)
  def_2 <- stringr::str_extract(text, "\\(.* draws|\\(.* steals")
  pos_1 <-
    trimws(gsub('(misses|defensive|offensive|makes|turnover)', '', pos_1))
  pos_2 <- trimws(gsub("\\(| assists|blocks|'s", '', pos_2))
  def_1 <- trimws(gsub("blocks", '', def_1))
  def_2 <-
    trimws(gsub("\\(|draws|steals|bad pass\\)|lost ball\\)", '', def_2))
  return(data.frame(pos_1,
                    pos_2,
                    def_1,
                    def_2))
}

#' Parse pbp data into participation data
#'
#' @description Takes in a dataframe of PBP data, returns the lineups and the times those lineups were on-court for.
#' @param pbp_text A dataframe of pbp data as returned by `scrape_pbp()`.
#'
#' @return A dataframe of lineups and the times that they were on court for.
#' @export
#'
#' @examples parse_pbp(scrape_pbp())
parse_pbp <- function(pbp_text) {
  pbp <- pbp_text |>
    # fill in score column (is left blank when score is unchanged)
    dplyr::mutate(score = dplyr::case_when(score == "" ~ NA_character_,
                                           T ~ score)) |>
    tidyr::fill(score, .direction = "down") |>
    dplyr::mutate(score = dplyr::case_when(is.na(score) ~ "0-0",
                                           T ~ score)) |>
    # generate time columns
    tidyr::separate(time,
                    c("minute", "second"),
                    fill = "right") |>
    dplyr::ungroup() |>
    dplyr::mutate(
      dplyr::across(c(minute, second),
                    \(x) as.numeric(x)),
      time = lubridate::period(minute = minute, second = second),
      play_id = paste0(game_id, "_", dplyr::row_number()),
      events = dplyr::case_when(homeText == '' ~ visitorText,
                                visitorText == '' ~ homeText,
                                T ~ '')
    )
  # identify if this is v1 or v2
  if (any(grepl('Subbing in for ', pbp$events))) {
    # v2
    pbp_parsed <- pbp |>
      # check which plays get subbed in, which get subbed out
      dplyr::mutate(
        subbed_in_home = grepl('Subbing in for ', homeText),
        subbed_out_home = grepl('Subbing out for ', homeText),
        player_on_play_home = gsub(
          "((.*)'s |-|by )",
          "",
          stringr::str_extract(homeText, "('s|by |-).*?$")
        ),
        player_on_play_home = gsub("\\(.*\\)", "", player_on_play_home),
        player_on_play_home = dplyr::case_when(
          player_on_play_home == "second time out." ~ "",
          T ~ player_on_play_home
        ),
        player_on_play_home = trimws(player_on_play_home),
        player_on_play_home = gsub(dplyr::first(shortName_home), "", player_on_play_home),
        player_on_play_home = dplyr::case_when(
          player_on_play_home == '' ~ NA_character_,
          player_on_play_home == "'s" ~ NA_character_,
          T ~ player_on_play_home
        ),
        on_court_flag_home = dplyr::case_when(subbed_in_home ~ 1,
                                              subbed_out_home ~ 0,
                                              T ~ NA_real_),
        subbed_in_visitor = grepl('Subbing in for ', visitorText),
        subbed_out_visitor = grepl('Subbing out for ', visitorText),
        player_on_play_visitor = gsub(
          "((.*)'s |-|by )",
          "",
          stringr::str_extract(visitorText, "('s|by |-).*?$")
        ),
        player_on_play_visitor = gsub("\\(.*\\)", "", player_on_play_visitor),
        player_on_play_visitor = dplyr::case_when(
          player_on_play_visitor == "second time out." ~ "",
          T ~ player_on_play_visitor
        ),
        player_on_play_visitor = trimws(player_on_play_visitor),
        player_on_play_visitor = gsub(
          dplyr::first(shortName_visitor),
          "",
          player_on_play_visitor
        ),
        player_on_play_visitor = dplyr::case_when(
          player_on_play_visitor == '' ~ NA_character_,
          player_on_play_visitor == "'s" ~ NA_character_,
          T ~ player_on_play_visitor
        ),
        on_court_flag_visitor = dplyr::case_when(subbed_in_visitor ~ 1,
                                                 subbed_out_visitor ~ 0,
                                                 T ~ NA_real_),
      ) |>
      dplyr::filter(!is.na(player_on_play_visitor) |
                      !is.na(player_on_play_home)) |>
      dplyr::group_by(periodNumber) |>
      dplyr::group_modify( ~ (\(a) {
        cbind(
          a,
          a |>
            # create a matrix of all players mentioned in the pbp at any point
            tidyr::pivot_wider(
              names_from = player_on_play_home,
              values_from = on_court_flag_home,
              names_prefix = 'x_',
              names_repair = "check_unique"
            ) |>
            #' whenever a player is subbed in, they have a 1 in that row and a 0
            #' in the row before. whenever a player is subbed out, they have a 0
            #' in that row and a 1 in the row before
            dplyr::mutate(
              dplyr::across(
                dplyr::starts_with('x_'),
                ~ dplyr::case_when(dplyr::lead(.) == 0 ~ 1,
                                   dplyr::lead(.) == 1 ~ 0,
                                   T ~
                                     .)
              )
            ) |>
            #' we then cascade the 1s and 0s up and down to create map of who is
            #' in the game at any given time
            tidyr::fill(c(dplyr::starts_with('x_')), .direction = "down") |>
            tidyr::fill(c(dplyr::starts_with('x_')), .direction = "up") |>
            dplyr::mutate(
              dplyr::across(
                dplyr::starts_with('x_'),
                ~ dplyr::case_when(is.na(.x) ~ 1,
                                   T ~ .x)
              )
            ) |>
            # finally we collapse the values down into a string of who is on court
            (\(d) {
              d |>
                dplyr::select(dplyr::starts_with('x_')) |>
                dplyr::select(-dplyr::any_of('x_NA')) |>
                (
                  \(f) which(f == 1, arr.ind = T) |>
                    as.data.frame() |>
                    dplyr::group_by(row) |>
                    dplyr::summarize(on_court_home = paste0(colnames(f)[unlist(list(col))], collapse =
                                                              ';'))
                )()
            })()
        )
      })(.x)) |>
      dplyr::group_modify( ~ (\(a) {
        cbind(
          a,
          a |>
            # create a matrix of all players mentioned in the pbp at any point
            tidyr::pivot_wider(
              names_from = player_on_play_visitor,
              values_from = on_court_flag_visitor,
              names_prefix = 'x_',
              names_repair = "check_unique"
            ) |>
            #' whenever a player is subbed in, they have a 1 in that row and a 0
            #' in the row before. whenever a player is subbed out, they have a 0
            #' in that row and a 1 in the row before
            dplyr::mutate(
              dplyr::across(
                dplyr::starts_with('x_'),
                ~ dplyr::case_when(dplyr::lead(.) == 0 ~ 1,
                                   dplyr::lead(.) == 1 ~ 0,
                                   T ~
                                     .)
              )
            ) |>
            #' we then cascade the 1s and 0s up and down to create map of who is
            #' in the game at any given time
            tidyr::fill(c(dplyr::starts_with('x_')), .direction = "down") |>
            tidyr::fill(c(dplyr::starts_with('x_')), .direction = "up") |>
            dplyr::mutate(
              dplyr::across(
                dplyr::starts_with('x_'),
                ~ dplyr::case_when(is.na(.x) ~ 1,
                                   T ~ .x)
              )
            ) |>
            # finally we collapse the values down into a string of who is on court
            (\(d) {
              d |>
                dplyr::select(dplyr::starts_with('x_')) |>
                dplyr::select(-dplyr::any_of('x_NA')) |>
                (
                  \(f) which(f == 1, arr.ind = T) |>
                    as.data.frame() |>
                    dplyr::group_by(row) |>
                    dplyr::summarize(on_court_visitor = paste0(colnames(f)[unlist(list(col))], collapse =
                                                                 ';'))
                )()
            })()
        )
      })(.x)) |>
      dplyr::ungroup() |>
      # find out when lineups change
      dplyr::mutate(stint = cumsum(
        subbed_in_home + subbed_out_home + subbed_in_visitor + subbed_in_home
      )) |>
      dplyr::group_by(stint, on_court_home, on_court_visitor, periodNumber) |>
      dplyr::summarise(
        stint_start = dplyr::first(time),
        stint_end = dplyr::last(time),
        .groups = "drop"
      ) |>
      dplyr::filter(stint_start != stint_end) |>
      dplyr::ungroup() |>
      dplyr::group_by(periodNumber) |>
      dplyr::mutate(
        stint_start = dplyr::case_when(
          stint == 0 &
            periodNumber %in% c(1, 2) ~ lubridate::as.period("20M 0S"),
          stint == 0 &
            periodNumber >= 3 ~ lubridate::as.period("5M 0S"),
          T ~ stint_start
        ),
        stint_end = dplyr::case_when(
          stint == max(stint) ~ lubridate::as.period("0M 0S"),
          T ~ stint_end
        )
      ) |>
      dplyr::select(-c(stint)) |>
      #remove x_team from listed players in on_court
      dplyr::mutate(
        on_court_home = gsub(";x_team|x_team;", "", on_court_home),
        on_court_visitor = gsub(";x_team|x_team;", "", on_court_visitor),
        on_court_home = gsub(';x_ \\[.*\\]', "", on_court_home),
        on_court_home = gsub(';x_ \\[.*\\]', "", on_court_home),
        on_court_visitor = gsub(';x_ \\[.*\\]', "", on_court_visitor),
        on_court_visitor = gsub(';x_ \\[.*\\]', "", on_court_visitor),
      ) |>
      # omit bad sub data
      dplyr::mutate(dplyr::across(
        dplyr::starts_with("on_court"),
        \(x) dplyr::case_when(stringr::str_count(x, ';') == 4 ~ x,
                              T ~ NA_character_)
      )) |>
      data.frame()
  } else if (any(grepl(' lineup change ', pbp$events))) {
    # v1
    pbp_parsed <- pbp |>
      # v1 pbp just tells us full new lineup whenever there's a change, except to start the game
      dplyr::mutate(
        on_court = dplyr::case_when(
          grepl(' lineup change ', events) ~ stringr::str_extract(events, '\\((.*)\\)'),
          T ~ NA_character_
        ),
        on_court = gsub('\\(', 'x_', on_court),
        on_court = gsub(', ', ';x_', on_court),
        on_court = gsub(')', '', on_court),
        home_lineup_change = grepl(' lineup change ', homeText),
        away_lineup_change = grepl(' lineup change ', visitorText),
        home_on_court = dplyr::case_when(home_lineup_change ~ on_court,
                                         T ~ NA_character_),
        away_on_court = dplyr::case_when(away_lineup_change ~ on_court,
                                         T ~ NA_character_),
      ) |>
      tidyr::fill(c(home_on_court, away_on_court), .direction = "down") |>
      (\(x) {
        # for the start of the game, we're missing lineups, so we have to estimate these
        missing_both <- x |>
          dplyr::filter(is.na(home_on_court) &
                          is.na(away_on_court))
        # sometimes only one team makes a change initially, this handles that
        missing_home <- x |>
          dplyr::filter(is.na(home_on_court) &
                          !is.na(away_on_court))
        missing_away <- x |>
          dplyr::filter(is.na(away_on_court) &
                          !is.na(home_on_court))
        complete <- x |>
          dplyr::filter(!is.na(home_on_court) &
                          !is.na(away_on_court))
        # extract players/teams from missing data
        extracted_both_home <-
          extract_all_players(missing_both$homeText)
        extracted_both_away <-
          extract_all_players(missing_both$visitorText)
        # if the away team made a substitution first and the home team did not make a sub at the same time
        if (nrow(missing_home)) {
          # grab the players from the text
          extracted_one_home <-
            extract_all_players(missing_home$homeText)
          extracted_one_away <-
            extract_all_players(missing_home$visitorText)
          # pull in all the players who are recorded as being on court for the home team while this is missing
          on_court_home <- c(
            extracted_both_home$pos_1,
            extracted_both_home$pos_2,
            extracted_both_away$def_1,
            extracted_both_away$def_2,
            extracted_one_home$pos_1,
            extracted_one_home$pos_2,
            extracted_one_away$def_1,
            extracted_one_away$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_home[1], x$nickName_visitor[1], NA_character_))])()
          #  check that there's five players on the court for the home team
          if (length(on_court_home) == 5) {
            on_court_home <- on_court_home |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            # if not, NA the lineup
            on_court_home <- NA_character_
          }
          # pull in the away participation data, combine with the known lineups
          on_court_away <- c(
            extracted_both_away$pos_1,
            extracted_both_away$pos_2,
            extracted_both_home$def_1,
            extracted_both_home$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_home[1], x$nickName_visitor[1], NA_character_))])()
          if (length(on_court_away) == 5) {
            on_court_away <- on_court_away |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            on_court_away <- NA_character_
          }
          # finally set the lineups for the data
          missing_both$away_on_court <- on_court_away
          missing_both$home_on_court <- on_court_home
          missing_home$home_on_court <- on_court_home
          # do the same process for home sub first/away no sub
        } else if (nrow(missing_away)) {
          extracted_one_away <- extract_all_players(missing_away$awayText)
          extracted_one_home <-
            extract_all_players(missing_away$visitorText)
          on_court_away <- c(
            extracted_both_away$pos_1,
            extracted_both_away$pos_2,
            extracted_both_home$def_1,
            extracted_both_home$def_2,
            extracted_one_away$pos_1,
            extracted_one_away$pos_2,
            extracted_one_home$def_1,
            extracted_one_home$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_away[1], x$nickName_visitor[1], NA_character_))])()
          if (length(on_court_away) == 5) {
            on_court_away <- on_court_away |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            on_court_away <- NA_character_
          }
          on_court_home <- c(
            extracted_both_home$pos_1,
            extracted_both_home$pos_2,
            extracted_both_away$def_1,
            extracted_both_away$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_away[1], x$nickName_visitor[1], NA_character_))])()
          if (length(on_court_home) == 5) {
            on_court_home <- on_court_home |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            on_court_home <- NA_character_
          }
          missing_both$home_on_court <- on_court_home
          missing_both$away_on_court <- on_court_away
          missing_away$away_on_court <- on_court_away
          # now if both teams sub at the same time, rely on the usual lineup logic
        } else {
          on_court_home <- c(
            extracted_both_home$pos_1,
            extracted_both_home$pos_2,
            extracted_both_away$def_1,
            extracted_both_away$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_home[1], x$nickName_visitor[1], NA_character_))])()
          if (length(on_court_home) == 5) {
            on_court_home <- on_court_home |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            on_court_home <- NA_character_
          }
          on_court_away <- c(
            extracted_both_away$pos_1,
            extracted_both_away$pos_2,
            extracted_both_home$def_1,
            extracted_both_home$def_2
          ) |>
            unique() |>
            (\(y) y[!(y %in% c(x$nickName_home[1], x$nickName_visitor[1], NA_character_))])()
          if (length(on_court_away) == 5) {
            on_court_away <- on_court_away |>
              (\(y) paste0('x_', y))() |>
              paste0(collapse = ';')
          } else {
            on_court_away <- NA_character_
          }
          missing_both$away_on_court <- on_court_away
          missing_both$home_on_court <- on_court_home
        }
        # combine everything back together
        return(dplyr::bind_rows(missing_both,
                                missing_away,
                                missing_home,
                                complete))
      })() |>
      # clean the data and calculate stints
      dplyr::mutate(
        on_court = paste0(home_on_court, ";", away_on_court),
        substitution = grepl(' lineup change ', events)
      ) |>
      dplyr::ungroup() |>
      dplyr::mutate(stint = cumsum(substitution)) |>
      dplyr::group_by(stint, home_on_court, away_on_court, periodNumber) |>
      dplyr::summarise(
        stint_start = dplyr::first(time),
        stint_end = dplyr::last(time),
        .groups = "drop"
      ) |>
      dplyr::filter(stint_start != stint_end) |>
      dplyr::ungroup() |>
      dplyr::group_by(periodNumber) |>
      dplyr::mutate(
        stint_start = dplyr::case_when(
          stint == 0 &
            periodNumber %in% c(1, 2) ~ lubridate::as.period("20M 0S"),
          stint == 0 &
            periodNumber >= 3 ~ lubridate::as.period("5M 0S"),
          T ~ stint_start
        ),
        stint_end = dplyr::case_when(
          stint == max(stint) ~ lubridate::as.period("0M 0S"),
          T ~ stint_end
        )
      ) |>
      dplyr::select(-c(stint)) |>
      # omit bad sub data
      dplyr::mutate(home_on_court = dplyr::case_when(
        stringr::str_count(home_on_court, ';') == 4 ~ home_on_court,
        T ~ NA_character_
      )) |>
      dplyr::mutate(away_on_court = dplyr::case_when(
        stringr::str_count(away_on_court, ';') == 4 ~ away_on_court,
        T ~ NA_character_
      )) |>
      #consistent column naming with v2
      dplyr::rename(on_court_home = home_on_court,
                    on_court_visitor = away_on_court) |>
      data.frame()
  }
  return(pbp_parsed)
}
