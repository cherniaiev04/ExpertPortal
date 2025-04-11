json.extract! project, :id, :name, :time_period_start, :time_period_end, :schedule, :participants, :location, :clients,
              :expertise, :project_type, :key_topics, :created_at, :updated_at
json.url project_url(project, format: :json)
