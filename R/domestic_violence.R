#' Human and animal violence reports in São Paulo, Brazil
#'
#' A dataset containing observed and expected scaled values of
#' human and animal violence reports.
#' @references Baquero, O. S., Ferreira, F., Robis, M., Neto, J. S. F., & Onell, J. A. (2018). Bayesian spatial models of the association between interpersonal violence, animal abuse and social vulnerability in São Paulo, Brazil. Preventive veterinary medicine, 152, 48-55.
#'
#' @format A data frame of class "sf" with 768 rows and 4 variables:
#' \describe{
#'   \item{Type}{Animal or Human}
#'   \item{Value}{Observed or Expected}
#'   \item{Scaled}{Scaled value}
#'   \item{geometry}{sfc_POLYGON}
#' }
"domestic_violence"