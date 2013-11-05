class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.text :self_summary
      t.text :life_story
      t.text :favorite_things
      t.text :looking_for
      t.timestamps
    end
  end
end
