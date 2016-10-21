# Short Course on Systems Genetics 2016


This is a repository for [Short Course on Systems Genetics](https://www.jax.org/education-and-learning/education-calendar/2016/october/short-course-on-systems-genetics) (October 16 - 21, 2016) at [The Jackson Laboratory](http://www.jax.org) that includes the following tutorials:

* __DOQTL__ (D Gatti) [[markdown]](https://github.com/churchill-lab/sysgen2016/blob/master/markdown/DOQTL_workshop_2016.Rmd): kinship matrix, linkage and association mapping, eQTL viewer
* __DESeq2__ (P Simecek) [[markdown]](https://github.com/churchill-lab/sysgen2016/blob/master/markdown/DESeq.Rmd): detect differential expression between groups of RNASeq samples
* __Mediation analysis__ (S Munger & P Simecek) [[markdown]](https://cdn.rawgit.com/churchill-lab/sysgen2016/master/markdown/mediation.examples.html): find an intermediate between genotype and trans-regulated gene/protein
* __How to start Digital Ocean droplet?__ [[markdown]](https://github.com/churchill-lab/sysgen2016/blob/master/start_droplet.md) How to run the customized RStudio in the cloud
The participants use their web browsers to connect to customized [Docker](https://docs.docker.com/) containers hosted on [Digital Ocean](https://www.digitalocean.com/?refcode=673c97887267) virtual machines (see screen captures below).

![rstudio](figures/rstudio.jpg) 

Docker is a lightweight container virtualization platform. We created three Docker images for this course: [churchill/doqtl](https://github.com/churchill-lab/sysgen2016/tree/master/docker/doqtl) (RStudio, DOQTL, DESeq2), [churchill/asesuite](https://github.com/churchill-lab/sysgen2016/blob/master/docker/asesuite/Dockerfile) (kallisto, EMASE) and [churchill/webapp](https://github.com/churchill-lab/sysgen2016/blob/master/docker/webapp/Dockerfile) (eQTL/pQTL viewer).  You can run docker containers on your computer or in the cloud environments like AWS, Digital Ocean, Microsoft Azure or Google Cloud. [Dockerfiles](https://github.com/churchill-lab/sysgen2016/blob/master/docker/asesuite/Dockerfile) can also serve as a list of instructions how to install the software on your computer. See [here](https://github.com/churchill-lab/sysgen2016/blob/master/start_droplet.md) how to set up your own RStudio in the cloud. 
 
