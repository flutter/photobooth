import * as admin from 'firebase-admin';

// NOTE not using service account for now
// import serviceKey from '../creds/development.json';
// admin.initializeApp({
//   credential: admin.credential.cert(JSON.stringify(serviceKey)),
// });

admin.initializeApp();

import * as ImageApi from './images';
import * as ShareApi from './share';


export const uploadImage = ImageApi.uploadImage;
export const generateThumbnail = ImageApi.generateThumbnail;
export const shareImage = ShareApi.shareImage;
