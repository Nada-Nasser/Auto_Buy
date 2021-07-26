//const firebase = require('../db');
const Product = require('../models/product');
//const firestore = firebase.firestore();
const admin = require('../db')
const firestore=admin.firestore();


const addProduct = async (req, res, next) => {
    try {
        const data = req.body;        
        await firestore.collection('products').doc().set(data);
        res.send('Record saved successfuly');
    } catch (error) {
        res.status(400).send(error.message);
    }
}



const getAllProducts = async (req, res, next) => {
    try {
        const products = await firestore.collection('products');
        const data = await products.get();
        const productsarray = [];
        if(data.empty) {
            res.status(404).send('No Product record found');
        }else {
            data.forEach(doc => {
                const product = new Product(
                    doc.id,
                    doc.data().brand,
                    doc.data().category_id,
                    doc.data().has_discount,
                    doc.data().description,    
                    doc.data().name,
                    doc.data().number_in_stock,
                    doc.data().pic_path,
                    doc.data().price,
                    doc.data().price_after_discount,
                    doc.data().size,
                    doc.data().size_unit,
                    doc.data().sub_category,
                    doc.data().max_demand_per_user
                    
                );
                productsarray.push(product);
            });
            res.send(productsarray);
        }
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const getProduct = async (req, res, next) => {
    try {
        const id = req.params.id;
        const product = await firestore.collection('products').doc(id);
        const data = await product.get();
        if(!data.exists) {
            res.status(404).send('Product with the given ID not found');
        }else {
            res.send(data.data());
        }
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const updateProduct = async (req, res, next) => {
    try {
        const id = req.params.id;
        const data = req.body;
        const student =  await firestore.collection('products').doc(id);
        await student.update(data);
        res.send('Student record updated successfuly');        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const deleteProduct = async (req, res, next) => {
    try {
        const id = req.params.id;
        await firestore.collection('products').doc(id).delete();
        res.send('Record deleted successfuly');
    } catch (error) {
        res.status(400).send(error.message);
    }
}

module.exports = {
    addProduct,
    getAllProducts,
    getProduct, 
    updateProduct,
    deleteProduct
}