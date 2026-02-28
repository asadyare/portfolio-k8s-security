# Serve static files with nginx (no Node.js = no Node vulnerabilities)
# Uses unprivileged nginx for runAsNonRoot (Pod Security)
# Expects dist/ to be pre-built by CI (npm run build)
FROM nginxinc/nginx-unprivileged:alpine

# Upgrade packages for security (must run as root)
USER root
RUN apk upgrade --no-cache
COPY dist /usr/share/nginx/html
RUN chown -R 101:101 /usr/share/nginx/html
USER 101

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]