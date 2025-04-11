require 'application_system_test_case'

class ExpertsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @expert = experts(:alice)
    @admin = users(:admin_janet)
    sign_in @admin
  end

  test 'should cancel creating new Expert' do
    visit experts_url
    click_on I18n.t('experts.new_expert')
    click_on I18n.t('general.cancel')

    assert_selector 'h1', text: I18n.t('experts.experts')
  end

  test 'should cancel editing Expert' do
    visit expert_url(@expert)
    click_on I18n.t('general.change')

    click_on I18n.t('general.cancel')

    assert_selector 'h2',
                    text: "#{I18n.t('experts.expert_upcase')} #{@expert.title.upcase} #{@expert.firstname.upcase} #{@expert.name.upcase}"
  end

  test 'should go back to experts from expert' do
    visit expert_url(@expert)
    click_on I18n.t('general.back')

    assert_selector 'h1', text: I18n.t('experts.experts')
  end

  test 'should click on table row to go to expert' do
    visit experts_url
    find("tr[data-expert-id='#{@expert.id}']").click

    assert_selector 'h2',
                    text: "#{I18n.t('experts.expert_upcase')} #{@expert.title.upcase} #{@expert.firstname.upcase} #{@expert.name.upcase}"
  end

  test 'should show confirmation popup when clicking delete' do
    visit expert_url(@expert)
    click_on I18n.t('general.delete')

    assert_selector '#deleteModal', visible: true
    assert_text I18n.t('experts.confirm_delete')
  end

  test 'should close popup when clicking cancel' do
    visit expert_url(@expert)
    click_on I18n.t('general.delete')

    click_on I18n.t('general.cancel')

    assert_no_selector '#deleteModal', visible: true
    assert_text @expert.name
  end

  test 'should keep popup open when clicking outside modal' do
    visit expert_url(@expert)

    click_on I18n.t('general.delete')

    assert_selector '#deleteModal', visible: true
    assert_text I18n.t('experts.confirm_delete')

    find('body').click

    assert_selector '#deleteModal', visible: true
    assert_text I18n.t('experts.confirm_delete')
  end

  test "shows the institution field when the checkbox is checked" do
    visit new_expert_path
    assert_not find('input#expert_institution_bool').checked?

    check 'expert_institution_bool'
    assert_selector 'div#institution_container.d-block'
  end

  test "hides the institution field when the checkbox is unchecked" do
    expert = Expert.create(salutation: 'Frau',
                           title: 'Dr.',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id,
                                          categories(:computer_science).id],
                           expertise: 'Chemie',
                           institution_bool: true,
                           institution: 'Universität Konstanz',
                           telephone: '0049 123 89074205',
                           nationality: 'Deutsch',
                           hourlyRate: 100,
                           dailyRate: 1000,
                           expInChina: 'Ich habe in China für 2 Jahre gearbeitet',
                           additionalInfo: 'Keine')
    visit edit_expert_path(expert)
    assert find('input#expert_institution_bool').checked?
    assert_selector 'div#institution_container.d-block'

    uncheck 'expert_institution_bool'
    assert_not find('input#expert_institution_bool').checked?
  end
end
