module LabRequestsHelper

  def available_labs
    selected = @record.lab_results.map {|r| r.lab_service_id}
    available = {}
    LabGroup.all.each do |group|
      available[group.name] =
          group.lab_services.all.map {|s| {id: s.id, name: s.name, abbrev: s.abbrev,
                                           selected: selected.include?(s.id)}  }
    end
    available
  end


end