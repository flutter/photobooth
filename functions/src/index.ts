import * as functions from "firebase-functions";
import {shareRes} from "./helpers";
import * as admin from "firebase-admin";
admin.initializeApp();

export const share = functions.https.onRequest(async (req, res) => {
  const {status, send} = await shareRes(req.path);
  res.status(status).send(send);
});
