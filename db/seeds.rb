2.upto(100) do |t|
  Board.create([
    {
      "name": "Minesweeper#{t}",
      "email": "minesweeper#{t}@example.com",
      "width": rand(100),
      "height": rand(100),
      "mines": rand(1000)
    }
  ])
end