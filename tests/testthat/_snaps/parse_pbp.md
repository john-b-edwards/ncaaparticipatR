# scoreboard is scraped correctly

    Code
      scrape_mbb_scoreboard("2023-02-20")
    Output
      # A tibble: 19 x 37
         id      final_m~1 brack~2 title conte~3 url   network live_~4 start~5 start~6
         <chr>   <chr>     <chr>   <chr> <chr>   <chr> <chr>   <lgl>   <chr>   <chr>  
       1 2196235 FINAL     ""      UC D~ ""      /gam~ ""      FALSE   06:00P~ 167693~
       2 2196244 FINAL     ""      Duke~ ""      /gam~ ""      FALSE   07:00P~ 167693~
       3 2196242 FINAL     ""      West~ ""      /gam~ ""      FALSE   07:00P~ 167693~
       4 2349976 FINAL     ""      Norf~ ""      /gam~ ""      FALSE   07:30P~ 167693~
       5 2196247 FINAL     ""      UMES~ ""      /gam~ ""      FALSE   07:30P~ 167693~
       6 2349996 FINAL     ""      Morg~ ""      /gam~ ""      FALSE   07:30P~ 167693~
       7 2241143 FINAL     ""      Dela~ ""      /gam~ ""      FALSE   07:30P~ 167693~
       8 2241746 FINAL     ""      UTRG~ ""      /gam~ ""      FALSE   07:30P~ 167693~
       9 2193547 FINAL     ""      Nich~ ""      /gam~ ""      FALSE   08:00P~ 167694~
      10 2196239 FINAL     ""      CSU ~ ""      /gam~ ""      FALSE   08:00P~ 167694~
      11 2196232 FINAL     ""      Texa~ ""      /gam~ ""      FALSE   08:30P~ 167694~
      12 2196230 FINAL     ""      Alab~ ""      /gam~ ""      FALSE   08:30P~ 167694~
      13 2196234 FINAL     ""      Alab~ ""      /gam~ ""      FALSE   09:00P~ 167694~
      14 2196248 FINAL     ""      Prai~ ""      /gam~ ""      FALSE   09:00P~ 167694~
      15 2196254 FINAL     ""      TCU ~ ""      /gam~ ""      FALSE   09:00P~ 167694~
      16 2194286 FINAL     ""      Illi~ ""      /gam~ ""      FALSE   09:00P~ 167694~
      17 2196238 FINAL     ""      CSUN~ ""      /gam~ ""      FALSE   10:00P~ 167694~
      18 2196237 FINAL     ""      UC S~ ""      /gam~ ""      FALSE   10:00P~ 167694~
      19 2196240 FINAL     ""      Cal ~ ""      /gam~ ""      FALSE   10:00P~ 167694~
      # ... with 27 more variables: bracket_id <chr>, state <chr>, start_date <chr>,
      #   current_period <chr>, video_state <chr>, bracket_region <chr>,
      #   contest_clock <chr>, away_score <chr>, away_winner <lgl>, away_seed <chr>,
      #   away_description <chr>, away_rank <chr>, away_conferences <list>,
      #   away_names_char6 <chr>, away_names_short <chr>, away_names_seo <chr>,
      #   away_names_full <chr>, home_score <chr>, home_winner <lgl>,
      #   home_seed <chr>, home_description <chr>, home_rank <chr>, ...

