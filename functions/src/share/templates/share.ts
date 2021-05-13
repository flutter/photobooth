export default `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/png" href="{{{assetUrls.favicon}}}">
    <meta name="viewport" content="width=device-width,initial-scale=1" />

    <title>{{meta.title}}</title>
    <meta name="descripton" content="{{meta.desc}}">

    {{{ga}}}

    <meta property="og:title" content="{{meta.title}}">
    <meta property="og:description" content="{{meta.desc}}">
    <meta property="og:url" content="{{{shareUrl}}}">
    <meta property="og:image" content="{{{shareImageUrl}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{shareImageUrl}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    
    <style>{{{styles}}}</style>
  </head>
  <body>
    <div class="backdrop"></div>
    <img src="{{{assetUrls.fixedPhotosLeft}}}" class="fixed-photos left">
    <img src="{{{assetUrls.fixedPhotosRight}}}" class="fixed-photos right">
    <main>
      <div class="share-image">
        <img src="{{{shareImageUrl}}}">
      </div>
      <div class="text">
        <h1>Taken with I/O Photo Booth</h1>
        <h2>Join the fun! Grab a photo with your favorite Google mascot 
          at the I/O Photo Booth.</h2>
        <a class="share-btn" href="/">Get started</a>
      </div>
    </main>
    {{{footer}}}
  </body>
</html>
`;
