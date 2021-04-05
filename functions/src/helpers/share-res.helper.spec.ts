import {shareRes} from "./share-res.helper";

describe("shareRes", () => {
  test("invalid path returns 404 Not Found", async () => {
    expect(await shareRes("")).toMatchObject({
      status: 404,
      send: "Not Found",
    });
  });
  test("invalid file extension returns 404 Not Found", async () => {
    expect(await shareRes("/share/image.gif")).toMatchObject({
      status: 404,
      send: "Not Found",
    });
  });
});
