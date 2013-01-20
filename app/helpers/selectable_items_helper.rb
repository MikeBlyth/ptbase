require 'pry'
module SelectableItemsHelper

  # Set up HTML table containing checkboxes supplied by SectionName.visit_fields, and pre-checked
  # according to their status in record.
  def check_boxes(record, section_name, columns=4)  # section is attribute name for table to use e.g., symptoms
    section= section_name.to_s.singularize.camelize.constantize   # e.g. Symptom
    fields = section.visit_fields          #
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
          label = label_tag :visit, field.to_label
          box = check_box_tag("visit[#{section_name}][#{field.name}]", 1, record.send(section_name)[field.name])
          comment = field.with_comment ? text_field_tag("visit[#{section_name}][#{field.name}_comment]") : nil
          row_contents << content_tag(:td, box+label+comment)
        end
      end
      table_contents << content_tag(:tr, row_contents)
    end
    return content_tag(:table, table_contents, {class: 'table-striped', style: 'width: 100%'})
  end

  def selections_to_string(record, section_name)
    merged = selectable_selected(record, section_name)
    merged.map do |k,v|
      v = v.blank? ? nil : v
      [k,v].compact.join(': ')
    end.join('; ')
  end

  # Given a store of features and associated comments, like
  # {:headache=>'true', :fever=>'high', :cough => 'true', :headache_comment => 'improving', :fever_comment=>'night sweats'}
  # return a hash like
  # {:headache=>'improving', :fever=>'high--night sweats', :cough => ''}
  def selectable_selected(record, section_name)
    merged = Hash.new {|h,k| h[k] = ''}
    stored_hash =  record.send(section_name)
    return {} if stored_hash.nil?
    comments, basic =stored_hash.partition {|x| x[0] =~ /_comment\Z/}
    basic.each { |b| merged[b[0]] = (b[1] == 'true') ? '' : b[1] }
    comments.each do |comment|
      source_key = comment[0][0..-9]
      merged[source_key] = [merged[source_key], comment[1]].join ('--')
    end
    return merged
  end
end

