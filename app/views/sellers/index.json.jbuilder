json.array!(@sellers) do |seller|
  json.extract! seller, :id, :first_name, :last_name, :street, :zip_code, :city, :email, :phone
  json.url seller_url(seller, format: :json)
end
