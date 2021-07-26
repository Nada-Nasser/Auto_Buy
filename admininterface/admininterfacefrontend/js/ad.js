function myfunction2() {
    var apikey = localStorage['apikey']
    const file = document.querySelector("#searchqueryimage").files[0]
    var form_data = new FormData();
    form_data.append('adimage', file);
    alert(form_data);
    $.ajax({
      url: `http://127.0.0.1:3000/api/${apikey}/ad/upload`, // point to server-side PHP script 
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
    var searchquery = document.getElementById("searchquery").value
    var path = "/images/advertisements/" + document.querySelector("#searchqueryimage").files[0].name    
    console.log("searchquery:" + searchquery)
    console.log("path:" + path)
    
    const data = {
      "image_ref": path,
      "search_query": searchquery
    };
    var apikey = localStorage['apikey']
    //POST request with body equal on data in JSON format
    fetch(`http://127.0.0.1:3000/api/${apikey}/ad`, {
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
  