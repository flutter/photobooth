export default `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/png" href="{{{assetUrls.favicon}}}">
    <meta name="viewport" content="width=device-width,initial-scale=1" />

    <title>{{meta.title}}</title>
    <meta name="descripton" content="{{meta.desc}}">

    <meta property="og:title" content="{{meta.message}}">
    <meta property="og:description" content="{{meta.desc}}">
    <meta property="og:url" content="{{{shareUrl}}}">
    <meta property="og:image" content="{{{shareImageUrl}}}">

    <meta name="twitter:title" content="{{meta.title}}">
    <meta name="twitter:text:title" content="{{meta.message}}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@flutterdev">
    <meta name="twitter:description" content="{{metaDesc}}">
    <meta name="twitter:image" content="{{{shareImageUrl}}}">

    <link href="https://fonts.googleapis.com/css?family=Google+Sans:400,500" rel="stylesheet">
    
    <style>

      html, body {
        margin: 0;
        padding: 0;
      }

      body {
        font-family: "Google Sans", sans-serif;
        font-size: 12px;
        background-image: url("{{{assetUrls.bgMobile}}}");
        background-repeat: no-repeat;
        background-position: center;
        background-size: cover;
        display: flex;
        flex-direction: column;
      }

      *, ::before, ::after {
        box-sizing: border-box;
      }

      .fixed-photos {
        display: none;
      }

      main {
        width: 95%;
        max-width: 1000px;
        margin: 0 auto 45px;
        text-align: center;
        flex: 1 0 auto;
        z-index: 10;
        position: relative;
      }

      .share-image {
        margin: 2rem auto;
        width: 90%;
        transform: rotate(-5deg);
      }

      .share-image img {
        width: 100%;
      }

      .text {}

      h1, h2 {
        color: white;
        margin-block-start: 0;
        margin-block-end: 0;
      }

      h1 {
        line-height: 1.2;
        font-size: 32px;
        font-weight: 700;
        width: 67%;
        margin: 0 auto 25px;
      }

      h2 {
        line-height: 1.3;
        font-size: 18px;
        font-weight: 100;
        width: 75%;
        margin: 0 auto 35px;
      }

      .share-btn {
        display: inline-block;
        font-weight: 400;
        line-height: 1.5;
        text-align: center;
        text-decoration: none;
        line-height: 1;
        padding: 16px 0;
        background-color: #428eff;
        color: white;
        font-size: 18px;
        border-radius: 50px;
        width: 208px;
      }

      footer {
        width: 100%;
        color: white;
        font-size: 14px;
        font-weight: 100;
        flex-direction: column;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 5% 2rem;
        text-align: center;
        position: relative;
        flex-shrink: 0;
        z-index: 10;
        position: relative;
      }

      footer a {
        color: white;
        text-decoration: none;
        white-space: nowrap;
      }

      footer a:hover {
        text-decoration: underline;
      }

      footer ul {
        margin: 0;
        padding: 0;
        line-height: 2;
      }

      footer .left {
        font-size: 16px;
        font-weight: 400;
        margin-bottom: 17px;
      }

      footer .left a {
        text-decoration: underline;
      }

      footer li {
        display: inline;
        margin-right: 1rem;
      }

      @media (min-width:768px) {
        body {
          background-image: url("{{{assetUrls.bg}}}");
        }

        .fixed-photos {
          position: fixed;
          top: 0;
          background-repeat: no-repeat;
          background-size: contain;
          z-index: -1;
          display: block;
          width: 800px;
        }

        .fixed-photos.left  {
          left: -22%;
        }
  
        .fixed-photos.right  {
          right: -22%;
        }

        .share-image {
          margin: 4.25rem auto 3rem;
          width: 710px;
          position: relative;
          left: -22px;
        }

        h1, h2 {
          width: 100%;
        }

        h1 {
          font-size: 56px;
        }
  
        h2 {
          font-size: 24px;
        }

        .share-btn {
          font-size: 22px;
        }

        footer {
          flex-direction: row;
          text-align: left;
          padding: 0 2% 2rem;
        }

        footer .left {
          font-size: 18px;
          margin-bottom: 0;
        }
      }
      
    </style>
  </head>
  <body>
    <img src="{{{assetUrls.fixedPhotosLeft}}}" class="fixed-photos left">
    <img src="{{{assetUrls.fixedPhotosRight}}}" class="fixed-photos right">
    <main>
      <div class="share-image">
        <img src="{{{shareImageUrl}}}">
      </div>
      <div class="text">
        <h1>Photo taken with Flutter</h1>
        <h2>Join the fun! Grab a photo with your favorite Google mascot 
          at the I/O Photo Booth.</h2>
        <a class="share-btn" href="{{{appUrl}}}">Get started</a>
      </div>
    </main>
    <footer>
      <div class="left">
        <span>Made with
          <a href="https://flutter.dev">Futter</a> &amp;
          <a href="https://firebase.google.com">Firebase</a>
        </ul>
      </div>
      <div class="right">
        <ul>
          <li><a href="">Google I/O</a></li>
          <li><a href="https://flutter.dev/docs/codelabs">Codelab</a></li>
          <li><a href="">How It's Made</a></li>
          <li><a href="https://policies.google.com/terms">Terms of Service</a></li>
          <li><a href="https://policies.google.com/privacy">Privacy Policy</a></li>
        </ul>
      </div>
    </footer>
  </body>
</html>
`;
