class Board < ApplicationRecord
  REGEX_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :name, :width, :height, :mines, presence: :true
  validates_format_of :email, with: REGEX_EMAIL
  validates :width, :height, :mines, numericality: {only_integer: true, greater_than: 0, less_than: 10000}
  validate :validate_mines

  before_create :generate

  scope :recently_created, -> { order(created_at: :desc) }

  def validate_mines
    return false if width.nil? || height.nil? || mines.nil?
    errors.add :mines, "must be less than #{width * height}" if mines >= width * height
    errors.add :mines, ": enter valid width or height" if width.zero? || height.zero? || mines.zero?
  end

  def generate
    @width = self.width
    @height = self.height
    @mines = self.mines
    @board_matrix = Matrix.zero(@width, @height)
    @points = []
    0.upto(@width - 1) do |i|
      0.upto(@height - 1) do |j|
        @points.push [i, j]
      end
    end
    @points = @points.shuffle.first(@mines)
    @points.each do |point|
      @board_matrix[point.first, point.last] = 1
    end
    self.board_game = JSON.dump(@board_matrix.to_a)
  end
end
