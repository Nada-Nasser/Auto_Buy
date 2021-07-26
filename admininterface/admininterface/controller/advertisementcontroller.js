//const firebase = require('../db');
const Product = require('../models/advertisement');
//const firestore = firebase.firestore();
const admin = require('../db')
const firestore=admin.firestore();


const addAd = async (req, res, next) => {
    try {
        const data = req.body;        
        await firestore.collection('advertisements').doc().set(data);
        res.send('Record saved successfuly');
    } catch (error) {
        res.status(400).send(error.message);
    }
}

module.exports = {
    addAd
}