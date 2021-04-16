import * as admin from 'firebase-admin';

import { STORAGE_BUCKET } from './config';

admin.initializeApp({
  storageBucket: STORAGE_BUCKET,
});

// import * as ImageApi from './images';
import * as ShareApi from './share';


// NOTE putting both of these on hold
// export const uploadImage = ImageApi.uploadImage;
// export const generateThumbnail = ImageApi.generateThumbnail;

export const shareImage = ShareApi.shareImage;
