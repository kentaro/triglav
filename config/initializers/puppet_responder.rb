module ActionController
  class Responder
    def to_puppet
      controller.render text: resource.to_puppet
    end
  end
end
