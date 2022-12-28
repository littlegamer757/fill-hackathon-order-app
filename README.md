# Santa Filli Order App

A mobile app to order your very own Filli and get it delivered to your doorstep.

## Overview

This project consists of two parts:

- Flutter app to place your order and track its status
- Dart server for communication between the app and delivery robot

## Testing the app

### Prerequesites

- Flutter SDK
- Android Studio configured for Flutter
- Device/Emulator to test on

### Installing the app

- Clone the repo
- Open the `frontend` project in Android Studio
- Deploy to the desired device
- Ignore the warnings/errors
    - it's a hackathon project what do you expect

### Communication with the backend

- The .env files (front-/backend) must be configured properly (look at the examples)
- Start the backend
    - Open the backend project in your favorite dart IDE
    - Click start
- After clicking order, the app connects to the backend
- The backend can then send mock-status-updates to the app to simulate order progress (see the following section)

## Messaging Protocol

The server and app communicate in a predefined manner that has to be taken into account when faking the order process.

- App sends `[cmd] start` to backend to initialize communication. This happens upon clicking "order".
- (Server starts order process with driverless transport system)
- Server sends status updates to the app. These messages must be sent by hand in a mock-environment. The server provides assistance.
    1. `[status] confirmed`: Server received order, process started
    2. `[status] arrived`: Product has reached destination, process finished
