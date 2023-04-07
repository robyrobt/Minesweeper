json.extract! board, :id, :name, :email, :width, :height, :mines, :created_at, :updated_at
json.url board_url(board, format: :json)
