% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/srcrefs.R
\name{package_check_has_keep_source}
\alias{package_check_has_keep_source}
\title{Verify that the package collection contains srcref information}
\usage{
package_check_has_keep_source(env)
}
\arguments{
\item{env}{A package namespace environment or iterable collection of package
objects}
}
\value{
Used for side effect of throwing an error when a package was not
installed with \code{srcref}s.
}
\description{
Test whether the package object collection contains srcref attributes.
}
