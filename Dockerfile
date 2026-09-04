ARG GIT_COMMIT=unknown
ARG APP_VERSION=local

FROM eclipse-temurin:17-jre-jammy
ARG GIT_COMMIT
ARG APP_VERSION
LABEL org.opencontainers.image.source="https://github.com/LwaziShozi17/Capitec-Appointment-Bookings-System-2026-2026" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.version="${APP_VERSION}"
WORKDIR /app
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
COPY build/libs/*.jar app.jar
RUN chown appuser:appgroup app.jar
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
