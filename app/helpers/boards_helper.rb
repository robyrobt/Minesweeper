module BoardsHelper
  def display_icon(options)
    icons =  {
      0 => "<span>&#11036;</span>".html_safe,
      1 => "<span>&#128163;</span>".html_safe
    }
    icons[options]
  end

  def count_mines(matrix)
    matrix.collect{ |line| line.count(1)}.sum
  end

  def count_zeros(matrix)
    matrix.collect{ |line| line.count(0)}.sum
  end

end
