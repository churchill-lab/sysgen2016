
library("analogsea")
Sys.setenv(DO_PAT = "*** REPLACE THIS BY YOUR DIGITAL OCEAN API KEY ***")

d <- docklet_create(size = getOption("do_size", "8gb"),
                    region = getOption("do_region", "nyc2"))

# Needed to add this to update the IP address. OTherwise, I got a "network not up yet" error.
d = droplet(d$id)

# pull images (~10 min)
d %>% docklet_pull("rocker/hadleyverse")
d %>% docklet_pull("churchill/sysgen2016")
d %>% docklet_pull("churchill/asesuite")
d %>% docklet_pull("ipython/scipystack")
#d %>% docklet_pull("churchill/webapp")
d %>% docklet_images()

# download files to /data folder, (~60 mins).
lines <- "wget https://raw.githubusercontent.com/churchill-lab/sysgen2016/master/scripts/download_data_from_ftp.sh
          /bin/bash download_data_from_ftp.sh
          rm download_data_from_ftp.sh"
cmd <- paste0("ssh ", analogsea:::ssh_options(), " ", "root", "@", analogsea:::droplet_ip(d)," ", shQuote(lines))
analogsea:::do_system(d, cmd, verbose = TRUE)

# Make a snapshot of this machine (~20  min).
d %>%
  droplet_power_off() %>%
  droplet_wait() %>%
  droplet_snapshot(name = "shortcourse2016")

# Destroy the source droplet to see if we can re-make it using the image.
droplet_delete(d)
rm(d)

# Run the one machine (~ 5 min).
img = images(private = TRUE)[["shortcourse2016"]]
d = droplet_create(name = "droplet1", size = "8gb", image = img[["id"]],
                   region = "nyc2")

# Needed to add this to update the IP address. OTherwise, I got a "network not up yet" error.
d = droplet(d$id)

# start the containers
d %>% docklet_run("-d", " -v /data:/data", " -p 8787:8787", " -e USER=rstudio", " -e PASSWORD=sysgen ", "churchill/sysgen2016")
d %>% docklet_run("-dt", " -v /data:/data", " -p 43210:43210 -p 43211:43211 ", "churchill/asesuite") %>% docklet_ps()

# start eQTL/pQTL viewer - may cause memory problems for kallisto
# d %>% docklet_run("-dt", " -v /data:/data", " -p 8888:8888 -p 8889:8889 ", "churchill/webapp /usr/bin/start-app.sh") %>% docklet_ps()

# kill droplet
# droplet_delete(d)
