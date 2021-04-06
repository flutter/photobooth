import * as path from 'path';
import * as querystring from 'querystring';

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { STORAGE_BUCKET, SHARE_PATH } from '../config';


const htmlMeta = {
  title: 'Google IO Photobooth',
  description: 'Take a photo with special IO effects and share it with your community.',
  ogUrl: 'https://io-photobooth.web.app',
  ogTwitterSite: '@flutterdev',
  imgPathBackground: 'public/background.jpg',
  imgPathLogo: 'public/logo.svg',
  ctaHeaderText: 'Take a selfie and share your photo with the community.',
  ctaBtnText: 'Take Your Own',
  faviconPath: 'public/favicon.png',
};

/**
 * Returns bucket path
 * @param {string} filename
 * @return {string}
 */
function bucketPathForFile(filename: string): string {
  return (
    `https://firebasestorage.googleapis.com/v0/b/${STORAGE_BUCKET }` +
    `/o/${querystring.escape(filename)}?alt=media`
  );
}

/**
 * Return not found response
 * @return {Object} Corrent not found response?
 */
function getNotFoundHTML(): string {
  return (`
    <!doctype html>
    <html>
      <head>
        <title>${htmlMeta.title}</title>
        <meta name='viewport' content='width=device-width,initial-scale=1' />
        <style>
          html {
            font-family: 'Google Sans', 'Roboto', sans-serif;
            background-repeat: no-repeat;
            background-image: url('${bucketPathForFile(htmlMeta.imgPathBackground)}');
            background-position: center center;
            background-attachement: fixed;
            background-size: cover;
          }
          .logo {
            width: 90%;
            margin: 3rem auto;
            display:block;
            max-width: 800px;
          }
          .share-content {
            background: #fff;
            width: 95%;
            max-width: 800px;
            border-radius: 6px;
            padding: 2rem 1rem 3rem;
            margin: 0 auto;
            text-align: center;
          }
        </style>
      </head>
      <body>
        <img class='logo' src='${bucketPathForFile(htmlMeta.imgPathLogo)}'/>
        <div class='share-content'>
          <h2>Some clever not found message :)</h2>
        </div>
      </body>
    </html>
  `);
}

/**
 * Populate and return the share page HTML for given path
 * @param {string} filePath
 * @return {string} HTML string
 */
function generateShareHTML(filePath: string): string {
  /*eslint-disable */
  return (`
    <!doctype html>
    <html>
      <head>
        <title>${htmlMeta.title}</title>
        <meta name='viewport' content='width=device-width,initial-scale=1' />
        <meta name='descripton' content='${htmlMeta.description}'>
        <meta property='og:description' content='${htmlMeta.description}'>
        <meta property='og:title' content='${htmlMeta.title}'>
        <meta property='og:url' content='${htmlMeta.ogUrl}'>
        <meta property='og:image' content='${bucketPathForFile(filePath)}'>
        <meta name='twitter:text:title' content='${htmlMeta.title}'>
        <meta name='twitter:card' content='summary_large_image'>
        <meta name='twitter:site' content='${htmlMeta.ogTwitterSite}'>
        <meta name='twitter:title' content='${htmlMeta.title}'>
        <meta name='twitter:description' content='${htmlMeta.description}'>
        <meta name='twitter:image' content='${bucketPathForFile(filePath)}'>
        <link rel='icon' type='image/png' href='${bucketPathForFile(htmlMeta.faviconPath)}'>
        <style>
          html {
            font-family: 'Google Sans', 'Roboto', sans-serif;
            background-repeat: no-repeat;
            background-image: url('${bucketPathForFile(htmlMeta.imgPathBackground)}');
            background-position: center center;
            background-attachement: fixed;
            background-size: cover;
          }
          .logo {
            width: 90%;
            margin: 3rem auto;
            display:block;
            max-width: 800px;
          }
          .share-content {
            background: #fff;
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
            background-color: #1389FD;
            border-color: #1389FD;
            border-radius: 0;
            border: 1px solid transparent;
            box-sizing: border-box;
            color: #fff;
            cursor: pointer;
            display: inline-block;
            font-size: 2rem;
            font-weight: 400;
            line-height: 1.5;
            margin-top: 3rem;
            min-width: 250px;
            padding: 1rem 1.5rem;
            text-align: center;
            text-decoration: none;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            user-select: none;
            vertical-align: middle;
            white-space: normal;
          }
        </style>
      </head>
      <body>
        <img class='logo' src='${bucketPathForFile(htmlMeta.imgPathLogo)}'/>
        <div class='share-content'>
          <img class='share-image' src='${bucketPathForFile(filePath)}'/>
          <div class='share-header'> ${htmlMeta.ctaHeaderText} </div>
          <a  class='share-btn' href='${htmlMeta.ogUrl}'> ${htmlMeta.ctaBtnText} </a>
        </div>
      </body>
    </html>
  `);
  /* eslint-enable */
}

/**
 * Get share response
 * @param {string} reqPath
 * @return {Object} share response
 */
export async function getShareResponse(
  reqPath: string
): Promise<{ status: number; send: string }> {
  try {
    const { dir, ext, base } = path.parse(reqPath);
    const isValidPath = (
      dir !== `/${SHARE_PATH}` || ![ '.png', '.jpeg', '.jpg' ].includes(ext)
    );

    const storagePath = `${STORAGE_BUCKET}/${base}`;
    let exists: [boolean] | undefined;

    if (isValidPath) {
      exists = await admin.storage().bucket().file(storagePath).exists();

      console.log({ exists });

      if (exists && exists[0]) {
        return {
          status: 200,
          send: generateShareHTML(storagePath),
        };
      }
    }

    functions.logger.info('File path invalid or not found', {
      storagePath, exists, valid: isValidPath,
    });

    return {
      status: 404,
      send: getNotFoundHTML(),
    };
  } catch (error) {
    functions.logger.error(error);
    return {
      status: 500,
      send: 'Something went wrong',
    };
  }
}

/**
 * Public sharing function
 */
export const shareImage = functions.https.onRequest(async (req, res) => {
  const { status, send } = await getShareResponse(req.path);

  // development only, set to actual production hosting domain
  res.set('Access-Control-Allow-Origin', '*');

  res.status(status).send(send);
});
