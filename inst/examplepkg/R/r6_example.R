#' Helper function to test closures as R6 methods
#'
adder <- function(self) {
  function(x = 1) {
    # Accumulator$add  ## [comment used for testing]
    self$sum <- self$sum + x
    invisible(self)
  }
}



#' An example R6 Accumulator class
#'
#' @references <https://adv-r.hadley.nz/r6.html>
#' @importFrom R6 R6Class
#' @export
#'
Accumulator <- R6::R6Class("Accumulator", list(
  #' @field sum An accumulated sum
  sum = 0,

  #' @description
  #' Create a new Accumulator
  #'
  #' @param sum An initial sum to begin accumulating
  #' @return A new `Accumulator` object
  #'
  initialize = function(sum = 0) {
    # Accumulator$initialize  ## [comment used for testing]
    self$sum <- sum
  },

  #' @description
  #' Add to the accumulating sum
  #'
  #' @param x A value to add to the accumulating sum
  #' @return The `Accumulator` object after accumulating the new value
  #'
  add = adder(self)
))



#' An example R6 Person class with public and private fields/methods
#'
#' @references <https://adv-r.hadley.nz/r6.html>
#' @importFrom R6 R6Class
#' @export
#'
Person <- R6::R6Class("Person",
  public = list(

    #' @description
    #' Create a new Person
    #'
    #' @param name A name for the person
    #' @param age An age for the person
    #'
    initialize = function(name, age = NA) {
      # Person$initialize  ## [comment used for testing]
      private$name <- name
      private$age <- age
    },


    #' @description
    #' Print a Person objects info
    #'
    #' @param ... Arguments unused
    #'
    print = function(...) {
      # Person$print  ## [comment used for testing]
      cat("Person: \n")
      cat("  Name: ", private$name, "\n", sep = "")
      cat("  Age:  ", private$age, "\n", sep = "")
    }
  ),
  private = list(
    age = NA,
    name = NULL
  )
)



#' An example R6 Rando class using an active field
#'
#' @references <https://adv-r.hadley.nz/r6.html>
#' @importFrom R6 R6Class
#' @export
#'
Rando <- R6::R6Class("Rando", active = list(
  #' @field random A random number, generated uniquely upon access
  random = function(value) {
    # Rando$random   ## [comment used for testing]
    if (missing(value)) {
      runif(1)
    } else {
      stop("Can't set `$random`", call. = FALSE)
    }
  }
))



#' A materialized R6 object declared within a package namespace
#'
#' @export
PersonPrime <- Person$new("Optimus", "Prime")
