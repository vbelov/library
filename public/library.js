var currentPage = 0;

function loadPage(page, pushState) {
    if (currentPage == 0) {
        $('#previous-page').parent().addClass('disabled');
    } else {
        $('#previous-page').parent().removeClass('disabled');
    }

    $.get('/api/books', {page: page}, function(data){
        var table_content = $('#books tbody');
        table_content.empty();
        var books = $.parseJSON(data);
        for (var i = 0; i < books.length; i++) {
            var book = books[i];
            var authors = "";
            for (var j = 0; j < book.authors.length; j++) {
                if (authors.length > 0) authors += ', ';
                authors += book.authors[j].name;
            }
            var row = $('<tr>').append(
                $('<td>').text(book.name),
                $('<td>').text(authors),
                $('<td>').text(book.year),
                $('<td><button type="button" class="btn btn-danger delete-book">Delete</button></td>')
            ).appendTo(table_content);

            (function(){
                var book_id = book.id;
                var $row = row;
                row.find('.delete-book').click(function(){
                    if (confirm("Are you sure?") == true) {
                        $.ajax({
                            type: "DELETE",
                            url: '/api/books/' + book_id,
                            success: function(){
                                $row.fadeOut(500, function(){
                                    loadPage(currentPage);
                                });
                            }
                        });
                    }
                });
            })();
        }

        if (pushState) history.pushState({page: currentPage}, '', '/books?page=' + currentPage);
    });
}

$('#previous-page').click(function(){
    currentPage -= 1;
    loadPage(currentPage, true);
    return false;
});

$('#next-page').click(function(){
    currentPage += 1;
    loadPage(currentPage, true);
    return false;
});

function loadCurrentPage() {
    var match,
        search = /page=([^&]*)/g,
        query  = window.location.search.substring(1);

    if (match = search.exec(query)) {
        currentPage = parseInt(match[1]);
    }
}

window.onpopstate = function(event) {
    if (event.state) {
        currentPage = event.state.page;
        loadPage(currentPage, false);
    }
};

$(document).ready(function(){
    loadCurrentPage();
    loadPage(currentPage, true);
});

$('#add-book').click(function(){
    $('#new-book').show();
    $('#bookTitle').focus();
});

$('#new-book .cancel').click(function(){
    $('#new-book').hide();
    $('#new-book input').val('');
    $('#new-book .alert').hide();
    return false;
});

$('#new-book .save').click(function(){
    $('#new-book .alert').hide();

    var book = {
        name: $('#bookTitle').val(),
        year: $('#bookYear').val()
    };
    $.post('/api/books', book, function(data){
        $('#new-book').hide();
        $('#new-book input').val('');
        $('#book-saved').show().fadeOut(1500);
    }).fail(function(obj){
        var errors = $.parseJSON(obj.responseText).errors2;
        var msg = '';
        for (var j = 0; j < errors.length; j++) {
            if (msg.length > 0) msg += '<br/>';
            msg += errors[j];
        }

        $('#new-book .alert').show();
        $('#new-book .alert .message').html(msg);
    });

    return false;
});
