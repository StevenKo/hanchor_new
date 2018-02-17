$ ->
  $("#cart_item_product_color_id,#cart_item_product_size_id").change ->
    color_id = $("#cart_item_product_color_id :selected").val()
    size_id = $("#cart_item_product_size_id :selected").val()
    locale = $("#locale").val()
    $.ajax
      url: "/products/quantity"
      type: "get"
      data:
        color_id: color_id
        size_id: size_id
        locale: locale
  $( "#cart_item_product_color_id" ).change();

  $(".label-radio").change ->
    a = this.getAttribute('class')
    index = this.getAttribute('value')
    $("#cart_item_product_color_id")[0].selectedIndex = index;
    color_id = $("#cart_item_product_color_id :selected").val()
    size_id = $("#cart_item_product_size_id :selected").val()
    locale = $("#locale").val()
    $.ajax
      url: "/products/quantity"
      type: "get"
      data:
        color_id: color_id
        size_id: size_id
        locale: locale