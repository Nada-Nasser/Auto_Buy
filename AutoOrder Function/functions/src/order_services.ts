import * as firestoreServices from "./firestoreServices";
import * as firestoreDB from "firebase-admin";

/**
 * make order
 * @param {object} data
 * @param {Date} curDate
 */
export async function makeOrder(data, curDate) {
  console.log("make Order function started\n");
  data.order_date = new Date();
  data.delivery_date =
      new Date(curDate.setDate(curDate.getDate() + 3));

  // add a new order and get its ID
  const id = await firestoreServices.addDocument("orders", data);

  // we then add the ID to the
  await firestoreServices.updateDocumentField(
      "users_orders",
      data.user_id,
      {orders_ids: firestoreDB.firestore.FieldValue.arrayUnion(id)});
}

/**
 * delete products that were checked out from the stock
 * @param {object} productIdsAndQuantity
 */
export async function deleteProductsFromStock(productIdsAndQuantity) {
  // reduce the quantity in stock
  for (const productID in productIdsAndQuantity) {
    if (Object.prototype.hasOwnProperty
        .call(productIdsAndQuantity, productID)) {
      const quantity = productIdsAndQuantity[productID];
      let productNumberInStock = await firestoreDB.firestore()
          .doc("products/"+productID).get().then((snapshot) => {
            return snapshot.data()!.number_in_stock;
          });

      productNumberInStock = productNumberInStock - quantity;
      if (productNumberInStock < 0) productNumberInStock = 0;
      await firestoreServices.updateDocumentField("products", productID,
          {"number_in_stock": productNumberInStock});
    }
  }
}