---

    Code
      scrape_wbb_scoreboard("2023-02-20")
    Output
      # A tibble: 19 x 37
         id      final_m~1 brack~2 title conte~3 url   network live_~4 start~5 start~6
         <chr>   <chr>     <chr>   <chr> <chr>   <chr> <chr>   <lgl>   <chr>   <chr>  
       1 2180539 FINAL     ""      UC R~ ""      /gam~ ""      FALSE   05:00P~ 167693~
       2 2180552 FINAL     ""      UMES~ ""      /gam~ ""      FALSE   05:30P~ 167693~
       3 2180549 FINAL     ""      Norf~ ""      /gam~ ""      FALSE   05:30P~ 167693~
       4 2180548 FINAL     ""      Dela~ ""      /gam~ ""      FALSE   05:30P~ 167693~
       5 2334276 FINAL     ""      Morg~ ""      /gam~ ""      FALSE   05:30P~ 167693~
       6 2177780 FINAL     ""      Nich~ ""      /gam~ ""      FALSE   06:00P~ 167693~
       7 2180540 FINAL     ""      UC S~ ""      /gam~ ""      FALSE   06:00P~ 167693~
       8 2180541 FINAL     ""      Alab~ ""      /gam~ ""      FALSE   06:00P~ 167693~
       9 2334252 FINAL     ""      Alab~ ""      /gam~ ""      FALSE   06:30P~ 167693~
      10 2334253 FINAL     ""      Texa~ ""      /gam~ ""      FALSE   06:30P~ 167693~
      11 2180547 FINAL     ""      Prai~ ""      /gam~ ""      FALSE   06:30P~ 167693~
      12 2334251 FINAL     ""      Hawa~ ""      /gam~ ""      FALSE   07:00P~ 167693~
      13 2180553 FINAL     ""      Texa~ ""      /gam~ ""      FALSE   07:00P~ 167693~
      14 2180559 FINAL     ""      Wisc~ ""      /gam~ ""      FALSE   07:00P~ 167693~
      15 2334272 FINAL     ""      Mich~ ""      /gam~ ""      FALSE   07:00P~ 167693~
      16 2334275 FINAL     ""      Oakl~ ""      /gam~ ""      FALSE   07:00P~ 167693~
      17 2180555 FINAL     ""      Nort~ ""      /gam~ ""      FALSE   07:30P~ 167693~
      18 2334250 FINAL     ""      Stan~ ""      /gam~ ""      FALSE   09:00P~ 167694~
      19 2180556 FINAL     ""      Cal ~ ""      /gam~ ""      FALSE   10:00P~ 167694~
      # ... with 27 more variables: bracket_id <chr>, state <chr>, start_date <chr>,
      #   current_period <chr>, video_state <chr>, bracket_region <chr>,
      #   contest_clock <chr>, away_score <chr>, away_winner <lgl>, away_seed <chr>,
      #   away_description <chr>, away_rank <chr>, away_conferences <list>,
      #   away_names_char6 <chr>, away_names_short <chr>, away_names_seo <chr>,
      #   away_names_full <chr>, home_score <chr>, home_winner <lgl>,
      #   home_seed <chr>, home_description <chr>, home_rank <chr>, ...

# box score is scraped correctly

    Code
      scrape_boxscore(6053773)
    Output
      # A tibble: 19 x 26
         teamId firstName lastName     posit~1 minut~2 field~3 field~4 three~5 three~6
         <chr>  <chr>     <chr>        <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
       1 1143   EL        ELLIS        G            36       8      16       3       5
       2 1143   BRANDON   HUNTLEY-HAT~ F            27       3       4       0       1
       3 1143   MIKE      JAMES        F            32       2       7       0       2
       4 1143   JJ        TRAYNOR      F            27       6      10       4       5
       5 1143   JAE'LYN   WITHERS      F            30       1       7       0       2
       6 1143   SYDNEY    CURRY        F             8       2       2       0       0
       7 1143   KAMARI    LANDS        F            20       0       3       0       0
       8 1143   HERCY     MILLER       G             9       0       2       0       2
       9 1143   ALEXANDER PAYNE        F             2       0       0       0       0
      10 1143   DEVIN     REE          F             2       0       0       0       0
      11 1143   ROOSEVELT WHEELER      C             7       1       1       0       0
      12 1782   KYLE      FILIPOWSKI   C            23       5       7       1       2
      13 1782   DERECK    LIVELY II    C            25       3       5       0       1
      14 1782   MARK      MITCHELL     F            32       5       8       0       1
      15 1782   TYRESE    PROCTOR      G            35       4      13       4       8
      16 1782   JEREMY    ROACH        G            30       6       9       0       0
      17 1782   JACOB     GRANDISON    F            14       3       5       3       5
      18 1782   DARIQ     WHITEHEAD    F            27       2       9       1       5
      19 1782   RYAN      YOUNG        C            14       1       3       0       0
      # ... with 17 more variables: freeThrowsMade <dbl>, freeThrowsAttempted <dbl>,
      #   totalRebounds <dbl>, offensiveRebounds <dbl>, assists <dbl>,
      #   personalFouls <dbl>, steals <dbl>, turnovers <chr>, blockedShots <chr>,
      #   points <chr>, game_id <dbl>, homeTeam <chr>, seoName <chr>,
      #   sixCharAbbr <chr>, shortName <chr>, nickName <chr>, color <chr>, and
      #   abbreviated variable names 1: position, 2: minutesPlayed,
      #   3: fieldGoalsMade, 4: fieldGoalsAttempted, 5: threePointsMade, ...

