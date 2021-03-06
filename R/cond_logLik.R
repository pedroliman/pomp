##' Conditional log likelihood
##'
##' The estimated conditional log likelihood from a fitted model.
##'
##' The conditional likelihood is defined to be the value of the density
##' of \deqn{Y(t_k) | Y(t_1),\dots,Y(t_{k-1})}{Yk | Y1,\dots,Y(k-1)} evaluated at \eqn{Y(t_k) = y^*_k}{Yk = yk*}.
##' Here, \eqn{Y(t_k)}{Yk} is the observable process, and \eqn{y^*_k}{yk*} the data, at time \eqn{t_k}.
##'
##' Thus the conditional log likelihood at time \eqn{t_k} is
##' \deqn{\ell_k(\theta) = \log f[Y(t_k)=y^*_k \vert Y(t_1)=y^*_1, \dots, Y(t_{k-1})=y^*_{k-1}],}{ell_k(theta)=log f[Yk = yk* | Y1=y1*, \dots, Y(k-1)=y(k-1)*],}
##' where \eqn{f} is the probability density above.
##'
##' @name cond.logLik
##' @docType methods
##' @rdname cond_logLik
##' @include pomp_class.R kalman.R pfilter.R wpfilter.R
##' @aliases cond.logLik cond.logLik,missing-method cond.logLik,ANY-method
##' @family particle_filter_methods
##' @inheritParams filter.mean
##'
##' @return
##' The numerical value of the conditional log likelihood.
##' Note that some methods compute not the log likelihood itself but instead a related quantity.
##' To keep the code simple, the \code{cond.logLik} function is nevertheless used to extract this quantity.
NULL

setGeneric("cond.logLik",
  function (object, ...)
    standardGeneric("cond.logLik")
)

setMethod(
  "cond.logLik",
  signature=signature(object="missing"),
  definition=function (...) {
    reqd_arg("cond.logLik","object")
  }
)

setMethod(
  "cond.logLik",
  signature=signature(object="ANY"),
  definition=function (object, ...) {
    undef_method("cond.logLik",object)
  }
)

##' @name cond.logLik-kalmand_pomp
##' @aliases cond.logLik,kalmand_pomp-method
##' @rdname cond_logLik
##' @export
setMethod(
  "cond.logLik",
  signature=signature(object="kalmand_pomp"),
  definition=function(object,...)object@cond.logLik
)

##' @name cond.logLik-pfilterd_pomp
##' @aliases cond.logLik,pfilterd_pomp-method
##' @rdname cond_logLik
##' @export
setMethod(
  "cond.logLik",
  signature=signature(object="pfilterd_pomp"),
  definition=function(object,...)object@cond.logLik
)

##' @name cond.logLik-wpfilterd_pomp
##' @aliases cond.logLik,wpfilterd_pomp-method
##' @rdname cond_logLik
##' @export
setMethod(
  "cond.logLik",
  signature=signature(object="wpfilterd_pomp"),
  definition=function(object,...)object@cond.logLik
)

##' @name cond.logLik-bsmcd_pomp
##' @aliases cond.logLik,bsmcd_pomp-method
##' @rdname cond_logLik
##'
##' @return
##' When \code{object} is of class \sQuote{bsmcd_pomp} (i.e., the result of a \code{bsmc2} computation), \code{cond.logLik} returns the conditional log \dQuote{evidence} (see \code{\link{bsmc2}}).
##'
##' @export
setMethod(
  "cond.logLik",
  signature=signature(object="bsmcd_pomp"),
  definition=function(object,...)object@cond.log.evidence
)

##' @name cond.loglik
##' @aliases cond.loglik
##' @rdname deprecated
##' @export
cond.loglik <- function (...) {
  .Deprecated("cond.logLik",package="pomp")
  cond.logLik(...)
}
