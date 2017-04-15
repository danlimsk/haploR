# Using haploR, an R package for querying HaploReg and RegulomeDB

## Overview

HaploReg <http://archive.broadinstitute.org/mammals/haploreg/haploreg.php> and 
RegulomeDB <http://www.regulomedb.org>
are web-based tools that extracts biological information such as eQTL, 
LD, motifs, etc. from large genomic projects such as ENCODE, 
the 1000 Genomes Project, Roadmap Epigenomics Project and others. 
This is sometimes called "post-GWAS" analysis.

The R-package \texttt{haploR} was developed to query 
those tools (HaploReg and RegulomeDB) directly from 
\texttt{R} in order to facilitate high-throughput 
genomic data analysis. Below we provide several examples 
that show how to work with this package.

Note: you must have a stable Internet connection 
to use this package.

Contact: <ilya.zhbannikov@duke.edu> for questions of 
usage the \texttt{haploR} or any other issues.

### Motivation and general strategy

This package was inspired by the fact that many web-based annotation databases do not have Application Programing Interface (API) and, therefore, do not allow users to query them remotedly. In our research we used Haploreg and Regulome annotation databases and had a hard time with  downloading results from Haploreg web site since it does not allow to do this. Regulome was a little bit friendly, but still not offering API therefore we could not include it to our automated data processing pipeline. 

We developed a custom analysis pipeline whcih prepares data, performs genetic association analysis and presents results in user-friendly form. Results include a list of genetic variants (SNPs), their corresponding p-values, phenotypes (traits) tested and other meta-information such as LD, alternative allele, minor allele frequency, motifs changed, etc. Of course, we could go thought the SNPs with genome-wide significant p-values (1e-8) and submit each SNP to Haploreg and Regulome manually, one-by-one, but of course it would take time and will not be fully automatic (which ruins one of the pipeline's paradigms). This is especially difficult if the web site does not have a download results option.

Therefore, we developed \code{haploR}, a user-friendly R package to connet to Haploreg and Regulome remotedly. This package siginificantly saved our time in developing reporting system for our internal genomic analysis pipeline.



## Installation of \emph{haploR} package

In order to install the \emph{haploR} package, the user must first install R <https://www.r-project.org>. After that, \emph{haploR} (its developer version) can be installed with:

```{r, echo=TRUE, eval=FALSE}
devtools::install_github("izhbannikov/haplor", buildVignette=TRUE)
```





## Examples

### Querying HaploReg
#### One or several genetic variants

```{r, echo=TRUE, message=FALSE}
library(haploR)
x <- queryHaploreg(query=c("rs10048158","rs4791078"))
x
```

Here \texttt{query} is a vector with names of genetic variants. 
\texttt{results} are the table similar to the output of HaploReg.

We then can create a subset from the results, for example, to choose only SNPs with r2 > 0.9:

```{r, echo=TRUE, message=FALSE}
subset.high.LD <- x[x$r2 > 0.9, c("rsID", "r2", "chr", "pos_hg38", "is_query_snp", "ref", "alt")]
subset.high.LD
```

We can then save the \code{subset.high.LD} into an Excel workbook:

```{r, echo=TRUE, message=FALSE}
require(openxlsx)
write.xlsx(x=subset.high.LD, file="subset.high.LD.xlsx")
```

These steps are summarized in a picture below.



#### Uploading file with variants

If you have a file with your SNPs you would like 
to analyze, you can 
supply it on an input as follows:

```{r, echo=TRUE, message=FALSE}
library(haploR)
x <- queryHaploreg(file=system.file("extdata/snps.txt", package = "haploR"))
x
```

File "snps.txt" is a text file which contains one rs-ID per line.

#### Using existing studies

Sometimes you would like to explore results from 
already performed study. In this case you should 
first the explore existing studies from 
HaploReg web site and then use one of 
them as an input parameter. See example below:

```{r, echo=TRUE, message=FALSE}
library(haploR)
# Getting a list of existing studies:
studies <- getHaploRegStudyList()
# Let us look at the first element:
studies[[1]]
# Let us look at the second element:
studies[[2]]
# Query Hploreg to explore results from 
# this study:
x <- queryHaploreg(study=studies[[1]])
x
```

### Querying RegulomeDB

To query RegulomeDB use this function:
```
queryRegulome(query = NULL, 
              format = "full",
              url = "http://www.regulomedb.org/results", 
              timeout = 10,
              check_bad_snps = TRUE, 
              verbose = FALSE)
```

This function queries RegulomeDB www.regulomedb.org web-based tool and returns results in a data frame.

#### Arguments

* query: Query (a vector of rsIDs).
* format: An output format.  Only 'full' is currently supported. See http://www.regulomedb.org/results.
* url: Regulome url address.  Default: http://www.regulomedb.org/results
* timeout: A 'timeout' parameter for 'curl'. Default: 10.
* check_bad_snps: Checks if all query SNPs are annotated (i.e. presented in the Regulome Database). Default: 'TRUE'
* verbose: Verbosing output. Default: FALSE.

#### Output

A list of two: (1) a data frame (table) wrapped to a \code{tibble} object and (2) a list of bad SNP IDs.  Bad SNP ID are those IDs that were not found in 1000 Genomes Phase 1 data

#### Example

```{r, echo=TRUE, message=FALSE}
library(haploR)
x <- queryRegulome(c("rs4791078","rs10048158"))
x$res.table
```


## Session information
```{r, echo=TRUE}
sessionInfo()
```
