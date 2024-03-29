% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/srcref_df.R
\name{test_trace_mapping}
\alias{test_trace_mapping}
\title{Create a data.frame mapping tests to coverage traces}
\usage{
test_trace_mapping(x)
}
\arguments{
\item{x}{A \code{coverage} object produced with
\code{options(covr.record_tests = TRUE)}.}
}
\value{
A \code{data.frame} with one record for each line of code executed, with
variables:

\describe{
\item{test}{The index of the test that was executed, reflecting the order
in which tests are executed}
\item{depth}{The call stack depth when the coverage trace was evaluated}
\item{i}{The index of the expression evaluated by each test. This can be
used to recover an order of trace execution for a given test index}
\item{trace}{The index of the coverage trace that was evaluated}
}
}
\description{
Extract a matrix used to relate test code to the traces that each test
evaluates.
}
\examples{
options(covr.record_tests = TRUE)
pkg_path <- system.file("examplepkg", package = "covtracer")
cov <- covr::package_coverage(pkg_path)
test_trace_mapping(cov)

}
\seealso{
srcrefs_df srcrefs
}
