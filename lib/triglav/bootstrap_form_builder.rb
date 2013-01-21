module Triglav
  class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
    basic_helpers     = %w(
      text_field text_area select email_field password_field check_box number_field
    )

    def get_error_text(object, field, options)
      if object.nil? || options[:hide_errors]
        ""
      else
        errors = object.errors[field.to_sym]
        errors.empty? ? "" : errors.first
      end
    end

    basic_helpers.each do |name|
      class_eval("alias super_#{name.to_s} #{name}")

      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
        object  = @template.instance_variable_get("@#{@object_name}")

        error_text    = get_error_text(object, field, options)
        wrapper_class = 'control-group' + (error_text.empty? ? '' : ' error')
        label         = label(field, options[:label]).gsub(/<\/?div[^>]*>/, '')
        field         = super(field, options).gsub(/<\/?div[^>]*>/, '')

        <<-EOS.strip_heredoc.html_safe
          <div class="#{wrapper_class}">
            #{label}
            <div class="controls">
              #{field}
              <span class='help-inline'>#{error_text}</span>
            </div>
          </div>
        EOS
      end
    end
  end
end
