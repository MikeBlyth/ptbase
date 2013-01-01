# Growth Chart
jQuery ->
  Morris.Line
    element: 'growth-chart',
    data: $('growth').data('chart-data')
    xkey: 'y',
    ykeys: ['a'],
    labels: ['Series A']

