#' Translate gcdg to gsed
#' Translate the object language of a data.frame and/or a dmodel object from gcdg lexicon to gsed lexicon.
#' @param input object of class "data.frame" or object of class "dmodel".
#' @param items names of the items in te original data.frame that need to be translated.
#'
#' @return output object
#' @export
translate_gcdg_gsed <- function(input, items = NULL){
  if("dmodel" %in% class(input)){
    model <- input
    model$beta_l$agedays <- as.integer(model$beta_l$agedays)
    model$beta_l$age <- NULL
    model$dscore$agedays <- as.integer(model$dscore$agedays)
    model$dscore$age <- NULL
    ##omzetten naar gsed lex
    rownames(model$fit$item) <- gseddata::rename_gcdg_gsed( rownames(model$fit$item))
    model$itembank$lex_gsed <- gseddata::rename_gcdg_gsed(model$itembank$lex_gsed)
    model$items <- gseddata::rename_gcdg_gsed(model$items)
    model$itemtable$item <- gseddata::rename_gcdg_gsed(model$itemtable$item)
    model$item_fit$item <- gseddata::rename_gcdg_gsed(model$item_fit$item)
    names(model$fit$b) <- gseddata::rename_gcdg_gsed(names(model$fit$b))
    output <- model
  }
  if("data.frame" %in% class(input)){
    data <- input
    if(is.null(items)){items <- colnames(data)}
    if(is.null(items)){warning("all column names in data are translated, because item are not specified")}
    colnames(data)[items] <- gseddata::rename_gcdg_gsed(colnames(data)[items])
  }
  return(output)
}
