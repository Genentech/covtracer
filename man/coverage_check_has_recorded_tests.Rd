% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_trace_df.R
\name{coverage_check_has_recorded_tests}
\alias{coverage_check_has_recorded_tests}
\title{Check that the coverage object retains testing information}
\usage{
coverage_check_has_recorded_tests(coverage, warn = TRUE)
}
\arguments{
\item{coverage}{a \code{\link[covr]{covr}} coverage object}

\item{warn}{Whether to warn when it is uncertain whether the tests were
recorded. It may be uncertain if tests were recorded if there are no tested
R code traces.}
}
\value{
Used for side-effects of emitting an error when a coverage object
does not contain recorded traces, or a warning when a coverage object
appears to have no tests.
}
\description{
Check whether the coverage object has expected fields produced when coverage
was captured with \code{option(covr.record_tests = TRUE)}, throwing an error
if it was not.
}
\seealso{
Other coverage_tests: 
\code{\link{coverage_get_tests}()},
\code{\link{coverage_has_recorded_tests}()}
}
\concept{coverage_tests}
