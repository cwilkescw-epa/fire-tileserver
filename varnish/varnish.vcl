vcl 4.0;

sub vcl_recv {
    # Set the grace period for serving stale content if the backend is down
    set req.grace = 15m;

    # Normalize the Host header (remove port if it exists)
    set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");

    # Allow caching based on Cache-Control header
    if (req.http.Cache-Control ~ "no-cache") {
        return (pass);
    }

    return (hash);
}

sub vcl_backend_response {
    # Allow caching based on Cache-Control header
    if (beresp.http.Cache-Control ~ "private" || beresp.http.Cache-Control ~ "no-store") {
        set beresp.ttl = 0s;
    } else {
        set beresp.ttl = 15m;
    }
}