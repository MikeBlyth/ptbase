class LabeledFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(name, &args)
    @template.content_tag(:div, class: 'field' ) do
      label(name) + super
    end
  end

end
