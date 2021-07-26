var subcategories = []
let productsarray = [];
let imagesurls = [];
function update() {
    
    var b = event.target.name,
        url = 'update.html?id=' + encodeURIComponent(b);

    console.log(url);
    document.location.href = url;

}
function deletee() {
    
    var b = event.target.name,
        url = 'delete.html?id=' + encodeURIComponent(b);

    console.log(url);
    document.location.href = url;

}


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
        //console.log(categories[i])
        categorylist.options.add(category);
    }

}

function viewsub(){
    var tempdiv = ``;
    for (let i = 0; i < productsarray.length; i++) {
        if (productsarray[i].category_id==$('#productcategory option:selected').text() && productsarray[i].sub_category==$('#subproductcategory option:selected').text()) {
            console.log('iam here')
            var imgsrc = getlinks(productsarray[i].pic_path);
            var name = productsarray[i].name;
            var category = productsarray[i].category_id;
            tempdiv +=
            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">
            <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
            <input type="hidden" name="data" id="hiddenField${productsarray[i].id}" value="${productsarray[i].id}" />
            <button type="submit" class="btn btn-outline-warning mb-2" name="${productsarray[i].id}" onClick="update()">Edit</button>
            <button type="submit" class="btn btn-outline-warning" name="${productsarray[i].id}" onClick="deletee()">Delete</button>
            </div>
            </div>
            `;
        }
    }

    $("#moviesshow").html(tempdiv)
 
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
        //console.log(currentsubcategory[i])
        subcategorylist.options.add(category);
    }
    
    var tempdiv = ``;
    for (let i = 0; i < productsarray.length; i++) {
        //console.log(productsarray[i].category_id)
        
        if (productsarray[i].category_id==$('#productcategory option:selected').text()) {
            var imgsrc = getlinks(productsarray[i].pic_path);
            var name = productsarray[i].name;
            var category = productsarray[i].category_id;
            tempdiv +=
            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">
            <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
            <input type="hidden" name="data" id="hiddenField${productsarray[i].id}" value="${productsarray[i].id}" />
            <button type="submit" class="btn btn-outline-warning mb-2" name="${productsarray[i].id}" onClick="update()">Edit</button>
            <button type="submit" class="btn btn-outline-warning" name="${productsarray[i].id}" onClick="deletee()">Delete</button>
            </div>
            </div>
            `;
        }
    }

    $("#moviesshow").html(tempdiv)


}
function getlinks(path) {
    var apikey = localStorage['apikey']
    var url = `http://127.0.0.1:3000/api/${apikey}/image`;
    var params;
    params = "path=" + path.substring(1);
    var xhttp = new XMLHttpRequest();
    xhttp.open('GET', url + '?' + params, false);
    xhttp.send();
    return xhttp.responseText

}


