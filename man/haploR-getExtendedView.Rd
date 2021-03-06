% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/haploregExtendedView.R
\name{getExtendedView}
\alias{getExtendedView}
\title{This function queries HaploReg web-based tool 
in order to Extended view for SNP of interest}
\usage{
getExtendedView(snp, url = Haploreg.settings[["extended.view.url"]])
}
\arguments{
\item{snp}{A SNP of interest.}

\item{url}{A url to HaploReg.
Default: <http://pubs.broadinstitute.org/mammals/haploreg/detail_v4.1.php?query=&id=>
Previously was: <"http://archive.broadinstitute.org/mammals/haploreg/detail_v4.1.php?query=&id=">}
}
\value{
A list of tables t1, t2, ..., etc 
depending on information contained in HaploReg database.
}
\description{
This function queries HaploReg web-based tool 
in order to Extended view for SNP of interest
}
\examples{
tables <- getExtendedView(snp="rs10048158")
tables
}
