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
});