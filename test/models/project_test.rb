require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = projects(:project_expertgrid)
  end

  test 'should create project' do
    project = Project.new(
      name: @project.name,
      time_period_start: @project.time_period_start,
      time_period_end: @project.time_period_end,
      schedule: @project.schedule,
      participants: @project.participants,
      location: @project.location,
      clients: @project.clients,
      expertise: @project.expertise,
      project_type: @project.project_type,
      key_topics: @project.key_topics
    )
    assert project.save
  end

  test 'should create project with valid start date format' do
    valid_start_date_formats = %w[2023-01-01 2023-02-01]
    valid_start_date_formats.each do |time_period_start|
      project = Project.new(
        name: @project.name,
        time_period_start:,
        time_period_end: '2023-12-31', # Ensure end date is after start date
        schedule: @project.schedule,
        participants: @project.participants,
        location: @project.location,
        clients: @project.clients,
        expertise: @project.expertise,
        project_type: @project.project_type,
        key_topics: @project.key_topics
      )
      assert project.valid?, I18n.t('projects.messages.project_should_be_valid_with_valid_start_date_format')
    end
  end

  test 'should create project with valid end date format' do
    valid_end_date_formats = %w[2023-12-31 2024-01-01]
    valid_end_date_formats.each do |time_period_end|
      project = Project.new(
        name: @project.name,
        time_period_start: '2023-01-01', # Ensure start date is before end date
        time_period_end:,
        schedule: @project.schedule,
        participants: @project.participants,
        location: @project.location,
        clients: @project.clients,
        expertise: @project.expertise,
        project_type: @project.project_type,
        key_topics: @project.key_topics
      )
      assert project.valid?, I18n.t('projects.messages.project_should_be_valid_with_valid_end_date_format')
    end
  end

  test 'should not create project with nil fields' do
    project = Project.new(
      name: nil,
      time_period_start: nil,
      time_period_end: nil,
      schedule: nil,
      participants: nil,
      location: nil,
      clients: nil,
      expertise: nil,
      project_type: nil,
      key_topics: nil
    )
    assert_not project.save, I18n.t('projects.messages.name_blank')
  end

  test 'should not create project with name too long' do
    project = Project.new(
      name: 'a' * 256,
      time_period_start: @project.time_period_start,
      time_period_end: @project.time_period_end,
      schedule: @project.schedule,
      participants: @project.participants,
      location: @project.location,
      clients: @project.clients,
      expertise: @project.expertise,
      project_type: @project.project_type,
      key_topics: @project.key_topics
    )
    assert_not project.save, I18n.t('projects.errors.name_too_long')
  end

  test 'should update project' do
    name_updated = 'Name_Updated'
    project = Project.find_by(name: @project.name)
    project.name = name_updated
    assert project.save, I18n.t('projects.messages.refreshed_success')
  end

  test 'should destroy project' do
    project = Project.create(
      name: @project.name,
      time_period_start: @project.time_period_start,
      time_period_end: @project.time_period_end,
      schedule: @project.schedule,
      participants: @project.participants,
      location: @project.location,
      clients: @project.clients,
      expertise: @project.expertise,
      project_type: @project.project_type,
      key_topics: @project.key_topics
    )
    assert_difference('Project.count', -1) do
      project.destroy
    end
  end
end
