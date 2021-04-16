# Firebase Functions

This folder contains firebase functions to support the Photobooth project.

## 'share' function

This function validates the requested path is valid for sharing (that it is /share/filename.ext) and that the extension is an expected image file type. It will validate the file exists in storage, and if so return HTML will valid <head> to support open graph and twitter sharing.

## Serving the functions locally

From the root folder of the project, run `firebase serve`. The console will output localhost paths that you can access in your browser.

For instance, to test the "share" function, try `http://localhost:5001/io-photobooth-dev/us-central1/shareImage/share/upload.jpg`

## Running tests

In this folder run `npm test`

## Lint and format files

- `npm run lint`
- `npm run lint:fix`