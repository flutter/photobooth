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
    <meta property="og:image" content="{{{assetUrls.notFoundPhoto}}}">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.title}}">
    <meta name="twitter:description" content="{{meta.desc}}">
    <meta name="twitter:image" content="{{{assetUrls.notFoundPhoto}}}">
    <meta name="twitter:site" content="@flutterdev">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    
    <style>{{{styles}}}</style>
  </head>
  <body>
    <div class="backdrop"></div>
    <img src="{{{assetUrls.fixedPhotosLeft}}}" class="fixed-photos left">
    <img src="{{{assetUrls.fixedPhotosRight}}}" class="fixed-photos right">
    <main>
      <div class="share-image no-shadow">
        <img src="{{{assetUrls.notFoundPhoto}}}">
      </div>
      <div class="text">
        <h1>Taken with I/O Photo Booth</h1>
        <h2>Oops! This photo is gone, but that doesn't mean the fun has to end.</h2>
        <a class="share-btn" href="/">Take your own</a>
      </div>
    </main>
    {{{footer}}}
  </body>
</html>
`;
