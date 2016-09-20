//= require active_versioning/form-serialize
//= require active_versioning/lodash.custom

(function (global) {
  function send (form, callback) {
    var http   = new XMLHttpRequest();
    var params = global.FormSerialize(form, { hash: true });
    var method = (params['_method'] || form.method).toUpperCase();

    http.open(method, form.action, true);;

    // Send JSON because we already need to serialize form parameters into JSON
    // to extract the method
    http.setRequestHeader("Content-Type", "application/json");

    // Accept JSON to save on paint time rendering the admin again
    http.setRequestHeader("Accept", "application/json");

    http.send(JSON.stringify(params));

    http.addEventListener('readystatechange', function onUpdate (event) {
      // We don't care about the payload, so trigger the callback as *soon*
      // as we get the progress state, which indicates that content is loading.
      if (http.readyState >= 2) {
        http.removeEventListener('readystatechange', onUpdate);
        callback();
      }
    })

    return http;
  }

  function previewer (options) {
    options = options || {};

    var frame = document.createElement('iframe');
    var form  = document.querySelector('form');
    var request = null;

    frame.id = "live_preview";
    frame.frameBorder = 0;

    document.body.appendChild(frame);
    document.body.className += ' am-live-preview';

    var refresh = function () {
      frame.contentWindow.postMessage(options.url, window.location.origin);
    }

    var update = global._.debounce(function() {
      if (request) {
        request.abort();
      }

      request = send(form, refresh);
    }, 500, { leading: true, trailing: true, maxWait: 1500 });

    frame.onload = function() {
      frame.onload = null;
      refresh();
      form.addEventListener('change', update, true);
    };

    frame.src = options.frameSrc;

    return update;
  }

  global.ActivePreview = previewer;
})(window);
