class AddImage < ActiveRecord::Migration[5.1]
  def change
        add_column :keywords, :image, :string, default: ''

  end
end
