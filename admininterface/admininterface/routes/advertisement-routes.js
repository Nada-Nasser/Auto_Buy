const express = require('express');
const admin = require('../db')
const { addAd} = require('../controller/advertisementcontroller');

const router = express.Router();
const bucket = admin.storage().bucket();


var multer = require('multer')

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './upload/')
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname)
    }
});
const apikey ='sajfnsdkjfnsdfsdfsd56468'
const upload = multer({ storage: storage })
router.post(`/${apikey}/ad`, addAd);



router.post(`/${apikey}/ad/upload/`, upload.single('adimage'), (req, res, next) => {
    try {

        console.log(req.file.originalname)
        bucket.upload('./upload/' + req.file.originalname, {
            gzip: true,
            destination: 'images/advertisements/' + req.file.originalname,
        })
        res.send(req.file);

    } catch (error) {
        res.status(400).send(error.message);
    }
});

module.exports = {
    routes: router
}