module LabRequestsHelper

  def available_labs(lab_request)
    current_results =  lab_request.lab_results
    selected = current_results.map {|r| r.lab_service_id}
    frozen = current_results.select {|r| r.status != 'pending'}.map {|r| r.lab_service_id}
    available = {}
    LabGroup.all.each do |group|
      available[group.name] =
          group.lab_services.all.map {|s| {id: s.id, name: s.name, abbrev: s.abbrev,
                                           selected: selected.include?(s.id),
                                           frozen: frozen.include?(s.id)}  }
    end
    available
  end


end