class AddContextToKeywords < ActiveRecord::Migration[5.1]
  def change
    add_column :keywords, :group, :string, default: ''
    add_column :keywords, :context, :string, default: ''
  end
end
