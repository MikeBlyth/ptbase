# Growth Chart
jQuery ->
  Morris.Line
    element: 'growth_chart'
    data: $('#growth_chart').data('growth')
#    data: [
#      {age:0, weight: 3}
#      {age: 0.5, weight: 6}
#      {age: 1, weight: 10}
#    ]
    xkey: 'age'
    ykeys: ['weight', 'weight50', 'height', 'height50']
    labels: ['Weight', 'Weight 50%ile', "Height", "Height 50%ile"]
    parseTime: false
#    xLabelFormat: (x) -> 'a'

