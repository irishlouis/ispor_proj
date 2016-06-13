#' bin_steps
#' @description function to bin and label step count data from epoch summary
#'
#' @param x vector to be binned
#' @param lower lower range value, default to 0
#' @param upper upper range value, default to 20
#' @param by increament step, default 2.5
#' @param sep separating char for labels, default to -
#' @param above.char end char for final value, default to +
#'
#' @return
#' @export
#'
#' @examples
bin_steps <- function(x, lower = 0, upper = 20, by = 2.5,
                    sep = "-", above.char = "+") {
  
  labs <- c(paste(seq(lower, upper - by, by = by),
                  seq(lower + by - 1, upper - 1, by = by),
                  sep = sep),
            paste(upper, above.char, sep = ""))
  
  cut(floor(x), breaks = c(seq(lower, upper, by = by), Inf),
      right = FALSE, labels = labs)
}