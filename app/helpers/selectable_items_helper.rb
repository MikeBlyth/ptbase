require 'pry'
module SelectableItemsHelper

  def check_boxes(record, section, columns=4)  # section is Class name for table to use e.g., Symptom
    section_name = section.to_s.underscore.pluralize
    fields = section.visit_fields
    return nil if fields.empty?
    rows = ((fields.length + columns -1) / columns).to_i   # how many rows
    table_contents = ''.html_safe
    0.upto(rows-1) do |row|
      row_contents = ''.html_safe
      0.upto(columns-1) do |column|
        i = column*rows + row # which diagnosis to put here
        field = fields[i]
        unless i >= fields.count
          #box = check_box :visit, field.to_tag
          box = check_box_tag("visit[#{section_name}][#{field.name}]", 1, record.send(section_name)[field.name])
          label = label_tag :visit, field.to_label
          comment = field.with_comment ? text_field_tag("visit[#{section_name}][#{field.name}_comment]") : nil
          row_contents << content_tag(:td, box+label+comment)
        end
      end
      table_contents << content_tag(:tr, row_contents)
    end
    return content_tag(:table, table_contents)
  end

end

