class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :question, :limit => 1000, :null => false
      t.text :answer, :null => false
      t.integer :position, :default => 0
      t.integer :activity_category_id
      t.timestamps
    end
    add_index :questions, :position
  end

  def self.down
    drop_table :questions
  end
end
