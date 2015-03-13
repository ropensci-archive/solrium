#' @param separator Specifies the character to act as the field separator. Default: ','
#' @param header TRUE if the first line of the CSV input contains field or column names. 
#' Default: \code{TRUE}. If the fieldnames parameter is absent, these field names 
#' will be used when adding documents to the index.
#' @param fieldnames Specifies a comma separated list of field names to use when adding 
#' documents to the Solr index. If the CSV input already has a header, the names 
#' specified by this parameter will override them. Example: fieldnames=id,name,category
#' @param skip A comma separated list of field names to skip in the input. An alternate 
#' way to skip a field is to specify it's name as a zero length string in fieldnames. 
#' For example, \code{fieldnames=id,name,category&skip=name} skips the name field, 
#' and is equivalent to \code{fieldnames=id,,category}
#' @param skipLines Specifies the number of lines in the input stream to discard 
#' before the CSV data starts (including the header, if present). Default: \code{0}
#' @param trim If true remove leading and trailing whitespace from values. CSV parsing 
#' already ignores leading whitespace by default, but there may be trailing whitespace, 
#' or there may be leading whitespace that is encapsulated by quotes and is thus not 
#' removed. This may be specified globally, or on a per-field basis. 
#' Default: \code{FALSE}
#' @param encapsulator The character optionally used to surround values to preserve 
#' characters such as the CSV separator or whitespace. This standard CSV format handles 
#' the encapsulator itself appearing in an encapsulated value by doubling the 
#' encapsulator.
#' @param escape The character used for escaping CSV separators or other reserved 
#' characters. If an escape is specified, the encapsulator is not used unless also 
#' explicitly specified since most formats use either encapsulation or escaping, not both.
#' @param keepEmpty Keep and index empty (zero length) field values. This may be specified 
#' globally, or on a per-field basis. Default: \code{FALSE}
#' @param literal Adds fixed field name/value to all documents. Example: Adds a "datasource" 
#' field with value equal to "products" for every document indexed from the CSV 
#' \code{literal.datasource=products}
#' @param map Specifies a mapping between one value and another. The string on the LHS of 
#' the colon will be replaced with the string on the RHS. This parameter can be specified 
#' globally or on a per-field basis. Example: replaces "Absolutely" with "true" in every 
#' field \code{map=Absolutely:true}. Example: removes any values of "RemoveMe" in the 
#' field "foo" \code{f.foo.map=RemoveMe:&f.foo.keepEmpty=false }
#' @param split If TRUE, the field value is split into multiple values by another 
#' CSV parser. The CSV parsing rules such as separator and encapsulator may be specified 
#' as field parameters. See \url{https://wiki.apache.org/solr/UpdateCSV#split} for examples.
#' @param rowid If not null, add a new field to the document where the passed in parameter 
#' name is the field name to be added and the current line/rowid is the value. This is 
#' useful if your CSV doesn't have a unique id already in it and you want to use the line 
#' number as one. Also useful if you simply want to index where exactly in the original 
#' CSV file the row came from
#' @param rowidOffset In conjunction with the rowid parameter, this integer value will be 
#' added to the rowid before adding it the field.
#' @param overwrite If true (the default), check for and overwrite duplicate documents, 
#' based on the uniqueKey field declared in the solr schema. If you know the documents you 
#' are indexing do not contain any duplicates then you may see a considerable speed up 
#' with &overwrite=false.
#' @param commit Commit changes after all records in this request have been indexed. The 
#' default is commit=false to avoid the potential performance impact of frequent commits.
