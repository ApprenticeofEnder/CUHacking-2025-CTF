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

EXPOSE 3000

ENTRYPOINT [ "./entrypoint.sh" ]
