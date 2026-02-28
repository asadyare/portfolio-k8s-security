# Serve static files with nginx (no Node.js = no Node vulnerabilities)
# Expects dist/ to be pre-built by CI (npm run build)
FROM nginx:alpine

# Upgrade libpng to fix CVE-2026-25646
RUN apk upgrade --no-cache

COPY dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]