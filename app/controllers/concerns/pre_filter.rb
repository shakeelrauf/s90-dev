
class PreFilter

  def self.before(controller)
    # Force no cache
    controller.response.headers["Cache-Control"] = "no-cache, must-revalidate, no-store"
    @p = controller.load_person
  end

end
