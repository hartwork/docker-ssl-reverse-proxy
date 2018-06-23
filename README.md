# About docker-ssl-reverse-proxy

My situation was this:
I had multiple Docker containers serving websites on port 80.
I wanted a single reverse proxy with SSL powered by
[Let's Encrypt](https://letsencrypt.org/)
in front of them, that keeps the certificates fresh and supports
multiple domain names per website (e.g. with `www.` subdomain and without).
Plain HTTP should be redirected to HTTPS on the master domain for each website,
alias domains should redirect to the master domain for both HTTP and HTTPS.
And that reverse proxy should also run in a Docker container.

This repository has all of that.  The heavy lifting is done by
[Caddy](https://caddyserver.com/)
and there's a [small tool](Caddyfile.generate) to generate Caddy configuration
from a minimal ini-like `sites.cfg` file ([see example](sites.cfg.EXAMPLE.gentoo-ev)).


# How to run

  1. Create a simple `sites.cfg` file manually
     as seen in the [example](sites.cfg.EXAMPLE.gentoo-ev).

  2. Run [`./Caddyfile.generate`](Caddyfile.generate)
     to generate `Caddyfile` from `sites.cfg` for you.

  3. Create Docker network `ssl-reverse-proxy` for the reverse proxy
     and its backend to talk:<br>
     `docker network create --internal ssl-reverse-proxy`

  4. Spin up the container:<br>
     `compose up -d --build`

  5. Have backend containers join network `ssl-reverse-proxy`,
     e.g. as done in the proxy's own
     [`docker-compose.yml` file](docker-compose.yml).

  6. Enjoy.


# A few more words on `sites.cfg`

The format is rather simple and has three options only.
Let's look at this example:

    [gentoo.de]
    backend = gentoo-de:80
    aliases =
        www.gentoo.de
            gentoo.eu
        www.gentoo.eu
            portage.de
        www.portage.de

Section name `gentoo.de` sets the master domain name that all alias domains
redirect to.  `backend` points to the hostname and port that serves actual
content.  Here, `gentoo-de` is the name of the Docker container that
Docker DNS will let us access because we made both containers join external
network `ssl-reverse-proxy` in their `docker-compose.yml` files.
`aliases` is an optional list of domian names to have both HTTP and HTTPS
redirect to master domain `gentoo.de`.

That's it.


# Support and Contributing

If you run into issues or have questions, please
[open an issue ticket](https://github.com/hartwork/docker-ssl-reverse-proxy/issues)
for that.

Please know that `sites.cfg` and [`Caddyfile.generate`](Caddyfile.generate)
are not meant to cover much more than they already do.  If it grows as powerful
as `Caddyfile` we have failed.
