source("d:/Rcompile/CRANpkg/make/check_diffs.R")

save_results("3.5")
save_results("3.6")
save_results("3.7")

try(check_results_diffs("3.5", flavor = "oldrel")) 
try(check_results_diffs("3.6", flavor = "release")) 
try(check_results_diffs("3.7", flavor = "devel", 
Sys.Date(), date.old = Sys.Date()-1)) # devel oder prerel

send_checks("3.5", Sys.Date(), Sys.Date()-1, send_external = FALSE)
send_checks("3.6", Sys.Date(), Sys.Date()-1, send_external = FALSE)
send_checks("3.7", Sys.Date(), Sys.Date()-1, send_external = Sys.getenv("Kurt") == "Kurt")


#check_results_diffs("3.4", date.new = Sys.Date(), date.old = Sys.Date()-2, windir = "D:\\Rcompile\\CRANpkg\\win", flavor = "release")
#send_checks("3.4", Sys.Date(), Sys.Date()-2, send_external = FALSE)
