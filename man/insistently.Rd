% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adverb-insistently.R
\name{insistently}
\alias{insistently}
\title{Transform a function to wait then retry after an error}
\usage{
insistently(f, rate = rate_backoff(), quiet = TRUE)
}
\arguments{
\item{f}{A function to modify, specified in one of the following ways:
\itemize{
\item A named function, e.g. \code{mean}.
\item An anonymous function, e.g. \verb{\\(x) x + 1} or \code{function(x) x + 1}.
\item A formula, e.g. \code{~ .x + 1}. Only recommended if you require backward
compatibility with olders version of R.
}}

\item{rate}{A \link[=rate-helpers]{rate} object. Defaults to jittered exponential
backoff.}

\item{quiet}{Hide errors (\code{TRUE}, the default), or display them
as they occur?}
}
\value{
A function that takes the same arguments as \code{.f}, but returns
a different value, as described above.
}
\description{
\code{insistently()} takes a function and modifies it to retry after given
amount of time whenever it errors.
}
\section{Adverbs}{
This function is called an adverb because it modifies the effect of a
function (a verb). If you'd like to include a function created an adverb
in a package, be sure to read \link{faq-adverbs-export}.
}

\examples{
# For the purpose of this example, we first create a custom rate
# object with a low waiting time between attempts:
rate <- rate_delay(0.1)

# insistently() makes a function repeatedly try to work
risky_runif <- function(lo = 0, hi = 1) {
  y <- runif(1, lo, hi)
  if(y < 0.9) {
    stop(y, " is too small")
  }
  y
}

# Let's now create an exponential backoff rate with a low waiting
# time between attempts:
rate <- rate_backoff(pause_base = 0.1, pause_min = 0.005, max_times = 4)

# Modify your function to run insistently.
insistent_risky_runif <- insistently(risky_runif, rate, quiet = FALSE)

set.seed(6) # Succeeding seed
insistent_risky_runif()

set.seed(3) # Failing seed
try(insistent_risky_runif())

# You can also use other types of rate settings, like a delay rate
# that waits for a fixed amount of time. Be aware that a delay rate
# has an infinite amount of attempts by default:
rate <- rate_delay(0.2, max_times = 3)
insistent_risky_runif <- insistently(risky_runif, rate = rate, quiet = FALSE)
try(insistent_risky_runif())

# insistently() and possibly() are a useful combination
rate <- rate_backoff(pause_base = 0.1, pause_min = 0.005)
possibly_insistent_risky_runif <- possibly(insistent_risky_runif, otherwise = -99)

set.seed(6)
possibly_insistent_risky_runif()

set.seed(3)
possibly_insistent_risky_runif()
}
\seealso{
\code{\link[httr:RETRY]{httr::RETRY()}} is a special case of \code{\link[=insistently]{insistently()}} for
HTTP verbs.

Other adverbs: 
\code{\link{auto_browse}()},
\code{\link{compose}()},
\code{\link{negate}()},
\code{\link{partial}()},
\code{\link{possibly}()},
\code{\link{quietly}()},
\code{\link{safely}()},
\code{\link{slowly}()}
}
\concept{adverbs}
