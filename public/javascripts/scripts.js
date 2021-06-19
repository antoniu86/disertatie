function cancel_form(back_url) {
  $.confirm({
    title: 'Confirm!',
    content: 'Are you sure you want to cancel?',
    buttons: {
      yes: function () {
        window.location = back_url;
      },
      no: function () { /* do nothing */ }
    }
  });
}

function submit_form(element) {
  var container = $(element).parents('.container');
  var form = container.find('form');

  if (form.length == 1) {
    form.submit();
  }
}

function confirm_delete(element) {
  $.confirm({
    title: 'Confirm!',
    content: 'Are you sure you want to delete?',
    buttons: {
      yes: function () {
        window.location = $(element).attr('href');
      },
      no: function () { /* do nothing */ }
    }
  });
}

function confirm_unmark_to_water(element, date) {
  $.confirm({
    title: 'Confirm!',
    content: 'This will stop the manual start of the water. Are you sure?',
    buttons: {
      yes: function () {
        window.location = $(element).attr('href');
      },
      no: function () { /* do nothing */ }
    }
  });
}

function confirm_mark_to_water(element, date) {
  $.confirm({
    title: 'Confirm!',
    content: 'You manually request the device to pump water. Are you sure?',
    buttons: {
      yes: function () {
        window.location = $(element).attr('href');
      },
      no: function () { /* do nothing */ }
    }
  });
}

function check_water(element, last_watered_at) {
  window.location = $(element).attr('href');
}

function ajax_submit_password_change(element, event) {
  event.preventDefault();

  var form = $(element).parents('form');
  var password = form.find('#user_password');
  var password_confirmation = form.find('#user_password_confirmation');

  $.post(form.attr('action'), {user: {password: password.val(), password_confirmation: password_confirmation.val()}}, function(response) {
    if (response.error) {
      $.alert({title: 'Alert!', content: response.error});
    } else {
      $.alert({title: 'Yeey!', content: 'The changes were successfully saved.'});
    }
  });
}

function ajax_submit_public_profile(element, event) {
  event.preventDefault();

  var form = $(element).parents('form');
  var username = form.find('#user_username');
  var enable = form.find('#user_public_profile');

  $.post(form.attr('action'), {user: {username: username.val(), public_profile: enable.is(':checked')}}, function(response) {
    if (response.error) {
      $.alert({title: 'Alert!', content: response.error});
    } else {
      $.alert({title: 'Yeey!', content: 'The changes were successfully saved.'});
    }
  });
}

function delete_account(element, event) {
  event.preventDefault();

  var form = $(element).parents('form');
  var input = form.find('#delete_account_text');

  if (input.val() == "") {
    $.alert({
      title: 'Alert!',
      content: 'Please enter the safety text in the input.'
    });

    return false;
  }

  if (input.val() != "delete my account") {
    $.alert({
      title: 'Alert!',
      content: 'Please enter the correct safety text in the input.'
    });

    return false;
  }

  $.confirm({
    title: 'DANGER!',
    content: 'YOU ARE ABOUT TO DELETE YOUR ACCOUNT AND ALL DATA RELATED TO IT. ARE YOU SURE?',
    buttons: {
      yes: function () {
        $.confirm({
          title: 'DANGER!',
          content: 'ARE YOU REALLY REALLY SURE?',
          buttons: {
            yes: function () {
              form.submit();
            },
            no: function () { /* do nothing */ }
          }
        });
      },
      no: function () { /* do nothing */ }
    }
  });
}