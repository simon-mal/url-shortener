# URL_REDIRECTOR

URL_REDIRECTOR is a small program to generate a short-url from a regular url. 

# Components

This repository consists of a client and a server. 
The client is a small Flutter Web App where a URL can be entered and a short-url will be displayed after creation. It is also possible to request a particular short-url.
The server is a simple dart-program which handles HTTP requests for creation of a new short-url. When a short-url is requested, the server will try to resolve the original url and redirect to it if possible.

# Requirements 
1. To run the client, flutter has to be installed

Install on macOS using Homebrew

```bash
brew install flutter
```

Note that this will install dart by default, so you can skip the next step.

1. To run the server, dart has to be installed. 

Install on macOS using Homebrew

```bash
brew install dart
```

# Executtion

Start the server to allow any incoming requests. The server will run at [localhost:8000](localhost:8000) by default configuration. 

```bash
dart run server/bin/main.dart
```
It is not required to use the client. To start the client, run:

```bash
cd client && 
flutter run lib/main.dart -d chrome --webport 5000
```

# Usage with client

The clients UI consists of two Input-Fields. Enter the URL to shorten in the upper Input-Field. If you wish for a particular short-URL enter it in the Input-Field below.
Once setup, press the action button ('LOS') to make a request.
The response will be shown below the action button. If it was successful, a short-URL will be displayed. Otherwise, an error-message will be displayed. 

Copy the generated short-url and paste it in a browser. You will be redirected to the original URL.


# API

The server offers two api-methods (POST)
1. /api/create/random 
- expects a body in the form of
```dart
{
    'target': ORIGIN_URL,
}
```
where ORIGIN_URL represents the URL to shorten. 
On success, the generated short-url will be returned in the HTTP-Response body.
1. /api/create/particular
- expects a body in the form of
```dart
{
    'target': ORIGIN_URL,
    'particular': REQUESTED_SHORT_URL
}
```
where ORIGIN_URL represents the URL to shorten nad REQUESTED_SHORT_URL represents the user-requested short-url.
On success, the requested short-url will be returned in the HTTP-Response body.

On any incoming GET request which has only one pathSegment (i.e. the char '/' does not occur) the server will try to resolve it by looking up a corresponding url in its database.
If a corresponding url is found, the server attempts to redirect the request to it. 

# Server
The server is connected to a particular DB (name: "url-shortener") of a MongoDB Atlas instance. 
This DB has only one collection (name: "urls"). In this collection, every entry consists of: 
1. ShortUrl: representing the short-link.
1. LongURL: representing the original URL to redirect to.
1. ParticularShort: representing wetcher the shortURL was a requested short link (true) or a generated one (false)

## Create random workflow
1. Validate request
1. Check if a shortURL exists for the desired ORIGIN_URL
1. If a shortURL exists, check if its shortURL was generated or specifically requested by a user
1. If it was not specifically requested by a user, return found entry since there is no need to have duplicates
1. If it was specifically requested by a user, create a new entry with a generated ID and return it on success.

## Create particular workflow
1. Validate request
1. Check if a shortURL with the same value as REQUESTED_SHORT_URL already exists.
1. If a shortURL exists, cancel operation.
1. if no shortURL exists, create a new entry with the REQUESTED_SHORT_URL and return it on success.
