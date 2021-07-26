const express = require('express');
const {
    getAllCategories
      } = require('../controller/categorycontroller');

const router = express.Router();

const apikey ='sajfnsdkjfnsdfsdfsd56468'
router.get(`/${apikey}/categories`, getAllCategories);


module.exports = {
    routes: router
}