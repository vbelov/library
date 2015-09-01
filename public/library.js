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
                $('<td>').text(book.year)
            ).appendTo(table_content);
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