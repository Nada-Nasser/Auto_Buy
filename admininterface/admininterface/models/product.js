class Product {
    constructor(id,brand, category_id, has_discount, description,
        name, number_in_stock, pic_path, price, price_after_discount, size,size_unit,sub_category,max_demand_per_user ) {
            this.id=id;
            this.brand = brand;
            this.category_id = category_id;
            this.has_discount = has_discount;
            this.description = description;
            this.name = name;
            this.number_in_stock = number_in_stock;
            this.pic_path = pic_path;
            this.price = price;
            this.price_after_discount = price_after_discount;
            this.size = size;
            this.sub_category = sub_category;
            this.size_unit = size_unit;
            this.max_demand_per_user = max_demand_per_user;
    }
}

module.exports = Product;