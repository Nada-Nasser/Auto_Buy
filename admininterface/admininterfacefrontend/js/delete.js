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
    let req = new XMLHttpRequest();
    var apikey = localStorage['apikey']
	productid=document.getElementById('productid').value;
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
    document.getElementById('productid').value =productid;

    
}




function submit() {

    //POST request with body equal on data in JSON format
    var apikey = localStorage['apikey']
    fetch(`http://127.0.0.1:3000/api/${apikey}/product/`+productid, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
      },
      
    })
      
  
  
  }
  