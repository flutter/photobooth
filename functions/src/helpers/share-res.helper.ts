import * as admin from "firebase-admin";
import * as path from "path";
import * as querystring from "querystring";
import {storageFolderName, sharePath, htmlContent} from "../config";

function notFoundHtml(): { status: 404; send: string } {
  return {status: 404, send: "Not Found"};
}

function bucketPathForFile(filename: string): String {
  return `https://firebasestorage.googleapis.com/v0/b/${
    admin.storage().bucket().name
  }/o/${querystring.escape(filename)}?alt=media`;
}

function foundHtml(filePath: string): { status: 200; send: string } {
  /*eslint-disable */
  return {
    status: 200,
    send: `<!doctype html>
    <html>
      <head>
          <title>${htmlContent.title}</title>
          <meta name="description" content="${htmlContent.description}">
          <meta property="og:description" content="${htmlContent.description}">
          <meta property="og:title" content="${htmlContent.title}">
          <meta property="og:url" content="${htmlContent.ogUrl}">
          <meta property="og:image" content="${bucketPathForFile(filePath)}">
          <meta name="twitter:text:title" content="${htmlContent.title}">
          <meta name="twitter:card" content="summary_large_image">
          <meta name="twitter:site" content="${htmlContent.ogTwitterSite}">
          <meta name="twitter:title" content="${htmlContent.title}">
          <meta name="twitter:description" content="${htmlContent.description}">
          <meta name="twitter:image" content="${bucketPathForFile(filePath)}">
          <link rel="icon" type="image/png" href="${bucketPathForFile(
            htmlContent.faviconPath
          )}">
          <style>
            html {
              font-family: 'Google Sans', 'Roboto', sans-serif;
              background: url('${bucketPathForFile(
                htmlContent.imgPathBackground
              )}') no-repeat center center fixed;
              -webkit-background-size: cover;
              -moz-background-size: cover;
              -o-background-size: cover;
              background-size: cover;
            }
            .logo {
              width:90%;
              margin: 3rem auto;
              display:block;
              max-width: 800px;
            }
            .share-content {
              background:#ffffff;
              width: 95%;
              max-width: 800px;
              border-radius: 6px;
              padding: 2rem 1rem 3rem;
              margin: 0 auto;
              text-align: center;
            }
            .share-image {
              width: 80%;
              margin: 0 1rem;
            }
            .share-header {
              margin: 4rem auto 0;
              font-size:1.5rem;
            }
            .share-btn {
              box-sizing: border-box;
              text-decoration: none;
              display: inline-block;
              text-align: center;
              vertical-align: middle;
              user-select: none;
              border: 1px solid transparent;
              line-height: 1.5;
              border-radius: 0;
              transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
              color: #fff;
              background-color: #1389FD;
              border-color: #1389FD;
              white-space: normal;
              margin-top: 3rem;
              font-size: 2rem;
              font-weight: 400;
              padding: 1rem 1.5rem;
              min-width: 250px;
              cursor: pointer;
            }
          </style>
      </head>
      <body>
          <img class="logo" src="${bucketPathForFile(
            htmlContent.imgPathLogo
          )}"/>
          <div class="share-content">
            <img class="share-image" src="${bucketPathForFile(filePath)}"/>
            <div class="share-header"> ${htmlContent.ctaHeaderText} </div>
            <a  class="share-btn" href="${htmlContent.ogUrl}"> ${
      htmlContent.ctaBtnText
    } </a>
          </div>
        </body>
    </html>`,
  };
  /* eslint-enable */
}

export async function shareRes(
    reqPath: string
): Promise<{ status: number; send: string }> {
  const parsedPath = path.parse(reqPath);
  const storagePath = `${storageFolderName}/${parsedPath.base}`;

  if (
    parsedPath.dir !== `/${sharePath}` ||
    ![".png", ".jpeg", ".jpg"].includes(parsedPath.ext)
  ) {
    console.log(`Invalid path: ${reqPath}`);
    return notFoundHtml();
  }

  if (!(await admin.storage().bucket().file(storagePath).exists())[0]) {
    console.log(`File not found at : ${storagePath}`);
    return notFoundHtml();
  }
  return foundHtml(storagePath);
}
