# Serve static files with nginx (no Node.js = no Node vulnerabilities)
# Uses unprivileged nginx for runAsNonRoot (Pod Security)
# Expects dist/ to be pre-built by CI (npm run build)
FROM nginxinc/nginx-unprivileged:alpine

# Upgrade packages for security
RUN apk upgrade --no-cache

COPY dist /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]