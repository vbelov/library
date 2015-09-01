function setupChart1(){
    var ctx = document.getElementById("booksPerYear").getContext("2d");

    $.get('/api/stats/books_per_year', {}, function(str){
        var data = $.parseJSON(str);
        var labels = data.map(function(el){
            return el.year;
        });
        var values = data.map(function(el){
            return el.count;
        });

        var chart_data = {
            labels: labels,
            datasets: [
                {
                    label: "Books published per year",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,0.8)",
                    highlightFill: "rgba(220,220,220,0.75)",
                    highlightStroke: "rgba(220,220,220,1)",
                    data: values
                }
            ]
        };
        new Chart(ctx).Bar(chart_data, {scaleBeginAtZero: false});
    });
}

function setupChart2(){
    var ctx = document.getElementById("booksOfMostProductiveAuthors").getContext("2d");

    $.get('/api/stats/books_of_most_productive_authors', {}, function(str){
        var data = $.parseJSON(str);
        var labels = data.map(function(el){
            return el.year;
        });
        var values = data.map(function(el){
            return el.count;
        });

        var chart_data = {
            labels: labels,
            datasets: [
                {
                    label: "Books of most productive authors",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,0.8)",
                    highlightFill: "rgba(220,220,220,0.75)",
                    highlightStroke: "rgba(220,220,220,1)",
                    data: values
                }
            ]
        };
        new Chart(ctx).Bar(chart_data);
    });
}

function setupChart3(){
    var ctx = document.getElementById("firstLetter").getContext("2d");

    $.get('/api/stats/first_letter_of_book_title', {}, function(str){
        var data = $.parseJSON(str);
        var labels = data.map(function(el){
            return el.first_letter;
        });
        var values = data.map(function(el){
            return el.count;
        });

        var chart_data = {
            labels: labels,
            datasets: [
                {
                    label: "First letter of book titles stats",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,0.8)",
                    highlightFill: "rgba(220,220,220,0.75)",
                    highlightStroke: "rgba(220,220,220,1)",
                    data: values
                }
            ]
        };
        new Chart(ctx).Bar(chart_data);
    });
}

$(document).ready(function(){
    setupChart1();
    setupChart2();
    setupChart3();
});
