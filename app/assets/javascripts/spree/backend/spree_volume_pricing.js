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

$(document).ready(function () {
  'use strict';

  function formatUser(user) {
    return Select2.util.escapeMarkup(user.email);
  }

  if ($('#pricing_tier_user_ids').length > 0) {
    $('#pricing_tier_user_ids').select2({
      placeholder: 'Choose an user',
      minimumInputLength: 1,
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.users_api, {
          ids: element.val(),
          token: Spree.api_key
        });
        return $.getJSON(url, null, function (data) {
          return callback(data.users);
        });
      },
      ajax: {
        url: Spree.routes.users_api,
        quietMillis: 200,
        datatype: 'json',
        data: function (term) {
          return {
            q: {
              email_cont: term
            },
            supplier_id: $('#pricing_tier_supplier_credential_attributes_supplier_id').val(),
            token: Spree.api_key
          };
        },
        results: function (data) {
          return {
            results: data.users
          };
        }
      },
      formatResult: formatUser,
      formatSelection: formatUser
    });
  }

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