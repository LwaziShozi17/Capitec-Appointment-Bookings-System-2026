ARG GIT_COMMIT=unknown

FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
ARG GIT_COMMIT
LABEL org.opencontainers.image.source="https://github.com/LwaziShozi17/Capitec-Appointment-Bookings-System-2026-2026" \
      org.opencontainers.image.revision="${GIT_COMMIT}"
# Run nginx as a non-root user
RUN sed -i 's/^user nginx;/# user nginx; # running as non-root/' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx && \
    touch /var/run/nginx.pid && chown nginx:nginx /var/run/nginx.pid
COPY --from=build --chown=nginx:nginx /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
USER nginx
EXPOSE 8081
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8081/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
