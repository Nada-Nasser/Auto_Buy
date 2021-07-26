let ordersarray = [];


async function displayitems(array) {
    console.log(ordersarray)
    var tempdiv = ``;
    for (let i = 0; i < ordersarray.length; i++) {

        
        
        var id = ordersarray[i].id;
        var governorate = ordersarray[i].governerate;
        var userid = ordersarray[i].user_id;
        var orderdate = ordersarray[i].order_date;
        var deliverydate = ordersarray[i].delivery_date;
        var status = ordersarray[i].status;
        
        tempdiv +=
            `
            <tr>
            <th scope="row">${id}</th>
            <td>${governorate}</td>
            <td>${userid}</td>
            <td>${orderdate}</td>
            <td>${deliverydate}</td>
            <td>${status}</td>
            </tr>
            `;
    }

    $("#ordershow").html(tempdiv)



}

function loadorders(){
    var apikey = localStorage['apikey']
    let req = new XMLHttpRequest();
    req.open("GET", `http://127.0.0.1:3000/api/${apikey}/orders`);
    req.send();
    req.onload = function () {
        let jsonObj = req.responseText;
        ordersarray = JSON.parse(jsonObj);
        //console.log(profileJson.data);
        //console.log(moviesarray)
        displayitems(ordersarray);

    }

}