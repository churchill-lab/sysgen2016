## How to start Digital Ocean droplet?

Here, I will give a description how our virtual machines have been created. You can either create a machine manually on Digital Ocean, SSH to it and start the docker containers. Or you can use [R/analogsea](https://github.com/sckott/analogsea) package to start a droplet from a command line. 

In both cases, first, create an account on [Digital Ocean](https://www.digitalocean.com/?refcode=673c97887267). You should get $10 promotional credit that currently corresponds to free 3.5 days of 8GB machine running expense.

### For beginners - create a virtual machine manually

* Log into your Digital Ocean account. Click on "Create Droplet" button. Choose any droplet hostname and select its size - 8GB memory, 4 CPU, $0.119/hour. 

![Droplet size](figures/droplet_size.jpg)   

   
Scroll down to "Select image", click on 'Applications' tab and select Docker. Click on "Create Droplet" button. Droplet now starts in 1-2 minutes. You should receive an email with a password.   
   

![Docker button](figures/docker.jpg)

* Note down your droplet's IP.ADDRESS. SSH into your droplet (`ssh root@IP.ADDRESS`) and pull docker images
```{r}
  docker pull rocker/hadleyverse
  docker pull churchill/doqtl
  docker pull churchill/asesuite
  docker pull ipython/scipystack
  docker pull churchill/webapp
```
* Next, download the required datasets (~30 minutes)
```
   wget https://raw.githubusercontent.com/churchill-lab/sysgen2016/master/scripts/download_data_from_ftp.sh
   /bin/bash download_data_from_ftp.sh
   rm download_data_from_ftp.sh
```
* Finally, run docker containers. 
```{r}
  docker run -d -v /data:/data -p 8787:8787 -e USER=rstudio -e PASSWORD=sysgen churchill/doqtl
  docker run -dt -v /data:/data -p 43210:43210 -p 43211:43211  churchill/asesuite
  docker run -dt -v /data:/data -p 8888:8888 -p 8889:8889 churchill/webapp /usr/bin/start-app.sh
```

### For advanced users - create a virtual machine with R/analogsea package

* Install [R/analogsea](https://github.com/sckott/analogsea) package to your computer
* Create [Digital Ocean API key](https://cloud.digitalocean.com/settings/applications) and copy it to the second line of a script below
* Run [the script](https://github.com/churchill-lab/sysgen2016/blob/master/scripts/run_one_DO_machine.R)


### Access your virtual machine in the web browser

In your browser you can now access RStudio at http://IP.ADDRESS:8787 (user: rstudio, password: sysgen) and the terminal at http://IP.ADDRESS:43210 (user: root, password: sysgen). The eQTL and pQTL viewers are running at http://IP.ADDRESS:8888 and http://IP.ADDRESS:8889, respectively.

You are paying for your Digital Ocean machine as long as it is running. Do not forget to destroy it when you are done!
