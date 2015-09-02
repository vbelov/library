function convertPerYearStats(data) {
    var pairs = [];
    for(var year in data) {
        if (data.hasOwnProperty(year)) {
            pairs.push([year, data[year]]);
        }
    }
    pairs = pairs.sort(function(pair1, pair2){
        if (pair1[0] < pair2[0]) return -1;
        if (pair1[0] > pair2[0]) return 1;
        return 0;
    });
    var labels = [], values = [];
    for (var i = 0; i < pairs.length; i++) {
        labels.push(pairs[i][0]);
        values.push(pairs[i][1]);
    }
    return {labels: labels, values: values};
}

function setupChart1(){
    var ctx = document.getElementById("booksPerYear").getContext("2d");

    $.get('/api/stats/books_per_year', {}, function(str){
        var data = $.parseJSON(str);

        data = convertPerYearStats(data);

        var chart_data = {
            labels: data['labels'],
            datasets: [
                {
                    label: "Books published per year",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,0.8)",
                    highlightFill: "rgba(220,220,220,0.75)",
                    highlightStroke: "rgba(220,220,220,1)",
                    data: data['values']
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
        data = convertPerYearStats(data);

        var chart_data = {
            labels: data['labels'],
            datasets: [
                {
                    label: "Books of most productive authors",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,0.8)",
                    highlightFill: "rgba(220,220,220,0.75)",
                    highlightStroke: "rgba(220,220,220,1)",
                    data: data['values']
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

$('.delete-books button').click(function(){
    var year = $('#yearToDelete').val();
    $.ajax({
        type: "DELETE",
        url: '/api/books_for_year',
        data: {year: year},
        success: function(){
            window.location.reload();
        }
    });
    return false;
});
