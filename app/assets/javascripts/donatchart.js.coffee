class @BarChart
  create: (canvas_selector) ->
    if $(canvas_selector + '[data-url]').length
      $.get $(canvas_selector).attr('data-url'), (json) ->
        values = $.map json, (element) -> element[1]
        labels = $.map json, (element) -> element[0]
        data =
          labels: labels
          datasets: [
            label: 'hae'
            fillColor: 'rgba(20,80,255,1)'
            data: values
          ]
        new Chart($(canvas_selector).get(0).getContext('2d')).Bar(data)
