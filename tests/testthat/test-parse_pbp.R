test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("scoreboard is scraped correctly", {
  expect_snapshot(scrape_mbb_scoreboard("2023-02-20"))
  expect_snapshot(scrape_wbb_scoreboard("2023-02-20"))
})

test_that("box score is scraped correctly", {
  # mbb box score
  expect_snapshot(scrape_boxscore(6053773))
  # wbb box score
  expect_snapshot(scrape_boxscore(6068979))
  # older mbb box score
  expect_snapshot(scrape_boxscore(3170318))
})

test_that("pbp is scraped correctly", {
  # mbb pbp
  expect_snapshot(scrape_pbp(6053773))
  # wbb pbp
  expect_snapshot(scrape_pbp(6068979))
  # older mbb pbp
  expect_snapshot(scrape_pbp(3170318))
})
