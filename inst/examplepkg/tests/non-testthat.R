library(examplepkg)

# test scenario where test traces need to be built based on S4 methods 
# associated with objects defined within the test
setClass("myS4Example", contains = "S4Example")
mys4ex <- new("myS4Example", data = list(a = 1, b = 2))  
mys4ex
