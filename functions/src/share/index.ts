import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as path from 'path';
import * as querystring from 'querystring';
import mustache from 'mustache';

import { UPLOAD_PATH, ALLOWED_HOSTS } from '../config';
import footerTmpl from './templates/footer';
import notFoundTmpl from './templates/notfound';
import shareTmpl from './templates/share';
import stylesTmpl from './templates/styles';
import gaTmpl from './templates/ga';


const VALID_IMAGE_EXT = [ '.png', '.jpeg', '.jpg' ];

const BaseHTMLContext: Record<string, string | Record<string, string>> = {
  appUrl: '',
  shareUrl: '',
  shareImageUrl: '',
  assetUrls: {
    favicon: bucketPathForFile('public/favicon.png'),
    bg: bucketPathForFile('public/background.jpg'),
    bgMobile: bucketPathForFile('public/background-mobile.jpg'),
    notFoundPhoto: bucketPathForFile('public/404-photo.png'),
    fixedPhotosLeft: bucketPathForFile('public/table-photos-left.png'),
    fixedPhotosRight: bucketPathForFile('public/table-photos-right.png'),
  },
  meta: {
    title: 'Google I/O Photo Booth',
    desc: (
      'Take a photo in the I/O Photo Booth with your favorite Google Developer Mascots! ' +
      'Built with Flutter & Firebase for Google I/O 2021.'
    ),
  },
  footer: footerTmpl,
  ga: gaTmpl,
  styles: '',
};


/**
 * Returns bucket path
 * @param {string} filename
 * @return {string}
 */
function bucketPathForFile(filename: string): string {
  return (
    'https://firebasestorage.googleapis.com/v0' +
    `/b/${admin.storage().bucket().name}` +
    `/o/${querystring.escape(filename)}?alt=media`
  );
}

/**
 * Return a local file HTML template built with context
 * @param {string} tmpl - html template string
 * @param {Object} context - html context dict
 * @return {string} HTML template string
 */
function renderTemplate(
  tmpl: string, context: Record<string, string | Record<string, string>>
): string {
  context.styles = mustache.render(stylesTmpl, context);
  return mustache.render(tmpl, context);
}

/**
 * Render the 404 html page
 * @param {string} imageFileName - filename of storage image
 * @param {string} baseUrl - http base fully qualified URL
 * @return {string} HTML string
 */
function renderNotFoundPage(imageFileName: string, baseUrl: string): string {
  const context = Object.assign({}, BaseHTMLContext, {
    appUrl: baseUrl,
    shareUrl: `${baseUrl}/share/${imageFileName}`,
    shareImageUrl: bucketPathForFile(`${UPLOAD_PATH}/${imageFileName}`),
  });
  return renderTemplate(notFoundTmpl, context);
}

/**
 * Populate and return the share page HTML for given path
 * @param {string} imageFileName - filename of storage image
 * @param {string} baseUrl - http base fully qualified URL
 * @return {string} HTML string
 */
function renderSharePage(imageFileName: string, baseUrl: string): string {
  const context = Object.assign({}, BaseHTMLContext, {
    appUrl: baseUrl,
    shareUrl: `${baseUrl}/share/${imageFileName}`,
    shareImageUrl: bucketPathForFile(`${UPLOAD_PATH}/${imageFileName}`),
  });
  return renderTemplate(shareTmpl, context);
}

/**
 * Get share response
 * @param {Object} req - request object
 * @return {Object} share response
 */
export async function getShareResponse(
  req: functions.https.Request
): Promise<{ status: number; send: string }> {
  try {
    const host = req.get('host') ?? '';
    const baseUrl = `${req.protocol}://${host}`;
    const { ext, base: imageFileName } = path.parse(req.path);

    if (!ALLOWED_HOSTS.includes(host) || !VALID_IMAGE_EXT.includes(ext)) {
      functions.logger.log('Bad host or image ext', { host, baseUrl, ext, imageFileName });
      return {
        status: 404,
        send: renderNotFoundPage(imageFileName, baseUrl),
      };
    }

    const imageBlobPath = `${UPLOAD_PATH}/${imageFileName}`;
    const imageExists = await admin.storage().bucket().file(imageBlobPath).exists();

    if (Array.isArray(imageExists) && imageExists[0]) {
      return {
        status: 200,
        send: renderSharePage(imageFileName, baseUrl),
      };
    }

    functions.logger.log('Image does not exist', { imageBlobPath });

    // NOTE 200 status so that default share meta tags work,
    // where twitter does not show meta tags on a 404 status
    return {
      status: 200,
      send: renderNotFoundPage(imageFileName, baseUrl),
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
  const { status, send } = await getShareResponse(req);
  res.set('Access-Control-Allow-Origin', '*');
  res.status(status).send(send);
});
