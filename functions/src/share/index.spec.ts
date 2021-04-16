import * as admin from 'firebase-admin';

import { STORAGE_BUCKET } from '../config';

admin.initializeApp({
  storageBucket: STORAGE_BUCKET,
});

import { getShareResponse } from './';


describe('Share API', () => {
  test('Invalid path returns 404 and html', async () => {
    const res = await getShareResponse('');
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });
  test('Invalid file extension returns 404 and html', async () => {
    const res = await getShareResponse('/share/image.gif');
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });
});
