library("analogsea")
library(parallel)
library(doParallel)
Sys.setenv(DO_PAT = "*** REPLACE THIS BY YOUR DIGITAL OCEAN API KEY ***")

participants <- read.csv("participant_list.txt", sep="\t", as.is=TRUE)
N = nrow(participants)

# Make machine names based on e-mail addresses.
email.column = grep("email", colnames(participants), ignore.case = TRUE)
machine.names = make.names(participants[,email.column])
machine.names = gsub("_", ".", machine.names)

# create a droplet for each participant
droplet_list <- list()

# Trying new command to make multiple machines at once.
img = images(private = TRUE)[["shortcourse2016"]]
# NOTE: You may get an error if you create more than 10 machines.  Just make
#       multiple calls to this function and stack up the droplets. (~ 10 min. for 10 machines)
droplet_list = droplets_create(names = machine.names[1:10], size = "8gb", image = img[[1]],
                               region = "nyc2")
droplet_list[11:20] = droplets_create(names =  machine.names[11:20], size = "8gb", image = img[[1]],
                               region = "nyc2")
droplet_list[21:30] = droplets_create(names =  machine.names[21:30], size = "8gb", image = img[[1]]
                               region = "nyc2")
droplet_list[31:N] = droplets_create(names =  machine.names[31:N], size = "8gb", image = img[[1]],
                               region = "nyc2")

# start docker containers
for(i in 1:N) {
  print(i)
  # select droplet
  d = droplet(droplet_list[[i]]$id)
  
  # start the containers.
  d %>% docklet_run("-d", " -v /data:/data", " -p 8787:8787", " -e USER=rstudio", " -e PASSWORD=sysgen ", "churchill/sysgen2016")
  d %>% docklet_run("-dt", " -v /data:/data", " -p 43210:43210 -p 43211:43211 ", "churchill/asesuite") %>% docklet_ps()
  
  # add symbolic links
#  lines2 <- "docker exec myrstudio ln -s /data /home/rstudio/data"
#  cmd2 <- paste0("ssh ", analogsea:::ssh_options(), " ", "root", "@", analogsea:::droplet_ip(d)," ", shQuote(lines2))
#  analogsea:::do_system(d, cmd2, verbose = TRUE)
} # for(i)



### Create participant table with links
participants$DO_machine <- sapply(droplet_list, function(x) x$name)
participants$link_RStudio <- sapply(droplet_list, function(x) paste0("http://",analogsea:::droplet_ip(x),":8787"))
participants$link_terminal <- sapply(droplet_list, function(x) paste0("http://",analogsea:::droplet_ip(x),":43210"))

library(xtable)
sanitize.text.function <- function(x) {
  idx <- substr(x, 1, 7) == "http://"
  x[idx] <- paste0('<a href="',x[idx],'">',sub("^http://","",x[idx]),'</a>')
  x
}
cols <- c("BadgeName", "DO_machine", "link_RStudio", "link_terminal")
print(xtable(participants[,cols], caption="Digital Ocean Machines"),
      type = "html", sanitize.text.function = sanitize.text.function,
      file = "dolist.html", include.rownames=FALSE)

### Send emails to course participants
library(mailR)


for (i in 1:N) {
  email_body <- paste0("Dear ",participants$first_Name[i],",\n\n",
                       "During the workshop, you will need an access to RStudio and terminal ",
                       "running on your personal Digital Ocean machine. You can access the machine ",
                       "directly in your browser:\n\n",
                       participants$link_RStudio[i]," (RStudio, user:rstudio, password:sysgen)\n",
                       participants$link_terminal[i]," (terminal, user:root, password:sysgen)\n\n",
                       "After the workshop you can run this docker image either on your personal machine or host it ",
                       "on Digital Ocean (as we did). Further instructions can be found on https://github.com/churchill-lab/sysgen2015.\n\n",
                       "Best regards,\n\n","Petr Simecek")
  
  send.mail(from = "REPLACE THIS BY YOUR_GMAIL@gmail.com",
            to = participants$Email_Address[i],
            replyTo = "REPLACE THIS BY YOUR_EMAIL",
            subject = "Short Course On The Genetics Of Addiction - Digital Ocean Machine Access",
            body = email_body,
            smtp = list(host.name = "smtp.gmail.com", port = 465, 
                        user.name = "REPLACE THIS BY YOUR_GMAIL@gmail.com", 
                        passwd = "***YOUR PASSWORD***", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
}
