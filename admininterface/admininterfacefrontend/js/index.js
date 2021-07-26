var output;
var flag=false;
function login(){
    localStorage['apikey']= document.getElementById('apikey').value
    url = 'home.html';
    if(flag==false || output==null || output!="jo"){
        localStorage['apikey']= null
    }
    else{
        document.location.href = url;
    }

}

function dataURItoBlob(dataURI) {
    // convert base64/URLEncoded data component to raw binary data held in a string
    var byteString;
    if (dataURI.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(dataURI.split(',')[1]);
    else
        byteString = unescape(dataURI.split(',')[1]);
    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    return new Blob([ia], {type:mimeString});
}

function dataURLtoFile(dataurl, filename) {
    var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
    while(n--){
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, {type:mime});
}
var width = 800; // We will scale the photo width to this
var height = 800; // This will be computed based on the input stream
var streaming = false;
var video = null;
var canvas = null;
var photo = null;
var startbutton = null;


function clearphoto() {
    var context = canvas.getContext('2d');
    context.fillStyle = "#AAA";
    context.fillRect(0, 0, canvas.width, canvas.height);

    var data = canvas.toDataURL('image/jpg');
    photo.setAttribute('src', data);
}

async function takepicture() {
    var context = canvas.getContext('2d');
    if (width && height) {
        canvas.width = width;
        canvas.height = height;
        context.drawImage(video, 0, 0, width, height);

        var data = canvas.toDataURL('image/jpg');
        
        //var file = dataURItoBlob(data)
        //var file =dataURLtoFile(data,'test.jpg')
        //console.log(data)
        //var form_data = new FormData();
        //form_data.append('base64_image', data);
        //alert(form_data);
        var http = new XMLHttpRequest();

        
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                output=this.responseText.substring(1).slice(0,-1);
                flag=true;
				
                if(output==null || output!="jo"){
                    console.log('aaaa')
                    $('#mybtn').attr('disabled','disabled');

                }
                else{
                    console.log('aaaa2')
                    $('#mybtn').removeAttr('disabled');
                }
                console.log(this.response);
            }
        };

        http.open('POST', 'https://7661f2afbea0.ngrok.io/', true);
        http.setRequestHeader('Content-Type', 'application/json');
        http.send(data.split(',')[1]);
        photo.setAttribute('src', data);
    } else {
        clearphoto();
    }
}

function startup() {
    video = document.getElementById('video');
    canvas = document.getElementById('canvas');
    photo = document.getElementById('photo');
    startbutton = document.getElementById('startbutton');
    $('#mybtn').attr('disabled','disabled');

    // access video stream from webcam
    navigator.mediaDevices.getUserMedia({
            video: true,
            audio: false
        })
        // on success, stream it in video tag
        .then(function(stream) {
            video.srcObject = stream;
            video.play();
        })
        .catch(function(err) {
            console.log("An error occurred: " + err);
        });

    video.addEventListener('canplay', function(ev) {
        if (!streaming) {
            height = video.videoHeight / (video.videoWidth / width);

            if (isNaN(height)) {
                height = width / (4 / 3);
            }

            video.setAttribute('width', width);
            video.setAttribute('height', height);
            canvas.setAttribute('width', width);
            canvas.setAttribute('height', height);
            streaming = true;
        }
    }, false);

    startbutton.addEventListener('click', function(ev) {
        takepicture();
        ev.preventDefault();
    }, false);

    clearphoto();
}
window.addEventListener('load', startup, false);