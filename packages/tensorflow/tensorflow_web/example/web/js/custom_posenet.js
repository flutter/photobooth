async function loadModel() {
    await posenet.load();
}

async function estimatePose(img) {
    if (img == null) return;

    // LOAD MOBILENET MODEL
    const model = await posenet.load();

    // ESTIMATE POSE IN THE IMAGE
    let predictions = await model.estimateSinglePose(img, {
        flipHorizontal: false,
      });
    return predictions;
}
