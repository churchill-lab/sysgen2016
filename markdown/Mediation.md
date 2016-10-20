Mediation Analysis
================

-   [Scan for Tmem68 eQTL and pQTL](#scan-for-tmem68-eqtl-and-pqtl)

``` r
options(stringsAsFactors = F)
library(DOQTL)
library(intermediate)
## devtools::install_github("kbroman/qtlcharts")
load("/data/Rdata/DO192_DataforSysGenCourse.Rdata")
```

``` r
### Setting covariates
X <- model.matrix(~Sex*Diet, covariates.protein.192)
colnames(X)[2] <- "sex" # DOQTL requirement
```

Scan for Tmem68 eQTL and pQTL
-----------------------------

### 1) Scan for Tmem68 eQTL

``` r
my.gene = "Tmem68"  ### Input your gene of interest
target.rna.index <- which(annotations.rna.192$Gene == my.gene)
annotations.rna.192[target.rna.index,]  ### Show information for the gene of interest
```

    ##                             EnsemblID   Gene Chr Start.Mbp  End.Mbp
    ## ENSMUSG00000028232 ENSMUSG00000028232 Tmem68   4  3.549041 3.574853
    ##                      Gene.Biotype Strand Mean.per.Expr Nonzeros
    ## ENSMUSG00000028232 protein_coding     -1      1.382734      192
