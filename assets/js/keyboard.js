function getKey (e) {
  var code = e.keyCode || e.which;
  if (!e.repeat && 65 <= code && code <= 90) {
    return document.querySelector(`[data-char=${e.key}]`);
  }
}

document.body.addEventListener('keydown', function (e) {
  var key = getKey(e);
  key && key.setAttribute('data-pressed', 'on');
});

document.body.addEventListener('keyup', function (e) {
  var key = getKey(e);
  key && key.removeAttribute('data-pressed');
});
