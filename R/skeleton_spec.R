##' The deterministic skeleton of a model
##'
##' Specification of \dfn{skeleton}.
##'
##' @name skeleton_spec
##' @rdname skeleton_spec
##' @docType methods
##' @include pomp_fun.R csnippet.R
##' @keywords internal
##' @family information on model implementation
##'
##' @details
##' The skeleton is a dynamical system that expresses the central tendency of the unobserved Markov state process.
##' As such, it is not uniquely defined, but can be both interesting in itself and useful in practice.
##' In \pkg{pomp}, the skeleton is used by \code{\link{trajectory}} and \code{\link{traj.match}}.

##' If the state process is a discrete-time stochastic process, then the skeleton is a discrete-time map.
##' To specify it, provide \preformatted{
##'   skeleton = map(f, delta.t)}
##' to \code{pomp}, where \code{f} implements the map and \code{delta.t} is the size of the timestep covered at one map iteration.

##' If the state process is a continuous-time stochastic process, then the skeleton is a vectorfield (i.e., a system of ordinary differential equations).
##' To specify it, supply \preformatted{
##'   skeleton = vectorfield(f)}
##' to \code{pomp}, where \code{f} implements the vectorfield, i.e., the right-hand-size of the differential equations.

##' In either case, \code{f} can be furnished either as a C snippet (the preferred choice), or an \R function.
##' In writing a \code{skeleton} C snippet, be aware that:
##' \enumerate{
##'   \item For each state variable, there is a corresponding component of the deterministic skeleton.
##'   The goal of such a snippet is to compute all the components.
##'   \item When the skeleton is a map, the component corresponding to state variable \code{x} is named \code{Dx} and is the new value of \code{x} after one iteration of the map.
##'   \item When the skeleton is a vectorfield, the component corresponding to state variable \code{x} is named \code{Dx} and is the value of \eqn{dx/dt}.
##'   \item As with the other C snippets, all states, parameters and covariates, as well as the current time, \code{t}, will be defined in the context within which the snippet is executed.
##' }
##' The tutorials on the \href{https://kingaa.github.io/pomp/}{package website} give some examples.

##' If \code{f} is an \R function, it must be of prototype \preformatted{
##'   f(x, t, params, \dots)}
##' where, as usual,
##' \itemize{
##'   \item \code{x} is a numeric vector (length \code{nvar}) containing the coordinates of a point in state space at which evaluation of the skeleton is desired.
##'   \item \code{t} is a scalar value giving the time at which evaluation of the skeleton is desired.
##'   \item \code{params} is a numeric vector (length \code{npar}) holding the parameters.
##' }
##' As with the other basic components, \code{f} may take additional arguments, provided these are passed along with it in the call to \code{pomp}.
##' The function \code{f} must return a numeric vector of the same length as \code{x}, which contains the value of the map or vectorfield at the required point and time.
##'
NULL

setClass(
  "skelPlugin",
  slots=c(
    csnippet='logical',
    slotname='character',
    type='integer',
    skel.fn="ANY"
  ),
  prototype=prototype(
    csnippet=FALSE,
    slotname=character(0),
    type=0L,
    skel.fn=NULL
  )
)

setClass(
  "vectorfieldPlugin",
  contains="skelPlugin"
)

setClass(
  "mapPlugin",
  contains="skelPlugin",
  slots=c(
    delta.t="numeric"
  )
)

setMethod(
  "show",
  signature=signature(object="skelPlugin"),
  definition=function (object) {
    cat("<default>\n\n")
  }
)

setMethod(
  "show",
  signature=signature(object="vectorfieldPlugin"),
  definition=function (object) {
    cat("vectorfield:\n  - ")
    show(object@skel.fn)
  }
)

setMethod(
  "show",
  signature=signature(object="mapPlugin"),
  definition=function (object) {
    cat("map:\n")
    cat("  - time-step =",object@delta.t,"\n")
    cat("  - ")
    show(object@skel.fn)
  }
)

skel_plugin <- function (object, skel.fn) {
  if (missing(object)) {
    new("skelPlugin")
  } else {
    if (!missing(skel.fn)) object@skel.fn <- skel.fn
    object
  }
}

##' @name vectorfield
##' @rdname skeleton_spec
##' @param f procedure for evaluating the deterministic skeleton
##' This can be a C snippet, an \R function, or the name of a native routine in a dynamically linked library.
##' @export
##'
vectorfield <- function (f) {
  new("vectorfieldPlugin",skel.fn=f,type=1L)
}

##' @name map
##' @rdname skeleton_spec
##' @param delta.t positive numerical value; the size of the discrete time step corresponding to an application of the map
##' @export
##'
map <- function (f, delta.t = 1) {
  if (!isTRUE(delta.t > 0 && length(delta.t)==1))
    stop("in ",sQuote("map"),": ",sQuote("delta.t"),
      " must be a positive number.",call.=FALSE)
  new("mapPlugin",skel.fn=f,delta.t=delta.t,type=2L)
}