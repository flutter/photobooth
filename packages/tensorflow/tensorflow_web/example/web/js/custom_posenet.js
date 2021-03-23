async function estimatePose(img) {
    console.log('img: ', img);
    // RESULT TO PASS
    let result = [];

    // LOAD MOBILENET MODEL
    console.log("Load model");
    const model = await posenet.load();

    // ESTIMATE POSE IN THE IMAGE
    console.log("Estimate pose");

    let predictions = await model.estimateSinglePose(img.imageData, {
        flipHorizontal: false
      });
    console.log('Pred >>>', predictions);

    // EXTRACTION OF DATA...
    predictions.forEach(function(item, index) {
        result.push(item);
    });

    return result;
}

function testJsMethod(something) {
    console.log("hello world");
    console.log(something);
}

async function loadModel() {
    console.log("loading model");
    const model = await posenet.load();
    console.log("loaded model");
}
