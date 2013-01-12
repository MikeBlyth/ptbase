class RecentResultsQuery
    def initialize(patient, relation, days_since=30, *columns)
      @patient_id = patient.id
      @relation = relation
      @days_since = days_since
      @columns = columns
    end

    def find_each(&block)
      @relation.
          where(plan: nil, invites_count: 0).
          find_each(&block)
    end


end