---

    Code
      scrape_boxscore(6068979)
    Output
      # A tibble: 18 x 26
         teamId firstName lastName     posit~1 minut~2 field~3 field~4 three~5 three~6
         <chr>  <chr>     <chr>        <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
       1 2288   "RIKKI"   HARRIS       G            34       7       9       3       4
       2 2288   "COTIE"   MCMAHON      F            30       3       8       0       1
       3 2288   "TAYLOR"  MIKESELL     G            40       4      12       4       6
       4 2288   "TAYLOR"  THIERRY      G            40       6      12       2       3
       5 2288   "EBONI"   WALKER       F            17       3       8       0       1
       6 2288   "KAITLYN" COSTNER      G             1       0       0       0       0
       7 2288   "REBEKA"  MIKULASIKOVA F            23       4       9       1       4
       8 2288   "EMMA "   SHUMATE      G            15       1       2       0       0
       9 2512   "LEIGHA"  BROWN        G            38      11      21       3       6
      10 2512   "JORDAN"  HOBBS        G            30       3       9       3       6
      11 2512   "EMILY"   KISER        F            39       3       7       1       2
      12 2512   "MADDIE"  NOLAN        G            36       1       7       0       5
      13 2512   "CAMERON" WILLIAMS     F             9       1       1       0       0
      14 2512   "ALYSSA"  CROCKETT     F             7       0       0       0       0
      15 2512   "CHYRA"   EVANS        F            17       0       3       0       0
      16 2512   "GRETA "  KAMPSCHROED~ G             9       0       3       0       2
      17 2512   "ELISE"   STUCK        F             3       0       0       0       0
      18 2512   "ARI"     WIGGINS      G            12       0       0       0       0
      # ... with 17 more variables: freeThrowsMade <dbl>, freeThrowsAttempted <dbl>,
      #   totalRebounds <dbl>, offensiveRebounds <dbl>, assists <dbl>,
      #   personalFouls <dbl>, steals <dbl>, turnovers <chr>, blockedShots <chr>,
      #   points <chr>, game_id <dbl>, homeTeam <chr>, seoName <chr>,
      #   sixCharAbbr <chr>, shortName <chr>, nickName <chr>, color <chr>, and
      #   abbreviated variable names 1: position, 2: minutesPlayed,
      #   3: fieldGoalsMade, 4: fieldGoalsAttempted, 5: threePointsMade, ...

---

    Code
      scrape_boxscore(3170318)
    Output
      # A tibble: 17 x 26
         teamId firstName   lastName  position minut~1 field~2 field~3 three~4 three~5
         <chr>  <chr>       <chr>     <chr>      <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
       1 1628   "Jordan"    Brown     F             10       3       4       0       0
       2 1628   "Tre'Shawn" Thurman   F             20       0       4       0       1
       3 1628   "Caleb"     Martin    F             30       5      14       3      10
       4 1628   "Trey"      Porter    F             17       3       5       0       0
       5 1628   "Cody"      Martin    F             40       1       7       1       1
       6 1628   "Jazz"      Johnson   G             31       2       7       1       5
       7 1628   "Corey"     Henson    G             17       2       3       2       3
       8 1628   "Jordan"    Caroline  G-F           35       3      12       0       5
       9 2640   "Jalen"     McDaniels F             37       4      15       0       2
      10 2640   "Matt"      Mitchell  F             35       3       9       1       4
      11 2640   "Aguek"     Arop      F             26       3       5       0       0
      12 2640   "Nolan"     Narain    F             10       0       1       0       0
      13 2640   "Nathan"    Mensah    F             10       2       3       0       0
      14 2640   "Jordan"    Schakel   G             13       2       3       2       2
      15 2640   "Jeremy "   Hemsley   G             26       6      12       2       4
      16 2640   "Devin"     Watson    G             39       5      14       1       6
      17 2640   "Adam"      Seiko     G              4       0       1       0       1
      # ... with 17 more variables: freeThrowsMade <dbl>, freeThrowsAttempted <dbl>,
      #   totalRebounds <dbl>, offensiveRebounds <dbl>, assists <dbl>,
      #   personalFouls <dbl>, steals <dbl>, turnovers <chr>, blockedShots <chr>,
      #   points <chr>, game_id <dbl>, homeTeam <chr>, seoName <chr>,
      #   sixCharAbbr <chr>, shortName <chr>, nickName <chr>, color <chr>, and
      #   abbreviated variable names 1: minutesPlayed, 2: fieldGoalsMade,
      #   3: fieldGoalsAttempted, 4: threePointsMade, 5: threePointsAttempted

