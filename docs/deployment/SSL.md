# SHAHEEN OS — SSL / HTTPS

## Production

Production HTTPS should use a certificate issued by a trusted
Certificate Authority.

Recommended options include:

- Cloudflare SSL/TLS
- Let's Encrypt
- Caddy
- Nginx + Certbot
- managed hosting TLS

Do not use the development self-signed certificate for production.

## Development

A self-signed certificate can be generated for local development.

Generated development files:

storage/ssl/

Expected files:

- localhost.crt
- localhost.key

## Security

Private keys must never be committed to Git.

Add the following to `.gitignore`:

storage/ssl/*.key
storage/ssl/*.crt
