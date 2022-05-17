# A ruby proxy-server for a single function from Alphavantage API

## Description

The project is an answer to a test task for a Ruby Developer position.

The task:

> Here is an API https://www.alphavantage.co/documentation/#currency-exchange. Using the provided API, create a proxy service that accepts two currencies as parameters and returns the exchange rate of the currencies.

    Clarifications:

    - when hit API limits cached value can be returned (the service won't be used for financial operations)
    - currency white list can be part of the service

## Instalation

1. Provide API key

```sh
    # claim API key on [https://www.alphavantage.co/support/#api-key](https://www.alphavantage.co/support/#api-key)
    # make `.env` file with API key

    cp .env-example .env

    # replace `demo_key` in by the provided key
    nano .env
```

2. Install gems

```sh
    bundle install
```

## Run

```sh
    bundle exec rackup config.ru
    # or    
    make start
```

## Testing

```sh
    bundle exec rspec spec/*
    # or 
    make test
```

## Notes

- Caching service is out of the scope of the test task, so I've used stubs in `Cache` class
