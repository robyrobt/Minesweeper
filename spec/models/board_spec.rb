require 'rails_helper'

RSpec.describe Board, type: :model do

  describe "Test Model" do
      let(:first_board) { Board.create(
        name: "New Board",
        email: "test@example.com",
        width: 10,
        height: 10,
        mines: 5)
      }

    it "Empty board is not valid" do
      board = Board.new
      expect(board).to_not be_valid
      expect(board.errors).to_not be_empty
    end

    it "Board with valid data should be valid" do
      expect(first_board ).to be_valid
      expect(first_board.name).to eq("New Board")
      expect(first_board.email).to eq("test@example.com")
      expect(first_board.width).to eq(10)
      expect(first_board.height).to eq(10)
      expect(first_board.mines).to eq(5)
      expect(first_board.errors).to be_empty
    end

    it "Board with empty email should not be valid" do
      first_board.email = nil
      expect(first_board).to_not be_valid
    end

    it "Board with invalid email should not be valid" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |valid_address|
        first_board.email = valid_address
        expect(first_board).to_not be_valid
      end
    end

    it "Board with empty name should not be valid" do
      first_board.name = nil
      expect(first_board).to_not be_valid
    end

    it "Board with invalid width should not be valid" do
      invalid_number_range_width = [nil, 0, -4, 4.3, 100001, 0.3, "", "invalid", [3, 3], {"width" => 2, "height" => 2}]
      invalid_number_range_width.each do |width|
        first_board.width = width
        expect(first_board).to_not be_valid
      end
    end

    it "Board with height" do
      invalid_height = [nil, 0, -4, 4.3, 100001, 0.3, "", "invalid", [3, 3], {"width" => 2, "height" => 2}]
      invalid_height.each do |height|
        first_board.height = height
        expect(first_board).to_not be_valid
      end
    end

    it "Board with invalid mines" do
      invalid_mines = [nil, 160, 230, 0, -2, 1000000, "", "invalid mine", ["mine", "invalid mine"], {"mine" =>" invalid mine"}]
      invalid_mines.each do |mine|
        first_board.mines = mine
        expect(first_board).to_not be_valid
      end
    end

    it "Board game is created and have correct number of mines" do
      expect(first_board).to be_valid
      expect(ApplicationController.helpers.count_mines(JSON.parse(first_board.board_game))).to eq(5)
    end
  end
end
