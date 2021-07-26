const Order = require('../models/order');
const admin = require('../db')
const firestore=admin.firestore();



const getAllOrders = async (req, res, next) => {
    try {
        const orders = await firestore.collection('orders');
        const data = await orders.get();
        const ordersarray = [];
        if(data.empty) {
            res.status(404).send('No Orders record found');
        }else {
            data.forEach(doc => {
                const order = new Order(
                    doc.id,
                    doc.data().address['governorate'],
                    doc.data().user_id,
                    doc.data().order_date,
                    doc.data().delivery_date,    
                    doc.data().status
                    
                );
                ordersarray.push(order);
            });
            res.send(ordersarray);
        }
    } catch (error) {
        res.status(400).send(error.message);
    }
}



module.exports = {
    getAllOrders
}