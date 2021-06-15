//= require spree/backend

// spree's version only handles 'input', not 'select', and this breaks spree_volume_pricing

$(function () {
  $('#add_volume_price').click( function() {
    var target = $(this).data("target"),
      new_table_row = $(target + ' tr:visible:first');
    new_table_row.find('div.select2').remove();
    $('select.select2').select2({
      allowClear: true,
      dropdownAutoWidth: true
    });
  });

});

$.fn.userAutocomplete = function () {
  'use strict'

  if (this.length > 0) {
    this.select2({
      placeholder: 'Choose an user',
      minimumInputLength: 2,
      multiple: true,
      ajax: {
        url: Spree.routes.users_api,
        datatype: 'json',
        data: function (params) {
          var query = {
            q: {
              email_cont: params.term
            },
            supplier_id: $('#pricing_tier_supplier_credential_attributes_supplier_id').val(),
            token: Spree.api_key
          }

          return query
        },
        processResults: function (data) {
          return {
            results: data.users
          }
        }
      },
      templateResult: function (data) {
        return data.email
      },
      templateSelection: function (data) {
        return data.email
      }
    })
  }
}

$(document).ready(function () {
  'use strict';

  $('#pricing_tier_user_ids').userAutocomplete()

  $(document).on('change', '.supplier_select', function(e) {
    var supplier_id = e.currentTarget.value
    window._this = this;
    var url = "/shop/admin/suppliers/"+supplier_id+"/pricing_tiers"
    $.ajax({
      type: "GET",
      dataType: "json",
      url: url.toString(),
      data: {
        token: Spree.api_key
      },
        success: function(response) {
        var $el = $(_this).closest('tr').find('select.pricing_tier_select')
        $el.empty(); // remove old options
        $.each(response, function(index, option) {
          $el.append($("<option></option>")
             .attr("value", option['value']).text(option['text']));
        });
        $('select.select2').select2({
          allowClear: true,
          dropdownAutoWidth: true
        });
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
      }
    });
  });

  // Added custom function to remove volume price row when delete action is performed
  $('.spree_remove_volume_price').click( function() {
    var $el = $(this);
    $el.prev("input[type=hidden]").val("1");
    $el.closest(".fields").hide();
    if ($el.prop("href").substr(-1) == '#') {
      $el.parents("tr").fadeOut('hide');
    }else if ($el.prop("href")) {
      $.ajax({
        type: 'POST',
        url: $el.prop("href"),
        data: {
          _method: 'delete',
          authenticity_token: AUTH_TOKEN
        },
        success: function(response) {
          $el.parents("tr").fadeOut('hide', function() {
            this.nextElementSibling.remove();
            $(this).remove();
          });
        },
        error: function(response, textStatus, errorThrown) {
          show_flash('error', response.responseText);
        }

      })
    }
    return false;
  });
});