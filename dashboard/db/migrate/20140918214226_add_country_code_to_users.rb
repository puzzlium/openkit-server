class AddCountryCodeToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :countryCode, :string
  end
end
