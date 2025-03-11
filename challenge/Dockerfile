FROM node:lts-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

FROM base AS prod

COPY package.json pnpm-lock.yaml /app/
RUN pnpm install

COPY . /app
RUN --mount=type=secret,id=DATABASE_URL \
  DATABASE_URL=$(cat /run/secrets/DATABASE_URL) \
  pnpm run build

FROM base AS final
COPY --from=prod /app/secret_data /app/secret_data
COPY --from=prod /app/node_modules /app/node_modules
COPY --from=prod /app/.svelte-kit /app/.svelte-kit
COPY --from=prod /app/src/lib/db/schema.ts /app/src/lib/db/schema.ts
COPY --from=prod \
  /app/entrypoint.sh \
  /app/package.json \
  /app/pnpm-lock.yaml \
  /app/drizzle.config.ts \
  /app/vite.config.ts \
  /app/
EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]
