# company-documentation

The 404 Engineering website: a static portfolio site for the 404 Engineering projects, Following Drone
(with 3D Space Mapping, NRF Module and Drone Controller) and Line Simulator. Plain HTML and CSS, no build step.

| Path | What |
|---|---|
| `site/` | The website: `index.html`, `404.html`, `assets/` |
| `deploy/nginx.conf` | nginx server block (domain filled in by `setup.sh`) |
| `deploy/setup.sh` | One-time droplet setup: nginx, ufw, Let's Encrypt HTTPS |
| `deploy/deploy.sh` | rsync `site/` to the droplet |

## Preview locally

```bash
python3 -m http.server 8000 -d site
```

Then open http://localhost:8000.

## Hosting on a DigitalOcean droplet

Assumes an Ubuntu droplet, a non-root sudo user with SSH access, and a domain.

1. **DNS:** add `A` records for `@` and `www` pointing at the droplet's IP. Wait until
   `dig +short yourdomain.com` returns that IP.
2. **Copy the deploy files and run setup** (once):
   ```bash
   scp -r deploy user@DROPLET_IP:~/
   ssh user@DROPLET_IP 'sudo bash ~/deploy/setup.sh yourdomain.com you@example.com'
   ```
3. **Deploy the site** (every time it changes):
   ```bash
   ./deploy/deploy.sh user@DROPLET_IP
   ```

Certbot sets up automatic certificate renewal; check it with `sudo certbot renew --dry-run`.