async function displayitems(array) {
    console.log(productsarray)
    var tempdiv = ``;
    for (let i = 0; i < productsarray.length; i++) {

        var imgsrc = getlinks(productsarray[i].pic_path);
        
        var name = productsarray[i].name;
        var category = productsarray[i].category_id;
        tempdiv +=
            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">
            <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
            <input type="hidden" name="data" id="hiddenField${array[i].id}" value="${array[i].id}" />
            <button type="submit" class="btn btn-outline-warning mb-2" name="${array[i].id}" onClick="update()">Edit</button>
            <button type="submit" class="btn btn-outline-warning" name="${array[i].id}" onClick="deletee()">Delete</button>        
            </div>
            </div>
            `;
    }

    $("#moviesshow").html(tempdiv)



}
/*var tempdiv = ``;

for (let i = 0; i < array.length; i++) {
    var imgsrc = "images/" + array[i].path;
    var name = array[i].name;
    var category = array[i].genere;

    tempdiv +=

        `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
    <img src=${imgsrc} class="w-100 h-100">

    <div class="overlay d-flex align-items-center justify-content-center flex-column">
        <h2>${name}</h2>
        <p>${category}</p>

        <form method="POST" action="databaseaddwatchlist.php" name="update-form">
        <input type="hidden" name="data" id="${array[i].ID}" value="${array[i].ID}" />
        <button type="submit" class="btn btn-outline-warning">Add To WatchList</button>
        </form>
    </div>


</div>
`;





}
$("#moviesshow").html(tempdiv)*/





function getApi() {
    var apikey = localStorage['apikey']
    let req = new XMLHttpRequest();
    req.open("GET", `http://127.0.0.1:3000/api/${apikey}/products`);
    req.send();
    req.onload = function () {
        let jsonObj = req.responseText;
        productsarray = JSON.parse(jsonObj);
        //console.log(profileJson.data);
        //console.log(moviesarray)
        displayitems(productsarray);

    }



}
$("#searchbar").keyup(function () {

    var tempdiv = ``;
    for (let i = 0; i < productsarray.length; i++) {
        if (productsarray[i].name.includes(this.value)) {
            var imgsrc = getlinks(productsarray[i].pic_path);
            var name = productsarray[i].name;
            var category = productsarray[i].category_id;
            tempdiv +=
            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">
            <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
            <input type="hidden" name="data" id="hiddenField${productsarray[i].id}" value="${productsarray[i].id}" />
            <button type="submit" class="btn btn-outline-warning mb-2" name="${productsarray[i].id}" onClick="update()">Edit</button>
            <button type="submit" class="btn btn-outline-warning" name="${productsarray[i].id}" onClick="deletee()">Delete</button>
            </div>
            </div>
            `;
        }
    }

    $("#moviesshow").html(tempdiv)

})

window.onload = function () {
    this.getcategories();
    this.getApi();
}


/*
let moviesarray = [];
let watchlist=[];

$(".portfoliofilters span").click(function () {
    $(this).addClass("active");
    $(".portfoliofilters span").not($(this)).removeClass("active");

})

$("#watchlist").click(function(){
    getwatchlistapi();
})
$("#all").click(function(){
    displayitems(moviesarray);
})

$("#drama").click(function(){
    let temp="Drama";
    displaycertaincategory(temp);
})

$("#comedy").click(function(){
    let temp="Comedy";
    displaycertaincategory(temp);
})

$("#action").click(function(){
    let temp="Action";
    displaycertaincategory(temp);
})
$("#horror").click(function(){
    let temp="Horror";
    displaycertaincategory(temp);
})
$("#series").click(function(){
    let temp="Series";
    displaycertaincategory(temp);
})
$("#scifi").click(function(){
    console.log("asdas");
    let temp="Sci-fi";
    displaycertaincategory(temp);
})

$("#series").click(function(){
    let temp="Drama";
    displaycertaincategory(temp);
})


function getwatchlistapi()
{
    let req = new XMLHttpRequest();
    req.open("GET", "userwatchlist.php");
    req.send();
    req.onload = function () {
        let jsonObj = req.responseText;
        watchlist = JSON.parse(jsonObj);
        //console.log(profileJson.data);

        displaywatchlist(watchlist);

    }
}

function getApi() {
    let req = new XMLHttpRequest();
    req.open("GET", "moviesdata.php");
    req.send();
    req.onload = function () {
        let jsonObj = req.responseText;
        moviesarray = JSON.parse(jsonObj);
        //console.log(profileJson.data);

        displayitems(moviesarray);

    }
}
$("#searchbar").keyup(function () {

    var tempdiv = ``;
    for (let i = 0; i < moviesarray.length; i++) {
        if (moviesarray[i].name.includes(this.value)) {
            var imgsrc = getlinks(moviesarray[i].pic_path);
            console.log(array[i].id)
            var name = array[i].name;
            var category = array[i].category_id;
            tempdiv +=
            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">
            <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
            <input type="hidden" name="data" id="hiddenField${array[i].id}" value="${array[i].id}" />
            <button type="submit" class="btn btn-outline-warning mb-2" name="${array[i].id}" onClick="update()">Edit</button>
            <button type="submit" class="btn btn-outline-warning" name="${array[i].id}" onClick="deletee()">Delete</button>
            </div>
            </div>
            `;
        }
    }

    $("#moviesshow").html(tempdiv)


    var tempdiv = ``;
    for (let i = 0; i < moviesarray.length; i++) {
        if (moviesarray[i].name.includes(this.value)) {
            var imgsrc = "images/" + moviesarray[i].path;
            var name = moviesarray[i].name;
            var category = moviesarray[i].genere;
            console.log(imgsrc);
            tempdiv +=

                `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
            <img src=${imgsrc} class="w-100 h-100">

            <div class="overlay d-flex align-items-center justify-content-center flex-column">
                <h2>${name}</h2>
                <p>${category}</p>
                <form method="POST" action="databaseaddwatchlist.php" name="update-form">
                <input type="hidden" name="data" id="hiddenField" value="${moviesarray[i].ID}" />
            <button type="submit" class="btn btn-outline-warning">Add To WatchList</button>
            </form>
            </div>
            </div>
            `;


        }

    }
    $("#moviesshow").html(tempdiv);
});


function displaycertaincategory(category) {
    var tempdiv=``;

    for (let i = 0; i < moviesarray.length; i++) {
        if(moviesarray[i].genere==category){
            var imgsrc = "images/" + moviesarray[i].path;
        var name = moviesarray[i].name;
        var category = moviesarray[i].genere;

        tempdiv+=

            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
        <img src=${imgsrc} class="w-100 h-100">

        <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>

            <form method="POST" action="databaseaddwatchlist.php" name="update-form">
            <input type="hidden" name="data" id="hiddenField" value="${moviesarray[i].ID}" />
            <button type="submit" class="btn btn-outline-warning">Add To WatchList</button>
            </form>
        </div>


    </div>
    `;



        }



    }
    $("#moviesshow").html(tempdiv)
}

function displayitems(array) {
    var tempdiv=``;

    for (let i = 0; i < array.length; i++) {
        var imgsrc = "images/" + array[i].path;
        var name = array[i].name;
        var category = array[i].genere;

        tempdiv+=

            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
        <img src=${imgsrc} class="w-100 h-100">

        <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>

            <form method="POST" action="databaseaddwatchlist.php" name="update-form">
            <input type="hidden" name="data" id="hiddenField" value="${array[i].ID}" />
            <button type="submit" class="btn btn-outline-warning">Add To WatchList</button>
            </form>
        </div>


    </div>
    `;





    }
    $("#moviesshow").html(tempdiv)
}



function displaywatchlist(array) {
    var tempdiv=``;

    for (let i = 0; i < array.length; i++) {
        var imgsrc = "images/" + array[i].path;
        var name = array[i].name;
        var category = array[i].genere;

        tempdiv+=

            `<div class="col-md-3 col-s-6  position-relative customheight mt-2 movieitem">
        <img src=${imgsrc} class="w-100 h-100">

        <div class="overlay d-flex align-items-center justify-content-center flex-column">
            <h2>${name}</h2>
            <p>${category}</p>
        </div>


    </div>
    `;





    }
    $("#moviesshow").html(tempdiv)
}



window.onload = function () {
    this.getApi();
}
*/