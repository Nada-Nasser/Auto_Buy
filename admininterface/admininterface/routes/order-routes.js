const express = require('express');
const admin = require('../db')
const { 
    getAllOrders
} = require('../controller/ordercontroller');

const router = express.Router();




const apikey ='sajfnsdkjfnsdfsdfsd56468'
router.get(`/${apikey}/orders`, getAllOrders);


module.exports = {
    routes: router
}