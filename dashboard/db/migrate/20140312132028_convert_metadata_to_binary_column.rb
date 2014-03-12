class ConvertMetadataToBinaryColumn < ActiveRecord::Migration
  def up
    change_column :scores, :metadata, :binary, :limit => 1024
    change_column :sandbox_scores, :metadata, :binary, :limit => 1024
  end
  
  def down
    change_column :scores, :metadata, :integer
    change_column :sandbox_scores, :metadata, :integer
  end
end
