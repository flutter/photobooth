import * as admin from 'firebase-admin';

import { STORAGE_BUCKET } from './config';

admin.initializeApp({
  storageBucket: STORAGE_BUCKET,
});

// import * as ImageApi from './images';
import * as ShareApi from './share';

export const shareImage = ShareApi.shareImage;
