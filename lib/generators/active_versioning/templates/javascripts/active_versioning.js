$(function() {
  $('a.commit-link').on('click', function(e) {
    e.preventDefault();

    $('.commit-draft').slideDown();
  });

  $('a.cancel-commit').on('click', function(e) {
    e.preventDefault();

    $('.commit-draft').slideUp();
  });
});
