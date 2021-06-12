
var start = function (fileId, url, auth, filename, ext) {
    console.log(url);
    fetch(url, {
        headers: {
            "Authentication": auth
        }
    }).then(response  => {
        var reader = response.body.getReader();
        var bytesReceived = 0;
        var chunks =[];

        const total =+ response.headers.get('Content-Length');

        reader.read().then(function processResult(result) {
            if (result.done) {
                console.log("Fetch complete");
                let blob = new Blob(chunks);
                var a = document.createElement('a');
                var url = window.URL.createObjectURL(blob);
                a.href = url;
                a.download = `${filename}.${ext}`;
                a.click();
                window.URL.revokeObjectURL(url);


                eval(`finishedCallback${fileId}()`);
                return;
            } else {
                chunks.push(result.value);
            }

            bytesReceived += result.value.length;
            eval(`progCallback${fileId}(${bytesReceived}, ${total})`);

            return reader.read().then(processResult);
        });
    });
}