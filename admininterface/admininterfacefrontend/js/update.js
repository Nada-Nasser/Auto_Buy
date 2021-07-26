var sale = false
var imagepath;
var productid;
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
    
    subcategorylist.options.add(category);
  }

}
function search(){
  var apikey = localStorage['apikey']
  productid=document.getElementById('productid').value;
  let req = new XMLHttpRequest();
    req.open("GET", `http://127.0.0.1:3000/api/${apikey}/product/`+productid);
    req.send();
    req.onload = function () {
        let jsonObj = req.responseText;
        productarray = JSON.parse(jsonObj);
        console.log(productarray)
        document.getElementById('productname').value = productarray.name;
        document.getElementById('productdescription').value = productarray.description;
        document.getElementById('stocknumber').value = productarray.number_in_stock;
        document.getElementById('productbrand').value = productarray.brand;
        document.getElementById('productprice').value = productarray.price;
        document.getElementById('productsize').value = productarray.size;
        document.getElementById('productsizeunit').value = productarray.size_unit;
        document.getElementById('maxdemand').value = productarray.max_demand_per_user;
        imagepath=productarray.pic_path;
        var options = $('#productcategory option');

        var categoryvalues = $.map(options ,function(option) {
            if(option.text==productarray.category_id){
                return option.value;
            }
            
        });
        document.getElementById('productcategory').value = categoryvalues[0];
        changesubcategory();
        var options = $('#subproductcategory option');

        var subcategoryvalues = $.map(options ,function(option) {
            if(option.text==productarray.sub_category){
                return option.value;
            }
            
        });
        document.getElementById('subproductcategory').value = subcategoryvalues[0];
        var checkBox = document.getElementById("btn-check-outlined");
        if(productarray.has_discount==true){
            checkBox.checked=true;
            myfunction();
            document.getElementById('productsale').value = productarray.price_after_discount;
        }
        else{
            checkBox.checked=false;
            myfunction();
        }
        
        

    }
}

window.onload = async function () {
    await getcategories()
    var url = document.location.href,
        params = url.split('?')[1].split('&'),
        data = {}, tmp;
    for (var i = 0, l = params.length; i < l; i++) {
         tmp = params[i].split('=');
         data[tmp[0]] = tmp[1];
    }
    productid=data.id;
    document.getElementById('productid').value = productid;

    
}
function myfunction2() {
  var apikey = localStorage['apikey']
  if(document.querySelector("#productimagepath").files.length==0){        
      return
  }
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
    var subcategory = e2.options[e2.selectedIndex].text;
    var sizeunit = document.getElementById("productsizeunit").value
    var path;
    if(document.querySelector("#productimagepath").files.length!=0){        
        path = "/images/products/" + document.querySelector("#productimagepath").files[0].name
    }
    else{
        console.log(imagepath);
        path = imagepath;
    }
    
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
      "size_unit": sizeunit
    };
    var apikey = localStorage['apikey']
    //POST request with body equal on data in JSON format
    fetch(`http://127.0.0.1:3000/api/${apikey}/product/`+productid, {
      method: 'PUT',
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
  