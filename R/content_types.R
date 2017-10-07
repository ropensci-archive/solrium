ctype_xml <- function() list(`Content-Type` = "application/xml") 
ctype_json <- function() list(`Content-Type` = "application/json") 
ctype_csv <- function() list(`Content-Type` = "application/csv")
ctype <- function(x) list(`Content-Type` = x)

get_ctype <- function(x) {
  switch(x, 
         xml = ctype_xml(),
         json = ctype_json(),
         csv = ctype("application/csv; charset=utf-8")
  )
}
