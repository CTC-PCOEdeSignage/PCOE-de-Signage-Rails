module DomHelpers
  def within_dom_id(resource)
    within("#" + dom_id(resource)) do
      yield
    end
  end

  def within_dom_class(resource)
    within("." + dom_class(resource)) do
      yield
    end
  end
end

RSpec.configure do |config|
  config.include DomHelpers, type: :system
end
