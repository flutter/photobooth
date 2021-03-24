async function loadModel() {
    console.log("load model started");
    await posenet.load();
    console.log("load model finished");
}

async function estimatePose(img) {
    console.log('img: ', img);
    if (img == null) return;
    // RESULT TO PASS
    let result = [];

    // LOAD MOBILENET MODEL
    console.log("Load model");
    const model = await posenet.load();

    // ESTIMATE POSE IN THE IMAGE
    console.log("Estimate pose");

    let predictions = await model.estimateSinglePose(img, {
        flipHorizontal: false,
      });
    console.log('Prediction ', predictions);
    return result;
}

async function getLeftShoulder(img) {
    if (img == null) return;
    
    // LOAD MOBILENET MODEL
    const model = await posenet.load();

    // ESTIMATE POSE IN THE IMAGE
    let predictions = await model.estimateSinglePose(img, {
        flipHorizontal: false,
    });
    //Returns left should prediction
    var leftShoulder = predictions.keypoints[5];
    console.log(leftShoulder);
    return leftShoulder;
}
