export default `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/png" href="{{favicon_url}}">
    <meta name="viewport" content="width=device-width,initial-scale=1" />

    <title>{{metaTitle}}</title>

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
    
    <style>

      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
      }

      body {
        font-family: "Google Sans", "Roboto", sans-serif;
        background-image: url("{{{bgImageUrl}}}");
        background-repeat: no-repeat;
        background-position: center;
        background-size: cover;
      }

      *, ::before, ::after {
        box-sizing: border-box;
      }

      main {
        width: 95%;
        max-width: 800px;
        padding: 0;
        margin: 0 auto;
        text-align: center;
      }

      h2 {
        font-size: 24px;
        font-weight: 400;
        color: white;
      }

      .share-image {
        width: 80%;
        margin: 0 1rem;
      }

      .share-btn {
        background-color: #428eff;
        color: white;
        font-size: 22px;
      }
      
    </style>
  </head>
  <body>
    <main>
      <h1>Flutter taken with Flutter</h1>
      <h2>Join the fun! Grab a photo with your favorite Google mascot 
        at the I/O Photo Booth.</h2>
      <a class="share-btn" href="{{appUrl}}">Take your own</a>
    </main>
  </body>
</html>
`;
