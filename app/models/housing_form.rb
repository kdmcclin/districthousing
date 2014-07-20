class HousingForm < ActiveRecord::Base
  attr_accessible :name, :uri, :location, :lat, :long
  has_and_belongs_to_many :form_fields

  class << self
    def create_from_path path
      new_form = new(uri: path)

      PDF_FORMS.get_field_names(path).each do |field_name|
        new_form.form_fields << FormField.find_or_create_by(name: field_name)
      end

      new_form.detect_location!

      new_form.save
    end
  end

  def name
    unless read_attribute(:name).blank?
      read_attribute(:name).to_s
    else
      File.basename read_attribute(:uri)
    end
  end

  def detect_location!
    metadata_output = PDF_FORMS.call_pdftk(uri, "dump_data")
    if /InfoKey: Location\nInfoValue: (.+)\n/.match(metadata_output)
      update(location: $1)
    end
  end

  def field_results applicant
    form_fields.map { |f| [f.name, applicant.value_for_field(f.name)] }.to_h
  end
end
