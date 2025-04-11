Project.find_each do |project|
    begin
      if project.location.is_a?(String)
        project.update(location: [project.location])
        puts "Fixed location for Project ID #{project.id}: #{project.location.inspect}"
      elsif project.location.nil?
        project.update(location: [])
        puts "Set empty array for Project ID #{project.id}"
      end
    rescue JSON::ParserError => e
      puts "Error processing Project ID #{project.id}: #{e.message}"
    end
  end
  