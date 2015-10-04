#' Convert an Amazon review XML node into a data.frame
#'
#' @param review XMLInternalElementNode. This will be parsed into a 1-row data.frame
#' @return a dataframe containing names: helpful_count, helpful_total, stars, title, date, description
review_to_df <- function(review) {
  helpfulness <-  grepl('people found the following review helpful', XML::xmlValue(review[[2]]))
  offset <- if (helpfulness) 2 else 0
  data.frame(
    helpful_count = if (helpfulness) parse_float(review[[2]]) else NA,
    helpful_total = if (helpfulness) parse_float(gsub('.* of ', '', XML::xmlValue(review[[2]]))) else NA,
    stars         = parse_float(review[[offset + 2]][[2]]),
    author        = XML::xmlValue(review[[offset + 4]][[2]][[2]][[1]][[1]]),
    title         = XML::xmlValue(review[[offset + 2]][[4]][[1]]),
    date          = XML::xmlValue(review[[offset + 2]][[4]][[3]]),
    description   = XML::xmlValue(review[[10]]),
    stringsAsFactors = FALSE
  )
}
