'use strict';
var path = require('path');
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const config = require('./config');
const productRoutes = require('./routes/product-routes');
const orderRoutes = require('./routes/order-routes');
const categoryRoutes = require('./routes/category-routes');
const advertisementsRoutes = require('./routes/advertisement-routes');
const app = express();

app.use(express.json());
app.use(cors());
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, 'public')));
app.use('/api', productRoutes.routes);
app.use('/api', categoryRoutes.routes);
app.use('/api', advertisementsRoutes.routes);
app.use('/api', orderRoutes.routes);



app.listen(config.port, () => console.log('App is listening on url http://127.0.0.1:' + config.port));