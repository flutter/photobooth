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
    get(host = 'http://localhost:5001') {
      return host;
    },
  };

  test('Invalid path returns 404 and html', async () => {
    const req = Object.assign(baseReq);
    const res = await getShareResponse(req);
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });

  test('Invalid file extension returns 404 and html', async () => {
    const req = Object.assign(baseReq);
    req.path = '/share/image.gif';
    const res = await getShareResponse(req);
    expect(res.status).toEqual(404);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });

  test('Valid file name returns 200 and html', async () => {
    const req = Object.assign(baseReq);
    req.path = '/share/image.gif';
    const res = await getShareResponse(req.path);
    expect(res.status).toEqual(200);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });
});
