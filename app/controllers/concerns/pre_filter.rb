
class PreFilter

  def self.before(controller)
    # Force no cache
    controller.response.headers["Cache-Control"] = "no-cache, must-revalidate, no-store"
    @p = controller.load_person

    puts "======> language: #{controller.request.headers['Accept-Language']}"
    lang_array = controller.request.headers['Accept-Language'].split(',')
    I18n.locale = :fr if lang_array[0].start_with?('fr')
    I18n.locale = :en if !lang_array[0].start_with?('fr')  # Default to en
  end

end