# pbp is scraped correctly

    Code
      scrape_pbp(6053773)
    Output
      # A tibble: 418 x 17
         periodN~1 perio~2 score time  visit~3 homeT~4 game_id id_home id_vi~5 short~6
         <chr>     <chr>   <chr> <chr> <chr>   <chr>     <dbl> <chr>   <chr>   <chr>  
       1 1         1st Ha~ ""    19:49 ""      "Layup~ 6053773 1782    1143    Duke   
       2 1         1st Ha~ ""    19:47 "LOU D~ ""      6053773 1782    1143    Duke   
       3 1         1st Ha~ "2-0" 19:39 "Layup~ ""      6053773 1782    1143    Duke   
       4 1         1st Ha~ ""    19:39 "LOU A~ ""      6053773 1782    1143    Duke   
       5 1         1st Ha~ ""    19:19 ""      "DU Tu~ 6053773 1782    1143    Duke   
       6 1         1st Ha~ ""    19:19 "LOU S~ ""      6053773 1782    1143    Duke   
       7 1         1st Ha~ ""    19:03 "3 Poi~ ""      6053773 1782    1143    Duke   
       8 1         1st Ha~ ""    19:03 ""      "DU Bl~ 6053773 1782    1143    Duke   
       9 1         1st Ha~ ""    18:59 ""      "DU De~ 6053773 1782    1143    Duke   
      10 1         1st Ha~ ""    18:46 "Foul ~ ""      6053773 1782    1143    Duke   
      # ... with 408 more rows, 7 more variables: shortName_visitor <chr>,
      #   seoName_home <chr>, seoName_visitor <chr>, sixCharAbbr_home <chr>,
      #   sixCharAbbr_visitor <chr>, nickName_home <chr>, nickName_visitor <chr>, and
      #   abbreviated variable names 1: periodNumber, 2: periodDisplay,
      #   3: visitorText, 4: homeText, 5: id_visitor, 6: shortName_home

---

    Code
      scrape_pbp(6068979)
    Output
      # A tibble: 461 x 17
         periodN~1 perio~2 score time  visit~3 homeT~4 game_id id_home id_vi~5 short~6
         <chr>     <chr>   <chr> <chr> <chr>   <chr>     <dbl> <chr>   <chr>   <chr>  
       1 1         1st Qu~ ""    09:37 "3 Poi~ ""      6068979 2512    2288    Michig~
       2 1         1st Qu~ ""    09:34 ""      "Mich ~ 6068979 2512    2288    Michig~
       3 1         1st Qu~ ""    09:11 ""      "Jumpe~ 6068979 2512    2288    Michig~
       4 1         1st Qu~ ""    09:09 "OSU D~ ""      6068979 2512    2288    Michig~
       5 1         1st Qu~ ""    09:02 "OSU T~ ""      6068979 2512    2288    Michig~
       6 1         1st Qu~ "0-3" 08:45 ""      "3 Poi~ 6068979 2512    2288    Michig~
       7 1         1st Qu~ ""    08:45 ""      "Mich ~ 6068979 2512    2288    Michig~
       8 1         1st Qu~ ""    08:34 "OSU T~ ""      6068979 2512    2288    Michig~
       9 1         1st Qu~ ""    08:34 ""      "Mich ~ 6068979 2512    2288    Michig~
      10 1         1st Qu~ "0-5" 08:30 ""      "Jumpe~ 6068979 2512    2288    Michig~
      # ... with 451 more rows, 7 more variables: shortName_visitor <chr>,
      #   seoName_home <chr>, seoName_visitor <chr>, sixCharAbbr_home <chr>,
      #   sixCharAbbr_visitor <chr>, nickName_home <chr>, nickName_visitor <chr>, and
      #   abbreviated variable names 1: periodNumber, 2: periodDisplay,
      #   3: visitorText, 4: homeText, 5: id_visitor, 6: shortName_home

---

    Code
      scrape_pbp(3170318)
    Output
      # A tibble: 380 x 17
         periodN~1 perio~2 score time  visit~3 homeT~4 game_id id_home id_vi~5 short~6
         <chr>     <chr>   <chr> <chr> <chr>   <chr>     <dbl> <chr>   <chr>   <chr>  
       1 1         1st Ha~ ""    20:00 "Trey ~ ""      3170318 2640    1628    San Di~
       2 1         1st Ha~ ""    19:35 "Jorda~ ""      3170318 2640    1628    San Di~
       3 1         1st Ha~ ""    19:33 "Tre'S~ ""      3170318 2640    1628    San Di~
       4 1         1st Ha~ ""    19:25 "Natha~ ""      3170318 2640    1628    San Di~
       5 1         1st Ha~ ""    19:23 ""      "Devin~ 3170318 2640    1628    San Di~
       6 1         1st Ha~ ""    18:59 ""      "Devin~ 3170318 2640    1628    San Di~
       7 1         1st Ha~ ""    18:57 "Tre'S~ ""      3170318 2640    1628    San Di~
       8 1         1st Ha~ ""    18:52 "Caleb~ ""      3170318 2640    1628    San Di~
       9 1         1st Ha~ ""    18:50 ""      "Jerem~ 3170318 2640    1628    San Di~
      10 1         1st Ha~ "0-2" 18:39 ""      "Jerem~ 3170318 2640    1628    San Di~
      # ... with 370 more rows, 7 more variables: shortName_visitor <chr>,
      #   seoName_home <chr>, seoName_visitor <chr>, sixCharAbbr_home <chr>,
      #   sixCharAbbr_visitor <chr>, nickName_home <chr>, nickName_visitor <chr>, and
      #   abbreviated variable names 1: periodNumber, 2: periodDisplay,
      #   3: visitorText, 4: homeText, 5: id_visitor, 6: shortName_home

