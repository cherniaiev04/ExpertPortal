require 'test_helper'

class ExpertTest < ActiveSupport::TestCase
  test 'assert fixtures' do
    assert_equal Expert.count, 3
    assert_equal experts(:alice).category_ids, [1, 2]
    assert_equal experts(:alice).categories, [categories(:computer_science), categories(:digitalize)]
  end

  test 'create valid expert' do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id],
                           telephone: '0049 123 89074205')
    assert expert.save
    expert.reload
    assert_equal expert.name, 'Bühl'
    assert_equal expert.categories, [categories(:science)]
  end

  test 'create complete expert' do
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
                           cooperation: 'Produktentwicklung',
                           hourlyRate: 100,
                           dailyRate: 1000,
                           expInChina: 'Ich habe in China für 2 Jahre gearbeitet',
                           additionalInfo: 'Keine')
    assert expert.save
    expert.reload
    assert_equal expert.name, 'Bühl'
    assert_includes expert.categories, categories(:science)
    assert_includes expert.categories, categories(:computer_science)
  end

  test "don't create expert without salutation" do
    expert = Expert.create(name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id],
                           telephone: '0049 123 89074205')
    assert_not expert.save
    assert_includes expert.errors[:salutation], I18n.t('experts.errors.salutation_missing')
  end

  test "don't create expert without name" do
    expert = Expert.create(salutation: 'Frau',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id],
                           telephone: '0049 123 89074205')
    assert_not expert.save
    assert_includes expert.errors[:name], I18n.t('experts.errors.name_missing')
  end

  test "don't create expert without firstname" do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id],
                           telephone: '0049 123 89074205')
    assert_not expert.save
    assert_includes expert.errors[:firstname], I18n.t('experts.errors.firstname_missing')
  end

  test "don't create expert without email" do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           category_ids: [categories(:science).id],
                           telephone: '0049 123 89074205')
    assert_not expert.save
    assert_includes expert.errors[:email], I18n.t('experts.errors.email_missing')
  end

  test "don't create expert without categories" do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           telephone: '0049 123 89074205')
    assert_not expert.save
    assert_includes expert.errors[:categories], I18n.t('experts.errors.category_missing')
  end

  test "don't create expert without telephone" do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           category_ids: [categories(:science).id])
    assert_not expert.save
    assert_includes expert.errors[:telephone], I18n.t('experts.errors.telephone_missing')
  end

  test "don't create expert without institution if institution_bool is true" do
    expert = Expert.create(salutation: 'Frau',
                           name: 'Bühl',
                           firstname: 'Dorothea',
                           email: 'Dorothea.Buehl@gmx.de',
                           telephone: '0049 123 89074205',
                           institution_bool: true,
                           category_ids: [categories(:science).id])
    assert_not expert.save
    assert_includes expert.errors[:institution], I18n.t("experts.errors.institution_missing")
  end

  test 'update expert' do
    expert = experts(:alice)
    assert_equal expert.name, 'Fischer'
    expert.update(name: 'Schön')
    expert.reload
    assert_equal expert.name, 'Schön'
  end

  test 'update expert categories' do
    expert = experts(:alice)
    assert_includes expert.categories, categories(:computer_science)
    expert.update(category_ids: categories(:digitalize).id)
    expert.reload
    assert_not_includes expert.categories, categories(:computer_science)
    expert.update(category_ids: categories(:computer_science).id)
    expert.reload
    assert_includes expert.categories, categories(:computer_science)
  end

  test "don't update expert without categories" do
    expert = experts(:alice)
    expert.update(category_ids: nil)
    assert_not expert.save
    assert_includes expert.errors[:categories], I18n.t('experts.errors.category_missing')
  end

  test 'delete expert' do
    expert = experts(:alice)
    assert_difference('Expert.count', -1) do
      expert.destroy
    end
    assert_raises ActiveRecord::RecordNotFound do
      Expert.find(expert.id)
    end
  end

  test 'no categories deleted on expert deletion' do
    expert = experts(:alice)
    assert_no_difference('Category.count') do
      assert expert.destroy
    end
  end

  # debatable if these make sense if there's no REGEX in model
  test 'assert valid emails' do
    expert = experts(:alice)

    valid_emails = [
      'user@example.com',
      'user.name@example.com',
      'user+tag@example.com',
      'user_name@example.com',
      'user@example.co.uk',
      'user@sub.example.com',
      'user@domain.com',
      'user123@domain.org',
      'firstname.lastname@gmail.com',
      'user@outlook.com',
      'user@protonmail.com',
      'user@icloud.com',
      'user@zoho.com',
      'user@domain.info',
      'user@domain.travel',
      'user@domain.jobs'
    ]

    valid_emails.each do |email|
      expert.update(email:)
      assert expert.valid?, "#{email} should be valid"
    end
  end

  test 'assert valid phone numbers' do
    expert = experts(:alice)
    valid_numbers = ['+49 123 456 7890', '(123) 456-7890', '123.456.7890', '1234567890']

    valid_numbers.each do |number|
      expert.update(telephone: number)
      assert expert.valid?, "#{number} should be valid"
    end
  end

  test 'attach cv to expert' do
    expert = experts(:alice)
    file_path = Rails.root.join('test', 'fixtures', 'files', 'sample.pdf')
    expert.cv.attach(io: File.open(file_path), filename: 'sample.pdf', content_type: 'application/pdf')
    assert expert.cv.attached?
    assert_equal 'sample.pdf', expert.cv.filename.to_s
  end

  test 'expert without cv' do
    expert = experts(:alice)
    assert_not expert.cv.attached?
  end

  test 'delete cv' do
    expert = experts(:alice)
    file_path = Rails.root.join('test', 'fixtures', 'files', 'sample.pdf')
    expert.cv.attach(io: File.open(file_path), filename: 'sample.pdf', content_type: 'application/pdf')
    assert expert.cv.attached?
    expert.cv.purge
    assert_not expert.cv.attached?
  end

  test 'expert without certificates' do
      expert = experts(:alice) # Use a fixture or create a new expert
      assert_not expert.certificates.attached?, 'Certificates should not be attached initially'
  end

  test 'attach multiple certificates' do
    expert = experts(:alice)
    file_path1 = Rails.root.join('test', 'fixtures', 'files', 'certificate1.pdf')
    file_path2 = Rails.root.join('test', 'fixtures', 'files', 'certificate2.pdf')

    # Attach multiple files
    expert.certificates.attach([
      { io: File.open(file_path1), filename: 'certificate1.pdf', content_type: 'application/pdf' },
      { io: File.open(file_path2), filename: 'certificate2.pdf', content_type: 'application/pdf' }
    ])

    assert expert.certificates.attached?, 'Certificates should be attached'
    assert_equal 2, expert.certificates.count, 'Two certificates should be attached'

    filenames = expert.certificates.map(&:filename).map(&:to_s)
    assert_includes filenames, 'certificate1.pdf', 'certificate1.pdf should be attached'
    assert_includes filenames, 'certificate2.pdf', 'certificate2.pdf should be attached'
  end

  test 'delete a single certificate' do
    expert = experts(:alice)
    file_path1 = Rails.root.join('test', 'fixtures', 'files', 'certificate1.pdf')
    file_path2 = Rails.root.join('test', 'fixtures', 'files', 'certificate2.pdf')

    # Attach multiple files
    expert.certificates.attach([
      { io: File.open(file_path1), filename: 'certificate1.pdf', content_type: 'application/pdf' },
      { io: File.open(file_path2), filename: 'certificate2.pdf', content_type: 'application/pdf' }
    ])

    # Ensure both files are attached
    assert_equal 2, expert.certificates.count, 'Two certificates should be attached'

    # Find and delete the first certificate
    certificate_to_delete = expert.certificates.find { |c| c.blob.filename.to_s == 'certificate1.pdf' }
    certificate_to_delete.purge
    expert.reload

    assert_equal 1, expert.certificates.count, 'One certificate should remain after deletion'
    filenames = expert.certificates.map { |c| c.blob.filename.to_s }
    assert_not_includes filenames, 'certificate1.pdf', 'certificate1.pdf should be deleted'
    assert_includes filenames, 'certificate2.pdf', 'certificate2.pdf should still be attached'
  end

end
