class Order {
    constructor(id,governerate, user_id, order_date,delivery_date, status) {
            this.id=id;
            this.governerate = governerate;
            this.user_id = user_id;
            var orderdate;
            var deliverydate;
            try {
                orderdate=order_date.toDate()    
            } catch (error) {
                
            }
            try {
                deliverydate=delivery_date.toDate()    
            } catch (error) {
                
            }
            
            this.order_date = orderdate;
            this.delivery_date = deliverydate;
            this.status = status;
    }
}

module.exports = Order;