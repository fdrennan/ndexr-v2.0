# https://github.com/rstudio/websocket

library(curl)
library(httpuv)
library(websocket)

# URL of the remote websocket server
target_host <- "echo.websocket.org:80"
# Should be "ws" or "wss"
target_protocol <- "ws"

# Port this computer will listen on
listen_port <- 5002

# ==============================================================================
# Functions for translating header strings between HTTP request and Rook formats
# ==============================================================================
req_rook_to_curl <- function(req, host) {
  # Rename headers. Example: HTTP_CACHE_CONTROL => Cache-Control
  r <- as.list(req)

  # Uncomment to print out request headers
  # cat("== Original ==\n")
  # cat(capture.output(print(str(r))), sep = "\n")

  r <- r[grepl("^HTTP_", names(r))]
  nms <- names(r)
  nms <- sub("^HTTP_", "", nms)
  nms <- tolower(nms)
  nms <- gsub("_", "-", nms, fixed = TRUE)
  nms <- gsub("\\b([a-z])", "\\U\\1", nms, perl = TRUE)
  names(r) <- nms
  # Overwrite host field
  r$Host <- host

  # Uncomment to print out modified request headers
  # cat("== Modified ==\n")
  # cat(capture.output(print(str(r))), sep = "\n")
  r
}

resp_httr_to_rook <- function(resp) {
  status <- as.integer(sub("^HTTP\\S+ (\\d+).*", "\\1", curl::parse_headers(resp$headers)[1]))
  list(
    status = status,
    headers = parse_headers_list(resp$headers),
    body = resp$content
  )
}


# ==============================================================================
# Websocket proxy frontend
# ==============================================================================

# These functions are called from the server frontend; defined here so that they
# can be modified while the application is running.
onHeaders <- function(req) {
  # Print out the headers received from server
  # str(as.list(req$HEADERS))
  NULL
}

call <- function(req) {
  req_curl <- req_rook_to_curl(req, target_host)
  h <- new_handle()
  do.call(handle_setheaders, c(h, req_curl))
  resp_curl <- curl_fetch_memory(paste0("http://", target_host, req$PATH_INFO), handle = h)
  resp_httr_to_rook(resp_curl)
}

onWSOpen <- function(clientWS) {
  # The httpuv package contains a WebSocket server class and the websocket
  # package contains a WebSocket client class. It may be a bit confusing, but
  # both of these classes are named "WebSocket", and they have slightly
  # different interfaces.
  serverWS <- websocket::WebSocket$new(paste0(target_protocol, "://", target_host))

  msg_from_client_buffer <- list()
  # Flush the queued messages from the client
  flush_msg_from_client_buffer <- function() {
    for (msg in msg_from_client_buffer) {
      serverWS$send(msg)
    }
    msg_from_client_buffer <<- list()
  }
  clientWS$onMessage(function(isBinary, msgFromClient) {
    cat("Got message from client: ", msgFromClient, "\n")

    # NOTE: This is where we modify the messages going from the client to the
    # server. This simply converts to upper case. You can modify to suit your
    # needs.
    msgFromClient <- toupper(msgFromClient)
    cat("Converting toupper() and then sending to server: ", msgFromClient, "\n")

    if (serverWS$readyState() == 0) {
      msg_from_client_buffer[length(msg_from_client_buffer) + 1] <<- msgFromClient
    } else {
      serverWS$send(msgFromClient)
    }
  })
  serverWS$onOpen(function(event) {
    serverWS$onMessage(function(msgFromServer) {
      cat("Got message from server: ", msgFromServer$data, "\n")

      # NOTE: This is where we could modify the messages going from the server
      # to the client. You can modify to suit your needs.
      msg <- paste0(msgFromServer$data, ", world")
      cat('Appending ", world" and then sending to client: ', msg, "\n")

      clientWS$send(msg)
    })
    flush_msg_from_client_buffer()
  })
}

# Start the websocket proxy frontend
s <- startServer(
  "0.0.0.0", listen_port,
  list(
    onHeaders = function(req) {
      onHeaders(req)
    },
    call = function(req) {
      call(req)
    },
    onWSOpen = function(clientWS) {
      onWSOpen(clientWS)
    }
  )
)

# Run this to stop the server:
# s$stop()

# If you want to run this code with `Rscript -e "source('server.R')"`, also
# uncomment the following so that it doesn't immediately exit.
httpuv::service(Inf)


# In another session
# ws <- websocket::WebSocket$new("ws://localhost:5002")
# ws$send('ok freddy')
