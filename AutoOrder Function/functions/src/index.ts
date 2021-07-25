import * as functions from "firebase-functions";
import * as firestoreDB from "firebase-admin";
import {deleteProductsFromStock, makeOrder} from "./order_services";
import * as firestoreServices from "./firestoreServices";

firestoreDB.initializeApp();

export const monthlyCartCheck = functions.https.onRequest(
    (request, response) => {
      firestoreDB.firestore().collection("checked_out_monthly_carts").get()
          .then(function(querySnapshot) {
            querySnapshot.forEach(function(doc) {
              // snapshot to get the data in collection checked_out_monthly_cart
              console.log(doc.id, " => ", doc.data().delivery_date);

              let deliveryDate = doc.data().delivery_date;
              deliveryDate = deliveryDate.toDate();

              // we know that the next order will be automatically
              // ordered on the 27th day
              const nextOrderingDate =
                  new Date(deliveryDate.setDate(deliveryDate.getDate() + 27));

              console.log("delivery date = ", deliveryDate);
              console.log("next order date = ", nextOrderingDate);

              const curDate = new Date();

              console.log("cur date = ", curDate.getTime());
              console.log("next order date = ", nextOrderingDate.getTime());
              // check if today is the next ordering date
              if (curDate.getTime() > nextOrderingDate.getTime()) {
                // we make the new order with the new delivery date
                makeOrder(doc.data(), new Date());

                // we then remove the checked out items from the stock
                deleteProductsFromStock(doc.data().productid_quantity);

                // we need to update the checked_out_monthly carts with
                // new delivery date and new ordering date
                updateDatesInCheckedCarts(new Date(), doc.id);

                // we also need to update the delivery date of the monthly cart
                updateDateInMonthlyCart(doc.id.replace(doc.data().user_id, "")
                    , doc.data().user_id);
              }
            });
            response.send("done!");
          }).catch((error) => {
            console.log(error);
            response.status(500).send(error);
          });
    });

/**
 * update dates in checked out monthly carts collection
 * @param {Date} curDate
 * @param {string} docID
 */
async function updateDatesInCheckedCarts(curDate: Date, docID: string) {
  await firestoreServices.updateDocumentField("checked_out_monthly_carts",
      docID, {"order_date": curDate});

  const newDeliverDate = new Date(new Date().setDate(new Date().getDate() + 3));
  await firestoreServices.updateDocumentField("checked_out_monthly_carts",
      docID, {"delivery_date": newDeliverDate});
}

/**
 * update delivery date in the specified monthly cart
 * @param {string} cartID
 * @param {string} userID
 */
async function updateDateInMonthlyCart(cartID: string, userID: string) {
  const newDeliverDate = new Date(new Date().setDate(new Date().getDate() + 3));
  await firestoreServices.updateDocumentField(
      "monthly_carts/" + userID + "/monthly_carts",
      cartID, {"delivery_date": newDeliverDate});
}
