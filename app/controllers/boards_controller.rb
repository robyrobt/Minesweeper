class BoardsController < ApplicationController
  def index
    @boards = Board.recently_created
    @board = Board.new
  end

  def new
    @boards = Board.recently_created.take(10)
    @board = Board.new
  end

  def show
    @board = Board.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render @board, status: :created, location: @board}
    end
  end

  def create
    @board = Board.new(board_params)
    @boards = Board.recently_created.take(10)

    respond_to do |format|
      if @board.save
        format.html { redirect_to board_url(@board) }
        format.json { render :show, status: :created, location: @board}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private
    def board_params
      params.require(:board).permit(:email, :name, :width, :height, :mines)
    end
end
