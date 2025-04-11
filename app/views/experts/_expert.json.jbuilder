json.extract! expert, :id, :name, :firstname, :email, :expertise, :institution, :additionalInfo, :category_id,
              :created_at, :updated_at
json.url expert_url(expert, format: :json)
