require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "GET /index" do

    before do
      @board1 = Board.create!(name: 'test', email: 'test@example.com', width: 10, height: 18, mines: 5)
      @board2 = Board.create!(name: 'test2', email: 'test2@example.com', width: 10, height: 10, mines: 99)
    end

    after do
      Board.find(@board1.id).destroy!
      Board.find(@board2.id).destroy!
    end

    before(:each) do
      @ro_board = {
        "email" => 'test_ro@example.com',
        "name" => 'test_ro',
        "width" => 12,
        "height" => 12,
        "mines" => 6
      }
    end

    it "should return a board" do
      get board_url(@board1.id)
      expect(response).to have_http_status(:success)
      expect(response).to render_template('show')
    end

    it "should return all boards" do
      get '/boards'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it "should render new template" do
      get '/boards/new'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('new')
    end

    it "should render create template" do
      post '/boards', params: { board: { email: 'test@example.com', name: 'test new board created', width: 10, height: 10, mines: 5 }}
      expect(response).to have_http_status(302)
    end

    # ---- JSON ----

    it "should return all boards as json" do
      get '/boards.json'
      expect(response).to have_http_status(:success)
      expect(json.size).to eq(2)
    end

    it "should return a boards as json" do
      get "/boards/#{@board1.id}.json"
      expect(response).to have_http_status(:success)
      expect(json["email"]).to eq(@board1.email)
    end

    it "should return creates board as json" do
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(201)
      expect(json["email"]).to eq(@ro_board["email"])
      expect(json["name"]).to eq(@ro_board["name"])
    end

    it "should return errors when invalid email is send" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        @ro_board["email"] = invalid_address
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::EMAIL_IS_INVALID
      end
    end

    it "should return errors when invalid  name is send" do
      @ro_board["name"] = nil
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::NAME_CAN_NOT_BE_BLANK
    end

    it "should return errors when invalid width is send" do
      @ro_board["width"] = nil
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::WIDTH_CAN_NOT_BE_BLANK

      @ro_board["width"] = 3.4
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::WIDTH_MUST_BE_AN_INTEGER

      @ro_board["width"] = 200000
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::WIDTH_MUST_BE_LESS_THAN_NUMBER

      negative_width = [ -4, 0]
      negative_width.each do |neg_width|
        @ro_board["width"] = neg_width
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::WIDTH_MUST_BE_GREATER_THAN_NUMBER
      end

      invalid_width_type = [nil, "", "invalid", [3, 3], {"width" => 2, "height" => 2}]
      invalid_width_type.each do |inv_width|
        @ro_board["width"] = inv_width
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::WIDTH_IS_NOT_A_NUMBER
      end
    end

    it "should return errors when invalid height is send" do
      @ro_board["height"] = nil
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::HEIGHT_CAN_NOT_BE_BLANK

      @ro_board["height"] = 3.4
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::HEIGHT_MUST_BE_AN_INTEGER

      @ro_board["height"] = 200000
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::HEIGHT_MUST_BE_LESS_THAN_NUMBER

      negative_height = [ -4, 0]
      negative_height.each do |neg_height|
        @ro_board["height"] = neg_height
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::HEIGHT_MUST_BE_GREATER_THAN_NUMBER
      end

      invalid_height_type = [nil, "", "invalid", [3, 3], {"width" => 2, "height" => 2}]
      invalid_height_type.each do |inv_height|
        @ro_board["height"] = inv_height
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::HEIGHT_IS_NOT_A_NUMBER
      end
    end

    it "should return errors when invalid mines is send" do
      @ro_board["mines"] = nil
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::MINES_CAN_NOT_BE_BLANK

      @ro_board["mines"] = 3.4
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::MINES_MUST_BE_AN_INTEGER

      @ro_board["mines"] = 200000
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::MINES_MUST_BE_LESS_THAN_NUMBER + "10000"

      negative_height = [ -4, 0]
      negative_height.each do |neg_height|
        @ro_board["mines"] = neg_height
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::MINES_MUST_BE_GREATER_THAN_NUMBER
      end

      invalid_height_type = [nil, "", "invalid", [3, 3], {"width" => 2, "height" => 2}]
      invalid_height_type.each do |inv_height|
        @ro_board["mines"] = inv_height
        post '/boards.json', params: @ro_board, as: :json
        expect(response).to have_http_status(422)
        expect(json).to include Constants::MINES_IS_NOT_A_NUMBER
      end
    end

    it "should return error if mines are greater than width * height" do
      @ro_board["mines"] = 10000
      post '/boards.json', params: @ro_board, as: :json
      expect(response).to have_http_status(422)
      expect(json).to include Constants::MINES_MUST_BE_LESS_THAN_NUMBER + "#{@ro_board["width"] * @ro_board["height"]}"
    end

    it "board game should be generated after after Board is created" do
      board_game = JSON.parse(@board1.board_game)
      expect(board_game.length).to eq(@board1.width)
      expect(board_game[0].length).to eq(@board1.height)
      expect(ApplicationController.helpers.count_mines(board_game)).to eq(@board1.mines)
    end

    it "board game should be generated after after Board is created" do
      board_game = JSON.parse(@board2.board_game)
      expect(ApplicationController.helpers.count_mines(board_game)).to eq(@board2.mines)
      expect(ApplicationController.helpers.count_zeros(board_game)).to eq(1)
    end
  end
end
