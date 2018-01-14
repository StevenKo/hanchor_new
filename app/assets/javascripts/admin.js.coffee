jQuery ->
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

jQuery ->
  $('#select_all').click (e) ->
    $('input[name=\'products[is_select][]\']').each ->
      $(this).prop 'checked', true
    e.preventDefault()

jQuery ->
  $('#unselect_all').click (e) ->
    $('input[name=\'products[is_select][]\']').each ->
      $(this).prop 'checked', false
    e.preventDefault()


jQuery ->
  $('#discount_rule_discount_type').change ->
    $('input').each ->
      $(this).prop('disabled', false);

    id = $(this).find('option:selected').attr('value')

    switch id
      when 'percentage'
        $('#discount_rule_discount_money').prop('disabled', true)
        $('#discount_rule_discount_money').val('');
      when 'cash'
        $('#discount_rule_discount_percentage').prop('disabled', true)
        $('#discount_rule_discount_percentage').val('');
      when "free_shipping"
        $('#discount_rule_discount_money').prop('disabled', true)
        $('#discount_rule_discount_percentage').prop('disabled', true)
        $('#discount_rule_discount_money').val('');
        $('#discount_rule_discount_percentage').val('');
    return

  $('#discount_rule_discount_type').trigger("change");