jQuery ->
  $('#paintings').sortable
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))

  $('#recommends').sortable
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))

  $('#new_product_pic').fileupload
    dataType: "script"
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#new_product_pic').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
