FROM python:3.13-alpine3.22 AS builder
RUN apk update
RUN apk add gcc musl-dev libffi-dev
RUN pip install poetry
COPY . /app
WORKDIR /app
RUN poetry build --format=wheel


FROM python:3.13-alpine3.22

LABEL org.opencontainers.image.source=https://github.com/cbh123/holtztabs
LABEL org.opencontainers.image.description="HoltzTabs - an alternative frontend to ultimate-guitar.com"
LABEL org.opencontainers.image.licenses=GPL-3.0-only

ENV PYTHONUNBUFFERED=TRUE

COPY --from=builder /app/dist/*.whl .
RUN adduser -D holtztabs && \
    pip install *.whl && \
    rm *.whl

USER holtztabs
EXPOSE 22000

ENTRYPOINT ["/usr/local/bin/freetar"]
