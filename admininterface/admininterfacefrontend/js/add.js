var subcategories = []
async function getcategories() {

  var categorylist = document.getElementById("productcategory");
  var categories = [];
  var apikey = localStorage['apikey']
  await $.getJSON(`http://127.0.0.1:3000/api/${apikey}/categories`, function (data) {

    $.each(data, function (i, obj) {
      categories.push(obj.id);
      subcategories.push(obj.sub_categories)
    });

  });

  while (categorylist.options.length) {
    categorylist.remove(0);
  }

  for (i = 0; i < categories.length; i++) {
    var category = new Option(categories[i], i);
    console.log(categories[i])
    categorylist.options.add(category);
  }

}

function changesubcategory() {
  var subcategorylist = document.getElementById("subproductcategory");
  selectElem = document.getElementById("productcategory");
  var index = selectElem.selectedIndex;
  currentsubcategory = subcategories[index];

  while (subcategorylist.options.length) {
    subcategorylist.remove(0);
  }

  for (i = 0; i < currentsubcategory.length; i++) {
    var category = new Option(currentsubcategory[i], i);
    console.log(currentsubcategory[i])
    subcategorylist.options.add(category);
  }

}



var sale = false
function myfunction() {
  var checkBox = document.getElementById("btn-check-outlined");
  var text = document.getElementById("productsale");
  if (checkBox.checked == true) {
    text.style.display = "block";
    sale = true
  } else {
    text.value = null;
    text.style.display = "none";
    sale = false
  }
}

function myfunction2() {
  var apikey = localStorage['apikey']
  const file = document.querySelector("#productimagepath").files[0]
  var form_data = new FormData();
  form_data.append('productImage', file);
  alert(form_data);
  $.ajax({
    url: `http://127.0.0.1:3000/api/${apikey}/upload`, // point to server-side PHP script 
    dataType: 'text',  // what to expect back from the PHP script, if anything
    cache: false,
    contentType: false,
    processData: false,
    data: form_data,
    type: 'post',
  });


}



function submit() {
  myfunction2();
  var name = document.getElementById("productname").value
  var description = document.getElementById("productdescription").value
  var stock = document.getElementById("stocknumber").value
  var brand = document.getElementById("productbrand").value
  var price = document.getElementById("productprice").value
  var size = document.getElementById("productsize").value
  var priceaftersale = document.getElementById("productsale").value
  var e=document.getElementById('productcategory');
  var category = e.options[e.selectedIndex].text;
  var e2=document.getElementById('subproductcategory');
  var subcategory='';
  if(e2.selectedIndex!=-1){
    subcategory = e2.options[e2.selectedIndex].text;
  }
  
  var sizeunit = document.getElementById("productsizeunit").value
  var maxdemand = document.getElementById("maxdemand").value
  var path = "/images/products/" + document.querySelector("#productimagepath").files[0].name
  console.log("name:" + name)
  console.log("desc:" + description)
  console.log("stock:" + stock)
  console.log("brand:" + brand)
  console.log("price:" + price)
  console.log("size:" + size)
  console.log("priceaftersale:" + priceaftersale)
  console.log("category:" + category)
  console.log("sub-category:" + subcategory)
  console.log("sizeunit:" + sizeunit)
  console.log("path:" + path)
  console.log("sale:" + sale)
  
  const data = {
    "brand": brand,
    "category_id": category,
    "has_discount": sale,
    "description": description,
    "name": name,
    "number_in_stock": parseFloat(stock),
    "pic_path": path,
    "price": parseFloat(price),
    "price_after_discount": parseFloat(priceaftersale),
    "size": parseFloat(size),
    "sub_category": subcategory,
    "size_unit": sizeunit,
    "max_demand_per_user": maxdemand
  };
  var apikey = localStorage['apikey']
  //POST request with body equal on data in JSON format
  fetch(`http://127.0.0.1:3000/api/${apikey}/product`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  })
    .then((response) => response.json())
    //Then with the data from the response in JSON...
    .then((data) => {
      console.log('Success:', data);
    })
    



}
