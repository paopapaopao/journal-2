class AddPriorityToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :priority, :datetime
  end
end
