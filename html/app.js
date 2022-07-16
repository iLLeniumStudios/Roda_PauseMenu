const resourceName = window.GetParentResourceName();

window.addEventListener('message', function (event) {
  var v = event.data

  switch (v.action) {

    case 'show':
      ShowSettings()
      setTimeout(function () {
        $(document).bind("keyup", escapeHandler);
      }, 1000);
      break;

    case 'UpdateData':
      setValue(v.key, v.value)
      break;

    case 'updateJobs':
      $('.appendJobs').append(`
            <h1 class="RemoveShit">${v.label} ${v.job} : ${v.value}</h1>
          `)
      break;

    case 'updatePlayers':
      $('.footer h2').text(`Connected Players ${v.total}/${v.max}`)
      break;
      
    case 'closeMenu':
      CloseAll()
      break;
  }
})

function escapeHandler(e) {
  if (e.key === "Escape") {
    CloseAll();
  }
}

function setValue(key, value) {
  if ($('#' + key + '').text() != value) {
    if (!isNaN(value)) {
      var $this = $('#' + key + '');
      jQuery({ Counter: parseInt($this.text(), 10) }).animate({ Counter: value }, {
        duration: 2000,
        easing: 'swing',
        step: function (now) {
          var prefix = '$ ';
          if(key=='cash'){
            prefix = 'Cash: $ ';
          }else if(key=='bank'){
            prefix = 'Bank: $ ';
          }else if(key=='crypto'){
            prefix = 'Crypto: $ ';
          }
          $this.text(prefix + Math.ceil(now));
        }
      });
    } else {
      $('#' + key + '').text('' + value + '')
    }
  }
}

function ShowSettings() {
  $('.container-fluid').show(500)
  openUi = true
}

$(function () {
  $('#settingsPe').click(function () {
    $.post(`https://${resourceName}/SendAction`, JSON.stringify({ action: 'settings' }));
    CloseAll()
  })
  $('#mapita').click(function () {
    $.post(`https://${resourceName}/SendAction`, JSON.stringify({ action: 'map' }));
    CloseAll()
  })
  $('#resume').click(function () {
    CloseAll()
  })

  $('#discordinv').click(function () {
    window.invokeNative('openUrl', 'https://discord.gg/veDufrHnAn')
  })

  $('#tebexshop').click(function () {
    window.invokeNative('openUrl', 'https://roda.tebex.io/')
  })
})

function CloseAll() {
  $(document).unbind("keyup", escapeHandler);
  $('.RemoveShit').remove()
  $('.container-fluid').hide(500)
  $.post(`https://${resourceName}/exit`, JSON.stringify({}));
}
