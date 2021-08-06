class ChangeDataTypeForDescription < ActiveRecord::Migration[6.1]
  def change
    change_column :categories, :description, :string
  end
end
