const express = require('express');
const admin = require('../db')
const firestore=admin.firestore();
const { addProduct,
    getAllProducts,
    getProduct,

    updateProduct,
    deleteProduct
} = require('../controller/productcontroller');

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
router.post(`/${apikey}/product`, addProduct);
router.get(`/${apikey}/products`, getAllProducts);

router.get(`/${apikey}/image`, function (req, res, next) {
    const config = {
        action: 'read',

        // A timestamp when this link will expire
        expires: '01-01-2026',
    };
    try {

        var fileRef = bucket.file(req.query.path);
        fileRef.exists().then(function (data) {
            console.log("File in database exists ");
        });
        fileRef.getSignedUrl(config, function (err, url) {
            if (err) {
                console.error(err);
                return;
            }

            // The file is now available to
            // read from this URL
            res.send(url);
        });
        


    } catch (error) {
        res.status(400).send(error.message);
    }
});

router.post(`/${apikey}/upload/`, upload.single('productImage'), (req, res, next) => {
    try {

        console.log(req.file.originalname)
        bucket.upload('./upload/' + req.file.originalname, {
            gzip: true,
            destination: 'images/products/' + req.file.originalname,
        })
        //const file = req.params.image;
        //var storageRef = bucket.ref("test");
        //storageRef.put(file);
        res.send(req.file);

    } catch (error) {
        res.status(400).send(error.message);
    }
});

router.get(`/${apikey}/product/:id`, getProduct);
router.put(`/${apikey}/product/:id`, updateProduct);
router.delete(`/${apikey}/product/:id`, deleteProduct);


module.exports = {
    routes: router
}