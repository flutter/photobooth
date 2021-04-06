import * as fs from 'fs';
import * as os from 'os';
import * as path from 'path';

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { spawn } from 'child-process-promise';

import { STORAGE_BUCKET } from '../config';


// ImageMagick for more advanced
// const gm = require('gm').subClass({imageMagick: true});


/**
 * Generate a thumbnail for a new image upload
 */
export const generateThumbnail = functions
  .storage
  .object()
  .onFinalize(async (
    object: functions.storage.ObjectMetadata,
    context: functions.EventContext
  ): Promise<void> => {
    const { contentType, name: filePath = '', metageneration } = object;

    functions.logger.info(object);
    functions.logger.info(context);

    if (metageneration && metageneration === '1') {
      return;
    }

    if (!contentType?.startsWith('image/')) {
      return functions.logger.warn('File is not an image!', { contentType });
    } else if (filePath.includes('_thumb')) {
      return functions.logger.info('Image has already been processed');
    }

    const { dir: dirname, base: fileName, ext: fileExt } = path.parse(filePath);
    const bucket = admin.storage().bucket(STORAGE_BUCKET);
    const tempFilePath = path.join(os.tmpdir(), fileName);

    await bucket.file(filePath).download({ destination: tempFilePath });

    // Generate a thumbnail using ImageMagick.
    // TODO generate with correct dimensions and aspect ratio
    const newWidth = 200;
    const hewHeight = 200;

    // End gte symbol means only resize images larger than this
    // We could use a perc based dimension like 50%, but a bit naive
    const dim = `${newWidth}x${hewHeight}>`;

    await spawn('convert', [ tempFilePath, '-thumbnail', `${dim}`, tempFilePath ]);

    const thumbFileName = path.normalize(
      path.format({ dir: dirname, name: fileName, ext: fileExt })
    );

    functions.logger.log('Uploading image thumbnail', thumbFileName);

    // Upload thumb as main image with the original name/path
    await bucket.upload(tempFilePath, {
      destination: path.join(dirname, thumbFileName),
      metadata: { contentType },
    });

    return fs.unlinkSync(tempFilePath);
  });


/**
 * Public upload image function
 */
export const uploadImage = functions.https.onRequest(async (req, res) => {
  if (req.method.toLowerCase() !== 'post') {
    res.status(405).json({
      error: 'Method not allowed',
    });
    return;
  }

  // development only, set to actual production hosting domain
  res.set('Access-Control-Allow-Origin', '*');

  res.status(200).json({
    success: true,
  });
});
