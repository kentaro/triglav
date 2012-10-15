module HostsHelper
  def template_for_relation_fields(f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new

    fields = f.fields_for(association, new_object, index: "new_#{association}") do |builder|
      render(partial: association.to_s.singularize + "_fields", locals: { f: builder })
    end

    content_tag(:script, fields, id: 'relation_fields_template' )
  end
end
