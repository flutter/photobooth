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
  test('Valid file name returns 200 and html', async () => {
    const res = await getShareResponse('/share/upload.jpeg');
    expect(res.status).toEqual(200);
    expect(typeof res.send).toEqual('string');
    expect(res.send).toContain('<html>');
  });
});
