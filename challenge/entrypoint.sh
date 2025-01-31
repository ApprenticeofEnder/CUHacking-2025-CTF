#!/bin/sh
pnpm migrate && \
    pnpm seed && \
    pnpm preview 