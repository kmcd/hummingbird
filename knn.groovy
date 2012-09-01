def ndx10_minute() {
  classification = null
  
  switch( (Math.random() * 10) as int ) {
    case 1..3 : classification = 'long'   ; break
    case 4..6 : classification = 'short'  ; break
    default   : classification = 'n/a'          
  }
  
  [ 'intc':   Math.random()/100, 
    'appl':   Math.random()/100,
    'goog':   Math.random()/100,
    'msft':   Math.random()/100,
    'csco':   Math.random()/100,
    'orcl':   Math.random()/100,
    'vrzn':   Math.random()/100,
    'qcom':   Math.random()/100,
    'cmcsa':  Math.random()/100,
    'amgn':   Math.random()/100,
    'qqq':    classification ]
}

ndx10_3days = []
(391*3).times {
  ndx10_3days << ndx10_minute()
}

class Knn {
  def examples
  Knn( examples ) { this.examples = examples }
  
  def classify( data_point ) {
    def distances = []
    examples.each {
      distances << distance( data_point, it)
    }
    println distances.sort()[0..7]
  }
  
  def distance( point_1, point_2 ) {
    def sum_sq = 0
    point_1.each {
      if ( it.key == 'qqq' ) { return } // could pre-filter this
      sum_sq += ( it.value - point_2[it.key] ) ** 2
    }
    Math.sqrt(sum_sq)
  }
}

knn = new Knn( ndx10_3days )
knn.classify( ndx10_minute() )
