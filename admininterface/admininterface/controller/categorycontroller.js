//const firebase = require('../db');
const Category = require('../models/category');
const admin = require('../db')
const firestore=admin.firestore();
//const firestore = firebase.firestore();


const getAllCategories = async (req, res, next) => {
    try {
        const categories = await firestore.collection('categories');
        const data = await categories.get();
        const catgoriesarray = [];
        if(data.empty) {
            res.status(404).send('No Category record found');
        }else {
            data.forEach(doc => {
                const category = new Category(
                    doc.id,
                    doc.data().sub_categories,
                );
                catgoriesarray.push(category);
            });
            res.send(catgoriesarray);
        }
    } catch (error) {
        res.status(400).send(error.message);
    }
}
module.exports = {
    getAllCategories
}