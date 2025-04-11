json.extract! course_module, :id, :name, :created_at, :updated_at
json.url category_url(course_module, format: :json)
