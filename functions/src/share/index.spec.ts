/* eslint-disable @typescript-eslint/no-unused-vars */
import * as functions from 'firebase-functions';

import { getShareResponse } from './';


jest.mock('firebase-admin', () => {
  return {
    storage: jest.fn(() => ({
      bucket: jest.fn(() => ({
        name: 'test-bucket',
        file: jest.fn(() => ({
          exists: jest.fn(async () => {
            return [ true ];
          }),
        })),
      })),
    })),
  };
});

describe('Share API', () => {
  const baseReq = {
    path: '',
    protocol: 'http',
    get(_: string) {
      return 'localhost:5001';
    },
  } as functions.https.Request;

  test('Invalid path returns 404 and html', async () => {
    const req = Object.assign({}, baseReq);
    const res = await getShareResponse(req);
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('DOCTYPE html');
  });

  test('Invalid file extension returns 404 and html', async () => {
    const req = Object.assign({}, baseReq, {
      path: 'wrong.gif',
    });
    const res = await getShareResponse(req);
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('DOCTYPE html');
  });

  test('Valid file name returns 200 and html', async () => {
    const req = Object.assign({}, baseReq, {
      path: 'test.png',
    });
    const res = await getShareResponse(req);
    expect(res.status).toEqual(200);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('DOCTYPE html');
  });
});
