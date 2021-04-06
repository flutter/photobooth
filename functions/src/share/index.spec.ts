import { getShareResponse } from './';

describe('getShareResponse', () => {
  test('Invalid path returns 404 Not Found', async () => {
    expect(await getShareResponse('')).toMatchObject({
      status: 404,
      send: 'Not Found',
    });
  });
  test('Invalid file extension returns 404 Not Found', async () => {
    expect(await getShareResponse('/share/image.gif')).toMatchObject({
      status: 404,
      send: 'Not Found',
    });
  });
});
